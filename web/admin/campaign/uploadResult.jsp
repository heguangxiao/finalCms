<%@page import="gk.myname.vn.utils.DateProc"%>
<%@page import="gk.myname.vn.entity.Campaign"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.admin.Account"%>
<%@page contentType="text/html; charset=utf-8" %>
<%
    request.setCharacterEncoding("utf-8");
    Account userlogin = Account.getAccount(session);
    if (userlogin == null) {
        session.setAttribute("error", "Bạn cần đăng nhập để truy cập hệ thống");
        out.print("<script>top.location='" + request.getContextPath() + "/admin/login.jsp';</script>");
        return;
    }
    int cpid = RequestTool.getInt(request, "cpid");
    Campaign cpDao = new Campaign();
    cpDao = cpDao.findById(cpid);
%>
<div style="margin-left: 30px;">
    <form id="uploadForm" name="uploadForm" action="<%=request.getContextPath() + "/admin/campaign/processReport.jsp"%>" method="post"  enctype="multipart/form-data">
        <table id="rounded-corner">
            <input type="hidden" name="cpid" value="<%=cpid%>" />
            <tr>
                <td style="text-align: center" colspan="2" class="redBoldUp">Upload File Kết quả</td>
            </tr>
            <tr>
                <td>CAMPAIGN ID: </td>
                <td><input size="20" type="text" readonly value="<%=cpDao.getCampaignId()%>"/></td>
            </tr>
            <tr>
                <td>LABEL: </td>
                <td><input size="20" type="text" readonly value="<%=cpDao.getLabel()%>"/></td>
            </tr>
            <tr>
                <td>TIME SEND: </td>
                <td><input size="20" type="text" readonly value="<%=DateProc.Timestamp2DDMMYYYYHH24Mi(cpDao.getEndTime())%>"/></td>
            </tr>
            <tr>
                <td>File Dữ Liệu</td>
                <td colspan="3">
                    <input type="file" onchange="fileUploadChoice(this)" class="fileUpload" id="fileUpload_<%=cpid%>" cpid="<%=cpid%>" name="fileUpload_<%=cpid%>" style="display: none" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel"/>
                    <input size="40" type="text" id="file_path_fake" readonly="true"/>
                    <input type="button" value="Chọn File" class="button" name="choiceFile" onclick="HandleBrowseClick('<%=cpid%>');"/>
                </td>
            </tr>
            <tr>
                <td></td>
                <td colspan="3">
                    <span style="color: red" id="fileUpError"></span>
                </td>
            </tr>
            <tr>
                <td colspan="4"  align="center"><input name="submit" onclick="uploadFile('<%=cpid%>')" class="button" type="button" value="Upload" /></td>
            </tr>
        </table>
    </form>
</div>