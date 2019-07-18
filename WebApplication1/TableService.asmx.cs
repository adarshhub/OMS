using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OracleClient;
using System.Linq;
using System.Text;
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
            List<string> depts = new List<string>();
            
            cmd = new OracleCommand("SELECT DISTINCT dept FROM capacity", con);

            OracleDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                depts.Add(rdr["dept"].ToString());   
            }
            rdr.Close();
            Context.Response.Write(js.Serialize(depts));
        }

        [WebMethod]
        public void getSecurityQuestions()
        {
            List<SQ> questions = new List<SQ>();
            cmd = new OracleCommand("SELECT * FROM security_ques", con);

            OracleDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                SQ sq = new SQ();
                sq.id = Convert.ToInt32(rdr["id"]);
                sq.question = rdr["question"].ToString();
                questions.Add(sq);
            }
            rdr.Close();
            Context.Response.Write(js.Serialize(questions));
        }

        [WebMethod]
        public void getProcessCntr(string dept)
        {
            List<int> process_cntrs = new List<int>();
            cmd = new OracleCommand("SELECT DISTINCT process_cntr FROM capacity WHERE dept = :dept ORDER BY process_cntr", con);
            cmd.Parameters.AddWithValue("dept", dept);

            OracleDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                process_cntrs.Add(Convert.ToInt32(rdr["process_cntr"]));
            }
            rdr.Close();
            Context.Response.Write(js.Serialize(process_cntrs));
        }


        [WebMethod]
        public void getTable(string dept, int process_cntr, int from, int to)
        {
            List<Order> orders = new List<Order>();
            string SQL = "SELECT * FROM capacity";
            cmd = new OracleCommand();

            if (from != -1 && to == -1)
            {
                SQL = SQL + " WHERE yr_wk >= :fromT";
                cmd.Parameters.AddWithValue("fromT", from);
            }

            else if (from == -1 && to != -1)
            {
                SQL = SQL + " WHERE yr_wk <= :toT";
                cmd.Parameters.AddWithValue("toT", to);
            }

            else if (from != -1 && to != -1)
            {
                SQL = SQL + " WHERE yr_wk >= :fromT AND yr_wk <= :toT";
                cmd.Parameters.AddWithValue("fromT", from);
                cmd.Parameters.AddWithValue("toT", to);
            }
            else
            {
                SQL = SQL + " WHERE dept != '-1'";
            }

            if (dept != "-1")
            {
                SQL = SQL + " AND dept = :dept";
                cmd.Parameters.AddWithValue("dept", dept);
            }

            if(process_cntr != -1)
            {
                SQL = SQL + " AND process_cntr = :process_cntr";
                cmd.Parameters.AddWithValue("process_cntr", process_cntr);
            }

            SQL = SQL + " ORDER BY yr_wk";

            cmd.CommandText = SQL;
            cmd.Connection = con;

            /*
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

            */


            OracleDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                Order order = new Order();

                order.dept = rdr["dept"].ToString();
                order.process = rdr["process"].ToString();
                order.avl_promise = Convert.ToInt32(rdr["avl_promise"]);
                order.total_avl_qnty = Convert.ToInt32(rdr["total_avl_qnty"]);
                order.order_qnty = Convert.ToInt32(rdr["order_qnty"]);
                order.process_cntr = Convert.ToInt32(rdr["process_cntr"]);
                order.yr_wk = Convert.ToInt32(rdr["yr_wk"]);

                orders.Add(order);
            }
            rdr.Close();
            Context.Response.Write(js.Serialize(orders));

        }

        [WebMethod(EnableSession = true)]
        private void authenticate()
        {
            Session["edit"] = "0";

            int userid = Convert.ToInt32(Session["eid"]);
            cmd = new OracleCommand();

            string sql = "SELECT isAdmin FROM cap_users WHERE eid = :eid";

            cmd.Connection = con;
            cmd.CommandText = sql;

            cmd.Parameters.AddWithValue("eid", userid);

            string admin = cmd.ExecuteScalar().ToString();

            if (admin == "1")
            {
                Session["edit"] = "1";
            }

        }

        [WebMethod(EnableSession = true)]
        public void updateOrder(string dept, string process, int process_cntr,int yr_wk, int new_total_qnty)
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
        public void deleteOrder(string dept, string process, int process_cntr, int yr_wk)
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

        private int alreadyPresent(string  dept, string process,int process_cntr, int yr_wk)
        {
            
            cmd = new OracleCommand();

            string sql = "SELECT COUNT(*) FROM capacity WHERE dept = :dept AND process = :process AND process_cntr = :process_cntr AND yr_wk = :yr_wk";

            cmd.Connection = con;
            cmd.CommandText = sql;

            cmd.Parameters.AddWithValue("dept", dept);
            cmd.Parameters.AddWithValue("process", process);
            cmd.Parameters.AddWithValue("process_cntr", process_cntr);
            cmd.Parameters.AddWithValue("yr_wk", yr_wk);

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

                    if (alreadyPresent(order.dept, order.process, order.process_cntr, order.yr_wk) != 0)
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
        public void copyOrder(string dept, int process_cntr, int copyFrom, int copyTo)
        {
            if (Session["edit"] == null)
            {
                authenticate();
            }

            if (Session["edit"] == "1")
            {
                cmd = new OracleCommand();

                cmd.CommandText = "copy_from";

                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("deptIN", dept);
                cmd.Parameters.AddWithValue("processCntrIN", process_cntr);
                cmd.Parameters.AddWithValue("copyFromIN", copyFrom);
                cmd.Parameters.AddWithValue("copyToIN", copyTo);

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


        private static string encrypt(string password)
        {
            string msg = "";
            byte[] encode = new byte[password.Length];
            encode = Encoding.UTF8.GetBytes(password);
            msg = Convert.ToBase64String(encode);
            return msg;
        }

        [WebMethod(EnableSession = true)]
        public void change_password(string current_password, string new_password){

            cmd = new OracleCommand();

            string encrypted_current_password = encrypt(current_password);
            string encrypted_new_password  = encrypt(new_password);

            int eid = Convert.ToInt32(Session["eid"]);
            string SQL = "SELECT password FROM cap_users WHERE eid = :eid";

            cmd.CommandText = SQL;
            cmd.Connection = con;
            cmd.Parameters.AddWithValue("eid", eid);

            string password = cmd.ExecuteScalar().ToString();

            if(password != encrypted_current_password)
            {
                Context.Response.Write(js.Serialize("Wrong Password"));
            }
            else
            {
                SQL = "UPDATE cap_users SET password = :password WHERE eid = :eid";
                cmd.CommandText = SQL;
                cmd.Parameters.AddWithValue("password", encrypted_new_password);

                int success =0;

                try
                {
                    success = cmd.ExecuteNonQuery();
                }
                catch(Exception ex)
                {
                    Context.Response.Write(js.Serialize("Could not Change"));
                }

                if(success != 0)
                {
                    Context.Response.Write(js.Serialize("true"));
                }
                else
                {
                    Context.Response.Write(js.Serialize("Could not Change"));
                }

            }

        }

        private class UQ {

            public string question { set; get; }
            public string username { set; get; }
        }

        [WebMethod]
        public void checkEID(int eid)
        {
            cmd = new OracleCommand();
            cmd.CommandText = "SELECT username, sq_id FROM cap_users WHERE eid = :eid";
            cmd.Connection = con;
            cmd.Parameters.AddWithValue("eid", eid);

            try
            {

                OracleDataReader rdr = cmd.ExecuteReader();

                rdr.Read();

                UQ uq = new UQ();

                uq.username = rdr["username"].ToString();
                int ques_id = Convert.ToInt32(rdr["sq_id"]);

                rdr.Close();
                cmd = new OracleCommand();
                cmd.CommandText = "SELECT question FROM security_ques WHERE id = :ques_id";
                cmd.Connection = con;
                cmd.Parameters.AddWithValue("ques_id", ques_id);

                string question = cmd.ExecuteScalar().ToString();
                uq.question = question;

                Context.Response.Write(js.Serialize(uq));
            }
            catch(Exception ex)
            {
                Context.Response.Write(js.Serialize("false"));
            }

        }

        [WebMethod(EnableSession = true)]
        public void checkSecurityAnswer(int eid, string answer)
        {
            cmd = new OracleCommand();
            cmd.CommandText = "SELECT sq_ans FROM cap_users WHERE eid = :eid";
            cmd.Connection = con;

            try
            {
                cmd.Parameters.AddWithValue("eid", eid);

                string result = cmd.ExecuteScalar().ToString();

                if (result == answer)
                {
                    Session["eid"] = eid;
                    Context.Response.Write(js.Serialize("true"));
                }
                else
                {
                    Context.Response.Write(js.Serialize("false"));
                }
            }
            catch (Exception ex)
            {
                Context.Response.Write(js.Serialize("false"));
            }
            
        }

        [WebMethod(EnableSession = true)]
        public void resetPassword(string password)
        {
            string encrpted_password = encrypt(password);
            int eid = Convert.ToInt32(Session["eid"]);
            cmd = new OracleCommand();
            cmd.CommandText = "UPDATE cap_users SET password = :en_pass WHERE eid = :eid";
            cmd.Connection = con;

            cmd.Parameters.AddWithValue("en_pass", encrpted_password);
            cmd.Parameters.AddWithValue("eid", eid);

            int success =0;

            try
            {
                success = cmd.ExecuteNonQuery();

                if(success != 0)
                {
                    Context.Response.Write(js.Serialize("true"));
                }
                else
                {
                    Context.Response.Write(js.Serialize("false"));
                }
            }
            catch
            {
                Context.Response.Write(js.Serialize("false"));
            }
        }

    }
}
