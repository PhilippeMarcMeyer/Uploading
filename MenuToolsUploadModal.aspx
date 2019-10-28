<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MenuToolsUploadModal.aspx.cs" Inherits="Common.MenuToolsFileSender" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Files</title>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="../../css/bootstrap.min.css" rel="stylesheet">
    <link href="../../css/style-mapping.css" rel="stylesheet">
    <link href="../../js/plugins/sweetAlert/sweetalert.css" rel="stylesheet">
    <style>
        body {
            background-color: #fff;
            overflow-x: hidden; 
            overflow-y: hidden;
        }
        #fileSender-modal {
            margin: 4px 10px 10px 20px;
            width: 96%;
        }
        .date {
            width: 100px;
            min-width: 100px;
        }
        .filename {
            width: 500px;
            min-width: 500px;
        }
        .size {
            width: 140px;
            min-width: 140px;
        }
        .title {
            font-size: 16px;
            color: rgba(66, 139, 202, 1);
        }
        .token{
            border:1px solid rgba(92,184,92,1);
            border-radius:4px;
            padding:4px 2px;
            color:rgba(92,184,92,1);
            float:right;
            margin-right:5px;
        }
        tbody::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
            border-radius: 10px;
            background-color: #F5F5F5;
        }
        tbody::-webkit-scrollbar {
            width: 12px;
            background-color: #F5F5F5;
        }
        tbody::-webkit-scrollbar-thumb {
            border-radius: 10px;
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
            background-color: #66adea;
        }
            tbody::-webkit-scrollbar-thumb:hover {
                background: #337ab7;
            }
        .label-file {
            margin-top:25px;
            cursor: pointer;
            border: 1px solid rgba(92,184,92,0.5);
            border-radius: 8px;
            padding: 2px 4px;
            color: #5cb85c;
            font-weight: bold;
            font-size: 20px;
        }
            .label-file:hover {
                color: #0c6e0c;
                border: 1px solid #0c6e0c;
            }
        .input-file {
            display: none !important;
        }
        .progress-bar-complete {
            background-color: #5cb85c;
        }
        #drop-area {
            display:inline-block;
            background-color: #fefefe;
            border: 1px dashed rgba(92,184,92,0.5);
            border-radius:10px;
            padding-top:10px;
            float: right;
            font-size: 36px;
            text-align: center;
            width: 540px;
            margin-right:20px;
            height:80px;
            color:#5cb85c;
        }
        #drop-area:hover{
            border: 1px solid #0c6e0c;
            color:#0c6e0c;
        }
        #drop-area.hover{
            border: 1px solid #0c6e0c;
            color:#0c6e0c;
        }
        #fileFormats{
            position:absolute;
            margin-left:34px;
            margin-top:3px;
             user-select: none;
             font-size:11px;
        }    

    </style>
