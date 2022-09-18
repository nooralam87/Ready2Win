using ReadyToWin.Complaince.Entities.UserModel;
using ReadyToWin.Complaince.Framework.Exception;
using ReadyToWin.Complaince.Framework.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.DataAccess.Repository
{
    public class TokenRepository
    {
        public Token GenerateToken(string UserId)
        {
            try
            {
                Token token = new Token();
                // Validating ClientId and ClientSecert already Exists
                var keyExists = this.IsUniqueKeyAlreadyGenerate(UserId);
                if (keyExists)
                {
                    // Getting Generate ClientID and ClientSecert Key By UserID
                    token = this.GetGenerateUniqueKeyByUserID(UserId);
                }
                else
                {
                    string clientId = string.Empty;
                    string clientSecert = string.Empty;
                    //Generate Keys
                    this.GenerateUniqueKey(out clientId, out clientSecert);
                    //Saving Keys Details in Database
                    token.UserId = UserId;                    
                    token.TokenValue = clientSecert;
                    token.CreatedDate = DateTime.Now;

                    //this.SaveClientIDandClientSecert(clientkeys);
                    //save token to database
                }
                return token;
            }
            catch (Exception ex)
            {
                //ApiLogger.Instance.ErrorLog(ex.ToString());
                return new Token();
            }
        }

        public bool IsUniqueKeyAlreadyGenerate(string UserId)
        {
            //bool keyExists = _context.ClientKeys.Any(clientkeys => clientkeys.UserID.Equals(UserId) 
            //&& (clientkeys.CustomerID.Equals(CustomerId)));

            //if (keyExists)
            //{
            //    return true;
            //}
            //else
            //{
            //    return false;
            //}
            return true;
        }

        public Token GetGenerateUniqueKeyByUserID(string UserId)
        {
            //var clientkey = (from ckey in _context.ClientKeys.Where(x => x.UserID == UserId 
            //                 && (x.CustomerID == CustomerId)) select ckey).FirstOrDefault();
            //return clientkey;

            return new Token();
        }

        public void GenerateUniqueKey(out string TokenId, out string TokenValue)
        {
            TokenId = EncryptionLibrary.KeyGenerator.GetUniqueKey();
            TokenValue = EncryptionLibrary.KeyGenerator.GetUniqueKey();
        }
    }
}
