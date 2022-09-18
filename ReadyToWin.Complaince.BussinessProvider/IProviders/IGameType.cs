using ReadyToWin.Complaince.Entities.Dashboard;
using ReadyToWin.Complaince.Entities.RequestModels;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.GameType;
using ReadyToWin.Complaince.Framework;
using System.Collections.Generic;
using System.Data;

namespace ReadyToWin.Complaince.BussinessProvider.IProviders
{
    public interface IGameType
    {
        List<GameType> GetGameType();
        List<GameCategory> GetAllGameCategory(long GameTypeId);
        List<GameSubCategory> GetAllSubGameCategory(long GameCategoryId);
    }
}
