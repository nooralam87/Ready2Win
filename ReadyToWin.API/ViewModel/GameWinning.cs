using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ReadyToWin.API.ViewModel
{
    public class GameWinning
    {
        public long Id { get; set; }
        public long GameTypeId { get; set; }
        public string GameTypeName { get; set; }
        public long AdminUserId { get; set; }
        public int winningNumber { get; set; }
    }
}