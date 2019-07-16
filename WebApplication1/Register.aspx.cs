using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.OracleClient;
using System.Linq;
using System.Text;
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

        private string encrypt(string password)
        {
            string msg = "";
            byte[] encode = new byte[password.Length];
            encode = Encoding.UTF8.GetBytes(password);
            msg = Convert.ToBase64String(encode);
            return msg;
        }

        protected void register_button_Click(object sender, EventArgs e)
        {
            int eid;
            string username, password1, password2;

            eid = Convert.ToInt32(register_eid.Text);
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
                if (eid < 100000 && eid > 999999)
                {
                    Master.addMessage("EID should be of 6 Digits");
                }
                else if (password1 != password2)
                {
                    Master.addMessage("Password do not Match");
                }
                else
                {
                    string encr_pass = encrypt(password1);

                    sql = "INSERT INTO cap_users (username, eid, password, isAdmin) VALUES (:username, :eid, :password, :isAdmin)";
                    cmd.CommandText = sql;
                    cmd.Parameters.AddWithValue("eid", eid);
                    cmd.Parameters.AddWithValue("username", username);
                    cmd.Parameters.AddWithValue("password", encr_pass);
                    cmd.Parameters.AddWithValue("isAdmin", 0);

                    int success = cmd.ExecuteNonQuery();

                    if (success != 0)
                    {
                        Master.addMessage("Registration Successfull");
                        //Navigate to login page
                    }
                    else
                    {
                        Master.addMessage("Something Went Wrong");
                    }

                }
            }
            
            con.Close();

        }
    }
}