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
    public partial class Site1 : System.Web.UI.MasterPage
    {
        public String conString = ConfigurationManager.ConnectionStrings["orcldb"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}