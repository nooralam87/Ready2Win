using ReadyToWin.Complaince.Entities.Dashboard;
using ReadyToWin.Complaince.Entities.RequestModels;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.AdminModel;
using ReadyToWin.Complaince.Framework;
using System.Collections.Generic;
using System.Data;


namespace ReadyToWin.Complaince.BussinessProvider.IProviders
{
    public interface IAdminRepository
    {
        DbOutput InsertWinningAmountForUser(Admin winnerUser);
        List<Admin> ListOfWinningUsers();
        List<Admin> ListOfWinningUsersById(Admin Id);
        List<Admin> ListOfUserWinningByUserId(Admin userWinbyUserId);
        DbOutput UpdateWinningUser(Admin updateWiinerUserDetails);
        //DbOutput DeleteWinningUser(Admin deleteWinnerUser);
        DbOutput UserDepositAmountApproved(Admin approvedAmount);

        DbOutput UserWithdrawAmountApproved(Admin approvedAmount);
    }
}
