using System.Web;
using System.Web.Optimization;

namespace ReadyToWin.API
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            //Bootstrap core JavaScript
            bundles.Add(new ScriptBundle("~/bundles/vendor/jquery").Include(
                        "~/Content/vendor/jquery/jquery.min.js",
                        "~/Content/vendor/bootstrap/js/bootstrap.bundle.min.js"));
             //Core plugin JavaScript
            bundles.Add(new ScriptBundle("~/bundles/Coreplugin").Include(
                        "~/Content/vendor/jquery-easing/jquery.easing.min.js"));
             //Custom scripts for all pages
            bundles.Add(new ScriptBundle("~/bundles/Customscripts").Include(
                       "~/Content/js/sb-admin-2.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/site.css"));
        }
    }
}
