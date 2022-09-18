using ReadyToWin.Complaince.Entities.QutationRepositry;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.Vendor;
using System.Collections.Generic;
using System.Net.Mail;

namespace ReadyToWin.Complaince.BussinessProvider.IProviders
{
    public interface ICreateQutation
    {
        DbOutput RequestQutation(Qutation qutation);
        List<string> GetAllVendors();
    }
}
