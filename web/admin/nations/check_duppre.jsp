<%@page import="gk.myname.vn.entity.Nations"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.admin.Account"%>
<%@page contentType="text/html; charset=utf-8" %><%
    Account userlogin = Account.getAccount(session);
    if (userlogin == null) {
        session.setAttribute("mess", "Bạn không có quyên truy cập trang này");
    }
    String country_prefix = RequestTool.getString(request, "country_prefix");
    
    Nations dao = new Nations();
    Nations codeExist = dao.getByCountry_prefix("+"+country_prefix);
    if (codeExist != null) {
        out.print("1");
    } else {
        out.print("0");
    }
%>