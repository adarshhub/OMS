using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OracleClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class WebForm4 : System.Web.UI.Page
    {
        OracleConnection con;
        OracleCommand cmd;

        string SQL;

        protected void Page_Load(object sender, EventArgs e)
        {
            profile_username.Text = (string)Session["username"];

            con = new OracleConnection(Master.conString);
            cmd = new OracleCommand();
            cmd.Connection = con;

            SQL = "SELECT isAdmin FROM cap_users WHERE eid= :eid";
            cmd.CommandText = SQL;
            int userid = Convert.ToInt32(Session["eid"]);
            cmd.Parameters.AddWithValue("eid", userid);
            con.Open();

            int flag = Convert.ToInt32(cmd.ExecuteScalar());

            if (flag == 1)
                isAdmin.Text = "Admin";
            else
                isAdmin.Text = "Not Admin";

            Response.Write("<script>var isAdmin=" + flag + "</script>");
        }

    }
}