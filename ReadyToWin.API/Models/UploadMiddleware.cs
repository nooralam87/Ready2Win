using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Web;

namespace ReadyToWin.API.Models
{
    public class UploadMiddleware
    {
        private readonly SmtpClient smtpClient;

        public UploadMiddleware()
        {
            this.smtpClient = new SmtpClient();
        }

        // you can inject services here

        public async Task SendEmailAsync(string email, string subject, string htmlMessage)
        {
            var mailMessage = new MailMessage
            {
                From = new MailAddress("thomas@elmah.io"),
                Subject = subject,
                Body = htmlMessage,
                IsBodyHtml = true,
            };
            mailMessage.To.Add(email);

            await smtpClient.SendMailAsync(mailMessage);
        }
    }
}