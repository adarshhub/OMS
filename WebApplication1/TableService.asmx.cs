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

        JavaScriptSerializer js;

        public TableService()
        {
            con = new OracleConnection(conString);
            js = new JavaScriptSerializer();
            con.Open();
        }

        [WebMethod]
        public void getDepatments()
        {
            List<int> depts = new List<int>();
            
            cmd = new OracleCommand("SELECT DISTINCT dept FROM capacity", con);

            OracleDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                depts.Add(Convert.ToInt32(rdr["dept"]));   
            }

            Context.Response.Write(js.Serialize(depts));
        }

        [WebMethod]
        public void getProcess(int dept)
        {
            List<int> processes = new List<int>();
            cmd = new OracleCommand("SELECT DISTINCT process FROM capacity WHERE dept = :dept", con);
            cmd.Parameters.AddWithValue("dept", dept);

            OracleDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                processes.Add(Convert.ToInt32(rdr["process"]));
            }

            Context.Response.Write(js.Serialize(processes));
        }

        [WebMethod]
        public void getTable(int dept, int process, int from, int to)
        {
            List<Order> orders = new List<Order>();
            string SQL;

            if(from != -1 && to != -1)
            {
                cmd = new OracleCommand("SELECT * FROM capacity WHERE dept= :dept AND process = :process AND yr_wk >= :fromT AND yr_wk <= :toT ORDER BY yr_wk", con);
                cmd.Parameters.AddWithValue("fromT", from);
                cmd.Parameters.AddWithValue("toT", to);
            }
            else if (from != -1 && to == -1)
            {
                cmd = new OracleCommand("SELECT * FROM capacity WHERE dept= :dept AND process = :process AND yr_wk >= :fromT ORDER BY yr_wk", con);
                cmd.Parameters.AddWithValue("fromT", from);
            }
            else
            {
                cmd = new OracleCommand("SELECT * FROM capacity WHERE dept= :dept AND process = :process ORDER BY yr_wk", con);
          
            }
            cmd.Parameters.AddWithValue("dept", dept);
            cmd.Parameters.AddWithValue("process", process);


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
                order.yr_wk = Convert.ToInt32(rdr["yr_wk"]);

                orders.Add(order);
            }

            Context.Response.Write(js.Serialize(orders));

        }

        [WebMethod(EnableSession = true)]
        private void authenticate()
        {
            Session["edit"] = "0";

            int userid = Convert.ToInt32(Session["id"]);
            cmd = new OracleCommand();

            string sql = "SELECT isAdmin FROM cap_users WHERE id = :id";

            cmd.Connection = con;
            cmd.CommandText = sql;

            cmd.Parameters.AddWithValue("id", userid);

            string admin = cmd.ExecuteScalar().ToString();

            if (admin == "1")
            {
                Session["edit"] = "1";
            }

        }

        [WebMethod(EnableSession = true)]
        public void updateOrder(int dept, int process, int process_cntr,int yr_wk, int new_total_qnty)
        {
            
            if(Session["edit"] == null)
            {
                authenticate();
            }

            if (Session["edit"] == "1")
            {
                cmd = new OracleCommand();

                string sql = "UPDATE capacity SET total_avl_qnty = :qnty , last_userid = :userid WHERE dept = :dept AND process = :process AND process_cntr = :process_cntr AND yr_wk = :yr_wk";

                cmd.Connection = con;
                cmd.CommandText = sql;

                int userid = Convert.ToInt32(Session["id"]);

                cmd.Parameters.AddWithValue("qnty", new_total_qnty);
                cmd.Parameters.AddWithValue("dept", dept);
                cmd.Parameters.AddWithValue("process", process);
                cmd.Parameters.AddWithValue("process_cntr", process_cntr);
                cmd.Parameters.AddWithValue("userid", userid);
                cmd.Parameters.AddWithValue("yr_wk", yr_wk);

                int success;

                try
                {
                    success = cmd.ExecuteNonQuery();
                }

                catch(OracleException ex)
                {
                    success = 0;
                }

                if (success != 0)
                {
                    //Successfull
                    Context.Response.Write(js.Serialize("true"));
                }
                else
                {
                    //Not Successfull
                    Context.Response.Write(js.Serialize("false"));
                }

            }
            else
            {
                Context.Response.Write(js.Serialize("false"));
            }
            
        }

        [WebMethod(EnableSession = true)]
        public void deleteOrder(int dept, int process, int process_cntr, int yr_wk)
        {
            if (Session["edit"] == null)
            {
                authenticate();
            }

            if (Session["edit"] == "1")
            {
                
                cmd = new OracleCommand();

                string sql = "DELETE FROM capacity WHERE dept = :dept AND process = :process AND process_cntr = :process_cntr AND yr_wk = :yr_wk";

                cmd.Connection = con;
                cmd.CommandText = sql;

                cmd.Parameters.AddWithValue("dept", dept);
                cmd.Parameters.AddWithValue("process", process);
                cmd.Parameters.AddWithValue("process_cntr", process_cntr);
                cmd.Parameters.AddWithValue("yr_wk", yr_wk);

                int success = cmd.ExecuteNonQuery();

                if (success != 0)
                {
                    //Successfull
                    Context.Response.Write(js.Serialize("true"));
                }
                else
                {
                    //Not Successfull
                    Context.Response.Write(js.Serialize("false"));
                }

            }
            else
            {
                Context.Response.Write(js.Serialize("false"));
            }

        }

        private int alreadyPresent(int dept,int process,int process_cntr)
        {
            
            cmd = new OracleCommand();

            string sql = "SELECT COUNT(*) FROM capacity WHERE dept = :dept AND process = :process AND process_cntr = :process_cntr";

            cmd.Connection = con;
            cmd.CommandText = sql;

            cmd.Parameters.AddWithValue("dept", dept);
            cmd.Parameters.AddWithValue("process", process);
            cmd.Parameters.AddWithValue("process_cntr", process_cntr);

            string success = cmd.ExecuteScalar().ToString();

            return Convert.ToInt32(success);
        }

        [WebMethod(EnableSession = true)]
        public void addOrder(string jsonOrder)
        {
            if (Session["edit"] == null)
            {
                authenticate();
            }

            if (Session["edit"] == "1")
            {
                
                try
                {
                    Order order = (Order)js.Deserialize(jsonOrder, typeof(Order));

                    if (alreadyPresent(order.dept, order.process, order.process_cntr) != 0)
                    {
                        Context.Response.Write(js.Serialize("Order Already Present"));
                    }
                    else
                    {
                        cmd = new OracleCommand();

                        string sql = "INSERT INTO capacity (dept, process, process_cntr, yr_wk, total_avl_qnty, order_qnty) VALUES (:dept, :process, :process_cntr, :yr_wk, :total_avl_qnty, :order_qnty)";

                        cmd.Connection = con;
                        cmd.CommandText = sql;

                        /*

                        int dept = order.dept;
                        int process = order.process;
                        int process_cntr = order.process_cntr;
                        int total_avl_qnty = order.total_avl_qnty;
                        int order_qnty = order.order_qnty;
                        int avl_promise = order.process_cntr;
                        int yr_wk = order.yr_wk;

            */

                        cmd.Parameters.AddWithValue("dept", order.dept);
                        cmd.Parameters.AddWithValue("process", order.process);
                        cmd.Parameters.AddWithValue("process_cntr", order.process_cntr);
                        cmd.Parameters.AddWithValue("yr_wk", order.yr_wk);
                        cmd.Parameters.AddWithValue("total_avl_qnty", order.total_avl_qnty);
                        cmd.Parameters.AddWithValue("order_qnty", order.order_qnty);

                        int success = cmd.ExecuteNonQuery();

                        if (success != 0)
                        {
                            //Successfull
                            Context.Response.Write(js.Serialize("true"));
                        }
                        else
                        {
                            //Not Successfull
                            Context.Response.Write(js.Serialize("Something Went Wrong"));
                        }
                    }

                }

                catch(Exception ex)
                {
                    Context.Response.Write(js.Serialize("Something Went Wrong"));
                }

            }
        }

        [WebMethod(EnableSession = true)]
        public void copyOrder(int dept, int process, int oldFrom, int oldTo, int newTo)
        {
            if (Session["edit"] == null)
            {
                authenticate();
            }

            if (Session["edit"] == "1")
            {
                cmd = new OracleCommand();

                if (oldTo == 0)
                {
                    cmd.CommandText = "copy_from";
                    
                } else
                {
                    cmd.CommandText = "copy_from_to";
                    cmd.Parameters.AddWithValue("oldTo", oldTo);
                }

                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("oldDept", dept);
                cmd.Parameters.AddWithValue("oldProcess", process);
                cmd.Parameters.AddWithValue("oldFrom", oldFrom);
                cmd.Parameters.AddWithValue("newTo", newTo);


                int success;

                try
                {
                    success = cmd.ExecuteNonQuery();

                    if(success != 0)
                    {
                        //Successfull
                        Context.Response.Write(js.Serialize("true"));
                    }
                    else
                    {
                        Context.Response.Write(js.Serialize("Something Went Wrong, Check values"));
                    }

                } catch(Exception ex)
                {
                    //Not Successfull
                    Context.Response.Write(js.Serialize("Could not Copy"));
                }
            }
        }
    }
}
