using ReadyToWin.API.Filters;
using System.Web.Mvc;

namespace ReadyToWin.API.Providers
{
    public class BaseController : Controller
    {
        protected virtual new CustomPrincipal User
        {
            get { return HttpContext.User as CustomPrincipal; }
        }
    }
}