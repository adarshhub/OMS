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

        public void addMessage(string msg)
        {
            msg_box.InnerHtml = "<div class='alert alert-warning' style='width: 200px; position: absolute; bottom: 0; left: 0; top: 20%; max-height: 135px; '><h4 class='alert-heading'>OOPs!</h4><p class='mb-0'>" + msg +"</p></div>";
        }
    }
}