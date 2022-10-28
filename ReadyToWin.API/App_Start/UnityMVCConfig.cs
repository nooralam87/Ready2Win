using System.Web.Mvc;
using Unity;
using Unity.Mvc5;
using ReadyToWin.Complaince.Bussiness.Provider.UserRepositry;
using ReadyToWin.Complaince.DataAccess.Repository;
using ReadyToWin.Complaince.DataAccess.UserRepositry;
using ReadyToWin.Complaince.BussinessProvider.IProviders;

namespace ReadyToWin.API.App_Start
{
    public static class UnityMVCConfig
    {
        public static void RegisterComponents()
        {
            var container = new UnityContainer();

            // register all your components with the container here
            // it is NOT necessary to register your controllers

            // e.g.
            container.RegisterType<IGameType, GameTypeRepository>();
            container.RegisterType<IUserRepository, UserRepository>();
            container.RegisterType<IUserTransaction, UserTransaction>();
            container.RegisterType<IAdminRepository, AdminRepository>();
            container.RegisterType<ICreateQutation, CreateQutation>();
            container.RegisterType<IVendorService, VendorService>();

            DependencyResolver.SetResolver(new UnityDependencyResolver(container));
        }
    }
}