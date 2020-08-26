<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.Nations"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page contentType="text/html; charset=utf-8" %>
<html>
    <head><%@include file="/admin/includes/header.jsp" %></head>
    <body>
        <%  //--          
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            int id = RequestTool.getInt(request, "id");
            Nations oneNa = new Nations();
            oneNa = oneNa.getbyId(id);
            if (id == 0 || oneNa == null) {
                session.setAttribute("mess", "Yêu cầu không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/admin/nations/list.jsp");
                return;
            }
            if (request.getParameter("submit") != null) {
                //---------------------------
                String country_code = RequestTool.getString(request, "country_code");
                String country_prefix = RequestTool.getString(request, "country_prefix");
                String country_name = RequestTool.getString(request, "country_name");
                //---
                
                if (Tool.checkNull(country_code) || Tool.checkNull(country_prefix) || Tool.checkNull(country_name)) {
                    session.setAttribute("mess", "Không được để trống mã nước, đầu số và tên nước!");
                    response.sendRedirect(request.getContextPath() + "/admin/nations/edit.jsp?id="+id);
                    return;
                }
                Nations dao = new Nations();
                if (!oneNa.getCountry_code().equals(country_code)) {
                    if (dao.getByCountry_code(country_code.toUpperCase()) != null) {
                        session.setAttribute("mess", "Mã nước này đã tồn tại!");
                        response.sendRedirect(request.getContextPath() + "/admin/nations/edit.jsp?id="+id);
                        return;
                    } 
                }
                
                oneNa.setCountry_code(country_code.toUpperCase());
                oneNa.setCountry_prefix(country_prefix);
                oneNa.setCountry_name(country_name);
                //------------
                if (oneNa.updateNa(oneNa)) {
                    session.setAttribute("mess", "Cập nhật dữ liệu nước thành công!");
                    response.sendRedirect(request.getContextPath() + "/admin/nations/list.jsp");
                    return;
                } else {
                    session.setAttribute("mess", "Cập nhật dữ liệu nước lỗi!");
                }
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
                        <form action="" method="post">
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Chỉnh sửa nước</th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Mã nước: </td>
                                        <td colspan="2"><input readonly style="text-transform: uppercase" value="<%=oneNa.getCountry_code()%>" size="75" type="text" name="country_code"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Đầu số của nước: </td>
                                        <td colspan="2"><input readonly value="<%=oneNa.getCountry_prefix()%>" size="75" type="text" name="country_prefix"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tên nước: </td>
                                        <td colspan="2"><input value="<%=oneNa.getCountry_name()%>" size="75" type="text" name="country_name"/></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input class="button" type="submit" name="submit" value="Cập nhật"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/nations/list.jsp"%>'" type="reset" name="reset" value="Hủy"/>
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