<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <%@include file="/admin/includes/header.jsp" %>
    </head>
    <body>
        <%
            if (!userlogin.checkView(request)) {
                //CongNX: Ghi log action vao db
                UserAction log = new UserAction(userlogin.getUserName(),
                                "UserAction",
                                UserAction.TYPE.VIEW.val,
                                UserAction.RESULT.REJECT.val,
                                "Permit deny!");
                log.logAction(request);
                //CongNX: ket thuc ghi log db voi action thao tac tu web
                session.setAttribute("mess", "Bạn không có quyền truy cập module này!");
                response.sendRedirect(request.getContextPath() + "/admin/");
                return;
            }
            int id = Tool.string2Integer(request.getParameter("id"));
            
            UserAction userAction = UserAction.findById(id);
            
            if (userAction == null) {
                UserAction log = new UserAction(userlogin.getUserName(),
                                "UserAction",
                                UserAction.TYPE.VIEW.val,
                                UserAction.RESULT.REJECT.val,
                                "Not exist ID = " + id);
                log.logAction(request);
                //CongNX: ket thuc ghi log db voi action thao tac tu web
                session.setAttribute("mess", "Không tồn tại bản ghi này!");
                response.sendRedirect(request.getContextPath() + "/admin/account/userAction.jsp");
                return;
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
                        <form action="" method="post">
                            <table align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th style="font-weight: bold"  scope="col" class="rounded redBoldUp">Log Action Details</th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">Username </td>
                                        <td colspan="2"><%=userAction.getUserName()%></td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">User IP </td>
                                        <td colspan="2"><%=userAction.getIp()%></td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">URL Action </td>
                                        <td colspan="2"><%=userAction.getUrlAction()%></td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">Table Action </td>
                                        <td colspan="2"><%=userAction.getTableAction()%></td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">Action Type </td>
                                        <td colspan="2"><%=userAction.getActionType()%></td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">Action Date </td>
                                        <td colspan="2"><%=userAction.getActionDate()%></td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">Result </td>
                                        <td colspan="2"><%=userAction.getResult()%></td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">Info </td>
                                        <td colspan="2"><%=userAction.getInfo()%></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath()+"/admin/account/userAction.jsp"%>'" type="reset" name="reset" value="Back"/>
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