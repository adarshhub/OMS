

using System;

using System.Configuration;
using System.Data.OracleClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class WebForm1 : System.Web.UI.Page
    {

        OracleConnection con;
        OracleCommand cmd;
        OracleDataReader reader;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void login_btn_Click(object sender, EventArgs e)
        {
            string eid = login_eid.Text.ToString();
            string password = login_password.Text.ToString();

            con = new OracleConnection(Master.conString);
            cmd = new OracleCommand();
            cmd.Connection = con;

            string sql = "SELECT id, username, password FROM cap_users WHERE eid= :eid";
            cmd.CommandText = sql;
            cmd.Parameters.AddWithValue("eid", eid);
            con.Open();

            try
            {
                reader = cmd.ExecuteReader();

                if (reader.HasRows)
                {
                    reader.Read();
                    string unR = reader["username"].ToString();
                    string passR = reader["password"].ToString();

                    reader.Close();
                    if (password != passR)
                    {
                        Master.addMessage("Wrong Password");
                    }
                    else
                    {
                        Session["username"] = unR;
                        Session["eid"] = eid;
                        Response.Redirect("Dashboard.aspx");
                    }

                }
                else
                {
                    Master.addMessage("Not Registered");
                }

            }

            catch(Exception ex)
            {
                Master.addMessage("Something Went Wrong");
            }

            con.Close();
        }

    }
}