using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication1
{
    public class Order
    {
        public int dept { set; get; }
        public int process { set; get; }
        public int process_cntr { set; get; }
        public int total_avl_qnty { set; get; }
        public int order_qnty { set; get; }
        public int avl_promise { set; get; }
        public int yr_wk { set; get; }
    }
}