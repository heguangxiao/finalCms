<%@page import="gk.myname.vn.entity.Campaign"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="gk.myname.vn.admin.Account"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@include file="/admin/includes/header.jsp" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%    
    System.out.println(" aaaaaaaaaaaaaaaaa");
    int id = RequestTool.getInt(request, "id");
    
    System.out.println(id);
        Campaign campaign = new Campaign();
        Campaign c = new Campaign();
        c = campaign.findById(id);
        if (c != null) {
%>
<table id="rounded-corner">
    <thead>
        <tr>
            <td colspan="10">Chi tiết MT</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="boder_right">MT: </td>
            <td colspan="9"><%=StringEscapeUtils.escapeHtml(c.getMessage())%></td>
        </tr>
        <tr>
            <td class="boder_right">MT: </td>
            <td colspan="9"><textarea onkeyup="demtin(this.value)" cols="55" rows="5"><%=StringEscapeUtils.escapeHtml(c.getMessage())%></textarea></td>
        </tr>
        <tr>
            <td class="boder_right">Số ký tự tin nhắn: </td>
            <td colspan="9"><span class="redBold" id="showtin"><%=StringEscapeUtils.escapeHtml(c.getMessage()).length()%></span></td>
        </tr>
    </tbody>
</table>
<%
        } else {
            out.print("<h1>Message Not found!</h1>");
        }
%> 
