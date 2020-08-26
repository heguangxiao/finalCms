<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.admin.AccountRole"%><%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.entity.PartnerManager"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%>
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
            function validForm() {
                var pn_code = $("#_cp_code  option:selected").val();
                if (isBlank(pn_code)) {
                    jAlert("Bạn chưa chọn một đại lý quản lý tài khoản này !");
                    return false;
                }
            }
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
                //----------Log--------------
                String account = Tool.validStringRequest(request.getParameter("name"));
                if (Tool.checkNull(account) || account.length() < 6) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.FAIL.val,
                                "Tên đăng nhập không được để trống và phải có ít nhất 6 ký tự!" +request);
                    log.logAction(request);
                    session.setAttribute("mess", "Tên đăng nhập không được để trống và phải có ít nhất 6 ký tự!");    
                    response.sendRedirect(request.getContextPath() + "/admin/customer/khle/edit.jsp?id="+id);
                    return;
                }
                
                if (Tool.stringIsSpace(account)) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.FAIL.val,
                                "Tên đăng nhập không được có dấu cách (space)!"+request);
                    log.logAction(request);
                    session.setAttribute("mess", "Tên đăng nhập không được có dấu cách (space)!");    
                    response.sendRedirect(request.getContextPath() + "/admin/customer/khle/edit.jsp?id="+id);
                    return;
                }
                
                if (!oneAdminEdit.getUserName().equals(account) && Account.existUsername(account)) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.FAIL.val,
                                "Tên đăng nhập đã tồn tại!"+request);
                    log.logAction(request);
                    session.setAttribute("mess", "Tên đăng nhập đã tồn tại!");    
                    response.sendRedirect(request.getContextPath() + "/admin/customer/khle/edit.jsp?id="+id);
                    return;
                }
                
                String pass = Tool.validStringRequest(request.getParameter("pass"));
                if (!Tool.checkNull(pass)) {
                    if (pass.length() < 8) {
                        UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.accounts.val,
                                    UserAction.TYPE.EDIT.val,
                                    UserAction.RESULT.FAIL.val,
                                    "Mật khẩu phải có ít nhất 8 ký tự!"+request);
                        log.logAction(request);
                        session.setAttribute("mess", "Mật khẩu không được để trống và phải có ít nhất 8 ký tự!");  
                        response.sendRedirect(request.getContextPath() + "/admin/customer/khle/edit.jsp?id="+id);
                        return;
                    }

                    if (Tool.stringIsSpace(pass)) {
                        UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.accounts.val,
                                    UserAction.TYPE.EDIT.val,
                                    UserAction.RESULT.FAIL.val,
                                    "Mật khẩu không được có dấu cách (space)!"+request);
                        log.logAction(request);
                        session.setAttribute("mess", "Mật khẩu không được có dấu cách (space)!");    
                        response.sendRedirect(request.getContextPath() + "/admin/customer/khle/edit.jsp?id="+id);
                        return;
                    }

                    if (!Tool.Password_Validation(pass)) {
                        UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.accounts.val,
                                    UserAction.TYPE.EDIT.val,
                                    UserAction.RESULT.FAIL.val,
                                    "Password phải có ít nhất 1 ký tự là số \"0123456789\" và 1 ký tự đặc biệt như \"!@#$%&*()_+=|<>?{}[]~-\"!" + request);
                        log.logAction(request);
                        session.setAttribute("mess", "Password phải có ít nhất 1 ký tự là số \"0123456789\" và 1 ký tự đặc biệt như \"!@#$%&*()_+=|<>?{}[]~-\"!");
                        response.sendRedirect(request.getContextPath() + "/admin/customer/khle/edit.jsp?id="+id);
                        return;
                    }
                }
                
                String fullname = Tool.validStringRequest(request.getParameter("fullname"));
                String phone = Tool.validStringRequest(request.getParameter("phone"));
                String email = Tool.validStringRequest(request.getParameter("email"));
                String ip_allow = "0";
                String mobiSend = "0";
                String desc = Tool.validStringRequest(request.getParameter("desc"));
                String address = Tool.validStringRequest(request.getParameter("address"));
                String url_dlr = Tool.validStringRequest(request.getParameter("url_dlr"));
                cpCode = RequestTool.getString(request, "cpCode");
                int totalsms = Tool.string2Integer(request.getParameter("totalsms"));
                int status = Tool.string2Integer(request.getParameter("status"));
                String phoneOtp = RequestTool.getString(request, "phoneOtp");
                boolean validOtp = RequestTool.getBoolean(request, "validOtp");
                boolean lockLogin = RequestTool.getBoolean(request, "lockLogin");

                AccountRole roleEdit = oneAdminEdit.getRole();
                roleEdit.setConfirmOTP(validOtp);
                roleEdit.setPhoneOtp(phoneOtp);
                roleEdit.setLockLogin(lockLogin);
                // -- Lay CP CODE CUA QUAN LY DAI LY
                oneAdminEdit.setUrl_dlr(url_dlr);
                oneAdminEdit.setUserName(account);
                if(!Tool.checkNull(pass)) {
                    oneAdminEdit.setPassWord(pass);
                }
                oneAdminEdit.setFullName(fullname);
                oneAdminEdit.setPhone(phone);
                oneAdminEdit.setEmail(email);
                oneAdminEdit.setMaxBrand(totalsms);
                oneAdminEdit.setIp_Allow(ip_allow);
                oneAdminEdit.setPhone_Send(mobiSend);
                oneAdminEdit.setDescription(desc);
                oneAdminEdit.setAddress(address);
                oneAdminEdit.setUpdateBy(userlogin.getUserName());
                oneAdminEdit.setStatus(status);
                oneAdminEdit.setCpCode(cpCode);
                oneAdminEdit.setRole(roleEdit);
                if (admDao.update2(oneAdminEdit)) {
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.SUCCESS.val,
                                "Sửa tài khoản thành công!" + request);
                log.logAction(request);
                    session.setAttribute("mess", "Sửa tài khoản thành công");
                    response.sendRedirect(request.getContextPath() + "/admin/customer/khle/index.jsp");
                    return;
                } else {
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.FAIL.val,
                                "Sửa tài khoản lỗi!" + request);
                log.logAction(request);
                    session.setAttribute("mess", "Sửa tài khoản lỗi");
                }
            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <div align="center" style="height: 20px;margin-bottom: 2px; color: red;font-weight: bold">
                            <%if (session.getAttribute("mess") != null) {
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
                                        <th colspan="2" style="font-weight: bold"  scope="col" class="rounded redBoldUp">
                                            Cập nhật thông tin khách hàng lẻ</th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr><td></td>
                                        <td>Đại Lý:</td>
                                        <td colspan="3">
                                            <%
                                                ArrayList<PartnerManager> allCp = PartnerManager.getAllCache();
                                                if (allCp != null && !allCp.isEmpty()) {
                                            %>
                                            <select style="width: 420px" id="_cp_code" name="cpCode" disabled="true">
                                                <option value="">******** Tất cả ********</option>
                                                <%
                                                    for (PartnerManager onePartner : allCp) {
                                                        if (!Tool.checkNull(onePartner.getCode())) {
                                                %>
                                                <option
                                                    value="<%=onePartner.getCode()%>" <%=onePartner.getCode().equals(cpCode) ? "selected=selected" : ""%>
                                                    img-data="<%=(onePartner.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>" >[<%=onePartner.getCode()%>] <%=onePartner.getName()%></option>
                                                <%}
                                                        }
                                                    }
                                                %>
                                            </select>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            Total Message
                                            <input readonly size="10" value="<%=oneAdminEdit.getMaxBrand() %>" type="text" name="totalsms"/>
                                            &nbsp;&nbsp;&nbsp;<b class="redBold">-99: Không gới hạn</b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            URL DeLivery Report:
                                        </td>
                                        <td colspan="5">
                                            <input id="url_dlr" size="30" value="<%=oneAdminEdit.getUrl_dlr() == null ? "" : oneAdminEdit.getUrl_dlr()%>" type="text" name="url_dlr"/>      
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">Tên đăng nhập: </td>
                                        <td colspan="3">
                                            <input readonly size="20" value="<%=oneAdminEdit.getUserName()%>" type="text" name="name"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            Mật khẩu đăng nhập:
                                            <input autocomplete="off" size="20" type="password" name="pass"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>Tên khách hàng:</td>
                                        <td colspan="3">
                                            <input size="33" type="text" value="<%=oneAdminEdit.getFullName()%>" name="fullname"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            Mobile:
                                            <input size="20" value="<%=oneAdminEdit.getPhone()%>" type="text" name="phone"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            Email: 
                                            <input size="25" value="<%=oneAdminEdit.getEmail()%>" type="text" name="email"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">Mô tả </td>
                                        <td>
                                            <textarea cols="40" name="desc"><%=oneAdminEdit.getDescription()%></textarea>
                                        </td>
                                        <td align="left">Address:</td>
                                        <td><textarea id="add_address" cols="40" name="address"><%=oneAdminEdit.getAddress()%></textarea></td>
                                    </tr>
                                    <tr>
                                        <td align="left"></td>
                                        <td align="left">Trạng thái API: </td>
                                        <td colspan="3">
                                            <select name="status">
                                                <option <%=oneAdminEdit.getStatus() == 1 ? "selected='selected'" : ""%> value="1">Kích hoạt</option>
                                                <option <%=oneAdminEdit.getStatus() == 0 ? "selected='selected'" : ""%> value="0">Khóa</option>
                                                <option <%=oneAdminEdit.getStatus() == 404 ? "selected='selected'" : ""%> value="404">Đã xoá</option>
                                            </select>
                                            &nbsp;<% AccountRole roleOld = oneAdminEdit.getRole();%>
                                            OTP gửi tin: 
                                            <input value="<%=roleOld.isConfirmOTP() ? "1" : "0"%>" <%=roleOld.isConfirmOTP() ? "checked='checked'" : ""%> size="30" name="validOtp" id="validOtp" type="checkbox" onclick="checkBoxClick(this)" />
                                            &nbsp;&nbsp;
                                            Số nhận OTP: 
                                            <input value="<%=Tool.checkNull(roleOld.getPhoneOtp())?"":roleOld.getPhoneOtp() %>" size="30" name="phoneOtp" <%=Tool.checkNull(roleOld.getPhoneOtp()) ? "" : "readonly='readonly'"%> id="phoneOtp" type="text"/>
                                            &nbsp;&nbsp;
                                            Khóa đăng nhập: 
                                            <input  onclick="checkBoxClick(this);" value="<%=roleOld.isLockLogin() ? "1" : "0"%>" name="lockLogin" <%=roleOld.isLockLogin() ? "checked='checked'" : ""%> id="lockLogin" type="checkbox"/>
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