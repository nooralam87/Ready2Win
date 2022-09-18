using ReadyToWin.Complaince.Framework.Base;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using ReadyToWin.Complaince.Entities.GameType;
using ReadyToWin.Complaince.BussinessProvider.IProviders;
using ReadyToWin.API.Filters;
using System.Web.Http.Description;
using System.Collections.Generic;
using ReadyToWin.Complaince.Entities.RequestModels;
using ReadyToWin.Complaince.Framework.Utility;
using ReadyToWin.Complaince.Entities.ResponseModel;
using ReadyToWin.Complaince.Entities.Constant;
using System.Data;
using System;
using System.Security.Claims;
using ReadyToWin.API.Models;

namespace ReadyToWin.API.Controllers
{
    [CustomAuthorize(Roles = "Player,Admin")]
    [RoutePrefix("api/GameType")]
    public class GameTypeController : BaseApiController
    {

       IGameType _iGameType;

        /// <summary>
        /// Initilize UserController.
        /// </summary>
        /// <param name="_iUserProvider"></param>
       public GameTypeController(IGameType _iGameType)
       {
            this._iGameType = _iGameType;
       }

       /// <summary>
       /// Get all GameType. 
       /// </summary>
       /// <returns></returns>        
       [HttpGet]
       [Route("GetAllGameType")]
       [ResponseType(typeof(GameType))]
       public async Task<HttpResponseMessage> GetAllGameType()
       {
           var output = _iGameType.GetGameType();
           return await CreateResponse(output, Convert.ToString(typeof(GameType)));
       }

       [HttpGet]
       [Route("GetAllGameCategory")]
       [ResponseType(typeof(GameCategory))]
       public async Task<HttpResponseMessage> GetAllGameCategory(long GameTypeId)
       {
           var output = _iGameType.GetAllGameCategory(GameTypeId);
           return await CreateResponse(output, Convert.ToString(typeof(GameCategory)));
       }

       [HttpGet]
       [Route("GetAllSubGameCategory")]
       [ResponseType(typeof(GameSubCategory))]
       public async Task<HttpResponseMessage> GetAllSubGameCategory(long GameCategoryId)
       {
           var output = _iGameType.GetAllSubGameCategory(GameCategoryId);
           return await CreateResponse(output, Convert.ToString(typeof(GameSubCategory)));
       }

	}
}