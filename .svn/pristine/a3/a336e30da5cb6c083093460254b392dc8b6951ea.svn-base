<%@page import="java.io.File"%>
<%@page import="gk.myname.vn.config.MyContext"%>
<%@page import="gk.myname.vn.entity.MsgBrandAds"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.admin.Account"%>
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
                            "MsgBrandAds",
                            UserAction.TYPE.DEL.val,
                            UserAction.RESULT.REJECT.val,
                            "Permit deny!");
        log.logAction(request);
        //CongNX: ket thuc ghi log db voi action thao tac tu web
        session.setAttribute("mess", "Bạn không có quyền truy cập module này!");
        response.sendRedirect(request.getContextPath() + "/admin/campaign/index.jsp");
        return;
    }
    String id = request.getParameter("id");
    String idC = request.getParameter("cid");
    try {
        boolean flag = MsgBrandAds.delALL(idC);
        if (flag) {                 
            String pathFileResult = MyContext.ROOT_DIR + "/upload/campaign/result/";
            File f1 = new File(pathFileResult + id + ".xls");
            File f2 = new File(pathFileResult + id + ".xlsx");
            String mess = "";
            if (f1.exists()) {                
                if (f1.delete()) {
                    mess += "và " + f1.getName() + " is deleted!";
                } else {
                    mess += "nhưng Delete operation is failed.";
                }
            }
            if (f2.exists()) {                
                if (f2.delete()) {
                    mess += "và " + f1.getName() + " is deleted!";
                } else {
                    mess += "nhưng Delete operation is failed.";
                }
            }
            //CongNX: Ghi log action vao db
            UserAction log = new UserAction(userlogin.getUserName(),
                            "MsgBrandAds",
                            UserAction.TYPE.DEL.val,
                            UserAction.RESULT.SUCCESS.val,
                            "MsgBrandAds + Campaign ID " + idC + mess);
            log.logAction(request);
            //CongNX: ket thuc ghi log db voi action thao tac tu web
            session.setAttribute("mess", "Xóa dữ liệu MsgBrandAds thành công ");
            response.sendRedirect(request.getContextPath() + "/admin/campaign/index.jsp");
        } else {
            //CongNX: Ghi log action vao db
            UserAction log = new UserAction(userlogin.getUserName(),
                            "MsgBrandAds",
                            UserAction.TYPE.DEL.val,
                            UserAction.RESULT.FAIL.val,
                            "MsgBrandAds + Campaign ID " + idC);
            log.logAction(request);
            //CongNX: ket thuc ghi log db voi action thao tac tu web
            session.setAttribute("mess", "Xóa MsgBrandAds thất bại");
            response.sendRedirect(request.getContextPath() + "/admin/campaign/index.jsp");
        }
    } catch (Exception ex) {
        //CongNX: Ghi log action vao db
        UserAction log = new UserAction(userlogin.getUserName(),
                            "MsgBrandAds",
                        UserAction.TYPE.DEL.val,
                        UserAction.RESULT.EXCEPTION.val,
                        "System error ");
        log.logAction(request);
        //CongNX: ket thuc ghi log db voi action thao tac tu web
        ex.printStackTrace();
        session.setAttribute("mess", "Xóa MsgBrandAds thất bại");
        response.sendRedirect(request.getContextPath() + "/admin/campaign/index.jsp");
    }
%>