using EconomikBusiness;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace Common
{
    /// <summary>
    /// Receive the uploads of MenuToolsUploadModal.aspx : text or excel files sent by the clients
    /// The files are put into a timestamped directory inside a directory {IdUser}
    /// \uploads\PJMails\{IdUser}\{timestamp}\files with original names
    /// </summary>
    public class MenuToolsUploader : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            Uri requestUri = context.Request.Url;
            bool sendMail = false;
            string mailSubject = "";
            string mailBody = "";
            string IdUser = context.Request.Params["idUser"];
            string attachementsBaseUrl = requestUri.Scheme + @"://" + requestUri.Authority + "/";
            HttpFileCollection Files;
            Files = context.Request.Files;
            bool isError = false;
            List<string> filenames = new List<string>();
            context.Response.ContentType = "application/json";
            string translation = App_GlobalResources.Resources.Aucun_fichier_recu;
            string result = "{\"error\":true,\"message\":\""+ translation + "\"}";
            try
            {
                if (Files.Count > 0)
                {
                    int maxSize = 2 * 1024 * 1024;
                    DateTime today = DateTime.Now;
                    string timeStamp = today.ToString("yyyyMMddTHHmmss000Z");
                    string common = context.Server.MapPath("~");
                    string parent = Path.GetDirectoryName(common);
                    string webServerRoot = Path.GetDirectoryName(parent);
                    attachementsBaseUrl += string.Format(@"uploads/PJMails/{0}/{1}/", IdUser, timeStamp);
                    string directoryPath = webServerRoot + string.Format(@"\uploads\PJMails\{0}\{1}\", IdUser, timeStamp);
                    System.IO.Directory.CreateDirectory(directoryPath);

                    foreach (string filename in Files)
                    {
                        HttpPostedFile file = Files[filename];
                        if (file.ContentLength <= maxSize)
                        {
                            if (!string.IsNullOrEmpty(file.FileName))
                            {
                                string fileToSave = directoryPath + file.FileName;
                                file.SaveAs(fileToSave);
                                filenames.Add(file.FileName);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                isError = true;
                result = "{\"error\":true,\"message\":\"" + ex.Message + "\" }";
            }

            if (!isError && filenames.Any())
            {
                // Built the resulting json : an array of filenames
                result = "{\"error\":false,\"filenames\":[";
                string sep = "";
                foreach(string filename in filenames)
                {
                    result += sep + "\""+ filename + "\"";
                    sep = ",";

                }
                result += "]}";
            }

            context.Response.Write(result);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}