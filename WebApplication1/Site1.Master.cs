using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.OracleClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        public String conString = ConfigurationManager.ConnectionStrings["orcldb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void errorMessage(string msg)
        {
            ms_msg_box.InnerHtml = "<div class='alert alert-dismissible alert-warning'  ><h4 class='alert-heading'>Not Successfull!</h4><p class='mb-0'>" + msg + "</p></div>";
        }

        public void successMessage(string msg)
        {
            ms_msg_box.InnerHtml = "<div class='alert alert-dismissible alert-success'  ><h4 class='alert-heading'>Great!</h4><p class='mb-0'>" + msg + "</p></div>";
        }
    }
}