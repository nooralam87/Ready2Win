using Microsoft.Owin.Security;
using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Http;
using System.Net;
using Microsoft.Practices.EnterpriseLibrary.ExceptionHandling.Properties;
using System.Threading;

namespace ReadyToWin.API.Providers
{
    public class MyAuthenticationFilter : IAuthenticationFilter
    {
        private readonly string _authenticationType;

        /// <summary>Initializes a new instance of the <see cref="HostAuthenticationFilter"/> class.</summary>
        /// <param name="authenticationType">The authentication type of the OWIN middleware to use.</param>
        public MyAuthenticationFilter(string authenticationType)
        {
            if (authenticationType == null)
            {
                throw new ArgumentNullException("authenticationType");
            }

            _authenticationType = authenticationType;
        }

        /// <summary>Gets the authentication type of the OWIN middleware to use.</summary>
        public string AuthenticationType
        {
            get { return _authenticationType; }
        }

        /// <inheritdoc />
        public async Task AuthenticateAsync(HttpAuthenticationContext context, CancellationToken cancellationToken)
        {
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            HttpRequestMessage request = context.Request;

            if (request == null)
            {
                throw new InvalidOperationException("Request mut not be null");
            }


            //In my case, i need try autenticate the request with BEARER token (Oauth)
            IAuthenticationManager authenticationManager = GetAuthenticationManagerOrThrow(request);

            cancellationToken.ThrowIfCancellationRequested();
            AuthenticateResult result = await authenticationManager.AuthenticateAsync(_authenticationType);
            System.Security.Claims.ClaimsIdentity identity = null;

            if (result != null)
            {
                identity = result.Identity;

                if (identity != null)
                {
                    context.Principal = new System.Security.Claims.ClaimsPrincipal(identity);
                }
            }
            else
            {
                //If havent success with oauth authentication, I need locate the legacy token
                //If dont exists the legacy token, set error (will generate http 401)
                if (!request.Headers.Contains("legacy-token-header"))
                    context.ErrorResult = new AuthenticationFailureResult(HttpStatusCode.NotFound.ToString(), request);
                else
                {
                    try
                    {
                        var queryString = request.GetQueryNameValuePairs();
                        if (!queryString.Any(x => x.Key == "l"))
                            context.ErrorResult = new AuthenticationFailureResult(Resources.ExceptionExceptionHandlingSectionNotFound, request);
                        else
                        {
                            var userType = queryString.First(x => x.Key == "l").Value;
                            String token = HttpUtility.UrlDecode(request.Headers.GetValues("tk").First());

                            //identity = TokenLegacy.ValidateToken(token, userType);
                            //identity.AddClaims(userType, (OwinRequest)((OwinContext)context.Request.Properties["MS_OwinContext"]).Request);
                            //if (identity != null)
                            //{
                            //    context.Principal = new ClaimsPrincipal(identity);
                            //}
                        }

                    }
                    catch (Exception e)
                    {
                        context.ErrorResult = new AuthenticationFailureResult(e.Message, request);
                    }
                }
            }
        }


        /// <inheritdoc />
        public Task ChallengeAsync(HttpAuthenticationChallengeContext context, CancellationToken cancellationToken)
        {
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            HttpRequestMessage request = context.Request;

            if (request == null)
            {
                throw new InvalidOperationException("Request mut not be null");
            }

            IAuthenticationManager authenticationManager = GetAuthenticationManagerOrThrow(request);

            // Control the challenges that OWIN middleware adds later.
            authenticationManager.AuthenticationResponseChallenge = AddChallengeAuthenticationType(
                authenticationManager.AuthenticationResponseChallenge, _authenticationType);


            return Task.CompletedTask;
        }

        /// <inheritdoc />
        public bool AllowMultiple
        {
            get { return true; }
        }

        private static AuthenticationResponseChallenge AddChallengeAuthenticationType(
            AuthenticationResponseChallenge challenge, string authenticationType)
        {
            Contract.Assert(authenticationType != null);

            List<string> authenticationTypes = new List<string>();
            AuthenticationProperties properties;

            if (challenge != null)
            {
                string[] currentAuthenticationTypes = challenge.AuthenticationTypes;

                if (currentAuthenticationTypes != null)
                {
                    authenticationTypes.AddRange(currentAuthenticationTypes);
                }

                properties = challenge.Properties;
            }
            else
            {
                properties = new AuthenticationProperties();
            }

            authenticationTypes.Add(authenticationType);

            return new AuthenticationResponseChallenge(authenticationTypes.ToArray(), properties);
        }

        private static IAuthenticationManager GetAuthenticationManagerOrThrow(HttpRequestMessage request)
        {
            Contract.Assert(request != null);

            var owinCtx = request.GetOwinContext();
            IAuthenticationManager authenticationManager = owinCtx != null ? owinCtx.Authentication : null;

            if (authenticationManager == null)
            {
                throw new InvalidOperationException("IAuthenticationManagerNotAvailable");
            }

            return authenticationManager;
        }

        

       
    }

    public class AuthenticationFailureResult : IHttpActionResult
    {
        public string ReasonPhrase { get; set; }
        public HttpRequestMessage Request { get; set; }
        public AuthenticationFailureResult(string reasonPhrase, HttpRequestMessage request)
        {
            ReasonPhrase = reasonPhrase;
            Request = request;
        }

        

        public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
        {
            return Task.FromResult(Execute());
        }

        private HttpResponseMessage Execute()
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Unauthorized)
            {
                RequestMessage = Request,
                ReasonPhrase = ReasonPhrase
            };

            return response;
        }
    }
}