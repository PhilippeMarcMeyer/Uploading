using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Common
{
    public partial class MenuToolsFileSender : BasePageWithSession
    {
        public string id_user = "";
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!string.IsNullOrEmpty(Request.QueryString["id_user"]))
            {
                id_user = Request.QueryString["id_user"];
            }

        }
    }
}