using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.Entities.Constant
{
    public static class Status
    {
        public const int FOUND = 200;
        public const int NOT_FOUND = 201;
        public const int INSERTED = 202;
        public const int NOT_INSERTED = 203;
        public const int ALREADY = 204;
        public const int UPDATED = 205;
        public const int NOT_UPDATED = 206;
        public const int DELETED = 207;
        public const int NOT_DELETED = 208;
        public const int VALIDATION_ERROR = 209;
        public const int ERROR = 500;
        public const int BAD_REQUEST = 400;
        public const int Done = 210;
        //public const int CONTINUE = 100;
        //public const int REFERENCE = 204;
        //public const int UN_AUTH = 401;
        //public const int INVALID_USER = 404;
        //public const int METHOD_NOT_SUPPORTED = 407;
        //public const int INVALID_REQUEST = 408;        
        //public const int RECORD_INSERTED_SUCCESSFULLY = 1;
    }
}
