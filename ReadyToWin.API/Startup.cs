using Microsoft.Owin;
using Microsoft.Owin.Cors;
using Owin;
using System.Web.Http;

[assembly: OwinStartup(typeof(ReadyToWin.API.Startup))]

namespace ReadyToWin.API
{
    public class Startup
    {

        
            /// <summary>
            /// 
            /// </summary>
            /// <param name="app"></param>
        public void Configuration(IAppBuilder app)
        {
            //ConfigureAuth(app);

            
            HttpConfiguration config = new HttpConfiguration();
            WebApiConfig.Register(config);
            UnityConfig.RegisterComponents(config);            
            app.UseWebApi(config);

            //app.Use(async (context, next) =>
            //{
            //    foreach (var header in context.Request.Headers)
            //    {
            //         string _url = ($"{context.Request.Path} : {header.Key}={header.Value}");

            //        //if (header.Key == "CLIENT-VERSION" && header.Value != 5)
            //        //{
            //        //    context.Request.Method = "GET";
            //        //    context.Request.Path = "/api/Error/VersionError";
            //        //}
            //    }

            //    await next();
            //});
            ////enable cors 
           app.UseCors(CorsOptions.AllowAll);


        }
    }
}
