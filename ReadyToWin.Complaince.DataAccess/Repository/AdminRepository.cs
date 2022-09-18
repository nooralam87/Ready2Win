using ReadyToWin.Complaince.Bussiness.Provider;
using ReadyToWin.Complaince.Entities.AdminModel;
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
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.Complaince.Entities.UserTransaction;

namespace ReadyToWin.Complaince.DataAccess.Repository
{
    public class AdminRepository : BaseDAL, IAdminRepository
    {
        private Database _dbContextDQCPRDDB;
        public AdminRepository()
        {
            DatabaseProviderFactory factory = new DatabaseProviderFactory();
            _dbContextDQCPRDDB = factory.Create(C_Connection);
        }
        public DbOutput InsertWinningAmountForUser(Admin insertWinningAmount)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_WINNER_AMOUNT))
            {
                
                //_dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.Int64, winnerUser.Id);
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, insertWinningAmount.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameTypeId", DbType.Int64, insertWinningAmount.GameTypeId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameTypeName", DbType.String, insertWinningAmount.GameTypeName);
                _dbContextDQCPRDDB.AddInParameter(command, "GameCategoryId", DbType.Int64, insertWinningAmount.GameCategoryId);
                _dbContextDQCPRDDB.AddInParameter(command, "CategoryName", DbType.String, insertWinningAmount.CategoryName);
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubCategoryId", DbType.Int64, insertWinningAmount.GameCategoryId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubCategoryName", DbType.String, insertWinningAmount.CategoryName);
                _dbContextDQCPRDDB.AddInParameter(command, "NumberType", DbType.String, insertWinningAmount.NumberType);
                _dbContextDQCPRDDB.AddInParameter(command, "WinningAmount", DbType.Decimal, insertWinningAmount.WinningAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "Remarks", DbType.String, insertWinningAmount.Remarks);
                _dbContextDQCPRDDB.AddInParameter(command, "isActive", DbType.Boolean, insertWinningAmount.isActive);
                _dbContextDQCPRDDB.AddInParameter(command, "isDeleted", DbType.String, insertWinningAmount.isDeleted);
                _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
                _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);
                _dbContextDQCPRDDB.AddInParameter(command, "StatementType", DbType.String, "Insert");
                _dbContextDQCPRDDB.ExecuteNonQuery(command);
                return new DbOutput()
                {
                    Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
                    Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
                };
            }

        }

        public List<Admin> ListOfWinningUsers()
        {
            List<Admin> winningUserList = new List<Admin>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_WINNER_AMOUNT);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Select");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    winningUserList.Add(GenerateFromDataReader(reader));
                }
            }
            return winningUserList;
        }
        private Admin GenerateFromDataReader(IDataReader reader)
        {
            Admin userList = new Admin();
            userList.Id = GetLongIntegerFromDataReader(reader, "Id");
            userList.UserId = GetLongIntegerFromDataReader(reader, "UserId");
            userList.GameTypeId = GetLongIntegerFromDataReader(reader, "GameTypeId");
            userList.GameTypeName = GetStringFromDataReader(reader, "GameTypeName");
            userList.GameCategoryId = GetLongIntegerFromDataReader(reader, "GameCategoryId");
            userList.CategoryName = GetStringFromDataReader(reader, "CategoryName");
            userList.GameSubCategoryId = GetLongIntegerFromDataReader(reader, "GameSubCategoryId");
            userList.GameSubCategoryName = GetStringFromDataReader(reader, "GameSubCategoryName");
            userList.NumberType = GetStringFromDataReader(reader, "NumberType");
            userList.WinningAmount = GetDoubleFromDataReader(reader, "WinningAmount");
            userList.Remarks = GetStringFromDataReader(reader, "Remarks");
            userList.ApprovedAmount = GetDoubleFromDataReader(reader, "ApprovedAmount");            
            userList.AdminUserId = GetLongIntegerFromDataReader(reader, "AdminUserId");
            userList.IsActive = GetBooleanFromDataReader(reader, "IsActive");
            userList.IsDeleted = GetBooleanFromDataReader(reader, "IsDeleted");
            userList.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");
            userList.CreatedBy = GetStringFromDataReader(reader, "CreatedBy");
            userList.UpdatedDate = GetDateFromDataReader(reader, "UpdatedDate");
            userList.UpdatedBy = GetStringFromDataReader(reader, "UpdatedBy");
            return userList;
        }

        public List<Admin> ListOfWinningUsersById(Admin Id)
        {
            List<Admin> winningUserList = new List<Admin>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_WINNER_AMOUNT);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "Id", DbType.Int64, Id.Id);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Select By RecordId");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    winningUserList.Add(GenerateFromDataReader(reader));
                }
            }
            return winningUserList;            
        }

        public List<Admin> ListOfUserWinningByUserId(Admin userWinbyUserId)
        {
            List<Admin> winningUserListbyUserId = new List<Admin>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_WINNER_AMOUNT);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.Int64, userWinbyUserId.UserId);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Select By UserId");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    winningUserListbyUserId.Add(GenerateFromDataReader(reader));
                }
            }
            return winningUserListbyUserId;

            
        }
        public DbOutput UpdateWinningUser(Admin updateWiinerUserDetails)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_WINNER_AMOUNT))
            {

                _dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.Int64, updateWiinerUserDetails.Id);
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, updateWiinerUserDetails.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameTypeId", DbType.Int64, updateWiinerUserDetails.GameTypeId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameTypeName", DbType.String, updateWiinerUserDetails.GameTypeName);
                _dbContextDQCPRDDB.AddInParameter(command, "GameCategoryId", DbType.Int64, updateWiinerUserDetails.GameCategoryId);
                _dbContextDQCPRDDB.AddInParameter(command, "CategoryName", DbType.String, updateWiinerUserDetails.CategoryName);
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubCategoryId", DbType.Int64, updateWiinerUserDetails.GameCategoryId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubCategoryName", DbType.String, updateWiinerUserDetails.CategoryName);
                _dbContextDQCPRDDB.AddInParameter(command, "NumberType", DbType.String, updateWiinerUserDetails.NumberType);
                _dbContextDQCPRDDB.AddInParameter(command, "WinningAmount", DbType.Decimal, updateWiinerUserDetails.WinningAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "Remarks", DbType.String, updateWiinerUserDetails.Remarks);
                _dbContextDQCPRDDB.AddInParameter(command, "isActive", DbType.Boolean, updateWiinerUserDetails.isActive);
                _dbContextDQCPRDDB.AddInParameter(command, "isDeleted", DbType.String, updateWiinerUserDetails.isDeleted);
                _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
                _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);
                _dbContextDQCPRDDB.AddInParameter(command, "StatementType", DbType.String, "Update");
                _dbContextDQCPRDDB.ExecuteNonQuery(command);
                return new DbOutput()
                {
                    Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
                    Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
                };
            }

        }

        //public DbOutput DeleteWinningUser(Admin deleteWinnerUser)
        //{
        //    using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_WINNER_AMOUNT))
        //    {
        //        _dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.Int64, deleteWinnerUser.Id);
        //        _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, deleteWinnerUser.UserId);
        //        _dbContextDQCPRDDB.AddOutParameter(command, "Code", DbType.String, 4000);
        //        _dbContextDQCPRDDB.AddOutParameter(command, "Message", DbType.String, 4000);
        //        _dbContextDQCPRDDB.AddInParameter(command, "StatementType", DbType.String, "Delete");
        //        _dbContextDQCPRDDB.ExecuteNonQuery(command);
        //        return new DbOutput()
        //        {
        //            Code = Convert.ToInt32(_dbContextDQCPRDDB.GetParameterValue(command, "Code")),
        //            Message = Convert.ToString(_dbContextDQCPRDDB.GetParameterValue(command, "Message"))
        //        };
        //    }
        //}
        public DbOutput UserDepositAmountApproved(Admin approvedAmount)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_DEPOSIT_AMOUNT_APPROVED))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.Int64, approvedAmount.Id);
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, approvedAmount.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "ApprovedAmount", DbType.Decimal, approvedAmount.ApprovedAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "Remarks", DbType.String, approvedAmount.Remarks);
                _dbContextDQCPRDDB.AddInParameter(command, "AdminUserId", DbType.Int64, approvedAmount.AdminUserId);
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
        public DbOutput UserWithdrawAmountApproved(Admin approvedAmount)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_WITHDRAW_AMOUNT_APPROVED))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.Int64, approvedAmount.Id);
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, approvedAmount.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "ApprovedAmount", DbType.Decimal, approvedAmount.ApprovedAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "Remarks", DbType.String, approvedAmount.Remarks);
                _dbContextDQCPRDDB.AddInParameter(command, "AdminUserId", DbType.Int64, approvedAmount.AdminUserId);
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
    }
}
