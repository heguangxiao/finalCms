<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.entity.TemplateCheckSMS"%>
<%@page import="gk.myname.vn.entity.Groups_Providers"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="gk.myname.vn.entity.GroupProvider"%>
<%@page import="gk.myname.vn.entity.Provider"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.PhoneBlackList"%>
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
                UserAction log = new UserAction(userlogin.getUserName(),
                        "temp_check_sms",
                        UserAction.TYPE.EDIT.val,
                        UserAction.RESULT.REJECT.val,
                        "Permit deny!");
                log.logAction(request);
                session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            int id = RequestTool.getInt(request, "id");
            
            TemplateCheckSMS dao = new TemplateCheckSMS();
            String message = "";
            if (id <= 0) {
                UserAction log = new UserAction(userlogin.getUserName(),
                        "temp_check_sms",
                        UserAction.TYPE.EDIT.val,
                        UserAction.RESULT.REJECT.val,
                        "Nội dung chỉnh sửa không tồn tại!");
                log.logAction(request);
                session.setAttribute("mess", "Nội dung bạn tìm kiếm không tồn tại ! ");
                response.sendRedirect(request.getContextPath() + "/admin/temp_check_sms/");
                return;
            }
            
            TemplateCheckSMS templateCheckSMS = dao.findById(id);
            
            if (request.getParameter("submit") != null) {
                //---------------------------
                String name = RequestTool.getString(request, "name");
                String key = RequestTool.getString(request, "key");
                String description = RequestTool.getString(request, "description");;
                String group = RequestTool.getString(request, "group");
                String vt = RequestTool.getString(request, "vitri");
                int vitri = Tool.string2Integer(vt);
                
                templateCheckSMS.setName(name);
                templateCheckSMS.setKey(key);
                templateCheckSMS.setDescription(description);
                templateCheckSMS.setGroup(group);
                templateCheckSMS.setVitri(vitri);
                
                if (dao.edit(templateCheckSMS)) {                    
                    message += "Sửa thông tin thành công <br/>";
                    UserAction log = new UserAction(userlogin.getUserName(),
                            "temp_check_sms",
                            UserAction.TYPE.EDIT.val,
                            UserAction.RESULT.REJECT.val,
                            "Sửa thông tin thành công!");
                    log.logAction(request);
                } else {
                    message += "Sửa thông tin không thành công <br/>";
                    UserAction log = new UserAction(userlogin.getUserName(),
                            "temp_check_sms",
                            UserAction.TYPE.EDIT.val,
                            UserAction.RESULT.REJECT.val,
                            "Sửa thông tin không thành công!");
                    log.logAction(request);
                }
                
                session.setAttribute("mess", message);
                response.sendRedirect(request.getContextPath() + "/admin/temp_check_sms/index.jsp");
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
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Chỉnh sửa loại tin nhắn</th>                                        
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Từ khóa : </td>
                                        <td colspan="2">
                                            <input size="50" type="text" name="key" value="<%=templateCheckSMS.getKey()%>"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Vị trí : </td>
                                        <td colspan="2">
                                            <select name="vitri" id="vitri">
                                                <option <%=templateCheckSMS.getVitri() == 1 ? "selected='selected'" : ""%> value="1">Đầu tin nhắn</option>
                                                <option <%=templateCheckSMS.getVitri() == 2 ? "selected='selected'" : ""%> value="2">Giữa tin nhắn</option>
                                                <option <%=templateCheckSMS.getVitri() == 3 ? "selected='selected'" : ""%> value="3">Cuối tin nhắn</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Nhóm : </td>
                                        <td colspan="2">
                                            <input size="50" type="text" name="group" value="<%=templateCheckSMS.getGroup()%>"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tên gợi nhớ : </td>
                                        <td colspan="2">
                                            <input size="50" type="text" name="name" value="<%=templateCheckSMS.getName()%>"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Mô tả : </td>
                                        <td colspan="2">
                                            <input size="50" type="text" name="description" value="<%=templateCheckSMS.getDescription()%>"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input class="button" type="submit" name="submit" value="Sửa"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/group_provider/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
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