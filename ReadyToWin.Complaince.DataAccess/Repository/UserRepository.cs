using ReadyToWin.Complaince.Bussiness.Provider.UserRepositry;
using ReadyToWin.Complaince.Entities.UserModel;
using ReadyToWin.Complaince.Framework.Exception;
using ReadyToWin.Complaince.Framework.Utility;
using Microsoft.Practices.EnterpriseLibrary.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using ReadyToWin.Complaince.Framework;
using ReadyToWin.Complaince.Entities.RequestModels;
using ReadyToWin.Complaince.Entities.Dashboard;
using ReadyToWin.Complaince.Entities.ResponseModel;

namespace ReadyToWin.Complaince.DataAccess.UserRepositry
{
   public class UserRepository : BaseDAL, IUserRepository
    {
        private Database _dbContextDQCPRDDB;

        public UserRepository()
        {
            DatabaseProviderFactory factory = new DatabaseProviderFactory();
            _dbContextDQCPRDDB = factory.Create(C_Connection);
        }
        public List<User> GetUsers()
        {
            List<User> userList = new List<User>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.ALL_USERS);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userList.Add(GenerateFromDataReader(reader));
                }
            }
            return userList;
        }
        public UserSearchResponse GetUsers(UserSearchRequest search)
        {
            DataSet ds = new DataSet();
            using (DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.GRID))
            {
                _dbContextDQCPRDDB.AddInParameter(dbCommand, "SearchValue", DbType.String, search.SearchValue);
                _dbContextDQCPRDDB.AddInParameter(dbCommand, "PageNo", DbType.Int32, search.PageNo);
                _dbContextDQCPRDDB.AddInParameter(dbCommand, "PageSize", DbType.Int32, search.PageSize);
                _dbContextDQCPRDDB.AddInParameter(dbCommand, "SortColumn", DbType.String, search.SortColumn);
                _dbContextDQCPRDDB.AddInParameter(dbCommand, "SortOrder", DbType.String, search.SortOrder);

                _dbContextDQCPRDDB.LoadDataSet(dbCommand, ds, new string[] { "Records, Count" });
            }

            UserSearchResponse response = new UserSearchResponse();
            if (ds != null)
            {
                response.result = ds.Tables[0] == null ? new DataTable() : ds.Tables[0];
                response.Count = ds.Tables[1] == null ? 0 : Convert.ToInt32(ds.Tables[1].Rows[0][0]);
            }

            return response;


            //List<User> userList = new List<User>();
            //DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.ALL_USERS);
            //using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            //{
            //    while (reader.Read())
            //    {
            //        userList.Add(GenerateFromDataReader(reader));
            //    }
            //}
            //return userList;
        }

        public User ValidateByUserId(string UserId, string Password)
        {
            User user = null;
            List<Menu> menuList = new List<Menu>();
            Password = EncryptionLibrary.EncryptText(Password);
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.GET_USER_BY_USERID);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.String, UserId);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "Password", DbType.String, Password);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    user = new User();
                    user.Id = GetLongIntegerFromDataReader(reader, "id");
                    user.UserId = GetStringFromDataReader(reader, "User_Id");
                    //user.FirstName = GetStringFromDataReader(reader, "First_Name");
                    //user.LastName = GetStringFromDataReader(reader, "Last_Name");
                    user.UserName = GetStringFromDataReader(reader, "User_Name");
                    //user.Password = GetStringFromDataReader(reader, "Password");
                    user.Email = GetStringFromDataReader(reader, "Email");
                    //user.DepartmentId = GetIntegerFromDataReader(reader, "DepartmentId");
                    user.Mobile = GetStringFromDataReader(reader, "Mobile");
                    user.Roles = GetStringFromDataReader(reader, "roles");
                    user.IsActive = GetBooleanFromDataReader(reader, "is_active");
                    //user.IsDeleted = GetBooleanFromDataReader(reader, "Is_Deleted");
                    user.City = GetStringFromDataReader(reader, "City");
                    user.CreatedDate = GetDateFromDataReader(reader, "Created_date");
                    user.CreatedBy = GetStringFromDataReader(reader, "Created_by");
                    user.UpdatedDate = GetDateFromDataReader(reader, "Updated_Date");
                    user.UpdatedBy = GetStringFromDataReader(reader, "Updated_By");
                }
                reader.NextResult();
                while (reader.Read())
                {
                    Menu menu = new Menu();
                    //menu.Id = GetIntegerFromDataReader(reader, "id");
                    menu.DisplayName = GetStringFromDataReader(reader, "display_name");
                    menu.Url = GetStringFromDataReader(reader, "url");
                    menu.ParentId = GetLongIntegerFromDataReader(reader, "parent_id");
                    menuList.Add(menu);
                }
                if (user != null)
                {
                    user.Menus = menuList == null ? new List<Menu>() : menuList;
                }
                
            }
            return user;
        }

        public string CreateToken(string UserId)
        {
            try
            {
                string token = CheckToken(UserId);

                if (string.IsNullOrEmpty(token))
                {
                    //create token if not exists
                    string randomnumber = string.Join(":", new string[] { UserId, EncryptionLibrary.KeyGenerator.GetUniqueKey(), Convert.ToString(DateTime.Now.Ticks) });
                    token = EncryptionLibrary.EncryptText(randomnumber);

                    //insert token to db
                    using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.INSERT_TOKEN))
                    {
                        _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.String, UserId);
                        _dbContextDQCPRDDB.AddInParameter(command, "Token", DbType.String, token);
                        _dbContextDQCPRDDB.ExecuteNonQuery(command);
                    }

                }
                return token;
            }
            catch (Exception ex)
            {
                //ApiLogger.Instance.ErrorLog(ex.ToString());
                return "";
            }
        }

        public string CheckToken(string UserId)
        {
            var token = string.Empty;
            // Validating token already exists.
            using (DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.CHECK_TOKEN))
            {
                _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.String, UserId);
                token = Convert.ToString(_dbContextDQCPRDDB.ExecuteScalar(dbCommand));
            }

            return token;
        }

        private User GenerateFromDataReader(IDataReader reader)
        {
            User user = new User();
            user.Id = GetLongIntegerFromDataReader(reader, "Id");
            user.UserId = GetStringFromDataReader(reader, "User_Id");
            user.UserName = GetStringFromDataReader(reader, "User_Name");
            user.Email = GetStringFromDataReader(reader, "Email");
            //user.DepartmentId = GetIntegerFromDataReader(reader, "Department_Id");
            user.Mobile = GetStringFromDataReader(reader, "Mobile");
            user.Roles = GetStringFromDataReader(reader, "Roles");
            user.City = GetStringFromDataReader(reader, "city");
            user.IsActive = GetBooleanFromDataReader(reader, "Is_Active");
            //user.IsDeleted = GetBooleanFromDataReader(reader, "Is_Deleted");
            user.CreatedDate = GetDateFromDataReader(reader, "Created_Date");
            user.CreatedBy = GetStringFromDataReader(reader, "Created_By");
            user.UpdatedDate = GetDateFromDataReader(reader, "Updated_Date");
            user.UpdatedBy = GetStringFromDataReader(reader, "Updated_By");

            return user;
        }        

        public string[] GetRoles(string UserId)
        {
            List<string> roles = new List<string>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.ROLE_BY_USERID);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.String, UserId);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    roles.Add(GetStringFromDataReader(reader, "RoleName"));
                }
            }
            return roles.ToArray();
        }        

        public DbOutput Add(User user)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.INSERT_USER))
            {
                //_dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.String, user.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "UserName", DbType.String, user.UserName);
                _dbContextDQCPRDDB.AddInParameter(command, "Password", DbType.String, user.Password);
                _dbContextDQCPRDDB.AddInParameter(command, "Email", DbType.String, user.Email);
                _dbContextDQCPRDDB.AddInParameter(command, "Mobile", DbType.String, user.Mobile);
                _dbContextDQCPRDDB.AddInParameter(command, "City", DbType.String, user.City);
                _dbContextDQCPRDDB.AddInParameter(command, "IPAdress", DbType.String, user.IPAdress);
                _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
                _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);

                _dbContextDQCPRDDB.ExecuteNonQuery(command);
                return new DbOutput()
                {
                    Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
                    Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
                };
            }
        }  

        public DbOutput Edit(UserEdit user)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.UPDATE_USER))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.String, user.Id);
                _dbContextDQCPRDDB.AddInParameter(command, "EmailID", DbType.String, user.Email);
                _dbContextDQCPRDDB.AddInParameter(command, "City", DbType.String, user.City);
                _dbContextDQCPRDDB.AddInParameter(command, "Name", DbType.String, user.UserName);
                _dbContextDQCPRDDB.AddInParameter(command, "UpdateBy", DbType.String, user.UpdatedBy);
                _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
                _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);

                _dbContextDQCPRDDB.ExecuteNonQuery(command);
                return new DbOutput()
                {
                    Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
                    Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
                };
            }
        }

        public DbOutput Delete(DeleteRoleModel model)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.DELETE_USER))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.String, model.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "DeletedBy", DbType.String, model.DeletedBy);
                _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
                _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);

                _dbContextDQCPRDDB.ExecuteNonQuery(command);
                return new DbOutput()
                {
                    Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
                    Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
                };
            }
        }

        public DbOutput AssignRole(AssignRoleModel model)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.CREATE_ROLE))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.String, model.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "RoleId", DbType.Int64, model.RoleId);
                _dbContextDQCPRDDB.AddInParameter(command, "CreatedBy", DbType.String, model.CreatedBy);
                _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
                _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);

                _dbContextDQCPRDDB.ExecuteNonQuery(command);
                return new DbOutput()
                {
                    Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
                    Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
                };
            }
        }

        public List<User> GetUsersByDepartmentId(long DepartmentId)
        {
            var userList = new List<User>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USERS_BY_DEPARTMENT_ID);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "DepartmentId", DbType.String, DepartmentId);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userList.Add(GenerateFromDataReader(reader));
                }
            }
            return userList;
        }
        public List<User> GetUserById(int Id)
        {
            var userList = new List<User>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.GET_USER_BY_ID);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "Id", DbType.String, Id);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userList.Add(GenerateFromDataReader(reader));
                }
            }
            return userList;
        }
        public List<User> GetAllUser()
        {
            var userList = new List<User>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.GET_All_USER);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userList.Add(GenerateFromDataReader(reader));
                }
            }
            return userList;
        }
        public int GetOnlineUsers()
        {
            int count = 0;
            using (DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.GET_ONLINE_USER))
            {
                count = Convert.ToInt32(_dbContextDQCPRDDB.ExecuteScalar(dbCommand));
            }

            return count;
        }

        public DbOutput Logout(string userId)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.LOGGOFF))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.String, userId);
                _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
                _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);

                _dbContextDQCPRDDB.ExecuteNonQuery(command);
                return new DbOutput()
                {
                    Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
                    Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
                };
            }
        }

        public DbOutput ChangePassword(ChangePasswordModel model)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.CHANGE_PASSWORD))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.String, model.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "Password", DbType.String, EncryptionLibrary.EncryptText(model.Password));
                _dbContextDQCPRDDB.AddInParameter(command, "ConfirmPassword", DbType.String, EncryptionLibrary.EncryptText(model.ConfirmPassword));
                _dbContextDQCPRDDB.AddInParameter(command, "UpdatedBy", DbType.String, model.UpdatedBy);
                _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
                _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);

                _dbContextDQCPRDDB.ExecuteNonQuery(command);
                return new DbOutput()
                {
                    Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
                    Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
                };
            }
        }

        public DbOutput ResetPassword(ResetPasswordModel model)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.RESET_PASSWORD))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.String, model.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "Password", DbType.String, model.Password);
                _dbContextDQCPRDDB.AddInParameter(command, "UpdatedBy", DbType.String, model.UpdatedBy);
                _dbContextDQCPRDDB.AddInParameter(command, "ResetToken", DbType.String, model.ResetToken);
                _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
                _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);

                _dbContextDQCPRDDB.ExecuteNonQuery(command);
                return new DbOutput()
                {
                    Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
                    Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
                };
            }
        }

        public List<ModuleReports> GetReportsByUserPermission(string userId)
        {
            List<ModuleReport> moduleList = new List<ModuleReport>();
            List<ModuleReports> moduleReportList = new List<ModuleReports>();

            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_REPORT_PERMISSION);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.String, userId);

            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    ModuleReport module = new ModuleReport();
                    module.ModuleId = GetIntegerFromDataReader(reader, "module_id");
                    module.ModuleName = GetStringFromDataReader(reader, "module_name");
                    module.ReportId = GetIntegerFromDataReader(reader, "report_id");
                    module.ReportName = GetStringFromDataReader(reader, "report_name");

                    moduleList.Add(module);
                }
            }

            foreach (var item in moduleList)
            {
                Report report = new Report();
                ModuleReports module = moduleReportList.Find(m => m.ModuleId == item.ModuleId);
                if (module == null)
                {
                    module = new ModuleReports();
                    module.ModuleId = item.ModuleId;
                    module.ModuleName = item.ModuleName;

                    if (!item.ReportId.Equals(0))
                    {
                        report.ReportId = item.ReportId;
                        report.ReportName = item.ReportName;
                        module.ReportList.Add(report);
                    }
                    moduleReportList.Add(module);
                }
                else
                {
                    if (!item.ReportId.Equals(0))
                    {
                        report.ReportId = item.ReportId;
                        report.ReportName = item.ReportName;
                        module.ReportList.Add(report);
                    }
                }
            }

            return moduleReportList;
        }

        public DataTable GenerateCSV()
        {
            DataSet ds = new DataSet();
            using (DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.EXPORT_USERS))
            {
                _dbContextDQCPRDDB.LoadDataSet(dbCommand, ds, new string[] { "Records" });
            }
            
            if (ds != null)
            {
                if (ds.Tables[0] != null)
                {
                    return ds.Tables[0] == null ? new DataTable() : ds.Tables[0];
                }
            }

            return new DataTable();
        }

        public DbOutput SendPasswordChangeEmail(string userId)
        {
            return new DbOutput();
        }
    }
}
