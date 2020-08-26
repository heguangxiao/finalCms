<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.TempContent"%>
<%@page import="gk.myname.vn.utils.SMSUtils"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page contentType="text/html; charset=utf-8" %>
<html>
    <head><%@include file="/admin/includes/header.jsp" %></head>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/admin/resource/select2/select2.css" />
    <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2_locale_vi.js"></script>
    <script type="text/javascript" language="javascript">
        //------
        $(document).ready(function () {
            $("#_label").select2({
                formatResult: function (item) {
                    return ('<div>' + item.text + '</div>');
                },
                formatSelection: function (item) {
                    return (item.text);
                },
                dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
                escapeMarkup: function (m) {
                    return m;
                }
            });
        });
    </script>
    <body>
        <%            //--
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            
            int id = RequestTool.getInt(request, "id");
            
            TempContent oneKeys = TempContent.findById(id);
            TempContent check = null;
            
            if (oneKeys == null) {
                session.setAttribute("mess", "Không tìm thấy temp content cần sửa !");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            
            ArrayList<String> allBrandname = null;
            TempContent pDao = new TempContent();
            allBrandname = pDao.getAllBrandDistand();
            if (request.getParameter("submit") != null) {
                
                String temp = RequestTool.getString(request, "temp");                
                int status = RequestTool.getInt(request, "status");
                
                if (Tool.checkNull(temp)) {
                    session.setAttribute("mess", "Không được để mẫu nội dung tin nhắn trống!");
                    response.sendRedirect(request.getContextPath() + "/admin/temp-content/edit.jsp?id="+id);
                    return;
                }
                
                oneKeys.setTemp(temp);
                oneKeys.setActive(status);
                if (oneKeys.update(oneKeys)) {
                    session.setAttribute("mess", "UPDATE dữ liệu thành công!");
                } else {                    
                    session.setAttribute("mess", "UPDATE dữ liệu lỗi !");
                }
            
                response.sendRedirect(request.getContextPath() + "/admin/temp-content/index.jsp");
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
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Thêm mới Từ Khóa</th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Viettel </td>
                                        <td colspan="1"><%=oneKeys.getOper()%></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <span class="redBold">Mẫu nội dung tin nhắn: </span>
                                        </td>
                                        <td>
                                            <textarea cols="40" rows="5" type="text" id="temp" name="temp"><%=oneKeys.getTemp()%></textarea>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <span class="redBold">Brandname</span>
                                            <%=oneKeys.getBrandname()%>
                                        </td>
                                        <td>
                                            &nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Status</span>
                                            <select name="status">
                                                <option value="0" <%=oneKeys.getActive() == 0 ? "selected='selected'" : ""%>>Không kích hoạt</option>
                                                <option value="1" <%=oneKeys.getActive() == 1 ? "selected='selected'" : ""%>>Kích hoạt</option>                                                
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input class="button" type="submit" name="submit" value="Update"/>
                                            <input class="button" onclick="window.location.href = '<%= request.getContextPath()%>/admin/temp-content/index.jsp'" type="reset" name="reset" value="Hủy"/>
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