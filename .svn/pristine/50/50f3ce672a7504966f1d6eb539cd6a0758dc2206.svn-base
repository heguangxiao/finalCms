<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.entity.Provider"%><%@page import="gk.myname.vn.admin.Account"%><%@page import="gk.myname.vn.utils.Tool"%>
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
        UserAction log = new UserAction(userlogin.getUserName(),
                        "Provider",
                        UserAction.TYPE.DEL.val,
                        UserAction.RESULT.REJECT.val,
                        "Permit deny!");
        log.logAction(request);
        session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        return;
    }
    int id = Tool.string2Integer(request.getParameter("id"));
    Provider gDao = new Provider();
    try {
        //--------------------
        if (gDao.del_ever(id)) {

            UserAction log = new UserAction(userlogin.getUserName(),
                            "Provider",
                            UserAction.TYPE.DEL.val,
                            UserAction.RESULT.SUCCESS.val,
                            "Provider = " + id);
            log.logAction(request);
            session.setAttribute("mess", "Xóa Provider thành công");
            response.sendRedirect(request.getContextPath() + "/admin/provider/index.jsp");
        } else {
            UserAction log = new UserAction(userlogin.getUserName(),
                            "Provider",
                            UserAction.TYPE.DEL.val,
                            UserAction.RESULT.FAIL.val,
                            "Provider = " + id);
            log.logAction(request);
            session.setAttribute("mess", "Xóa Provider thật bại");
            response.sendRedirect(request.getContextPath() + "/admin/provider/index.jsp");
        }
    } catch (Exception ex) {
        UserAction log = new UserAction(userlogin.getUserName(),
                        "Provider",
                        UserAction.TYPE.DEL.val,
                        UserAction.RESULT.FAIL.val,
                        "Provider = " + id);
        log.logAction(request);
        ex.printStackTrace();
        session.setAttribute("mess", "Xóa Provider thật bại Exception");
        response.sendRedirect(request.getContextPath() + "/admin/provider/index.jsp");
    }
%>