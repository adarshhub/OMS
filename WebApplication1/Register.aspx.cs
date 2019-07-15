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
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        OracleConnection con;
        OracleCommand cmd;

        protected void register_button_Click(object sender, EventArgs e)
        {
            string eid, username, password1, password2;

            eid = register_eid.Text.ToString();
            username = register_un.Text.ToString();
            password1 = register_password1.Text.ToString();
            password2 = register_password2.Text.ToString();

            con = new OracleConnection(Master.conString);
            cmd = new OracleCommand();
            cmd.Connection = con;

            string sql = "Select COUNT(*) from cap_users WHERE eid= :eid";
            cmd.CommandText = sql;
            cmd.Parameters.AddWithValue("eid", eid);
            con.Open();
            string resp = cmd.ExecuteScalar().ToString();
            //OracleDataAdapter orada = new OracleDataAdapter(cmd.CommandText, con);
            if(resp == "1"){
                Master.addMessage("EID already Registered");
            } else
            {
                if (password1 != password2)
                    Master.addMessage("Password do not Match");
                else
                {
                    sql = "INSERT INTO cap_users (username, eid, password, isAdmin) VALUES (:username, :eid, :password, :isAdmin)";
                    cmd.CommandText = sql;
                    cmd.Parameters.AddWithValue("eid", eid);
                    cmd.Parameters.AddWithValue("username", username);
                    cmd.Parameters.AddWithValue("password", password1);
                    cmd.Parameters.AddWithValue("isAdmin", 0);

                    int success = cmd.ExecuteNonQuery();

                    if (success != 0)
                    {
                        Master.addMessage("Registration Successfull");
                        //Navigate to login page
                    } else
                    {
                        Master.addMessage("Something Went Wrong");
                    }

                }
            }
            
            con.Close();

        }
    }
}