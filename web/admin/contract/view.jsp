<%@page import="gk.myname.vn.entity.Contract"%>
<%@page import="java.io.*" %>
<%@page contentType="text/html; charset=utf-8" %>
<%@include file="/admin/includes/header.jsp" %>
<%@include file="/admin/includes/checkLogin.jsp" %>

<style>
#customers {
  font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 50%;
}

#customers td, #customers th {
  border: 1px solid #ddd;
  padding: 8px;
}

#customers tr:nth-child(even){background-color: #f2f2f2;}

#customers tr:hover {background-color: #ddd;}

#customers th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #4CAF50;
  color: white;
}
</style>

<%    
    if (!userlogin.checkEdit(request)) {
        session.setAttribute("mess", "Bạn không có quyền sửa module này!");
        response.sendRedirect(request.getContextPath() + "/admin/contract/");
        return;
    } else {
        int subID = Integer.parseInt(request.getParameter("subid"));
        int partnerID = Integer.parseInt(request.getParameter("partnerid"));
        String contractNo = request.getParameter("contractno");
        Contract contract = new Contract();
        Contract contr = contract.getFile(subID, partnerID, contractNo);
        String fileName = contr.getFile_path();
        String folder = request.getContextPath() + "/upload/contract/" + subID + "-" + partnerID + "-" + contractNo + "/";
        String delfolder = "/upload/contract/" + subID + "-" + partnerID + "-" + contractNo + "/";
%>
    <center style="color: white">
        <h1>File</h1>
        <span id="mess"></span>
        <table id="customers">
<%
        for(String w:fileName.split("\\,",0)){  
            if (!w.equals("")) {
%>
<tr>
    <td>
        <a style="color: #00ccff;text-decoration: none;" href="<%=folder+w%>" download>
            <%=w%>
        </a>
    </td>
    <td>
        <a onclick="delFile('<%=delfolder+w%>','<%=subID%>','<%=partnerID%>','<%=contractNo%>')" href="" style="color: hotpink;text-decoration: none;">
            Xóa
        </a>
    </td>
</tr>
<%
            }
        }  
%>
        </table>
    </center>

<!--<object  
    data="<%=request.getContextPath()%>/upload/contract/<%=subID + "-" + partnerID + "-" + contractNo + "/"%><%=contr.getFile_path()%>" 
    hspace="120" 
    style="background-color: white;width: 80%;height:100% " >
</object>-->
<%
    }
%>
<script language="JScript">
    function delFile(i, a, b, c) {        
        var url = "<%=request.getContextPath()%>/admin/contract/delFile.jsp?code=" + i + "&subid=" + a + "&partnerID=" + b + "&contractNo=" + c;                
        AjaxAction(url, "mess");
        for (var y = 0 ; y < 200 ; y ++) {
            console.log(y+1);
        }
        location.reload();
    }
</script>

