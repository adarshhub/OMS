using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OracleClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace WebApplication1
{
    /// <summary>
    /// Summary description for TableService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class TableService : System.Web.Services.WebService
    {

        string conString = ConfigurationManager.ConnectionStrings["orcldb"].ConnectionString;
        OracleConnection con;
        OracleCommand cmd;

        [WebMethod(CacheDuration = 2000)]
        public void getDepatments()
        {
            List<int> depts = new List<int>();
            con = new OracleConnection(conString);
            cmd = new OracleCommand("SELECT DISTINCT dept FROM capacity", con);
            con.Open();

            OracleDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                depts.Add(Convert.ToInt32(rdr["dept"]));   
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Write(js.Serialize(depts));
        }

        [WebMethod(CacheDuration = 2000)]
        public void getProcess(int dept)
        {
            List<int> processes = new List<int>();
            con = new OracleConnection(conString);
            cmd = new OracleCommand("SELECT process FROM capacity WHERE dept = :dept", con);
            cmd.Parameters.AddWithValue("dept", dept);
            con.Open();

            OracleDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                processes.Add(Convert.ToInt32(rdr["process"]));
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Write(js.Serialize(processes));
        }

        [WebMethod]
        public void getTable(int dept, int process, int from, int to)
        {
            List<Order> orders = new List<Order>();
            con = new OracleConnection(conString);
            string SQL;

            if(from != -1 && to != -1)
            {
                cmd = new OracleCommand("SELECT * FROM capacity WHERE dept= :dept AND process = :process AND yr_wk >= :fromT AND yr_wk <= :toT", con);
                cmd.Parameters.AddWithValue("dept", dept);
                cmd.Parameters.AddWithValue("process", process);
                cmd.Parameters.AddWithValue("fromT", from);
                cmd.Parameters.AddWithValue("toT", to);
            }
            else if (from != -1 && to == -1)
            {
                cmd = new OracleCommand("SELECT * FROM capacity WHERE dept= :dept AND process = :process AND yr_wk >= :fromT", con);
                cmd.Parameters.AddWithValue("dept", dept);
                cmd.Parameters.AddWithValue("process", process);
                cmd.Parameters.AddWithValue("fromT", from);
            }
            else
            {
                cmd = new OracleCommand("SELECT * FROM capacity WHERE dept= :dept AND process = :process", con);
                cmd.Parameters.AddWithValue("dept", dept);
                cmd.Parameters.AddWithValue("process", process);
            }
            
            con.Open();
            
            OracleDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                Order order = new Order();

                order.dept = Convert.ToInt32(rdr["dept"]);
                order.process = Convert.ToInt32(rdr["process"]);
                order.avl_promise = Convert.ToInt32(rdr["avl_promise"]);
                order.total_avl_qnty = Convert.ToInt32(rdr["total_avl_qnty"]);
                order.order_qnty = Convert.ToInt32(rdr["order_qnty"]);
                order.process_cntr = Convert.ToInt32(rdr["process_cntr"]);

                orders.Add(order);
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Write(js.Serialize(orders));

        }

        [WebMethod(EnableSession = true)]
        private void authenticate()
        {
            Session["edit"] = "0";

            int userid = Convert.ToInt32(Session["id"]);

            con = new OracleConnection(conString);
            cmd = new OracleCommand();

            string sql = "SELECT isAdmin FROM cap_users WHERE id = :id";

            cmd.Connection = con;
            cmd.CommandText = sql;

            cmd.Parameters.AddWithValue("id", userid);

            con.Open();

            string admin = cmd.ExecuteScalar().ToString();

            if (admin == "1")
            {
                Session["edit"] = "1";
            }

        }

        [WebMethod(EnableSession = true)]
        public void updateOrder(int dept, int process, int process_cntr)
        {
            
            if(Session["edit"] == null)
            {
                authenticate();
            }

            JavaScriptSerializer js = new JavaScriptSerializer();

            if (Session["edit"] == "1")
            {
                Context.Response.Write(js.Serialize("true"));
            } else
            {
                Context.Response.Write(js.Serialize("false"));
            }
            
        }
    }
}
