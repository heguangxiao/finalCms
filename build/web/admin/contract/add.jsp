<%@page import="gk.myname.vn.entity.EmailConfigManager"%>
<%@page import="gk.myname.vn.entity.Subsidiary"%>
<%@page import="gk.myname.vn.utils.DateProc"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="gk.myname.vn.entity.Contract"%>
<%@page import="gk.myname.vn.entity.PartnerManager"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <%@include file="/admin/includes/header.jsp" %>
        <script>
            $(document).ready(function () {
                $('.dateproc').datetimepicker({
                    lang: 'vi',
                    format: 'd/m/Y',
                    formatDate: 'Y/m/d'
                });
               $('.select2').select2();
            });
            
        </script>
    </head>
    <body>
        <%    
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền thêm module này!");
                response.sendRedirect(request.getContextPath() + "/admin/contract/");
                return;
            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <div align="center" style="height: 20px;margin-bottom: 2px; color: red;font-weight: bold">
                            <%
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <form action="<%=request.getContextPath()%>/UploadServlet" method="post" enctype="multipart/form-data">
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th align="center" style="font-weight: bold" scope="col" class="rounded redBoldUp">
                                            Thêm mới hợp đồng </th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tên công ty: </td>
                                        <td>
                                            <%
                                                Subsidiary sub = new Subsidiary();
                                                ArrayList<Subsidiary> arr = sub.listID();
                                                if (arr != null && !arr.isEmpty()) {
                                            %>
                                            <select style="width: 400px" class="select2"  id="subID" name="subID">
                                                <option value="">--- Tất cả ---</option>
                                                <%
                                                    for (Subsidiary oneAcc : arr) {
                                                %>
                                                <option value="<%=oneAcc.getId()%>"><%=oneAcc.getName()%></option>
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
                                        <td align="left">Tên đối tác: </td>
                                        <td>
                                            <%
                                                PartnerManager dao = new PartnerManager();
                                                    ArrayList<PartnerManager> dts = dao.getAll();

                                                if (dts != null && !dts.isEmpty()) {
                                            %>
                                            <select style="width: 400px" class="select2"  id="partnerID" name="partnerID">
                                                <option value="">--- Tất cả ---</option>
                                                <%
                                                    for (PartnerManager b : dts) {
                                                %>
                                                <option value="<%= b.getId()%>"><%= b.getName()%></option>
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
                                        <td align="left">Số Hợp Đồng: </td>
                                        <td><input autocomplete="off" size="50" type="text" name="contract_no"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left" >Bắt Đầu: </td>
                                        <td><input class="dateproc" size="8" type="text" name="start_time"/><span style="margin-left: 10px">Kết Thúc:</span><input style="margin-left: 5px" class="dateproc" size="8" type="text" name="expire_time"/>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tự Động Gia Hạn: </td>
                                        <td><input type="checkbox" name="auto_renew" value="1" /></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Thông Tin: </td>
                                        <td><textarea autocomplete="off" cols="40" rows="5" type="text" name="option_info"/></textarea></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">File Hợp Đồng:</td>
                                        <td><input autocomplete="off" size="50" type="file" id="file" name="file_path" multiple/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td style="color: red">
                                            Chỉ cho file có đuôi .PDF .JPEG .JPG .ZIP .RAR
                                            <br/>
                                            <br/>
                                            Tên file không được có dấu. Thanks
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Dịch Vụ Ký Hợp Đồng: </td>
                                        <td>
                                            <input type="checkbox" name="brandname" value="1" />Brand Name
                                            <input type="checkbox" name="longcode" value="1" />Long Code
                                            <input type="checkbox" name="dausocodinh" value="1" />Đầu số cố định
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" align="center">
                                            <input class="button" type="submit" name="submit" value="Thêm mới"/>
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