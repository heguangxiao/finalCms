<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="gk.myname.vn.entity.Nations"%>
<%@page import="gk.myname.vn.admin.Account"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page contentType="text/html; charset=utf-8" %>
<%    Account userlogin = Account.getAccount(session);
    if (userlogin == null) {
        session.setAttribute("mess", "Bạn không có quyền truy cập trang này");
%>
<script type="text/javascript" language="javascript">
    alert('Bạn không có quyền truy cập trang này');
    parent.history.back();
</script>
<%
        return;
    }
    if (!userlogin.checkDel(request)) {
        session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
        response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        return;
    }
    int id = Tool.string2Integer(request.getParameter("id"));
    Nations gDao = new Nations();
    Nations aaa = gDao.getbyId(id);
    
    try {
        //--------------------
        if (gDao.del_ever(id)) {
            Telco_Nations bbb = new Telco_Nations();
            bbb.del_ever_NationCode(aaa.getCountry_code());
            session.setAttribute("mess", "Xóa nước thành công");
            response.sendRedirect(request.getContextPath() + "/admin/nations/list.jsp");
        } else {
            session.setAttribute("mess", "Xóa nước thất bại");
            response.sendRedirect(request.getContextPath() + "/admin/nations/list.jsp");
        }
    } catch (Exception ex) {
        ex.printStackTrace();
        session.setAttribute("mess", "Xóa nước thất bại");
        response.sendRedirect(request.getContextPath() + "/admin/nations/list.jsp");
    }
%>
