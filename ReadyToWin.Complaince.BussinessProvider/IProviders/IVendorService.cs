﻿using ReadyToWin.Complaince.Entities.QutationRepositry;
using ReadyToWin.Complaince.Entities.ResponseModel;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.BussinessProvider.IProviders
{
    public interface IVendorService
    {
        DbOutput RequestVendor(ref Vendor vendor);
        List<string> GetAllVendors();
        Customer GetCustomerTransaction(int id);
    }
}
