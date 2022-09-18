using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReadyToWin.Complaince.DataAccess
{
    class DBConstraints
    {   
        public const string IdParam = "In_ProjectStatusKey";
        //Big Commerce User
        public const string INSERT_USER_Qutation = "usp_insert_qutation";
        public const string INSERT_VENDOR_Qutation = "usp_insert_vendor_reply";
        public const string GET_ALL_Vendor_Email = "usp_select__all_vendor_Email";
        //GameType
        public const string ALL_GAMETYPE = "usp_select_gametype";
        public const string ALL_GAMECATEGORY = "usp_select_gamecatbyid";
        public const string ALL_GAMESUBCATEGORY = "usp_select_GameSubCategorybyId";

        //USER
        public const string ALL_USERS = "usp_select_user";
        public const string GET_All_USER = "usp_select_All_user";
        public const string USERS_BY_DEPARTMENT_ID = "usp_select_userbydepartmentid";
        public const string GET_USER_BY_USERID = "usp_select_userbyuserid";
        public const string GET_USER_BY_ID = "usp_select_userbyid";
        public const string CHECK_TOKEN = "usp_select_tokenbyuserid";
        public const string INSERT_TOKEN = "usp_insert_token";
        public const string INSERT_USER = "usp_insert_user";
        public const string UPDATE_USER = "usp_update_user";
        public const string DELETE_USER = "usp_delete_user";
        public const string ROLE_BY_USERID = "usp_select_rolebyuserid";
        public const string CREATE_ROLE = "usp_insert_assignrole";
        public const string LOGGOFF = "usp_logoff";
        public const string CHANGE_PASSWORD = "usp_change_password";
        public const string RESET_PASSWORD = "usp_reset_password";
        public const string USER_REPORT_PERMISSION = "usp_select_user_report_permission";
        public const string EXPORT_USERS = "usp_export_users";


        //USER Transaction       
        public const string USER_AMOUNT_DEPOSIT = "usp_user_deposit_amount";
        public const string USER_AMOUNT_WITHDRAW = "usp_user_withdraw_amount";
        public const string INSERT_USER_GAME_SELECTION_SUBMIT = "usp_user_game_selection_submit";

        //Admin declare Winner User      
        public const string USER_WINNER_AMOUNT = "usp_user_winning_amount";
        public const string USER_DEPOSIT_AMOUNT_APPROVED = "usp_user_deposit_amount_approvedby_admin";
        public const string USER_WITHDRAW_AMOUNT_APPROVED = "usp_user_withdraw_amount_approvedby_admin";

        public const string GET_USER_TOTAL_AMOUNT = "usp_user_Total_Amount";

        //CATEGORY
        public const string INSERT_CATEGORY = "usp_insert_categories";
        public const string UPDATE_CATEGORY = "usp_update_categories";
        public const string DELETE_CATEGORY = "usp_delete_categories";
        public const string GET_CATEGORY = "usp_select_categories";
        public const string GET_Parent_CATEGORY = "usp_select_parent_categories";

        //CATEGORY
        public const string INSERT_PRODUCT = "usp_insert_product";

        //Manufacturer
        public const string GET_MANUFACTURE = "usp_select_manufacturer"; 
        public const string GET_BESTOFFER = "usp_select_brand_sale";
        public const string GET_RECOMMENDED_ITEMS = "usp_select_recommended_items";

        //MASTER
        public const string GET_ONLINE_USER = "usp_select_onlineuser";
        public const string INSERT_DEPARTMENT = "usp_insert_department";
        public const string UPDATE_DEPARTMENT = "usp_update_department";
        public const string DELETE_DEPARTMENT = "usp_delete_department";
        public const string GET_DEPARTMENTS = "usp_select_departments";
        public const string INSERT_POLICY_STATUS = "usp_insert_policy_status";
        public const string UPDATE_POLICY_STATUS = "usp_update_policy_status";
        public const string DELETE_POLICY_STATUS = "usp_delete_policy_status";
        public const string GET_POLICY_STATUS = "usp_select_policy_status";
        public const string INSERT_MODULE = "usp_insert_module";
        public const string DELETE_MODULE = "usp_delete_module";
        public const string UPDATE_MODULE = "usp_update_module";
        public const string GET_MODULES = "usp_select_modules";


        //Dasboard
        public const string GET_REPORTS_BY_MODULE = "usp_select_module_reports";

        //Template
        public const string CREATE_TEMPLATE = "usp_create_report_template";
        public const string EDIT_TEMPLATE = "usp_update_template";
        public const string DELETE_TEMPLATE = "usp_delete_template";
        public const string ALL_TEMPLATE = "usp_select_all_template";

        //Policy 
        public const string VERIFY_POLICY = "usp_verify_policy";
        public const string POLICY_DETAIL_BY_POLICY_ID = "usp_policy_detail_by_policy_id";
        public const string REPORT_FILTER = "usp_report_filter";
        public const string CONCURRENT_AUDIT = "usp_concurrent_audit";
        public const string GRID = "usp_select_user";
        public const string CONSOLIDATED_REPORT = "usp_consolidated_report";

    }
}
