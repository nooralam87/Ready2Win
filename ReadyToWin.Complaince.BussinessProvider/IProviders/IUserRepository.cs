using ReadyToWin.Complaince.Entities.Dashboard;
using ReadyToWin.Complaince.Entities.RequestModels;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.UserModel;
using ReadyToWin.Complaince.Framework;
using System.Collections.Generic;
using System.Data;

namespace ReadyToWin.Complaince.Bussiness.Provider.UserRepositry
{
    public interface IUserRepository
    {
        List<User> GetUsers();
        UserSearchResponse GetUsers(UserSearchRequest search);
        User ValidateByUserId(string UserId, string Password);

        string CreateToken(string UserId);

        string CheckToken(string UserId);

        string[] GetRoles(string UserId);

        List<User> GetUsersByDepartmentId(long DepartmentId);

        DbOutput Add(User Add);

        DbOutput Edit(UserEdit user);
        List<User> GetUserById(int Id);
        List<User> GetAllUser();
        DbOutput Delete(DeleteRoleModel model);

        DbOutput AssignRole(AssignRoleModel model);
        int GetOnlineUsers();

        DbOutput Logout(string userId);

        DbOutput ResetPassword(ResetPasswordModel model);

        DbOutput ChangePassword(ChangePasswordModel model);
        List<ModuleReports> GetReportsByUserPermission(string userId);
        DataTable GenerateCSV();
        DbOutput SendPasswordChangeEmail(string userId);
    }
}
