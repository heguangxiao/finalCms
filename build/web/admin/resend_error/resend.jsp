<%@page import="gk.myname.vn.multipart.request.HttpServletMultipartRequest"%>
<%@page import="java.io.Reader"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.HttpURLConnection"%><%@page import="java.net.URL"%><%@page import="java.io.IOException"%><%@page import="java.net.URLEncoder"%><%@page import="java.util.LinkedHashMap"%><%@page import="java.util.Map"%><%@page import="gk.myname.vn.utils.SMSUtils"%><%@page import="gk.myname.vn.utils.DateProc"%><%@page import="java.util.Collection"%><%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="gk.myname.vn.config.MyContext"%><%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.entity.BrandLabel"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "Gửi lại tin bị lỗi"); %>
        <%@include file="/admin/includes/header.jsp" %>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/admin/resource/select2/select2.css" />
        <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2_locale_vi.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/js/jquery.blockUI.js"></script>        
        <script type="text/javascript" language="javascript">
            function HandleBrowseClick() {
                var fileinput = document.getElementById("fileUpload");
                fileinput.click();
            }
            $(document).ready(function () {
                $('#fileUpload').change(function (event) {
                    var textinput = document.getElementById("file_full_path");
                    textinput.value = $("#fileUpload").val();
                });
            });
            // unblock when ajax activity stops 
            $(document).ajaxStop($.unblockUI);
            function doWork() {
                var data = new FormData($("form#uploadForm")[0]);
                jQuery.each(jQuery('#fileUpload')[0].files, function (i, file) {
                    data.append('file-' + i, file);
                });
                jQuery.ajax({
                    url: '<%=request.getContextPath()%>/admin/resend_error/processSubmit.jsp',
                    data: data,
                    cache: false,
                    contentType: false,
                    processData: false,
                    type: 'POST',
                    timeout: 10 * 60 * 1000,
                    success: function (data) {
                        $("#infoProcess").html(data);
                    }
                });
            }
            $(document).ready(function () {
                $('#uploadata').click(function () {
                    $.blockUI({message: '<h1><img src="<%=request.getContextPath()%>/admin/resource/images/busy.gif" /> We are processing your request.  Please be patient....</h1>'});
                    doWork();
                });
            });

            $(document).ready(function () {
                $("#_agentcy").select2({
                    formatResult: function (item) {
                        var valOpt = $(item.element).attr('img-data');
                        if (!valOpt) {
                            return ('<div><b>' + item.text + '</b></div>');
                        } else {
                            return ('<div><span><b style="color: red">' + item.text + '<b> <img src="' + valOpt + '" class="img-flag" /></span></div>');
                        }
                    },
                    formatSelection: function (item) {
                        //  load page or selected
                        var opt = $("#_agentcy option:selected");
                        var valOpt = opt.attr("img-data");
                        if (!valOpt) {
                            return ('<b>' + item.text + '</b>');
                        } else {
                            return ('<div><span><b style="color: red">' + item.text + '</b> <img src="' + valOpt + '" class="img-flag" /></span></div>');
                        }
                    },
                    dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
                    escapeMarkup: function (m) {
                        return m;
                    }
                });
            });
        </script>
    </head>
    <body>
        <%
            if (!userlogin.checkView(request)) {
                session.setAttribute("mess", "Bạn không có quyền truy cập module này!");
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <!-- Tìm kiếm-->
                        <div id="infoProcess" align="center" style="height: 20px;margin-bottom: 2px; color: red;font-weight: bold;padding-top: 20px">
                            <%                                
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <form id="uploadForm" name="frmSend" enctype="multipart/form-data" action="<%=request.getContextPath()%>/admin/resend_error/processSubmit.jsp" method="post">
                            <table id="rounded-corner" align="center" >
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded"></th>
                                        <th style="color: white;font-weight: bold;text-transform: uppercase" colspan="2" scope="col" class="rounded-q4">
                                            Gửi LẠI TIN BỊ LỖI
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Khách hàng</td>                            
                                        <td>
                                            <select style="width: 380px" name="userSender" id="_agentcy">
                                                <option value="0">Chọn một KH Gửi lại</option>
                                                <%
                                                    ArrayList<Account> allCp = Account.getCPAgentcy();
                                                    for (Account one : allCp) {
                                                        if (one.getUserType() != Account.TYPE.AGENCY.val) {
                                                            continue;
                                                        }
                                                %>
                                                <option
                                                    value="<%=one.getUserName()%>"
                                                    img-data="<%=(one.getStatus() == 1 ? "" : request.getContextPath()+"/admin/resource/images/lock1.png")%>" >[<%=one.getUserName()%>] <%=one.getFullName()%></option>
                                                <%
                                                       // out.print("<option " + " value='" + one.getUserName() + "'>" + "[" + one.getUserName() + "] &nbsp;&nbsp;" + one.getFullName() + "</option>");
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>File Mẫu</td>                            
                                        <td><a href="<%=request.getContextPath() +"/admin/resend_error/FILE_MAU.xlsx"%>">FILE_MAU.xlsx</a></td>
                                    </tr>
                                    <tr>
                                        <td>File dữ liệu lỗi</td>                            
                                        <td>
                                            <input type="file" id="fileUpload" name="fileUpload" style="display: none" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel"/>
                                            <input size="50" type="text" id="file_full_path" readonly="true"/>
                                            <input type="button" value="Chọn file tải lên" id="fakeBrowse" onclick="HandleBrowseClick();"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <input id="uploadata" class="button" type="button" name="submit" value="Gửi thử"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                        <!--End tim kiếm-->
                    </div><!-- end of right content-->
                </div>   <!--end of center content -->
                <div class="clear"></div>
            </div> <!--end of main content-->
            <%@include file="/admin/includes/footer.jsp" %>
        </div>
    </body>
</html>