using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Transactions;
using ReadyToWin.Complaince.Entities.MasterModel;

namespace ReadyToWin.Complaince.DataAccess
{
   public class BaseDAL
    {
        protected const string C_Connection = "DQC_SQL_PRD_Connection";
        protected const string C_Connection_Big = "BigCommerce_Connection";
        public TransactionOptions trans = new TransactionOptions();

        public BaseDAL()
        {
            trans.IsolationLevel = System.Transactions.IsolationLevel.ReadCommitted;
        }

        #region Reading Data from IDataReader
        protected DateTime GetDateFromDataReader(IDataReader reader,String key)
        {
            //if(reader[key] == DBNull.Value)
            //{
            //    return DateTime.MinValue;
            //}
            //else
            //{
            //    return reader.GetDateTime(reader.GetOrdinal(key));
            //}
            return reader[key] == DBNull.Value ? DateTime.MinValue : reader.GetDateTime(reader.GetOrdinal(key));
        }
        protected Int16 GetShortIntegerFromDataReader(IDataReader reader, String key)
        {
            if (reader[key] == DBNull.Value)
            {
                return Int16.MinValue;
            }
            else
            {
                Int16 indexInt = Convert.ToInt16(reader.GetOrdinal(key));
                Object obj = reader.GetValue(indexInt);
                if(obj != null)
                {
                    return Convert.ToInt16(obj);
                }
            }
            return Int16.MinValue;
        }
        protected Int32 GetIntegerFromDataReader(IDataReader reader, String key)
        {
            try {
                if (reader[key] == DBNull.Value)
                {
                    return Int32.MinValue;
                }
                else
                {
                    Int32 indexInt = reader.GetOrdinal(key);
                    Object obj = reader.GetValue(indexInt);
                    if (obj != null)
                    {
                        return Convert.ToInt32(obj);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return Int32.MinValue;
        }
        protected Int64 GetLongIntegerFromDataReader(IDataReader reader, String key)
        {
            if (reader[key] == DBNull.Value)
            {
                return Int64.MinValue;
            }
            else
            {
                return reader.GetInt64(reader.GetOrdinal(key));
            }
        }
        protected String GetStringFromDataReader(IDataReader reader, String key)
        {
            if (reader[key] == DBNull.Value)
            {
                return null;
            }
            else
            {
                return reader.GetString(reader.GetOrdinal(key));
            }
        }
        protected bool GetBooleanFromDataReader(IDataReader reader, String key)
        {
            if (reader[key] == DBNull.Value)
            {
                return false;
            }
            else
            {
                Int16 boolValue = Convert.ToInt16(reader[key]);
                return boolValue > 0 ? true : false;
            }
        }
        protected byte[] GetByteFromDataReader(IDataReader reader, String key)
        {
            if (reader[key] == DBNull.Value)
            {
                return null;
            }
            else
            {
                return (byte[])reader[key];
            }
        }
        protected Decimal GetDecimalFromDataReader(IDataReader reader, String key)
        {
            if(reader[key] == DBNull.Value)
            {
                return Decimal.MinValue;
            }
            else
            {
                Decimal decimalValue;
                Decimal dec = Convert.ToDecimal(reader[key]);
                return Decimal.TryParse(Convert.ToString(reader[key]), out decimalValue)? decimalValue:0m;
                //return (decimal)reader[key];
            }
        }
        protected double GetDoubleFromDataReader(IDataReader reader, String key)
        {
            if (reader[key] == DBNull.Value)
            {
                return double.MinValue;
            }
            else
            {
                return reader.GetDouble(reader.GetOrdinal(key));
            }
        }
        #endregion

        #region OutPut Parameter Section
        protected Int32 GetIntegerFromOutPutParameter(object value)
        {
            return value == DBNull.Value ? Int32.MinValue : Convert.ToInt32(value);
        }
        protected String GetStringFromOutPutParameter(object value)
        {
            return value == DBNull.Value ? null : Convert.ToString(value);
        }
        protected bool GetBooleanFromOutPutParameter(object value)
        {
            if(value == DBNull.Value)
            {
                return false;
            }
            else
            {
                Int16 intgrValue = Convert.ToInt16(value);
                return intgrValue > 0 ? true : false;
            }
        }
        #endregion
        protected String GetDate(DateTime dt)
        {
            return string.Format("{0:yyyy/MM/dd}", dt);
        }
        protected String CurrentDate
        {
            get
            {
                return string.Format("{0:yyyy/MM/dd}", DateTime.Now.Date);
            }
            
        }
        public Picture GetPicture(IDataReader reader)
        {
            Picture _obj_pic = new Picture();
            _obj_pic.IsNew = GetBooleanFromDataReader(reader, "IsNew");
            _obj_pic.MimeType = GetStringFromDataReader(reader, "MimeType");
            _obj_pic.PictureBinary = GetByteFromDataReader(reader, "PictureBinary");
            //_obj_pic.ProductPictures = GetStringFromDataReader(reader, "");
            _obj_pic.SeoFilename = GetStringFromDataReader(reader, "SeoFilename");
            return _obj_pic;
        }
    }
}
