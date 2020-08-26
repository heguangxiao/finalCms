<%@page import="gk.myname.vn.entity.ListMail"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="java.util.Iterator"%>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "LIST MAIL"); %>
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
            ArrayList<ListMail> all = null;
            
            int currentPage = RequestTool.getInt(request, "page", 1);
            
            String name = RequestTool.getString(request, "name");
            
            all = ListMail.findAll(max, currentPage, name);
            
            int totalPage = 0;
            int totalRow = ListMail.count(name);
            
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
                        <form action="<%=request.getContextPath() + "/admin/listEmail/index.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"><b>Quản lý nhóm gửi mail</b></th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>                                        
                                        <td class="redBold">Từ khóa</td>
                                        <td><input type="text" name="name"/></td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="3">
                                            <input class="button" type="submit" name="submit" value="Tìm kiếm"/>
                                            &nbsp;&nbsp;
                                            <input class="button" onclick="location.href = '<%=request.getContextPath() + "/admin/listEmail/add.jsp"%>'" type="button" name="Thêm mới" value="Thêm mới"/>
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
                                    <th scope="col" class="rounded">Tên nhóm</th>
                                    <th scope="col" class="rounded">Danh sách email trong nhóm</th>
                                    <th scope="col" class="rounded">Người tạo</th>
                                    <th scope="col" class="rounded">Ngày tạo</th>
                                    <th scope="col" class="rounded">Người sửa cuối</th>
                                    <th scope="col" class="rounded">Ngày sửa cuối</th>
                                    <%=buildHeader(request, userlogin, true, true)%>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int count = 1; 
                                    
                                    for (Iterator<ListMail> iter = all.iterator(); iter.hasNext();) {
                                        ListMail one = iter.next();
                                        int tmp = (currentPage - 1) * 25 + count++;
                                %>
                                    <tr>
                                        <td class="boder_right"><%=tmp%></td>
                                        <td class="boder_right"><%=one.getName()%></td>
                                        <td class="boder_right">
                                            <%=one.getDesIndex()%>
                                        </td>
                                        <td class="boder_right"><%=one.getCreatedBy()%></td>
                                        <td class="boder_right"><%=one.getCreatedAt()%></td>
                                        <td class="boder_right"><%=one.getUpdatedBy()%></td>
                                        <td class="boder_right"><%=one.getUpdatedAt()%></td>
                                            <%=buildControl(request, userlogin,
                                                    "/admin/listEmail/edit.jsp?id=" + one.getId(),
                                                    "/admin/listEmail/del.jsp?id=" + one.getId())%>
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