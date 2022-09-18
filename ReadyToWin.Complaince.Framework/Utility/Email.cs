using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mail;
using System.Configuration;
using ReadyToWin.Complaince.Entities.Constant;

namespace ReadyToWin.Complaince.Framework.Utility
{
    public class Email
    {
        
        public void SendEmail(string from, string[] to, string[] cc = null, string[] bcc = null, byte[] attachment = null, string subject = "", string body = "")
        {
            SmtpClient client = new SmtpClient();
            var userName = ConfigurationManager.AppSettings[ConfigConstant.UserName].ToString();
            var password = ConfigurationManager.AppSettings[ConfigConstant.Password].ToString();
            client.UseDefaultCredentials = false;
            client.Credentials = new System.Net.NetworkCredential(userName, password);
            client.Port = Convert.ToInt32(ConfigurationManager.AppSettings[ConfigConstant.Port].ToString());
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.Host = ConfigurationManager.AppSettings[ConfigConstant.Host].ToString();

            var mailAddress = ConfigurationManager.AppSettings[ConfigConstant.MailAddress].ToString();

            string address = "";
            MailAddress fromAddress = new MailAddress(address);
            
            MailMessage mail = new MailMessage();
            mail.Priority = MailPriority.Normal;
            mail.From = fromAddress;

            foreach (var item in to)
            {
                mail.To.Add(new MailAddress(item));
            }

            foreach (var item in cc)
            {
                mail.CC.Add(new MailAddress(item));
            }

            foreach (var item in bcc)
            {
                mail.Bcc.Add(new MailAddress(item));
            }

            mail.Subject = subject;
            mail.Body = body;

            client.Send(mail);
        }
    }
}
