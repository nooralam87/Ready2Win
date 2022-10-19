using ReadyToWin.Complaince.Entities.AdminModel;
using ReadyToWin.Complaince.Entities.GameType;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ReadyToWin.API.ViewModel
{
    public class GameResultFilter
    {
        public List<AmountOnGameByGameType> AmountOnGameByGameType { get; set; }
        public List<GameType> GameNames { get; set; }
        public List<UserSelect> Users { get; set; }
        //public List<GameDate> GameDate { get; set; }
        public long gametypeId { get; set; }
        public long userId { get; set; }
        public int spliting_number { get; set; }
        //public DateTime selecteddate { get; set; }
    }
    public class UserSelect
    {
        public long userId { get; set; }
        public string MyUserName { get; set; }
    }
    public class GameDate
    {
        public long Id { get; set; }
        public DateTime gamedate { get; set; }
    }
}