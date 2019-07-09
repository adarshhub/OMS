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

            SQL = "SELECT isAdmin FROM cap_users WHERE id= :id";
            cmd.CommandText = SQL;
            int userid = Convert.ToInt32(Session["id"]);
            cmd.Parameters.AddWithValue("id", userid);
            con.Open();

            int flag = Convert.ToInt32(cmd.ExecuteScalar());

            if (flag == 1)
                isAdmin.Text = "Admin";
            else
                isAdmin.Text = "Not Admin";
        }

    }
}