using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using ReadyToWin.Complaince.Framework;
using ReadyToWin.Complaince.Entities.RequestModels;
using ReadyToWin.Complaince.Entities.Dashboard;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using Microsoft.Practices.EnterpriseLibrary.Data;
using ReadyToWin.Complaince.Entities.GameType;

namespace ReadyToWin.Complaince.DataAccess.Repository
{
    public class GameTypeRepository : BaseDAL, IGameType
    {
        private Database _dbContextDQCPRDDB;

        public GameTypeRepository()
        {
            DatabaseProviderFactory factory = new DatabaseProviderFactory();
            _dbContextDQCPRDDB = factory.Create(C_Connection);
        }
        public List<GameType> GetGameType()
        {
            List<GameType> GameTypeList = new List<GameType>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.ALL_GAMETYPE);
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    GameTypeList.Add(GenerateGameTypeDataReader(reader));
                }
            }
            return GameTypeList;
        }
        public List<GameCategory> GetAllGameCategory(long GameTypeId)
        {
            List<GameCategory> GameCategoryList = new List<GameCategory>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.ALL_GAMECATEGORY);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "GameTypeId", DbType.String, GameTypeId);            
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    GameCategoryList.Add(GenerateGameCategoryDataReader(reader));
                }
            }
            return GameCategoryList;
        }
        public List<GameSubCategory> GetAllSubGameCategory(long GameCategoryId)
        {
            List<GameSubCategory> GameSubCategoryList = new List<GameSubCategory>();
            DbCommand dbCommand = _dbContextDQCPRDDB.GetStoredProcCommand(DBConstraints.ALL_GAMESUBCATEGORY);
            _dbContextDQCPRDDB.AddInParameter(dbCommand, "GameCategoryId", DbType.String, GameCategoryId);         
            using (IDataReader reader = _dbContextDQCPRDDB.ExecuteReader(dbCommand))
            {
                while (reader.Read())
                {
                    GameSubCategoryList.Add(GenerateGameSubCategoryDataReader(reader));
                }
            }
            return GameSubCategoryList;
        }
        private GameType GenerateGameTypeDataReader(IDataReader reader)
        {
            GameType gameType = new GameType();
            gameType.GameTypeId = GetLongIntegerFromDataReader(reader, "GameTypeId");
            gameType.GameName = GetStringFromDataReader(reader, "GameName");
            gameType.StartDate = GetDateFromDataReader(reader, "StartDate");
            gameType.EndDate = GetDateFromDataReader(reader, "EndDate");
            gameType.IsActive = GetBooleanFromDataReader(reader, "isActive");
            //gameType.IsDeleted = GetBooleanFromDataReader(reader, "is_deleted");
            gameType.CreatedBy = GetStringFromDataReader(reader, "CreatedBy");
            gameType.UpdatedBy = GetStringFromDataReader(reader, "UpdatedBy");
            gameType.UpdatedDate = GetDateFromDataReader(reader, "UpdatedDate");
            gameType.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");
            
            return gameType;
        }
        private GameCategory GenerateGameCategoryDataReader(IDataReader reader)
        {
            GameCategory gameType = new GameCategory();
            gameType.GameCategoryId = GetLongIntegerFromDataReader(reader, "GameCategoryId");
            gameType.GameTypeId = new GameType() { GameTypeId= GetLongIntegerFromDataReader(reader, "GameTypeId") };
            gameType.CategoryName = GetStringFromDataReader(reader, "CategoryName");
            gameType.bidRate = GetDecimalFromDataReader(reader, "bidRate");
            gameType.IsActive = GetBooleanFromDataReader(reader, "IsActive");
            //gameType.IsDeleted = GetBooleanFromDataReader(reader, "is_deleted");
            gameType.CreatedBy = GetStringFromDataReader(reader, "CreatedBy");
            gameType.UpdatedBy = GetStringFromDataReader(reader, "UpdatedBy");
            gameType.UpdatedDate = GetDateFromDataReader(reader, "UpdatedDate");
            gameType.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");

            return gameType;
        }
        private GameSubCategory GenerateGameSubCategoryDataReader(IDataReader reader)
        {
            GameSubCategory gameType = new GameSubCategory();
            gameType.GameSubCategoryId = GetLongIntegerFromDataReader(reader, "GameSubCategoryId");
            gameType.GameCategeryId = new GameCategory() { GameCategoryId = GetLongIntegerFromDataReader(reader, "GameCategeryId") };
            gameType.SubCategoryName = GetStringFromDataReader(reader, "SubCategoryName");
            gameType.bidRate = GetDecimalFromDataReader(reader, "bidRate");
            gameType.IsActive = GetBooleanFromDataReader(reader, "IsActive");
            //gameType.IsDeleted = GetBooleanFromDataReader(reader, "is_deleted");
            //gameType.CreatedBy = GetStringFromDataReader(reader, "CreatedBy");
            //gameType.UpdatedBy = GetStringFromDataReader(reader, "UpdatedBy");
            //gameType.UpdatedDate = GetDateFromDataReader(reader, "UpdatedDate");
            //gameType.CreatedDate = GetDateFromDataReader(reader, "CreatedDate");

            return gameType;
        }     
    }
}
