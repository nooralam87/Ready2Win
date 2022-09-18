using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.UserModel
{
    public class Menu
    {
        public int Id { get; set; }
        public string DisplayName { get; set; }
        public string Url { get; set; }
        public long ParentId { get; set; }
    }
}
