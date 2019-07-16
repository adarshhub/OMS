

using System;

using System.Configuration;
using System.Data.OracleClient;
using System.Linq;
using System.Text;
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


        private static string decrypt(string encryptpwd)
        {
            string decryptpwd = string.Empty;
            UTF8Encoding encodepwd = new UTF8Encoding();
            Decoder Decode = encodepwd.GetDecoder();
            byte[] todecode_byte = Convert.FromBase64String(encryptpwd);
            int charCount = Decode.GetCharCount(todecode_byte, 0, todecode_byte.Length);
            char[] decoded_char = new char[charCount];
            Decode.GetChars(todecode_byte, 0, todecode_byte.Length, decoded_char, 0);
            decryptpwd = new String(decoded_char);
            return decryptpwd;
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
                    if (password != decrypt(passR))
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