</head>
<body style="overflow-x: hidden; overflow-y: hidden;">
    <div id="fileSender-modal">
        <label for="file-importer" class="label-file">Choisir des fichiers</label>
        <input type="file" class="input-file" accept=".txt,.csv,.xls,.xlsx" name="file" multiple="multiple" id="file-importer">
        <span id="fileFormats"></span>
        <div id="drop-area"><i class="fa fa-upload"></i></div>    
        <br />
        <div id="fileSender-modal-import-view-zone" style=" width: 96%;">
            <br />
            <label class="title"><%=Common.App_GlobalResources.Resources.Listea%></label><br />
            <table id="fileSender-modal-import-table" class="table table-striped table-bordered table-responsive-md">
                <thead style="display: block; overflow-y: hidden; height: 40px; max-height: 40px;">
                    <tr>
                        <th scope="col" class="date"><%=Common.App_GlobalResources.Resources.Date%></th>
                        <th scope="col" class="filename"><%=Common.App_GlobalResources.Resources.Nom_du_fichier%></th>
                        <th scope="col" class="size"><%=Common.App_GlobalResources.Resources.Taillea%></th>
                    </tr>
                </thead>
                <tbody style="display: block; overflow-y: scroll; height: 380px; max-height: 380px;">
                </tbody>
            </table>
            <button type="button" style="margin-top:-6px;" class="btn btn-primary pull-right" id="btn-upload-files"><i class="fa fa-upload"></i>&nbsp;&nbsp;<%=Common.App_GlobalResources.Resources.Envoyerz%></button>
            <div class="progress" style="width:80%;display:none;">
                <div class="progress-bar progress-bar-success" id="progressBar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="min-width: 2em;">
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../../js/jquery-1.12.0.min.js"></script>
<%--    <script type="text/javascript" src="../../js/bootstrap.min.js"></script>--%>
    <script type="text/javascript" src="../../js/plugins/sweetalert/sweetalert.min.js"></script>
    <script>
        let fileImporter = null;
       
        let idUser = "<%=id_user%>";
        (function () {
            'use strict'
            fileImporter = new fileImporterFactory();
            fileImporter.setListeners();
        })();
        function fileImporterFactory() {
            'use strict'
            let factory = this;
            this.allowedFiles = ["txt", "csv", "xls", "xlsx","ods"];
            this.dropArea = document.getElementById("drop-area");
            this.files = [];
            this.maxSize = 2 * 1024 * 1024;
            this.words = {
                "tooBig": "<%=Common.App_GlobalResources.Resources.Fichier_grand%>",
                "sent": "<%=Common.App_GlobalResources.Resources.envoye%>",
                "fileFormats":"<%=Common.App_GlobalResources.Resources.FormatsAcceptes%>"
            }

            $("#fileFormats").text(factory.words.fileFormats + " : " +factory.allowedFiles.join(", "));

            this.setListeners = function () {
                $("#file-importer").on("change", function (event) {
                    $(".progress")
                        .css({ "display": "none" });
                    factory.importFiles(event);
                });
                $("#btn-upload-files").on("click", function () {
                    factory.sendFiles();
                });
                factory.dropArea.addEventListener("click", function () { $("#file-importer").trigger("click")}, false);
                factory.dropArea.addEventListener("drop", factory.handleDrop, false);
                factory.dropArea.addEventListener("dragover", factory.handleDragOver, false);
                factory.dropArea.addEventListener("dragleave", factory.handleDragOut, false);
            }
            
            this.handleDragOver = function(event) {
                event.stopPropagation();
                event.preventDefault();

                factory.dropArea.className = "hover";
            }
            this.handleDragOut = function (event) {
                event.stopPropagation();
                event.preventDefault();

                factory.dropArea.className = "";
            }

            this.handleDrop=function(event) {
                event.stopPropagation();
                event.preventDefault();
                factory.dropArea.className = "";
                factory.importFiles(event); //event.dataTransfer.files
            }
            this.processFiles = function (filelist) {
                if (!filelist || !filelist.length || list.length) return;
                for (var i = 0; i < filelist.length && i < 5; i++) {
                    list.push(filelist[i]);
                    totalSize += filelist[i].size;
                }
            }
            this.importFiles = function (e) {
                let files;
                if(e.dataTransfer){
                    files = e.dataTransfer.files;
                }else{
                    files = event.target.files;
                }
                if (files.length > 0) {
                    let nrFilesReady = 0;
                    factory.manageProgress("onHide", 0);
                    Array.prototype.slice.call(files).forEach(function (x, i) {
                        let file = x;
                        let filename = x.name;
                        let type = x.type;
                        let extension = getFileExtension(filename);
                        if (factory.allowedFiles.indexOf(extension) != -1) {
                            factory.files.push({ "file": file, "filename": filename, "sent": false });
                        } 
                    });
                    factory.drawTable();
                }
            }
            this.manageProgress = function (action, percentage) {
                if (action == "onHide") {
                    $(".progress")
                        .css({ "display": "none" });

                } else if (action == "onStart") {
                    $(".progress")
                        .css({ "display": "inline-block" });

                    $("#progressBar")
                     .css({"width": "0%" })
                     .attr("class", "progress-bar progress-bar-warning")
                     .attr("aria-valuenow", 0)
                     .text("0%");

                } else if (action == "onProgress") {
                    if (percentage >= 100) percentage = 99;
                    $("#progressBar")
                        .css({ "width": percentage + "%" })
                        .attr("class", "progress-bar progress-bar-warning")
                        .attr("aria-valuenow", percentage)
                        .text(percentage + "%");

                } else if (action == "onComplete") {
                    $("#progressBar")
                        .css({ "width": "100%" })
                        .attr("class", "progress-bar progress-bar-complete")
                        .attr("aria-valuenow", 100)
                        .text("100%");

                } else if (action == "onError") {
                    $("#progressBar")
                        .css({ "width": percentage + "%" })
                        .attr("class", "progress-bar progress-bar-danger")
                        .attr("aria-valuenow", percentage)
                        .text(percentage + "%");
                }

            }

            this.drawTable = function () {
                let $zone = $("#fileSender-modal-import-table tbody");
                $zone.empty();
                let html = "";
                console.log(factory.files);
                factory.files.forEach(function (x) {
                    let status = x.sent ? " <span class='token'>" + factory.words.sent + "</span>" : "";
                    let size = x.file.size;
                    let className = size > factory.maxSize ? "danger" : "";
                    let sizeTranslated = size > factory.maxSize ? factory.words.tooBig : sizeToString(size);
                    html += "<tr class='" + className + "'>";
                    html += "<td class='date'>" + dateToString(x.file.lastModifiedDate) + "</td>";
                    html += "<td class='filename'>" + x.filename + status + "</td>";
                    html += "<td class='size'>" + sizeTranslated + "</td>";
                    html += "</tr>";
                });
                $zone.html(html);
                $("#fileSender-modal-import-view-zone").css("display", "block");
            }
            this.sendFiles = function () {
                let nrFiles = 0;
                let totalSize = 0;
                let progress = 0;
                let percentage = 0;
                let fd = new FormData();
                factory.files.forEach(function (x, i) {
                    if (!x.sent && x.file.size <= factory.maxSize) {
                        fd.append("file" + (i + 1), x.file);
                        nrFiles++;
                        totalSize += x.file.size;
                    }
                });
                if (nrFiles > 0) {
                    let xhr = new XMLHttpRequest();
                    xhr.open('POST', "../Common/MenuToolsUploader.ashx?idUser=" + idUser);
                    xhr.onload = function () {
                        let answer = JSON.parse(this.responseText);
                        setTimeout(function () {
                            factory.manageProgress("onComplete", 100);
                        }, 1000);

                        if (answer.error) {
                            parent.swal("", answer.message, "warning");
                        } else {
                            factory.files.forEach(function (x) {
                                if (answer.filenames.indexOf(x.file.name) != -1) {
                                    x.sent = true;
                                }
                            });
                            factory.drawTable();
                        }
                    };
                    xhr.onerror = function () {
                        result.textContent = this.responseText;
                        percentage = 0;
                        factory.manageProgress("onError", percentage);
                    };
                    xhr.upload.onprogress = function (event) {
                        progress = progress + event.loaded;
                        percentage = Math.floor((progress / totalSize * 100) + 0.5);
                        factory.manageProgress("onProgress", percentage);
                    }
                    xhr.upload.onloadstart = function (event) {
                        
                        factory.manageProgress("onStart", 0);
                    }

                    xhr.send(fd);
                } else {
                    parent.swal("", "<%=Common.App_GlobalResources.Resources.RienAEnregistrer%>", "warning");
                }
            }
        }
        function dateToString(d) {
            let options = {
                year: "numeric",
                month: "2-digit",
                day: "2-digit"
            };
            let result = "";
            if (d != null) {
                result = d.toLocaleDateString('fr-FR', options)
            }
            return result;
        }
        function getFileExtension(f) {
            
            let result = "";
            let arr = f.split(".");
            if (arr.length > 1) {
                result = arr[arr.length - 1];
            }
            return result;
        }
        function sizeToString(sizeInBytes) {
            let result = "";
            let translator = [
                { "value": 1024 * 1024 * 1024, "unit": "GB" },
                { "value": 1024 * 1024, "unit": "MB" },
                { "value": 1024, "unit": "KB" },
                { "value": 1, "unit": "B" },
            ]
            translator.forEach(function (x) {
                if (sizeInBytes >= x.value) {
                    result += parseInt(sizeInBytes / x.value) + " " + x.unit + " ";
                    sizeInBytes = sizeInBytes % x.value;
                }
            });
            return result;
        }
    </script>
</body>
</html>
