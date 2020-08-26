
<%@page import="gk.myname.vn.entity.ListMail"%>
<%@page import="gk.myname.vn.utils.SendMail"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.Email_tmp_config"%>
<%@page import="gk.myname.vn.entity.EmailConfigManager"%>
<%@page import="gk.myname.vn.entity.Subsidiary"%>
<%@page import="gk.myname.vn.utils.DateProc"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="gk.myname.vn.entity.Contract"%><%@page import="gk.myname.vn.entity.PartnerManager"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%><%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <%@include file="/admin/includes/header.jsp" %>
        <script>
        </script>
    </head>
    <body>
        <%  if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền thêm module này!");
                response.sendRedirect(request.getContextPath() + "/admin/send_mail/");
                return;
            }

            String sendMail= "";
            EmailConfigManager email_send = new EmailConfigManager();
            EmailConfigManager emailconfig = null;
            boolean success = false;

            if (request.getParameter("submit") != null) {
                int subid = RequestTool.getInt(request, "subID");
                
                int listMail = RequestTool.getInt(request, "listMail");
                int listUser = RequestTool.getInt(request, "listUser");
                int writeMail = RequestTool.getInt(request, "writeMail");
                
                String ds = "";
                
                if (listMail == 1) {
                    int listEmail = RequestTool.getInt(request, "listEmail");
                    ListMail lm = ListMail.findById(listEmail);
                    if (lm != null) {
                        ds += lm.getDes();
                    }
                }
                
                if (writeMail == 1) {                    
                    String ccc = RequestTool.getString(request, "toMail");
                    if (!ccc.endsWith(",")) {
                        ccc += ",";
                    }
                    ds += ccc;
                }
                
                if (listUser == 1) {
                    String b[] = request.getParameterValues("partnerID");
                    for (String s : b) {
                        ds += s + ",";
                    }
                }
                
                String subject = request.getParameter("title_mail");
                
                String content = request.getParameter("content");
                
                int listTemp = RequestTool.getInt(request, "listTemp");
                
                int tempId = RequestTool.getInt(request, "title_mail_temp");
                Email_tmp_config tempMail = new Email_tmp_config();
                Email_tmp_config mail = tempMail.getbyid(tempId);
                if (!ds.equals("") && !ds.equals("")) {
                    emailconfig = email_send.getConfigById(subid);
                    
                        if (listTemp == 0) {
                            success = SendMail.sendMailOneToOne(emailconfig.getFromname(), emailconfig.getEmail(), emailconfig.getPassmail(), emailconfig.getHostemail(), emailconfig.getPortmail(), subject, content, ds);
                        } else {
                            success = SendMail.sendMailOneToOne(emailconfig.getFromname(), emailconfig.getEmail(), emailconfig.getPassmail(), emailconfig.getHostemail(), emailconfig.getPortmail(), mail.getName(), mail.getContent(), ds);
                        }

                        if (success == true) {
                            sendMail += "<br/> Send mail success !";
                        } else {
                            sendMail += "<br/> Send mail lỗi !";
                        }
                    session.setAttribute("mess", sendMail);
                }
            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <div align="center" style="height: auto;margin-bottom: 2px; color: red;font-weight: bold">
                            <%
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <br/>
                        <form action="" method="post">
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th align="center" style="font-weight: bold" scope="col" class="rounded">
                                            Send Email</th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Người Gửi: </td>
                                        <td>
                                            <%
                                                EmailConfigManager sub = new EmailConfigManager();
                                                ArrayList<EmailConfigManager> arr = sub.listID();
                                                if (arr != null && !arr.isEmpty()) {
                                            %>
                                            <select style="width: 400px" id="subID" name="subID">
                                                <option value="">Chọn</option>
                                                <%
                                                    for (EmailConfigManager oneAcc : arr) {
                                                %>
                                                <option value="<%=oneAcc.getId()%>"><%=oneAcc.getEmail()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <%
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Chọn kiểu gửi tới: </td>
                                        <td>
                                            <input onclick="showMail('333',this.value,this.id)" type="checkbox" id="listMail" name="listMail" value="0">
                                            <label for="listMail">List Mail</label>
                                            <input onclick="showMail('111',this.value,this.id)" type="checkbox" id="listUser" name="listUser" value="0">
                                            <label for="listUser">List User</label>
                                            <input onclick="showMail('222',this.value,this.id)" checked type="checkbox" id="writeMail" name="writeMail" value="1">
                                            <label for="writeMail">Write Mail</label>
                                        </td>
                                        <script>
                                            function showMail(a,b,c) {
                                                if (b === '0') {
                                                    document.getElementById(c).value = '1';
                                                    document.getElementById('show'+a).style.display = '';
                                                } else {
                                                    document.getElementById(c).value = '0';
                                                    document.getElementById('show'+a).style.display = 'none';
                                                }
                                            }
                                        </script>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Gửi Tới: </td>
                                        <td>
                                            
                                            <div id="show333" style="display: none">     
                                                <%
                                                    ArrayList<ListMail> listMail = ListMail.getAll();
                                                    if (listMail != null && !listMail.isEmpty()) {
                                                %>
                                                <select style="width: 400px" class="select3" name="listEmail">
                                                    <option value="">Chọn</option>
                                                    <%
                                                        for (ListMail l : listMail) {
                                                    %>
                                                    <option value="<%=l.getId()%>"><%= l.getName()%></option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
                                                <br/>
                                                <%
                                                    }
                                                %>
                                            </div>
                                            
                                            <div id="show111" style="display: none">
                                                <%
                                                    Account partner = new Account();
                                                    ArrayList<Account> dts = partner.getKHAccount();
                                                    if (dts != null && !dts.isEmpty()) {
                                                %>
                                                <select style="width: 400px" class="select3" name="partnerID" multiple>
                                                    <%
                                                        for (Account b : dts) {
                                                    %>
                                                    <option value="<%= b.getEmail()%>"><%= b.getFullName()+" -- "+b.getEmail()%></option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
                                                <br/>
                                                <%
                                                    }
                                                %>
                                            </div>
                                            
                                            <div id="show222">                                                
                                                <input style="width: 392px" type="text" name="toMail"/>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Chọn loại gửi đi: </td>
                                        <td>
                                            <input onclick="showTin('template',this.value,this.id)" checked type="checkbox" id="listTemp" name="listTemp" value="1">
                                            <label for="listTemp">List Template</label>
                                            <input onclick="showTin('new',this.value,this.id)" type="checkbox" id="writeTin" name="writeTin" value="0">
                                            <label for="writeTin">Write New</label>
                                        </td>
                                        <script>
                                            function showTin(a,b,c) {
                                                if (b === '0') {
                                                    if (a === 'new') {
                                                        document.getElementById('listTemp').value = '0';
                                                        document.getElementById('listTemp').checked = false;
                                                        for (let el of document.querySelectorAll('.templateMail')) el.style.display = 'none';
                                                    } else {
                                                        document.getElementById('writeTin').value = '0';
                                                        document.getElementById('writeTin').checked = false;
                                                        for (let el of document.querySelectorAll('.newMail')) el.style.display = 'none';
                                                    }
                                                    document.getElementById(c).value = '1';
                                                    for (let el of document.querySelectorAll('.'+a+'Mail')) el.style.display = '';
                                                } else {
                                                    if (a === 'new') {
                                                        document.getElementById('listTemp').value = '1';
                                                        document.getElementById('listTemp').checked = true;
                                                        for (let el of document.querySelectorAll('.templateMail')) el.style.display = '';
                                                    } else {
                                                        document.getElementById('writeTin').value = '1';
                                                        document.getElementById('writeTin').checked = true;
                                                        for (let el of document.querySelectorAll('.newMail')) el.style.display = '';
                                                    }
                                                    document.getElementById(c).value = '0';
                                                    for (let el of document.querySelectorAll('.'+a+'Mail')) el.style.display = 'none';
                                                }
                                            }
                                        </script>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tiêu Đề Tin Nhắn: </td>
                                        <td class="newMail" style="display: none;">
                                            <input style="width: 392px" type="text" id="title_mail" name="title_mail"/>
                                        </td>
                                        <td class="templateMail">
                                            
                                            <%
                                                Email_tmp_config email = new Email_tmp_config();
                                                ArrayList<Email_tmp_config> etc = email.view();

                                                if (etc != null && !etc.isEmpty()) {
                                            %>
                                            <select style="width: 400px" name="title_mail_temp">
                                                <option value="">Chọn</option>
                                                <%
                                                    for (Email_tmp_config c : etc) {
                                                %>
                                                <option value="<%= c.getId()%>"><%= c.getName()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <%
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <tr class="newMail" style="display: none;">
                                        <td></td>
                                        <td align="left" >Nội Dung: </td>
                                        <td><textarea style="width: 394px" rows="5" type="text" id="content" name="content"></textarea></td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" align="center">
                                            <input class="button" type="submit" name="submit" value="Gửi Tin Nhắn"/>
                                            <input class="button" onclick="window.location.href = '<%= request.getContextPath() + "/admin/contract/"%>'" type="reset" name="reset" value="Hủy"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div><!-- end of right content-->
                </div>   <!--end of center content -->
                <div class="clear"></div>
            </div> <!--end of main content-->
            <%@include file="/admin/includes/footer.jsp" %>
        </div>
    </body>
</html>