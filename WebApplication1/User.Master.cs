using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class User : System.Web.UI.MasterPage
    {
        public String conString = ConfigurationManager.ConnectionStrings["orcldb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            string username = (string)Session["username"];
            if (username == null)
            {
                Response.Redirect("Login.aspx", true);
            }

            nav_username.Text = username;
            
        }


        protected void Logout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
    }
}