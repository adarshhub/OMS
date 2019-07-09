

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
            string email = login_email.Text.ToString();
            string password = login_password.Text.ToString();

            con = new OracleConnection(Master.conString);
            cmd = new OracleCommand();
            cmd.Connection = con;

            string sql = "SELECT id, username, password FROM cap_users WHERE email= :email";
            cmd.CommandText = sql;
            cmd.Parameters.AddWithValue("email", email);
            con.Open();

            reader = cmd.ExecuteReader();
            if (reader.HasRows)
            {
                reader.Read();
                string unR = reader["username"].ToString();
                string passR = reader["password"].ToString();
                int id = Convert.ToInt32(reader["id"]);
                reader.Close();
                if (password != passR)
                {
                    Response.Write("Wrong Password");
                }
                else
                {
                    Session["username"] = unR;
                    Session["email"] = email;
                    Session["id"] = id;
                    Response.Redirect("Dashboard.aspx");
                }
                
            }
            else
            {
                Response.Write("Not Registered");
            }
  
            con.Close();
        }

    }
}