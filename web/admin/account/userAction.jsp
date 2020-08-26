<%@page import="java.util.Iterator"%>
<%@page import="gk.myname.vn.utils.DateProc"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "LOG USER ACTION"); %>
        <%@include file="/admin/includes/header.jsp" %>
        <script type="text/javascript" language="javascript">
            $(document).ready(function () {
                $('.dateproc').datetimepicker({
                    lang: 'vi',
                    timepicker: false,
                    format: 'd/m/Y',
                    formatDate: 'Y/m/d',
                    minDate: '2016/12/01', // yesterday is minimum date
                    maxDate: '+1970/01/02' // and tommorow is maximum date calendar
                });
                 $('.ItemPopup').showPopup({
                    top: 100,
                    closeButton: ".close_popup", //khai báo nút close cho popup
                    scroll: 0, //cho phép scroll khi mở popup, mặc định là không cho phép
                    width: 500,
                    height: 'auto',
                    closeOnEscape: true
                });                
            });
            function validMonth() {
                var stRequest = $("#stRequest").val();
                var endRequest = $("#endRequest").val();
                var arrstRequest = stRequest.split("/");
                var arrendRequest = endRequest.split("/");
                if (stRequest !== "" && stRequest !== null) {
                    if (endRequest === "" || endRequest === null) {
                        jAlert("Bạn cần chọn ngày kết thúc...");
                        return false;
                    }
                    if (arrstRequest[2] !== arrendRequest[2]) {
                        jAlert("Năm bạn chọn không hợp lệ...");
                        return false;
                    }
                }
            }
            $(document).ready(function () {
                $('#_dataTable').DataTable({
                    "order": [[0, "asc"]],
                    "bPaginate": false,
                    "bLengthChange": false,
                    "bFilter": true,
                    "bInfo": false,
                    "bAutoWidth": false
                });
            });
            $(document).ready(function () {
                $('.ask').jConfirmAction();
            });
        </script>
    </head>
    <body>
        <%
            if (!userlogin.checkView(request)) {
                //CongNX: Ghi log action vao db
                UserAction log = new UserAction(userlogin.getUserName(),
                    "UserAction",
                    UserAction.TYPE.VIEW.val,
                    UserAction.RESULT.REJECT.val,
                    "Permit  deny!");
                log.logAction(request);
                //CongNX: ket thuc ghi log db voi action thao tac tu web
                session.setAttribute("mess", "Bạn không có quyền truy cập module này!");
                response.sendRedirect(request.getContextPath() + "/admin/");
                return;
            }
            
            int currentPage = Tool.string2Integer(request.getParameter("page"), 1);
            if (currentPage < 1) {
                currentPage = 1;
            }
            
            ArrayList<UserAction> allUserAction = null;
            String stRequest = RequestTool.getString(request, "stRequest");
            if (Tool.checkNull(stRequest)) {
//                stRequest = "01/12/2016";
                stRequest = DateProc.createDDMMYYYY();
            }
            String endRequest = RequestTool.getString(request, "endRequest");
            if (Tool.checkNull(endRequest)) {
                endRequest = DateProc.createDDMMYYYY();
            }
            
            String username = RequestTool.getString(request, "username");
            String table = RequestTool.getString(request, "table");
            String type = RequestTool.getString(request, "type");
            String result = RequestTool.getString(request, "result");
            
            allUserAction = UserAction.getAll(currentPage, maxRow, username, table, type, result, stRequest, endRequest);
            int max = 20;
            int totalPage = 0;
            int totalRow = UserAction.countAll(username, table, type, result, stRequest, endRequest);
            totalPage = (int) totalRow / max;
            if (totalRow % max != 0) {
                totalPage++;
            }
            
            RequestTool.debugParam(request);
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <!-- Tìm kiếm-->
                        <form action="<%=request.getContextPath() + "/admin/account/userAction.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"><b>LOG USER ACTION</b></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Username</td>
                                        <td>
                                            <select style="width: 180px" class="select3" name="username">
                                                <option value="">Tất cả</option>
                                                <%
                                                    ArrayList<String> users = UserAction.getUsernames();
                                                    for (String elem : users) {
                                                %>
                                                <option <%=username.equals(elem) ? "selected='selected'" : ""%> value="<%=elem%>"><%=elem%></option>
                                                <%
                                                        }
                                                %>
                                            </select>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Table Action</span>
                                            <select style="width: 180px" class="select3" name="table">
                                                <option value="">Tất cả</option>
                                                <%
                                                    ArrayList<String> tables = UserAction.getTables();
                                                    for (String elem : tables) {
                                                %>
                                                <option <%=table.equals(elem) ? "selected='selected'" : ""%> value="<%=elem%>"><%=elem%></option>
                                                <%
                                                        }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><span class="redBold"> Từ</span></td>
                                        <td>
                                            <input readonly value="<%=stRequest%>" class="dateproc" size="8" id="stRequest" type="text" name="stRequest"/>
                                            &nbsp;&nbsp;&nbsp;<span class="redBold">Đến </span>
                                            <input readonly value="<%=endRequest%>" class="dateproc" size="8" id="endRequest" type="text" name="endRequest"/>
                                            &nbsp;&nbsp;&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Type Action</td>
                                        <td>
                                            <select style="width: 180px" class="select3" name="type">
                                                <option value="">Tất cả</option>
                                                <option <%=type.equals(UserAction.TYPE.ADD.val) ? "selected='selected'" : ""%> value="<%=UserAction.TYPE.ADD.val%>"><%=UserAction.TYPE.ADD.val%></option>
                                                <option <%=type.equals(UserAction.TYPE.EDIT.val) ? "selected='selected'" : ""%> value="<%=UserAction.TYPE.EDIT.val%>"><%=UserAction.TYPE.EDIT.val%></option>
                                                <option <%=type.equals(UserAction.TYPE.DEL.val) ? "selected='selected'" : ""%> value="<%=UserAction.TYPE.DEL.val%>"><%=UserAction.TYPE.DEL.val%></option>
                                                <option <%=type.equals(UserAction.TYPE.LOGIN.val) ? "selected='selected'" : ""%> value="<%=UserAction.TYPE.LOGIN.val%>"><%=UserAction.TYPE.LOGIN.val%></option>
                                                <option <%=type.equals(UserAction.TYPE.EXPORT.val) ? "selected='selected'" : ""%> value="<%=UserAction.TYPE.EXPORT.val%>"><%=UserAction.TYPE.EXPORT.val%></option>
                                                <option <%=type.equals(UserAction.TYPE.UPLOAD.val) ? "selected='selected'" : ""%> value="<%=UserAction.TYPE.UPLOAD.val%>"><%=UserAction.TYPE.UPLOAD.val%></option>
                                                <option <%=type.equals(UserAction.TYPE.VIEW.val) ? "selected='selected'" : ""%> value="<%=UserAction.TYPE.VIEW.val%>"><%=UserAction.TYPE.VIEW.val%></option>
                                            </select>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Result</span>
                                            <select style="width: 180px" class="select3" name="result">
                                                <option value="">Tất cả</option>
                                                <option <%=result.equals(UserAction.RESULT.SUCCESS.val) ? "selected='selected'" : ""%> value="<%=UserAction.RESULT.SUCCESS.val%>"><%=UserAction.RESULT.SUCCESS.val%></option>
                                                <option <%=result.equals(UserAction.RESULT.EXCEPTION.val) ? "selected='selected'" : ""%> value="<%=UserAction.RESULT.EXCEPTION.val%>"><%=UserAction.RESULT.EXCEPTION.val%></option>
                                                <option <%=result.equals(UserAction.RESULT.FAIL.val) ? "selected='selected'" : ""%> value="<%=UserAction.RESULT.FAIL.val%>"><%=UserAction.RESULT.FAIL.val%></option>
                                                <option <%=result.equals(UserAction.RESULT.REJECT.val) ? "selected='selected'" : ""%> value="<%=UserAction.RESULT.REJECT.val%>"><%=UserAction.RESULT.REJECT.val%></option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="3">
                                            <input class="button" type="submit" name="btnsearch" value="Tìm kiếm"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>      
                        <!--End tim kiếm-->
                        <div align="center" style="height: auto;margin-bottom: 2px; color: red;font-weight: bold">
                            <%
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <%@include file="/admin/includes/page.jsp" %>
                        <!--Content-->
                        <form action="" name="mainForm" id="mainForm">
                            <table style="font-size: 11px" id="_dataTable" class="display" cellspacing="0" width="100%">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded">STT</th>
                                        <th scope="col" class="rounded">Username</th>
                                        <th scope="col" class="rounded">Table Action</th>
                                        <th scope="col" class="rounded">Type Action</th>
                                        <th scope="col" class="rounded">Result</th>
                                        <th scope="col" class="rounded">User IP</th>
                                        <!--<th scope="col" class="rounded">URL Action</th>-->
                                        <th scope="col" class="rounded">Action Date</th>
                                        <!--<th scope="col" class="rounded">Info</th>-->
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        int count = 1;
                                        for (Iterator<UserAction> iter = allUserAction.iterator(); iter.hasNext();) {
                                            UserAction one = iter.next();
                                            int tmp = (currentPage - 1) * maxRow + count++;
                                    %>
                                    <tr>
                                        <td class="boder_right"><%=tmp%></td>
                                        <td class="boder_right" align="left">
                                            <b>
                                                <a href="<%=request.getContextPath() + "/admin/account/userActionDetails.jsp?id=" + one.getId()%>">
                                                    <%=one.getUserName()%>
                                                </a>
                                            </b>
                                        </td>
                                        <td class="boder_right" align="left">
                                            <%=one.getTableAction()%>                                            
                                        </td>
                                        <td class="boder_right" align="left">
                                            <%=one.getActionType()%>         
                                        </td>
                                        <td class="boder_right" align="left">
                                            <%=one.getResult()%>         
                                        </td>
                                        <td class="boder_right" align="left">
                                            <%=one.getIp()%>         
                                        </td>
<!--                                        <td class="boder_right" align="left">
                                            <%//=one.getUrlAction()%>         
                                        </td>-->
                                        <td class="" align="left">
                                            <%=one.getActionDate()%>         
                                        </td>
<!--                                        <td class="" align="left">
                                            <%//=one.getInfo()%>         
                                        </td>-->
                                    </tr>
                                    <%}%>
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