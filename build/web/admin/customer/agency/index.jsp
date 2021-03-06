<%@page import="gk.myname.vn.entity.PartnerManager"%>
<%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "Quản lý tài khoản đại lý"); %>
        <%@include file="/admin/includes/header.jsp" %>
    </head>
    <body>
        <%            
            if (!userlogin.checkView(request)) {
                session.setAttribute("mess", "Bạn không có quyền truy cập module này!");
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }
            String key = RequestTool.getString(request, "key");
            String partner = RequestTool.getString(request, "partner");
            int status = RequestTool.getInt(request, "status", -2);
            ArrayList all = null;
            Account dao = new Account();
            int currentPage = Tool.string2Integer(request.getParameter("page"), 1);
            if (currentPage < 1) {
                currentPage = 1;
            }
            maxRow = 20;
            int totalPage = 0;
            int totalRow = dao.countAllAgentcy2(key, status, partner);
            totalPage = (int) totalRow / maxRow;
            if (totalRow % maxRow != 0) {
                totalPage++;
            }
            all = dao.getAllAgentcy2(currentPage, maxRow, key, status, partner);
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <form action="<%=request.getContextPath() + "/admin/customer/agency/index.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"><b>Tìm kiếm tài khoản đại lý</b></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Đại lý</td>
                                        <td>
                                            <select class="select3" style="width: 423px" id="partner" name="partner">
                                                <option value="">Tất cả</option>
                                                <%
                                                    ArrayList<PartnerManager> list = PartnerManager.getAll();
                                                    for (PartnerManager one : list) {
                                                %>
                                                <option <%=partner.equals(one.getCode()) ? "selected='selected'" : ""%> value="<%=one.getCode()%>">[<%=one.getCode()%>] <%=one.getName()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Từ khoá</td>
                                        <td>
                                            <input type="text" name="key" size="55"/>
                                            &nbsp;&nbsp;
                                            <span class="redBold">Trạng Thái</span>
                                            <select name="status">
                                                <option <%=status == -2 ? "selected='selected'" : ""%> value="-2">Tất cả</option>
                                                <option <%=status == 1 ? "selected='selected'" : ""%> value="1">Kích Hoạt</option>
                                                <option <%=status == 0 ? "selected='selected'" : ""%> value="0">Khóa</option>
                                                <option <%=status == 404 ? "selected='selected'" : ""%> value="404">Xóa</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="3">
                                            <input class="button" type="submit" name="submit" value="Tìm kiếm"/>
                                            &nbsp;&nbsp;
                                            &nbsp;&nbsp;
                                            <input onclick="addNew()" class="button" type="button" name="button" value="Thêm mới"/>
                                            <span id="showError" class="redBoldUp"></span>
                                            <script>
                                                function addNew() {
                                                    var urlOrg = $(location).attr('origin');
                                                    var uri = $(location).attr('pathname');
                                                    var arrUri = uri.split('/');
                                                    //Lấy Context path
                                                    var conTextPath = arrUri[1];
                                                    
                                                    var cpCode = document.getElementById('partner').value;
                                                    
                                                    var urlExportDS = urlOrg + "/" + conTextPath + "/admin/customer/agency/add.jsp?cpCode="+cpCode;
                                                    if (cpCode === '') {
                                                        document.getElementById('showError').innerHTML = 'Chọn đại lý trước khi thêm mới';
                                                    } else {
                                                        document.getElementById('showError').innerHTML = '';
                                                        window.location.replace(urlExportDS);
                                                    }
                                                }
                                            </script>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>      
                        <!--End tim kiếm-->
                        <div align="center" style="height: 20px;margin-bottom: 2px; color: red;font-weight: bold">
                            <%                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <!--Content-->
                        <%@include file="/admin/includes/page.jsp" %>
                        <table align="center" id="rounded-corner" summary="Msc Joint Stock Company" >
                            <thead>
                                <tr>
                                    <th scope="col" class="rounded-company">STT</th>
                                    <th scope="col" class="rounded">CP_CODE</th>
                                    <th scope="col" class="rounded">User</th>
                                    <th scope="col" class="rounded">Tên công ty</th>
                                    <!--<th scope="col" class="rounded">Điện thoại</th>-->
                                    <!--<th scope="col" class="rounded">Email</th>-->
                                    <th scope="col" class="rounded">IP Allow</th>
                                    <th scope="col" class="rounded">ADD RANGE</th>
                                    <!--<th scope="col" class="rounded">METHOD</th>-->
                                    <th scope="col" class="rounded">TPS</th>
                                    <th scope="col" class="rounded">User Type</th>
                                    <th scope="col" class="rounded">Quata</th>
                                    <th scope="col" class="rounded">Trạng thái Login</th>
                                    <th scope="col" class="rounded">Trạng thái API</th>
                                        <%=buildHeader(request, userlogin, true, true)%>
                                </tr>
                            </thead>
                            <tbody>
                                <%                                    int count = 1; //Bien dung de dem so dong
                                    for (Iterator<Account> iter = all.iterator(); iter.hasNext();) {
                                        Account oneAdmin = iter.next();
                                        int index = (currentPage - 1) * maxRow + count++;
                                %>
                                <tr>
                                    <td class="boder_right"><%=index%></td>
                                    <td align="left" class="boder_right redBoldUp"><%=oneAdmin.getCpCode()%></td>
                                    <td align="left" class="boder_right"><%=oneAdmin.getUserName()%></td>
                                    <td align="left" class="boder_right"><%= oneAdmin.getFullName()%></td>
                                    <!--                                    <td align="center" class="boder_right">
                                    <%//=oneAdmin.getPhone()%>
                                </td>-->
                                    <!--<td class="boder_right"><%=Tool.checkNull(oneAdmin.getEmail()) ? "" : oneAdmin.getEmail().replaceAll(",", "<br/>")%></td>-->
                                    <td class="boder_right"><%=Tool.checkNull(oneAdmin.getIp_Allow()) ? "" : oneAdmin.getIp_Allow().replaceAll(",", "<br/>")%></td>
                                    <td class="boder_right"><%=!Tool.checkNull(oneAdmin.getAddressRange()) ? oneAdmin.getAddressRange().replaceAll(",", "<br/>") : ""%></td>
                                    <!--<td class="boder_right"><%=oneAdmin.getMethod()%></td>-->
                                    <td class="boder_right"><%=oneAdmin.getTps()%></td>
                                    <td class="boder_right"><%=Account.getTypeName(oneAdmin.getUserType())%></td>
                                    <td class="boder_right"><%=oneAdmin.getMaxBrand()%></td>
                                    <td align="center" class="boder_right">
                                        <%if (!oneAdmin.getRole().isLockLogin()) {%>
                                        <img width="24" src="<%= request.getContextPath()%>/admin/resource/images/active.png"/>
                                        <%} else {%>
                                        <img width="24" src="<%= request.getContextPath()%>/admin/resource/images/key_lock.png"/>
                                        <%}%>
                                    </td>
                                    <td align="center" class="boder_right">
                                        <%if (oneAdmin.getStatus() == 1) {%>
                                        <img src="<%= request.getContextPath()%>/admin/resource/images/active.png"/>
                                        <%} else if (oneAdmin.getStatus() == 404) {%>
                                        <img src="<%= request.getContextPath()%>/admin/resource/images/remove.png"/>
                                        <%} else {%>
                                        <img width="24" src="<%= request.getContextPath()%>/admin/resource/images/key_lock.png"/>
                                        <%}%>
                                    </td>
                                    <%=buildControl(request, userlogin,
                                            "/admin/customer/agency/edit.jsp?id=" + oneAdmin.getAccID(),
                                            (oneAdmin.getStatus() == 404) ? "/admin/customer/agency/del__ever.jsp?id=" + oneAdmin.getAccID() : "/admin/customer/agency/del.jsp?id=" + oneAdmin.getAccID()
                                    )%>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div><!-- end of right content-->
                </div>   <!--end of center content -->
                <div class="clear"></div>
            </div> <!--end of main content-->
            <%@include file="/admin/includes/footer.jsp" %>
        </div>
    </body>
</html>