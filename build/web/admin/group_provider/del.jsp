<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.entity.GroupProvider"%>
<%@page import="gk.myname.vn.admin.Account"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page contentType="text/html; charset=utf-8" %>
<%    Account userlogin = Account.getAccount(session);
    if (userlogin == null) {
        session.setAttribute("mess", "Bạn không có quyên truy cập trang này");
%>
<script type="text/javascript" language="javascript">
    alert('Bạn không có quyên truy cập trang này');
    parent.history.back();
</script>
<%
        return;
    }
    if (!userlogin.checkDel(request)) {
        //CongNX: Ghi log action vao db
        UserAction log = new UserAction(userlogin.getUserName(),
                        "Group Provider",
                        UserAction.TYPE.DEL.val,
                        UserAction.RESULT.REJECT.val,
                        "Permit deny!");
        log.logAction(request);
        //CongNX: ket thuc ghi log db voi action thao tac tu web
        session.setAttribute("mess", "Bạn không có quyền truy cập module này!");
        response.sendRedirect(request.getContextPath() + "/admin/group_provider/");
        return;
    }
    int id = Tool.string2Integer(request.getParameter("id"));

    GroupProvider gDao = new GroupProvider();

    try {
        //--------------------
        if (gDao.delete(id)) {
            UserAction log = new UserAction(userlogin.getUserName(),
                            "Group Provider",
                            UserAction.TYPE.DEL.val,
                            UserAction.RESULT.SUCCESS.val,
                            "Group Provider = " + id);
            log.logAction(request);
            session.setAttribute("mess", "Xóa Group thành công");
            response.sendRedirect(request.getContextPath() + "/admin/group_provider/");
        } else {
            UserAction log = new UserAction(userlogin.getUserName(),
                            "Group Provider",
                            UserAction.TYPE.DEL.val,
                            UserAction.RESULT.FAIL.val,
                            "Group Provider = " + id);
            log.logAction(request);
            session.setAttribute("mess", "Xóa Group thất bại");
            response.sendRedirect(request.getContextPath() + "/admin/group_provider/");
        }
    } catch (Exception ex) {
        ex.printStackTrace();
        UserAction log = new UserAction(userlogin.getUserName(),
                        "Group Provider",
                        UserAction.TYPE.DEL.val,
                        UserAction.RESULT.FAIL.val,
                        "Group Provider = " + id);
        log.logAction(request);
        session.setAttribute("mess", "Xóa Group thất bại");
        response.sendRedirect(request.getContextPath() + "/admin/group_provider/");
    }
%>