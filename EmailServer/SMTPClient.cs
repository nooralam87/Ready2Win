using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Configuration;
using System.IO;

namespace EmailServer
{
    public class SMTPClient: ISmtpClient
    {
        private readonly SmtpClient smtpClient;
        MailAddress fromAddress = new MailAddress(Convert.ToString(ConfigurationManager.AppSettings["FromMailAddress"]),
            Convert.ToString(ConfigurationManager.AppSettings["FromName"]));
        private readonly string fromPassword = ConfigurationManager.AppSettings["FromPassword"].ToString();
        private readonly string CC_mail = ConfigurationManager.AppSettings["CCMailAddress"].ToString();
        public SMTPClient()
        {
            smtpClient = new SmtpClient
            {
                Host = Convert.ToString(ConfigurationManager.AppSettings["Host"]),
                Port = Convert.ToInt32(ConfigurationManager.AppSettings["Port"].ToString()),
                EnableSsl = ConfigurationManager.AppSettings["EnableSsl"].ToString().ToUpper()=="YES"?true:false ,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(fromAddress.Address, fromPassword)
            };
        }

        // you can inject services here

        public async Task SendEmailAsync(string email, string subject, string htmlMessage)
        {
            var mailMessage = new MailMessage
            {
                From = new MailAddress(fromAddress.Address, "Delegated Mtech Labs"),
                Subject = subject,               
                //Body = htmlMessage,
                IsBodyHtml = true,
            };
            string _filepath = @"C:\Users\Abdul\Downloads\standard.html";
            StreamReader str = new StreamReader(_filepath);
            string _mailbody = str.ReadToEnd();
            str.Close();
            mailMessage.Body = _mailbody;
            mailMessage.To.Add(email);
            mailMessage.CC.Add("umairraza3162@gmail.com");
            //mailMessage.To.Add(email);

            await smtpClient.SendMailAsync(mailMessage);
        }
    }
}
