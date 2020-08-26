<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.admin.Account"%><%@page import="gk.myname.vn.utils.Tool"%>
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
                        UserAction.TABLE.accounts.val,
                        UserAction.TYPE.DEL.val,
                        UserAction.RESULT.REJECT.val,
                        "Permit deny! " + request);
        log.logAction(request);
        session.setAttribute("mess", "Bạn không có quyền truy cập module này!");
        response.sendRedirect(request.getContextPath() + "/admin/customer/agency/index.jsp");
        return;
    }
    int id = Tool.string2Integer(request.getParameter("id"));
    Account adminDao = new Account();
    try {
        //--------------------
        if (adminDao.deleteBlock(id)) {
            UserAction log = new UserAction(userlogin.getUserName(),
                            UserAction.TABLE.accounts.val,
                            UserAction.TYPE.DEL.val,
                            UserAction.RESULT.SUCCESS.val,
                            "Xóa tài khoản thành công! " + request);
            log.logAction(request);
            session.setAttribute("mess", "Xóa tài khoản thành công");
            response.sendRedirect(request.getContextPath() + "/admin/customer/agency/index.jsp");
        } else {
            UserAction log = new UserAction(userlogin.getUserName(),
                            UserAction.TABLE.accounts.val,
                            UserAction.TYPE.DEL.val,
                            UserAction.RESULT.FAIL.val,
                            "Xóa tài khoản thật bại! " + request);
            log.logAction(request);
            session.setAttribute("mess", "Xóa tài khoản thật bại");
            response.sendRedirect(request.getContextPath() + "/admin/customer/agency/index.jsp");
        }
    } catch (Exception ex) {
        ex.printStackTrace();
        UserAction log = new UserAction(userlogin.getUserName(),
                        UserAction.TABLE.accounts.val,
                        UserAction.TYPE.DEL.val,
                        UserAction.RESULT.FAIL.val,
                        "Xóa tài khoản thật bại! " + request);
        log.logAction(request);
        session.setAttribute("mess", "Xóa tài khoản thật bại");
        response.sendRedirect(request.getContextPath() + "/admin/customer/agency/index.jsp");
    }
%>