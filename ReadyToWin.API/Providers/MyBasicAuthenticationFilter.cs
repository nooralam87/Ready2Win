using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Controllers;

namespace ReadyToWin.API.Providers
{
    public class MyBasicAuthenticationFilter : BasicAuthenticationFilter
    {
        public MyBasicAuthenticationFilter()
        {

        }

        public MyBasicAuthenticationFilter(bool active) : base(active)
        {

        }

        protected override bool OnAuthorizeUser(string username, string password, HttpActionContext actionContext)
        {
            //var userBus = new BusUser();

           // var user = userBus.AuthenticateAndLoad(username, password);
           // if (user == null)
               // return false;

            return true;
        }
    }
}