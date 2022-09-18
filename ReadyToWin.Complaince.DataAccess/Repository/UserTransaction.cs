using ReadyToWin.Complaince.Bussiness.Provider;
using ReadyToWin.Complaince.Entities.UserTransaction;
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
using ReadyToWin.Complaince.Entities.UserModel;

namespace ReadyToWin.Complaince.DataAccess.Repository
{
    public class UserTransaction : BaseDAL, IUserTransaction
    {
        private Database _dbContextDQCPRDDB;
        public UserTransaction()
        {
            DatabaseProviderFactory factory = new DatabaseProviderFactory();
            _dbContextDQCPRDDB = factory.Create(C_Connection);
        }
        public List<UserAmountDeposit> RecentTransaction(UserAmountDeposit userAmountdeposit)
        {
            List<UserAmountDeposit> userRecentTransactionList = new List<UserAmountDeposit>();

            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_DEPOSIT);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.Int64, userAmountdeposit.UserId);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Recent");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userRecentTransactionList.Add(GenerateFromDataReader(reader));
                }
            }
            return userRecentTransactionList;

        }
        public List<UserAmountWithdraw> RecentTransactionWithdrawAmount(UserAmountWithdraw userwithdrawAmount)
        {
            List<UserAmountWithdraw> userRecentTransactionList = new List<UserAmountWithdraw>();

            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_WITHDRAW);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.Int64, userwithdrawAmount.UserId);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Recent");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userRecentTransactionList.Add(GenerateFromDataReaderWithdraw(reader));
                }
            }
            return userRecentTransactionList;

        }
        private UserAmountDeposit GenerateFromDataReader(IDataReader reader)
        {
            UserAmountDeposit userAmount = new UserAmountDeposit();
            userAmount.Id = GetLongIntegerFromDataReader(reader, "Id");
            userAmount.UserId = GetLongIntegerFromDataReader(reader, "UserId");
            userAmount.UserName = GetStringFromDataReader(reader, "UserName");
            userAmount.DepositAmount = GetDecimalFromDataReader(reader, "DepositAmount");
            userAmount.PaymentScreenshot = GetByteFromDataReader(reader, "PaymentScreenShot");
            userAmount.PaymentModeId = GetIntegerFromDataReader(reader, "PaymentModeId");
            //user.DepartmentId = GetIntegerFromDataReader(reader, "Department_Id");
            userAmount.Status = GetStringFromDataReader(reader, "Status");
            userAmount.ApprovedAmount = GetDecimalFromDataReader(reader, "ApprovedAmount");
            userAmount.Remarks = GetStringFromDataReader(reader, "Remarks");
            userAmount.IsActive = GetBooleanFromDataReader(reader, "IsActive");
            userAmount.IsDeleted = GetBooleanFromDataReader(reader, "IsDeleted");
            userAmount.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");
            userAmount.CreatedBy = GetStringFromDataReader(reader, "CreatedBy");
            userAmount.UpdatedDate = GetDateFromDataReader(reader, "UpdatedDate");
            userAmount.UpdatedBy = GetStringFromDataReader(reader, "UpdatedBy");
            return userAmount;
        }

        private UserAmountWithdraw GenerateFromDataReaderWithdraw(IDataReader reader)
        {
            UserAmountWithdraw userAmount = new UserAmountWithdraw();
            userAmount.Id = GetLongIntegerFromDataReader(reader, "Id");
            userAmount.UserId = GetLongIntegerFromDataReader(reader, "UserId");
            userAmount.UserName = GetStringFromDataReader(reader, "UserName");
            userAmount.MobileNoForPayment = GetStringFromDataReader(reader, "MobileNoForPayment");
            userAmount.RequestedAmount = GetDecimalFromDataReader(reader, "RequestedAmount");
            //userAmount.PaymentScreenshot = GetByteFromDataReader(reader, "PaymentScreenShot");
            userAmount.PaymentModeId = GetIntegerFromDataReader(reader, "PaymentModeId");
            //user.DepartmentId = GetIntegerFromDataReader(reader, "Department_Id");
            userAmount.Status = GetStringFromDataReader(reader, "Status");
            userAmount.ApprovedAmount = GetDecimalFromDataReader(reader, "ApprovedAmount");
            //userAmount.isa = GetDecimalFromDataReader(reader, "ApprovedAmount");
            userAmount.Remarks = GetStringFromDataReader(reader, "Remarks");
            userAmount.IsActive = GetBooleanFromDataReader(reader, "IsActive");
            userAmount.IsDeleted = GetBooleanFromDataReader(reader, "IsDeleted");
            userAmount.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");
            userAmount.CreatedBy = GetStringFromDataReader(reader, "CreatedBy");
            userAmount.UpdatedDate = GetDateFromDataReader(reader, "UpdatedDate");
            userAmount.UpdatedBy = GetStringFromDataReader(reader, "UpdatedBy");
            return userAmount;
        }
        public List<UserAmountDeposit> ListOfUserAmountDeposit()
        {
            List<UserAmountDeposit> userTransactionList = new List<UserAmountDeposit>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_DEPOSIT);            
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Select");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userTransactionList.Add(GenerateFromDataReader(reader));
                }
            }
            return userTransactionList;
        }
        public List<UserAmountDeposit> ListOfUserAmountDepositByUserId(UserAmountDeposit userAmountdeposit)
        {
            List<UserAmountDeposit> userTransactionListbyUserId = new List<UserAmountDeposit>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_DEPOSIT);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.Int64, userAmountdeposit.UserId);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Select By UserId");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userTransactionListbyUserId.Add(GenerateFromDataReader(reader));
                }
            }
            return userTransactionListbyUserId;
        }
        public List<UserAmountDeposit> ListOfUserAmountDepositbyId(UserAmountDeposit userAmountdeposit)
        {
            List<UserAmountDeposit> userTransactionListbyId = new List<UserAmountDeposit>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_DEPOSIT);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "Id", DbType.Int64, userAmountdeposit.Id);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Select By RecordId");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userTransactionListbyId.Add(GenerateFromDataReader(reader));
                }
            }
            return userTransactionListbyId;
        }
        public DbOutput AddUserAmountDeposit(UserAmountDeposit userAmountdeposit)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_DEPOSIT))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, userAmountdeposit.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "DepositAmount", DbType.Decimal, userAmountdeposit.DepositAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "PaymentScreenShot", DbType.Binary, userAmountdeposit.PaymentScreenshot);
                _dbContextDQCPRDDB.AddInParameter(command, "PaymentModeId", DbType.Int64, userAmountdeposit.PaymentModeId);
                _dbContextDQCPRDDB.AddInParameter(command, "Status", DbType.String, userAmountdeposit.Status);
                _dbContextDQCPRDDB.AddInParameter(command, "isActive", DbType.Boolean, userAmountdeposit.isActive);
                _dbContextDQCPRDDB.AddInParameter(command, "isDeleted", DbType.String, userAmountdeposit.isDeleted);
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

        public List<UserAmountWithdraw> ListOfUserWithdrawRequestByUserId(UserAmountWithdraw userAmountwithdraw)
        {
            List<UserAmountWithdraw> userAmountWithdrawbyUserId = new List<UserAmountWithdraw>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_WITHDRAW);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.Int64, userAmountwithdraw.UserId);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Select By UserId");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userAmountWithdrawbyUserId.Add(GenerateFromDataReaderWithdraw(reader));
                }
            }
            return userAmountWithdrawbyUserId;
        }
        public DbOutput UpdateAmountDeposit(UserAmountDeposit userAmountdeposit)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_DEPOSIT))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.Int64, userAmountdeposit.Id);
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, userAmountdeposit.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "DepositAmount", DbType.Decimal, userAmountdeposit.DepositAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "PaymentScreenShot", DbType.Binary, userAmountdeposit.PaymentScreenshot);
                _dbContextDQCPRDDB.AddInParameter(command, "PaymentModeId", DbType.Int64, userAmountdeposit.PaymentModeId);
                _dbContextDQCPRDDB.AddInParameter(command, "Status", DbType.String, userAmountdeposit.Status);
                _dbContextDQCPRDDB.AddInParameter(command, "ApprovedAmount", DbType.Decimal, userAmountdeposit.ApprovedAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "Remarks", DbType.String, userAmountdeposit.Remarks);
                _dbContextDQCPRDDB.AddInParameter(command, "isActive", DbType.Boolean, userAmountdeposit.isActive);
                _dbContextDQCPRDDB.AddInParameter(command, "isDeleted", DbType.String, userAmountdeposit.isDeleted);
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
        //public DbOutput DeleteAmountDeposit(UserAmountDeposit userAmountdeposit)
        //{
        //    using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_DEPOSIT))
        //    {
        //        _dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.Int64, userAmountdeposit.Id);
        //        _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, userAmountdeposit.UserId);
        //        _dbContextDQCPRDDB.AddInParameter(command, "isDeleted", DbType.String, userAmountdeposit.isDeleted);
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

        public List<UserAmountWithdraw> ListOfUserWithdrawRequest()
        {
            List<UserAmountWithdraw> userAmountWithdrawList = new List<UserAmountWithdraw>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_WITHDRAW);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Select");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userAmountWithdrawList.Add(GenerateFromDataReaderWithdraw(reader));
                }
            }
            return userAmountWithdrawList;          
            
        }
       
        public List<UserAmountWithdraw> ListOfUserWithdrawRequestbyId(UserAmountWithdraw userAmountwithdraw)
        {
            List<UserAmountWithdraw> userAmountWithdrawById = new List<UserAmountWithdraw>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_WITHDRAW);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "Id", DbType.Int64, userAmountwithdraw.Id);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Code", DbType.String, 4000);
            _dbContextDQCPRDDB.AddOutParameter(dbCommand, "Message", DbType.String, 4000);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "StatementType", DbType.String, "Select By RecordId");
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userAmountWithdrawById.Add(GenerateFromDataReaderWithdraw(reader));
                }
            }
            return userAmountWithdrawById;
            
        }
        public DbOutput UserWithdrawRequest(UserAmountWithdraw userAmountwithdraw)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_WITHDRAW))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, userAmountwithdraw.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "RequestedAmount", DbType.Decimal, userAmountwithdraw.RequestedAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "MobileNoForPayment", DbType.String, userAmountwithdraw.MobileNoForPayment);
                _dbContextDQCPRDDB.AddInParameter(command, "PaymentModeId", DbType.Int64, userAmountwithdraw.PaymentModeId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameTypeId", DbType.Int64, userAmountwithdraw.GameTypeId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubTypeId", DbType.Int64, userAmountwithdraw.GameSubTypeId);
                _dbContextDQCPRDDB.AddInParameter(command, "Status", DbType.String, "Pending");
                _dbContextDQCPRDDB.AddInParameter(command, "isActive", DbType.Boolean, userAmountwithdraw.isActive);
                _dbContextDQCPRDDB.AddInParameter(command, "isDeleted", DbType.String, userAmountwithdraw.isDeleted);
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
        
        public DbOutput UpdateWithdrawRequest(UserAmountWithdraw userAmountwithdraw)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_WITHDRAW))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.Int64, userAmountwithdraw.Id);
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, userAmountwithdraw.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "RequestedAmount", DbType.Decimal, userAmountwithdraw.RequestedAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "ApprovedAmount", DbType.Decimal, userAmountwithdraw.ApprovedAmount);
                _dbContextDQCPRDDB.AddInParameter(command, "PaymentModeId", DbType.Int64, userAmountwithdraw.PaymentModeId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameTypeId", DbType.Int64, userAmountwithdraw.GameTypeId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubTypeId", DbType.Int64, userAmountwithdraw.GameSubTypeId);
                _dbContextDQCPRDDB.AddInParameter(command, "Status", DbType.String, userAmountwithdraw.Status);
                _dbContextDQCPRDDB.AddInParameter(command, "isActive", DbType.Boolean, userAmountwithdraw.isActive);
                _dbContextDQCPRDDB.AddInParameter(command, "isDeleted", DbType.String, userAmountwithdraw.isDeleted);
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
        //public DbOutput DeleteWithdrawRequest(UserAmountWithdraw userAmountwithdraw)
        //{
        //    using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_AMOUNT_WITHDRAW))
        //    {
        //        _dbContextDQCPRDDB.AddInParameter(command, "Id", DbType.Int64, userAmountwithdraw.Id);
        //        _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, userAmountwithdraw.UserId);
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
        public int UserGameSelectionSubmit(UserGameSelection userGameSelection)
        {
            int count = 0;
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.INSERT_USER_GAME_SELECTION_SUBMIT))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "UserId", DbType.Int64, userGameSelection.UserId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameTypeId", DbType.Int64, userGameSelection.GameTypeId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameTypeName", DbType.String, userGameSelection.GameTypeName);
                _dbContextDQCPRDDB.AddInParameter(command, "GameCategoryId", DbType.Int64, userGameSelection.GameCategoryId);
                _dbContextDQCPRDDB.AddInParameter(command, "CategoryName", DbType.String, userGameSelection.CategoryName);
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubCategoryId", DbType.Int64, userGameSelection.GameCategoryId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubCategoryName", DbType.String, userGameSelection.CategoryName);
                _dbContextDQCPRDDB.AddInParameter(command, "NumberType", DbType.String, userGameSelection.NumberType);
                _dbContextDQCPRDDB.AddInParameter(command, "Amount", DbType.Decimal, userGameSelection.Amount);
                _dbContextDQCPRDDB.AddInParameter(command, "BetNumbers", DbType.String, userGameSelection.BetNumbers);
                _dbContextDQCPRDDB.AddInParameter(command, "BetAmounts", DbType.String, userGameSelection.BetAmounts);                
               // _dbContextDQCPRDDB.ExecuteNonQuery(command);
                count = Convert.ToInt32(_dbContextDQCPRDDB.ExecuteScalar(command));
                return count;
                
            }
        }
        public decimal GetUserTotalAmount(long Id)
        {
            decimal TotalAmount = 0;
            using (DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.GET_USER_TOTAL_AMOUNT))
            {
                _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.Int64, Id);
                TotalAmount = Convert.ToDecimal(_dbContextDQCPRDDB.ExecuteScalar(dbCommand));
            }
            return TotalAmount;
        }

    }
}
