<%@page import="gk.myname.vn.entity.ListMail"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page contentType="text/html; charset=utf-8" %>
<html>
    <head><%@include file="/admin/includes/header.jsp" %></head>
    <body>
        <%      
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            
            int id = RequestTool.getInt(request, "id");
            
            ListMail listMail = ListMail.findById(id);
            
            if (listMail == null) {
                session.setAttribute("mess", "Nội dung bạn tìm kiếm không tồn tại ! ");
                response.sendRedirect(request.getContextPath() + "/admin/listEmail/");
                return;
            }
            
            if (request.getParameter("submit") != null) {
                
                String message = "";
                String name = RequestTool.getString(request, "name");
                
                if (Tool.checkNull(name)) {
                    session.setAttribute("mess", "Tên nhóm không được để trống");
                    response.sendRedirect(request.getContextPath() + "/admin/listEmail/index.jsp");
                    return;
                }
                if (!name.equals(listMail.getName())) {
                    if (ListMail.existsByName(name)) {
                        session.setAttribute("mess", "Tên nhóm đã tồn tại");
                        response.sendRedirect(request.getContextPath() + "/admin/listEmail/index.jsp");
                        return;
                    }
                }
                
                String des = RequestTool.getString(request, "des");
                
                String a[] = request.getParameterValues("partnerID");
                
                if (!des.endsWith(",") && !des.equals("")) {
                    des += ",";
                }
                
                for (String elem : a) {
                    if (!listMail.getDes().contains(elem+",") && !des.contains(elem+",")) {
                        des += elem + ",";
                    }
                }
                
                listMail.setName(name);
                listMail.setDes(listMail.getDes() + des);
                listMail.setUpdatedBy(userlogin.getUserName());
                
                if (ListMail.update(listMail)) {                    
                    message += "Sửa nhóm thành công <br/>";                    
                } else {
                    message += "Sửa nhóm không thành công <br/>";
                }
                
                session.setAttribute("mess", message);
                response.sendRedirect(request.getContextPath() + "/admin/listEmail/index.jsp");
                return;

            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <div align="center" style="margin-bottom: 2px; color: red;font-weight: bold">
                            <%                                
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <form action="" method="post">
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Sửa thông tin nhóm gửi mail</th>                                        
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tên nhóm </td>
                                        <td colspan="2">
                                            <input tyle="width: 392px" type="text" placeholder="Group Name" name="name" value="<%=listMail.getName()%>"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Danh sách email có trong nhóm </td>
                                        <td colspan="2">
                                            <%=listMail.getDesEdit(request)%>
                                        </td>
                                        <td>
<!--                                            <a title="Xóa" class="ask" href="#">
                                                <img width='12' src='/admin/resource/images/remove.png' alt='' title='Xóa' border='0' />
                                            </a>-->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Danh sách mail</td>
                                        <td colspan="2">
                                            <%
                                                Account partner = new Account();
                                                ArrayList<Account> dts = partner.getKHAccount();
                                                if (dts != null && !dts.isEmpty()) {
                                            %>
                                            <select style="width: 400px" class="select3" id="partnerID" name="partnerID" multiple>
                                                <option value="">--- Tất cả ---</option>
                                                <%
                                                    for (Account b : dts) {
                                                %>
                                                <option value="<%= b.getEmail()%>">[<%= b.getUserName()%>] <%= b.getFullName()+" --- "+b.getEmail()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <%
                                                }
                                            %>
                                            <br/>
                                            <span style="color: red">Danh sách tài khoản trên hệ thống. Chọn tài khoản có nhập email. OK</span>
                                        </td>
                                        <td class="redBoldUp"></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left"></td>
                                        <td colspan="2">
                                            <input style="width: 392px" type="text" name="des" value=""/>
                                            <br/>
                                            <span style="color: red">Email không có trên hệ thống, email ngăn cách nhau bởi dấu phẩy ( , )</span>
                                        </td>
                                        <td class="redBoldUp"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input class="button" type="submit" name="submit" value="Sửa"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/listEmail/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
                                        </td>
                                        <td></td>
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