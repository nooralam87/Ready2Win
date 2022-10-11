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
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubCategoryId", DbType.Int64, userGameSelection.GameSubCategoryId);
                _dbContextDQCPRDDB.AddInParameter(command, "GameSubCategoryName", DbType.String, userGameSelection.GameSubCategoryName);
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
        public List<UserBettingDetails> GetUserGameListbyUserIdandGameTypeId(long UserId, long GameTypeId)
        {
            List<UserBettingDetails> userGameSelectionsList = new List<UserBettingDetails>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.INSERT_USER_GAME_BIDDING_LIST);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.Int64, UserId);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "GameTypeId", DbType.Int64, GameTypeId);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userGameSelectionsList.Add(GenerateFromDataReaderGamePlayed(reader));
                }
            }
            return userGameSelectionsList;
        }
        public List<WinNumberDeclare> GetWinningDeclareNumberHistory(long GameTypeId)
        {
            List<WinNumberDeclare> winNumberDeclare = new List<WinNumberDeclare>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.WIN_NUMBER_DECLARED_HISTORY);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "GameTypeId", DbType.Int64, GameTypeId);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    winNumberDeclare.Add(GenerateFromDataReaderWinNumberDeclare(reader));
                }
            }
            return winNumberDeclare;
        }

        public List<WinNumberDeclare> GetLatestWinNumberDeclare()
        {
            List<WinNumberDeclare> winNumberDeclare = new List<WinNumberDeclare>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.LATEST_WIN_NUMBER_DECLARE);
            //_dbContextDQCPRDDB.AddInParameter(dbCommand, "GameTypeId", DbType.Int64, GameTypeId);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    winNumberDeclare.Add(GenerateFromDataReaderWinNumberDeclare(reader));
                }
            }
            return winNumberDeclare;
        }
        public List<UserBettingDetails> GetUserGameListbyGameSelectionId(long GameSelectionId)
        {
            List<UserBettingDetails> userGameSelectionsList = new List<UserBettingDetails>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.INSERT_USER_GAME_PLAYED_LIST_DETAILS);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "GameSelectionId", DbType.Int64, GameSelectionId);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userGameSelectionsList.Add(GenerateFromDataReaderGamePlayedList(reader));
                }
            }
            return userGameSelectionsList;
        }
        private UserBettingDetails GenerateFromDataReaderGamePlayed(IDataReader reader)
        {

            UserBettingDetails userGamePlayed = new UserBettingDetails();  
            userGamePlayed.CategoryName = GetStringFromDataReader(reader, "CategoryName");            
            userGamePlayed.BetNumber = GetIntegerFromDataReader(reader, "BetNumber");            
            userGamePlayed.BetAmount = GetDecimalFromDataReader(reader, "BetAmount");
            userGamePlayed.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");          

            return userGamePlayed;
        }
        private WinNumberDeclare GenerateFromDataReaderWinNumberDeclare(IDataReader reader)
        {
            WinNumberDeclare winNumber = new WinNumberDeclare();
            winNumber.GameTypeId = GetLongIntegerFromDataReader(reader, "GameTypeId");
            winNumber.GameTypeName = GetStringFromDataReader(reader, "GameTypeName");
            winNumber.WinningNumber = GetIntegerFromDataReader(reader, "WinningNumber");
            winNumber.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");
            return winNumber;
        }
        private UserBettingDetails GenerateFromDataReaderGamePlayedList(IDataReader reader)
        {
            UserBettingDetails userGamePlayed = new UserBettingDetails();
            //userGamePlayed.GameSelectionId = GetLongIntegerFromDataReader(reader, "GameSelectionId");
            userGamePlayed.BetNumber = GetIntegerFromDataReader(reader, "BetNumber");
            userGamePlayed.BetAmount = GetDecimalFromDataReader(reader, "BetAmount");
            //userGamePlayed.IsActive = GetBooleanFromDataReader(reader, "IsActive");
            //userGamePlayed.IsDeleted = GetBooleanFromDataReader(reader, "IsDeleted");
            //userGamePlayed.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");
            //userGamePlayed.CreatedBy = GetStringFromDataReader(reader, "CreatedBy");
            //userGamePlayed.UpdatedDate = GetDateFromDataReader(reader, "UpdatedDate");
            //userGamePlayed.UpdatedBy = GetStringFromDataReader(reader, "UpdatedBy");
            return userGamePlayed;
        }

        public List<UserWinDetails> GetUserWinDetails(UserWinDetails userWinDetailsList)
        {
            List<UserWinDetails> userWinDetails = new List<UserWinDetails>();

            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_WIN_LIST);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "UserId", DbType.Int64, userWinDetailsList.UserId);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "GameTypeId", DbType.Int64, userWinDetailsList.GameTypeId);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userWinDetails.Add(GenerateFromDataReaderWinDetails(reader));
                }
            }
            return userWinDetails;

        }
        private UserWinDetails GenerateFromDataReaderWinDetails(IDataReader reader)
        {
            UserWinDetails userWinDetails = new UserWinDetails();
            userWinDetails.WinningId = GetLongIntegerFromDataReader(reader, "WinningId");
            userWinDetails.UserId = GetLongIntegerFromDataReader(reader, "UserId");
            userWinDetails.GameBettingId = GetLongIntegerFromDataReader(reader, "GameBettingId");
            userWinDetails.BettingNumber = GetIntegerFromDataReader(reader, "BettingNumber");
            userWinDetails.BettingAmount = GetDecimalFromDataReader(reader, "BettingAmount");
            userWinDetails.GameTypeId = GetLongIntegerFromDataReader(reader, "GameTypeId");
            userWinDetails.GameTypeName = GetStringFromDataReader(reader, "GameTypeName");
            userWinDetails.GameCategoryId = GetLongIntegerFromDataReader(reader, "GameTypeId");
            userWinDetails.CategoryName = GetStringFromDataReader(reader, "GameTypeName");
            userWinDetails.GameSubCategoryId = GetLongIntegerFromDataReader(reader, "GameTypeId");
            userWinDetails.GameSubCategoryName = GetStringFromDataReader(reader, "GameTypeName");
            userWinDetails.WinAmount = GetDecimalFromDataReader(reader, "WinAmount");            
            userWinDetails.WinDate = GetDateFromDataReader(reader, "WinDate");            
            return userWinDetails;
        }
    }
}
