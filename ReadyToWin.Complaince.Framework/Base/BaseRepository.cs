using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;

namespace ReadyToWin.Complaince.Framework.Base
{
    public abstract class BaseRepository
    {
        /// <summary>
        /// OUTPARAMETER_SIZE
        /// </summary>
        protected const Int32 OUTPARAMETER_SIZE = -1;

        /// <summary>
        /// Gets the string value.
        /// </summary>
        /// <param name="dataReader">The data reader.</param>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        protected string GetStringValue(IDataReader dataReader, string columnName)
        {
            //Retreive the column from the data reader
            object value = dataReader[columnName];

            string valueToReturn = null;

            //If the retrieved value is not null then cast it to the correct type
            if (!(value is DBNull))
            {
                valueToReturn = value.ToString();
            }

            return valueToReturn;

        }

        /// <summary>
        /// Gets the integer value.
        /// </summary>
        /// <param name="dataReader">The data reader.</param>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        protected Int32? GetIntegerValue(IDataReader dataReader, string columnName)
        {
            //Retreive the column from the data reader
            object value = dataReader[columnName];

            Int32? valueToReturn = null;

            //If the retrieved value is not null then cast it to the correct type
            if (!(value is DBNull))
            {
                valueToReturn = (Int32?)value;
            }

            return valueToReturn;
        }

        /// <summary>
        /// Gets the date value.
        /// </summary>
        /// <param name="dataReader">The data reader.</param>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        protected DateTime? GetDateValue(IDataReader dataReader, string columnName)
        {
            //Retreive the column from the data reader
            object value = dataReader[columnName];

            DateTime? valueToReturn = null;

            //If the retrieved value is not null then cast it to the correct type
            if (!(value is DBNull))
            {
                valueToReturn = (DateTime?)value;
            }

            return valueToReturn;

        }

        /// <summary>
        /// Gets the bool value.
        /// </summary>
        /// <param name="dataReader">The data reader.</param>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        protected bool GetBoolValue(IDataReader dataReader, string columnName)
        {
            //Retreive the column from the data reader
            object value = dataReader[columnName];

            bool valueToReturn = false;

            //If the retrieved value is not null then cast it to the correct type
            if (!(value is DBNull))
            {
                valueToReturn = (bool)value;
            }

            return valueToReturn;

        }

        /// <summary>
        /// Gets the decimal value.
        /// </summary>
        /// <param name="dataReader">The data reader.</param>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        protected decimal? GetDecimalValue(IDataReader dataReader, string columnName)
        {
            //Retreive the column from the data reader
            object value = dataReader[columnName];

            decimal? valueToReturn = null;

            //If the retrieved value is not null then cast it to the correct type
            if (!(value is DBNull))
            {
                valueToReturn = (decimal?)value;
            }

            return valueToReturn;

        }

        /// <summary>
        /// Gets the byte value.
        /// </summary>
        /// <param name="dataReader">The data reader.</param>
        /// <param name="columnName">Name of the column.</param>
        /// <returns></returns>
        protected byte[] GetByteValue(IDataReader dataReader, string columnName)
        {
            //Retreive the column from the data reader
            object value = dataReader[columnName];

            byte[] valueToReturn = null;

            //If the retrieved value is not null then cast it to the correct type
            if (!(value is DBNull))
            {
                valueToReturn = (byte[])value;
            }

            return valueToReturn;

        }
    }

    /// <summary>
    /// Responsible to convert JSON and read 
    /// </summary>
    public static class JsonConversion
    {
        public static string ToJson(this object obj, int recursionDepth = 100, int maxJsonLength = Int32.MaxValue)
        {
            if (obj == null)
            {
                return null;
            }
            else
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                serializer.MaxJsonLength = maxJsonLength;
                serializer.RecursionLimit = recursionDepth;
                return serializer.Serialize(obj);
            }
        }

        public static List<T> ToListObject<T>(this string obj, int recursionDepth = 100, int maxJsonLength = 4000)
        {
            List<T> returnList = new List<T>();
            if (!string.IsNullOrEmpty(obj))
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                serializer.MaxJsonLength = maxJsonLength;
                serializer.RecursionLimit = recursionDepth;
                returnList = serializer.Deserialize<List<T>>(obj);
            }
            return returnList;
        }
    }
}
