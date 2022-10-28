using ReadyToWin.API.Filters;
using ReadyToWin.API.Models;
using ReadyToWin.Complaince.Bussiness.Provider.UserRepositry;
using ReadyToWin.Complaince.DataAccess.Repository;
using ReadyToWin.Complaince.DataAccess.UserRepositry;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using System.Web.Http;
using System.Web.Mvc;
using Unity;
//using Unity.WebApi;

namespace ReadyToWin.API
{
    public static class UnityConfig
    {
        public static void RegisterComponents(HttpConfiguration config)
        {
			var container = new UnityContainer();
            
            // register all your components with the container here
            // it is NOT necessary to register your controllers
            
            // e.g. container.RegisterType<ITestService, TestService>();

            container.RegisterType<IGameType, GameTypeRepository>();
            container.RegisterType<IUserRepository, UserRepository>();
            container.RegisterType<IUserTransaction, UserTransaction>();
            container.RegisterType<IAdminRepository, AdminRepository>();
            container.RegisterType<ICreateQutation, CreateQutation>();
            container.RegisterType<IVendorService, VendorService>();
            //DependencyResolver.SetResolver(new Unity.Mvc5.UnityDependencyResolver(container));
            //GlobalConfiguration.Configuration.DependencyResolver = new UnityResolver(container);
           config.DependencyResolver = new UnityResolver(container);

        }
    }
}