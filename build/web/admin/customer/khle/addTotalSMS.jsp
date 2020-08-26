<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.admin.AccountRole"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.PartnerManager"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <%@include file="/admin/includes/header.jsp" %>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/admin/resource/css/jquery-ui-1.8.16.custom.css">
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.core.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.position.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.widget.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.autocomplete.min.js"></script>
        <script type ='text/javascript'>
            $(document).ready(function () {
                $("#_cp_code").select2({
                    formatResult: function (item) {
                        var valOpt = $(item.element).attr('img-data');
                        if (!valOpt) {
                            return ('<div><b>' + item.text + '</b></div>');
                        } else {
                            return ('<div><span><b style="color: red">' + item.text + '<b> <img src="' + valOpt + '" class="img-flag" /></span></div>');
                        }
                    },
                    formatSelection: function (item) {
                        //  load page or selected
                        var opt = $("#_cp_code option:selected");
                        var valOpt = opt.attr("img-data");
                        if (!valOpt) {
                            return ('<b>' + item.text + '</b>');
                        } else {
                            return ('<div><span><b style="color: red">' + item.text + '</b> <img src="' + valOpt + '" class="img-flag" /></span></div>');
                        }
                    },
                    dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
                    escapeMarkup: function (m) {
                        return m;
                    }
                });
            });
        </script>
    </head>
    <body>
        <%
            if (!userlogin.checkEdit(request)) {
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.REJECT.val,
                                "Permit deny!" + request);
                log.logAction(request);
                session.setAttribute("mess", "Bạn không có quyền thêm module này!");
                response.sendRedirect(request.getContextPath() + "/admin/customer/khle/index.jsp");
                return;
            }
            
            int id = Tool.string2Integer(request.getParameter("id"));
            Account admDao = new Account();
            Account oneAdminEdit = null;
            oneAdminEdit = admDao.getByID(id);
            
            if (oneAdminEdit == null) {
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.REJECT.val,
                                "Yêu cầu không hợp lệ. Không tìm được thông tin tài khoản!" + request);
                log.logAction(request);
                session.setAttribute("mess", "Yêu cầu không hợp lệ. Không tìm được thông tin tài khoản!");
                response.sendRedirect(request.getContextPath() + "/admin/customer/khle/index.jsp");
                return;
            }
            
            String cpCode = oneAdminEdit.getCpCode();
            
            if (request.getParameter("submit") != null) {
                
                int totalsms = Tool.string2Integer(request.getParameter("totalsms"));
                int addtotalsms = Tool.string2Integer(request.getParameter("addtotalsms"));
                
                oneAdminEdit.setMaxBrand(totalsms+addtotalsms);
                
                if (admDao.update(oneAdminEdit)) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.accounts.val,
                                    UserAction.TYPE.EDIT.val,
                                    UserAction.RESULT.SUCCESS.val,
                                    "Thêm quata thành công!" + request);
                    log.logAction(request);
                    session.setAttribute("mess", "Thêm quata thành công");
                } else {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.accounts.val,
                                    UserAction.TYPE.EDIT.val,
                                    UserAction.RESULT.FAIL.val,
                                    "Thêm quata lỗi!" + request);
                    log.logAction(request);
                    session.setAttribute("mess", "Thêm quata lỗi");
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/customer/khle/index.jsp");
                return;
            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <div align="center" style="height: 20px;margin-bottom: 2px; color: red;font-weight: bold">
                            <%
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }%>
                        </div>
                        <form onsubmit="return validForm();" action="" method="post">
                            <table align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th colspan="2" style="font-weight: bold" scope="col">
                                            Thêm quata cho khách hàng lẻ " <%=oneAdminEdit.getUserName()%> "</th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td>
                                            Total Message
                                        </td>
                                        <td colspan="3">
                                            <input readonly size="10" value="<%=oneAdminEdit.getMaxBrand() %>" type="number" name="totalsms"/>
                                            &nbsp;&nbsp;&nbsp;<b class="redBold">-99: Không giới hạn</b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            Thêm
                                        </td>
                                        <td colspan="3">
                                            <input <%=oneAdminEdit.getMaxBrand() == -99 ? "readonly" : ""%> size="10" value="0" type="number" name="addtotalsms"/>
                                            &nbsp;&nbsp;&nbsp;<b class="redBold"><%=oneAdminEdit.getMaxBrand() == -99 ? "Không giới hạn thì cộng làm gì ?" : ""%></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="5" align="center">
                                            <input class="button" type="submit" name="submit" value="Cập nhật"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/customer/khle/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>

                                        </td>
                                    </tr>
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