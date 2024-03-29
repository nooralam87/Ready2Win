﻿using Microsoft.Practices.EnterpriseLibrary.Data;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.Complaince.Entities.AdminModel;
using ReadyToWin.Complaince.Entities.ResponseModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
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
            userList.WinningAmount = GetDecimalFromDataReader(reader, "WinningAmount");
            userList.Remarks = GetStringFromDataReader(reader, "Remarks");
            //userList.ApprovedAmount = GetDoubleFromDataReader(reader, "ApprovedAmount");            
            //userList.AdminUserId = GetLongIntegerFromDataReader(reader, "AdminUserId");
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
                _dbContextDQCPRDDB.AddInParameter(command, "Status", DbType.String, approvedAmount.Status);
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
                _dbContextDQCPRDDB.AddInParameter(command, "@StatementType", DbType.String, approvedAmount.Status);
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

        public DbOutput DeclaredWinningNumber(Admin adminModel)
        {
            using (DbCommand command = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.WIN_NUMBER_DECLARED))
            {
                _dbContextDQCPRDDB.AddInParameter(command, "GameTypeId", DbType.Int64, adminModel.GameTypeId);
                _dbContextDQCPRDDB.AddInParameter(command, "GametypeName", DbType.String, adminModel.GameTypeName);
                _dbContextDQCPRDDB.AddInParameter(command, "winningNumber", DbType.Int32, adminModel.winningNumber);
                _dbContextDQCPRDDB.AddInParameter(command, "AdminUserId", DbType.Int64, adminModel.AdminUserId);
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
        public List<AmountOnGameByGameType> ListOfAmountOnGameByGameType(long GameTypeId)
        {
            List<AmountOnGameByGameType> ListbyGameTypeId = new List<AmountOnGameByGameType>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.AMOUNT_ON_GAME_BY_GAMETYPEID);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "GameTypeId", DbType.Int64, GameTypeId);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    ListbyGameTypeId.Add(GenerateFromDataReaderForAmountOnGame(reader));
                }
            }
            return ListbyGameTypeId;
        }
        private AmountOnGameByGameType GenerateFromDataReaderForAmountOnGame(IDataReader reader)
        {
            AmountOnGameByGameType userList = new AmountOnGameByGameType();
            userList.GameBettingId = GetLongIntegerFromDataReader(reader, "GameBettingId");
            userList.UserId = GetLongIntegerFromDataReader(reader, "UserId");
            userList.UserName = GetStringFromDataReader(reader, "UserName");
            userList.GameTypeId = GetLongIntegerFromDataReader(reader, "GameTypeId");
            userList.GameTypeName = GetStringFromDataReader(reader, "GameTypeName");
            userList.GameCategoryId = GetLongIntegerFromDataReader(reader, "GameCategoryId");
            userList.CategoryName = GetStringFromDataReader(reader, "CategoryName");
            userList.GameSubCategoryId = GetLongIntegerFromDataReader(reader, "GameSubCategoryId");
            userList.GameSubCategoryName = GetStringFromDataReader(reader, "GameSubCategoryName");
            //userList.NumberType = GetStringFromDataReader(reader, "NumberType");
            userList.BetAmount = GetDecimalFromDataReader(reader, "BetAmount");
            //userList.Remarks = GetStringFromDataReader(reader, "Remarks");
            //userList.ApprovedAmount = GetDoubleFromDataReader(reader, "ApprovedAmount");            
            userList.BetNumber = GetIntegerFromDataReader(reader, "BetNumber");            
            userList.createdDate = GetDateFromDataReader(reader, "CreatedDate");
            
            return userList;
        }
        public List<UserWinDetails> GetUserListBasedOnGameWithBetNumberAndWinAmount()
        {
            List<UserWinDetails> userWinDetails = new List<UserWinDetails>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_LIST_BY_GAME_BETNUMBER_WINAMOUNT);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userWinDetails.Add(GenerateFromDataReaderGameWithBetNumberAndWinAmount(reader));
                }
            }
            return userWinDetails;

        }
        private UserWinDetails GenerateFromDataReaderGameWithBetNumberAndWinAmount(IDataReader reader)
        {
            UserWinDetails userWinDetails = new UserWinDetails();
            userWinDetails.UserName = GetStringFromDataReader(reader, "UserName");
            userWinDetails.GameTypeName = GetStringFromDataReader(reader, "GameTypeName");
            userWinDetails.CategoryName = GetStringFromDataReader(reader, "CategoryName");
            userWinDetails.GameSubCategoryName = GetStringFromDataReader(reader, "GameSubCategoryName");
            userWinDetails.BettingNumber = GetIntegerFromDataReader(reader, "BettingNumber");
            userWinDetails.BettingAmount = GetDecimalFromDataReader(reader, "BettingAmount");
            userWinDetails.WinAmount = GetDecimalFromDataReader(reader, "WinAmount");
            userWinDetails.WinDate = GetDateFromDataReader(reader, "WinDate");
            return userWinDetails;
        }
        public List<UserWalletBalance> GetUserListWalletBalance()
        {
            List<UserWalletBalance> userWalletBalance = new List<UserWalletBalance>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.USER_LIST_WALLET_BALANCE);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    userWalletBalance.Add(GenerateFromDataReaderWalletBalance(reader));
                }
            }
            return userWalletBalance;

        }
        private UserWalletBalance GenerateFromDataReaderWalletBalance(IDataReader reader)
        {
            UserWalletBalance userWalletBalance = new UserWalletBalance();
            userWalletBalance.Id = GetIntegerFromDataReader(reader, "id");
            userWalletBalance.UserId = GetStringFromDataReader(reader, "UserId");
            userWalletBalance.UserName = GetStringFromDataReader(reader, "UserName");
            userWalletBalance.Mobile = GetStringFromDataReader(reader, "Mobile");
            userWalletBalance.Email = GetStringFromDataReader(reader, "Email");
            userWalletBalance.City = GetStringFromDataReader(reader, "City");
            userWalletBalance.WalletBalance = GetDecimalFromDataReader(reader, "WalletBalance");
            userWalletBalance.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");
            return userWalletBalance;
        }
    }
}
