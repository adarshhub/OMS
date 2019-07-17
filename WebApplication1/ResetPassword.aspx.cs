using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class WebForm5 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["eid"] == null)
            {
                Response.Redirect("Login.aspx", true);
            }
        }

        protected void change_password_btn_Click(object sender, EventArgs e)
        {

        }
    }
}