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
            string email, username, password1, password2;

            email = register_email.Text.ToString();
            username = register_un.Text.ToString();
            password1 = register_password1.Text.ToString();
            password2 = register_password2.Text.ToString();

            con = new OracleConnection(Master.conString);
            cmd = new OracleCommand();
            cmd.Connection = con;

            string sql = "Select COUNT(*) from cap_users WHERE email= :email";
            cmd.CommandText = sql;
            cmd.Parameters.AddWithValue("email",email);
            con.Open();
            string resp = cmd.ExecuteScalar().ToString();
            //OracleDataAdapter orada = new OracleDataAdapter(cmd.CommandText, con);
            if(resp == "1"){
                Response.Write("Email already Registered");
            } else
            {
                if (password1 != password2)
                    Response.Write("Password do not Match");
                else
                {
                    sql = "INSERT INTO cap_users (username, email, password, isAdmin) VALUES (:username, :email, :password, :isAdmin)";
                    cmd.CommandText = sql;
                    cmd.Parameters.AddWithValue("email", email);
                    cmd.Parameters.AddWithValue("username", username);
                    cmd.Parameters.AddWithValue("password", password1);
                    cmd.Parameters.AddWithValue("isAdmin", 0);

                    int success = cmd.ExecuteNonQuery();

                    if (success != 0)
                    {
                        Response.Write("Registration Successfull");
                        //Navigate to login page
                    } else
                    {
                        Response.Write("Something Went Wrong");
                    }

                }
            }
            
            con.Close();

        }
    }
}