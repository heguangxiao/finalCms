<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="gk.myname.vn.entity.Nations"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="gk.myname.vn.config.MyContext"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "Quản lý quốc gia"); %>
        <%@include file="/admin/includes/header.jsp" %>
    </head>
    <body>
        <%  //-          
            if (!userlogin.checkView(request)) {
                session.setAttribute("mess", "Bạn không có quyền thêm module này!");
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }
            int max = 50;
            ArrayList<Nations> all = null;
            Nations pDao = new Nations();
            int currentPage = RequestTool.getInt(request, "page", 1);
            String country_name = RequestTool.getString(request, "country_name");
            all = pDao.getNa(currentPage, max, country_name);
            int totalPage = 0;
            int totalRow = pDao.countNa(country_name);
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
                        <form action="<%=request.getContextPath() + "/admin/nations/list.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"><b>Tìm kiếm nước</b></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Tên nước </td>
                                        <td>
                                            <input size="20" type="text" name="country_name"/>
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="3">
                                            <input class="button" type="submit" name="submit" value="Tìm kiếm"/>
                                            &nbsp;&nbsp;
                                            <input class="button" onclick="location.href = '<%=request.getContextPath() + "/admin/nations/add.jsp"%>'" type="button" name="Thêm mới" value="Thêm mới"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>      
                        <!--End tim kiếm-->
                        <%@include file="/admin/includes/page.jsp" %>
                        <div align="center" style="height: 20px;margin-bottom: 2px; color: red;font-weight: bold">
                            <%                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <!--Content-->
                        <table align="center" id="rounded-corner" summary="Msc Joint Stock Company" >
                            <thead>
                                <tr>
                                    <th>Mã nước</th>
                                    <th>Đầu số của nước</th>
                                    <th>Tên nước</th>
                                    <th>Nhà mạng thuộc nước</th>
                                    <th>Thêm mới nhà mạng</th>
                                    <th>Sửa</th>
                                    <th>Xóa</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int count = 1; //Bien dung de dem so dong
                                    for (Iterator<Nations> iter = all.iterator(); iter.hasNext();) {
                                        Nations oneNa = iter.next();
                                        int tmp = (currentPage - 1) * 25 + count++;
                                %>
                                <tr>
                                    <td class="boder_right" align="left">
                                        <%=oneNa.getCountry_code()%>
                                    </td>
                                    <td class="boder_right" align="left">
                                        <%=oneNa.getCountry_prefix()%>
                                    </td>
                                    <td class="boder_right" align="left">
                                        <%=oneNa.getCountry_name()%>
                                    </td>
                                    <td class="boder_right" align="left">
                                        <%
                                            ArrayList<Telco_Nations> allpro = Telco_Nations.getTelco_na();
                                            for (Telco_Nations one : allpro) {
                                                if (one.getCountry_code().equals(oneNa.getCountry_code())) {
                                        %>
                                        <span style="color: red;font-weight: bold;">
                                            <%=one.getTelco_name()%>&nbsp;&nbsp;[<%=one.getTelco_code()%>]</span>:
                                            &nbsp;&nbsp;
                                            <%=one.getTelco_prefix()%>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            
                                            <a href="<%= request.getContextPath() + "/admin/nations/edit_tel.jsp?id=" + one.getId()%>">
                                                <img width="16px" src="<%= request.getContextPath()%>/admin/resource/images/user_edit.png" alt="" title="" border="0" />
                                            </a> 
                                            <a class="ask" 
                                               href="<%= request.getContextPath() + "/admin/nations/del_tel.jsp?id=" + one.getId()%>">
                                                <img width="16px" src="<%= request.getContextPath()%>/admin/resource/images/remove.png" alt="" title="" border="0" /></a><br>
                                        <%
                                                }
                                            }

                                        %>
                                    </td>
                                    <td class="boder_right" align="center">
                                        <a href="<%=request.getContextPath() + "/admin/nations/add_telco.jsp?country_code=" + oneNa.getCountry_code()%>"><img src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/></a>
                                    </td>
                                    <td class="boder_right" align="left"><a href="<%= request.getContextPath() + "/admin/nations/edit.jsp?id=" + oneNa.getId()%>"><img width="24px" src="<%= request.getContextPath()%>/admin/resource/images/user_edit.png" alt="" title="" border="0" /></a></td>
                                    <td><a href="<%= request.getContextPath() + "/admin/nations/del.jsp?id=" + oneNa.getId()%>" class="ask"><img src="<%= request.getContextPath()%>/admin/resource/images/remove.png" alt="" title="" border="0" /></a></td>
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
