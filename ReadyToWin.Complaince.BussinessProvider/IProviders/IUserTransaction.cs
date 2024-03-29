﻿using ReadyToWin.Complaince.Entities.Dashboard;
using ReadyToWin.Complaince.Entities.RequestModels;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.UserModel;
using ReadyToWin.Complaince.Entities.UserTransaction;
using ReadyToWin.Complaince.Framework;
using System;
using System.Collections.Generic;
using System.Data;

namespace ReadyToWin.Complaince.BussinessProvider.IProviders
{
    public interface IUserTransaction
    {
        List<UserAmountDeposit> ListOfUserAmountDeposit();
        List<UserAmountDeposit> RecentTransaction(UserAmountDeposit userAmountdeposit);
        List<UserAmountWithdraw> RecentTransactionWithdrawAmount(UserAmountWithdraw userAmountwithdraw);
        List<UserAmountDeposit> ListOfUserAmountDepositByUserId(UserAmountDeposit userAmountdeposit);
        List<UserAmountDeposit> ListOfUserAmountDepositbyId(UserAmountDeposit userAmountdeposit);
        DbOutput AddUserAmountDeposit(UserAmountDeposit Add);
        DbOutput UpdateAmountDeposit(UserAmountDeposit userAmountdeposit);
        //DbOutput DeleteAmountDeposit(UserAmountDeposit userAmountdeposit);
        List<UserAmountWithdraw> ListOfUserWithdrawRequest();
        List<UserAmountWithdraw> ListOfUserWithdrawRequestByUserId(UserAmountWithdraw userAmountwithdraw);
        List<UserAmountWithdraw> ListOfUserWithdrawRequestbyId(UserAmountWithdraw userAmountwithdraw);
        DbOutput UserWithdrawRequest(UserAmountWithdraw userAmountwithdraw);
        DbOutput UpdateWithdrawRequest(UserAmountWithdraw userAmountwithdraw);
        //DbOutput DeleteWithdrawRequest(UserAmountWithdraw userAmountwithdraw);
        int UserGameSelectionSubmit(UserGameSelection userGameSelection);
        decimal GetUserTotalAmount(long id);
        List<UserBettingDetails> GetUserGameListbyUserIdandGameTypeId(long UserId, long GameTypeId);
        List<UserBettingDetails> GetUserGameListbyGameTypeId(long GameTypeId);
        List<UserBettingDetails> GetUserGameListbyGameSelectionId(long GameSelectionId);
        List<WinNumberDeclare> GetWinningDeclareNumberHistory(long GameTypeId);
        List<UserWinDetails> GetUserWinDetails(UserWinDetails userWinDetailsList);
        List<WinNumberDeclare> GetLatestWinNumberDeclare();
        List<WinNumberDeclare> GetAllGameWinningNumber();
        List<UserWinDetails> GetUserBiddingOnCategoryName(UserWinDetails userWinDetailsList);
    }
}
