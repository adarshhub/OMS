using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Data;
using System.Configuration;
using System.Data.OracleClient;

namespace WebApplication1
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        
        string conString = ConfigurationManager.ConnectionStrings["orcldb"].ConnectionString;
        OracleConnection con;
        protected void Button1_Click(object sender, EventArgs e)
        {
            con = new OracleConnection(conString);
            OracleCommand cmd = new OracleCommand();
            cmd.Connection = con;
            string sql = "SELECT  * from cap_users";
            cmd.CommandText = sql;
            con.Open();
            OracleDataAdapter orada = new OracleDataAdapter();
            orada.SelectCommand = cmd;
            DataTable table = new DataTable();
            orada.Fill(table);
            GridView1.DataSource = table;
            GridView1.DataBind();
            con.Close();
        }
    }
}