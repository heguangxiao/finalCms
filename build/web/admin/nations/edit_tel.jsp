<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.Telco_Nations"%>
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
            Telco_Nations oneNaT = new Telco_Nations();
            oneNaT = oneNaT.getbyId(id);
            if (id == 0 || oneNaT == null) {
                session.setAttribute("mess", "Yêu cầu không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/admin/nations/list.jsp");
                return;
            }
            if (request.getParameter("submit") != null) {
                //---------------------------
                String country_code = RequestTool.getString(request, "country_code");
                String telco_code = RequestTool.getString(request, "telco_code");
                String telco_prefix = RequestTool.getString(request, "telco_prefix");
                String telco_name = RequestTool.getString(request, "telco_name");
                int number_length = RequestTool.getInt(request, "number_length");
                
                if (telco_code == null || telco_code.equals("") || telco_name == null || telco_name.equals("")) {
                    session.setAttribute("mess", "Không được để trống mã nhà mạng và tên nhà mạng");
                    response.sendRedirect(request.getContextPath() + "/admin/nations/edit_tel.jsp?id="+id);
                    return;
                }
                
//                if (!oneNaT.getTelco_code().equals(telco_code) || !oneNaT.getTelco_name().equals(telco_name)) {                    
//                    ArrayList<Telco_Nations> arrayList = Telco_Nations.getTelco_na();
//                    for (Telco_Nations elem : arrayList) {
//                            if (elem.getTelco_code().equals(telco_code) || elem.getTelco_name().equals(telco_name)) {                            
//                                session.setAttribute("mess", "Mã nhà mạng hoặc tên nhà mạng đã tồn tại");
//                                response.sendRedirect(request.getContextPath() + "/admin/nations/edit_tel.jsp?id="+id);
//                                return;
//                            }
//                        }
//                }
                
                //---
                oneNaT.setCountry_code(country_code);
                oneNaT.setTelco_code(telco_code);
                oneNaT.setTelco_prefix(telco_prefix);
                oneNaT.setTelco_name(telco_name);
                oneNaT.setNumber_length(number_length);
                //------------
                if (oneNaT.updateTel(oneNaT)) {
                    session.setAttribute("mess", "Cập nhật dữ liệu nhà mạng thành công!");
                    response.sendRedirect(request.getContextPath() + "/admin/nations/list.jsp");
                    return;
                } else {
                    session.setAttribute("mess", "Cập nhật dữ liệu nhà mạng lỗi!");
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
                            <%                                if (session.getAttribute("mess") != null) {
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
                                        <td colspan="2"><input readonly size="75" type="text"  value="<%=oneNaT.getCountry_code()%>" name="country_code"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Mã nhà mạng: </td>
                                        <td colspan="2"><input readonly size="75" style="text-transform: uppercase" type="text" value="<%=oneNaT.getTelco_code()%>" name="telco_code"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Đầu số nhà mạng: </td>
                                        <td colspan="2"><input size="75" value="<%=oneNaT.getTelco_prefix()%>" type="text" name="telco_prefix"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tên nhà mạng: </td>
                                        <td colspan="2"><input size="75" value="<%=oneNaT.getTelco_name()%>" type="text" name="telco_name"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Độ dài: </td>
                                        <td colspan="2"><input size="75" value="<%=oneNaT.getNumber_length()%>" type="text" name="number_length"/></td>
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