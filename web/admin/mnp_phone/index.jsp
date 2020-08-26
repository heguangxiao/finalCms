<%@page import="gk.myname.vn.entity.MnpPhone"%>
<%@page import="gk.myname.vn.entity.TemplateCheckSMS"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="java.util.Iterator"%>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "MNP PHONE"); %>
        <%@include file="/admin/includes/header.jsp" %>
    </head>
    <body>
        <%       
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền vào module này!");
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }
            
            int max = 20;
            ArrayList<MnpPhone> all = null;
            MnpPhone dao = new MnpPhone();
            
            int currentPage = RequestTool.getInt(request, "page", 1);
            
            String phone = RequestTool.getString(request, "phone");
            
            all = dao.findAll(max, currentPage, phone);
            
            int totalPage = 0;
            int totalRow = dao.count(phone);
            
            totalPage = (int) totalRow / max;
            if (totalRow % max != 0) {
                totalPage++;
            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <!-- Tìm kiếm-->
                        <form action="<%=request.getContextPath() + "/admin/mnp_phone/index.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"><b>Quản lý MNP Phone</b></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Phone <input type="text" name="phone"/></td>                                        
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="4">
                                            <input class="button" type="submit" name="submit" value="Tìm kiếm"/>
                                            &nbsp;&nbsp;
                                            <input class="button" onclick="location.href = '<%=request.getContextPath() + "/admin/mnp_phone/add.jsp"%>'" type="button" name="Thêm mới" value="Thêm mới"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>      
                        <!--End tim kiếm-->
                        <%@include file="/admin/includes/page.jsp" %>
                        <div align="center" style="margin-bottom: 2px; color: red;font-weight: bold">
                            <%  
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <!--Content-->
                        <table align="center" id="rounded-corner" summary="Msc Joint Stock Company" >
                            <thead>
                                <tr>
                                    <th scope="col" class="rounded-company">STT</th>
                                    <th scope="col" class="rounded">Số điện thoại</th>
                                    <th scope="col" class="rounded">Nhà mạng chuyển tới</th>
                                    <th scope="col" class="rounded">Ngày khởi tạo</th>
                                    <th scope="col" class="rounded">Nhà mạng ban đầu</th>
                                    <th scope="col" class="rounded">Ngày tác động cuối cùng</th>
                                    <th scope="col" class="rounded">Nguồn</th>
                                    <th scope="col" class="rounded-q4">Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int count = 1; 
                                    
                                    for (Iterator<MnpPhone> iter = all.iterator(); iter.hasNext();) {
                                        MnpPhone one = iter.next();
                                        int tmp = (currentPage - 1) * 25 + count++;
                                %>
                                    <tr>
                                        <td class="boder_right"><%=tmp%></td>
                                        <td class="boder_right" align="left">
                                            <%=one.getPhone()%>
                                        </td>
                                        <td class="boder_right">
                                            <%=one.getOperMnp()%>
                                        </td>
                                        <td class="boder_right">
                                            <%=one.getCreatedat()%>
                                        </td>
                                        <td class="boder_right">
                                            <%=one.getOperOrg()%>
                                        </td>
                                        <td class="boder_right">
                                            <%=one.getUpdatedat()%>
                                        </td>
                                        <td class="boder_right">
                                            <%=one.getSources()%>
                                        </td>
                                        <td>
                                            <a title="Sửa"  href="<%=request.getContextPath()%>/admin/mnp_phone/edit.jsp?id=<%=one.getId()%>">
                                                <img width="24" src="<%= request.getContextPath()%>/admin/resource/images/user_edit.png" title="Sửa" border="0" />
                                            </a>
                                        </td>
                                    </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div><!-- end of right content-->
                </div>   <!--end of center content -->
                <div class="clear"></div>
            </div> <!--end of main content-->
            <%@include file="/admin/includes/footer.jsp" %>
        </div>
    </body>
</html>