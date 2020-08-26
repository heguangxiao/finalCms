<%@page import="com.sun.corba.se.spi.oa.OADefault"%>
<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.admin.AccountRole"%><%@page import="gk.myname.vn.entity.PartnerManager"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%><%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
            if (!userlogin.checkAdd(request)) {
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.ADD.val,
                                UserAction.RESULT.REJECT.val,
                                "Permit deny!  /admin/customer/agency/index.jsp  ");
                log.logAction(request);
                session.setAttribute("mess", "Bạn không có quyền thêm module này!");
                response.sendRedirect(request.getContextPath() + "/admin/customer/agency/index.jsp");
                return;
            }
            RequestTool.debugParam(request);
            String cpCode = Tool.validStringRequest(request.getParameter("cpCode"));
            PartnerManager partner = PartnerManager.getCacheByCode(cpCode);
                        
            if (partner == null) {
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.ADD.val,
                                UserAction.RESULT.REJECT.val,
                                "Not find by cpCode! /admin/customer/agency/add.jsp");
                log.logAction(request);
                session.setAttribute("mess", "Yêu cầu không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/admin/partner-manager/");
                return;
            }
            
            if (partner != null && partner.hasChild()) {
                if (Account.checkUserByCpCode(cpCode)) {
                    // Tai khoan Quan ly Dai ly Da co TK
                    UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.accounts.val,
                                    UserAction.TYPE.ADD.val,
                                    UserAction.RESULT.FAIL.val,
                                    "Đã có tài khoản quản lý của Đại lý này (Chỉ được tạo 1 TK cấp quản lý)");
                    log.logAction(request);
                    session.setAttribute("mess", "Đã có tài khoản quản lý của Đại lý này (Chỉ được tạo 1 TK cấp quản lý)");
                    response.sendRedirect(request.getContextPath() + "/admin/partner-manager/");
                    return;
                }
            }
            if (request.getParameter("submit") != null) {
                //---------------------------
                String account = Tool.validStringRequest(request.getParameter("name"));
                if (Tool.checkNull(account) || account.length() < 6) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.ADD.val,
                                UserAction.RESULT.FAIL.val,
                                "Tên đăng nhập không được để trống và phải có ít nhất 6 ký tự!" +request);
                    log.logAction(request);
                    session.setAttribute("mess", "Tên đăng nhập không được để trống và phải có ít nhất 6 ký tự!");    
                    response.sendRedirect(request.getContextPath() + "/admin/customer/agency/add.jsp?cpCode="+cpCode);
                    return;
                }
                
                if (Tool.stringIsSpace(account)) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.ADD.val,
                                UserAction.RESULT.FAIL.val,
                                "Tên đăng nhập không được có dấu cách (space)!"+request);
                    log.logAction(request);
                    session.setAttribute("mess", "Tên đăng nhập không được có dấu cách (space)!");    
                    response.sendRedirect(request.getContextPath() + "/admin/customer/agency/add.jsp?cpCode="+cpCode);
                    return;
                }
                
                if (Account.existUsername(account)) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.ADD.val,
                                UserAction.RESULT.FAIL.val,
                                "Tên đăng nhập đã tồn tại!"+request);
                    log.logAction(request);
                    session.setAttribute("mess", "Tên đăng nhập đã tồn tại!");    
                    response.sendRedirect(request.getContextPath() + "/admin/customer/agency/add.jsp?cpCode="+cpCode);
                    return;
                }
                
                String fullname = Tool.validStringRequest(request.getParameter("fullname"));
                String pass_send = Tool.validStringRequest(request.getParameter("pass_send"));
                if(Tool.checkNull(pass_send)) pass_send =Tool.getRandomString(18);
                String pass = Tool.validStringRequest(request.getParameter("pass"));
                
                if (Tool.checkNull(pass) || pass.length() < 8) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.ADD.val,
                                UserAction.RESULT.FAIL.val,
                                "Mật khẩu không được để trống và phải có ít nhất 8 ký tự!"+request);
                    log.logAction(request);
                    session.setAttribute("mess", "Mật khẩu không được để trống và phải có ít nhất 8 ký tự!");  
                    response.sendRedirect(request.getContextPath() + "/admin/customer/agency/add.jsp?cpCode="+cpCode);
                    return;
                }
                
                if (Tool.stringIsSpace(pass)) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.ADD.val,
                                UserAction.RESULT.FAIL.val,
                                "Mật khẩu không được có dấu cách (space)!"+request);
                    log.logAction(request);
                    session.setAttribute("mess", "Mật khẩu không được có dấu cách (space)!");    
                    response.sendRedirect(request.getContextPath() + "/admin/customer/agency/add.jsp?cpCode="+cpCode);
                    return;
                }
                
                if (!Tool.Password_Validation(pass)) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.ADD.val,
                                UserAction.RESULT.FAIL.val,
                                "Password phải có ít nhất 1 ký tự là số \"0123456789\" và 1 ký tự đặc biệt như \"!@#$%&*()_+=|<>?{}[]~-\"!" + request);
                    log.logAction(request);
                    session.setAttribute("mess", "Password phải có ít nhất 1 ký tự là số \"0123456789\" và 1 ký tự đặc biệt như \"!@#$%&*()_+=|<>?{}[]~-\"!");
                    response.sendRedirect(request.getContextPath() + "/admin/customer/agency/add.jsp?cpCode="+cpCode);
                    return;
                }
                
                String phone = Tool.validStringRequest(request.getParameter("phone"));
                String email = Tool.validStringRequest(request.getParameter("email"));
                String ip_allow = Tool.validStringRequest(request.getParameter("ip_allow"));
                String mobiSend = Tool.validStringRequest(request.getParameter("mobiSend"));
                String desc = Tool.validStringRequest(request.getParameter("desc"));
                String address = Tool.validStringRequest(request.getParameter("address"));
                String url_dlr = Tool.validStringRequest(request.getParameter("url_dlr"));

                String addRessRange = Tool.validStringRequest(request.getParameter("addRessRange"));
                String method = Tool.validStringRequest(request.getParameter("method"));
                int totalsms = Tool.string2Integer(request.getParameter("totalsms"));
                int status = Tool.string2Integer(request.getParameter("status"));
                int tps = Tool.string2Integer(request.getParameter("tps"));
                int parentId = Tool.string2Integer(request.getParameter("parentId"));
                int userType = Tool.string2Integer(request.getParameter("user_type"), Account.TYPE.AGENCY.val);
                boolean createAgentcy = Tool.getBoolean(request.getParameter("createAgentcy"));
                boolean createSubAcc = Tool.getBoolean(request.getParameter("createSubAcc"));
                AccountRole roleAdd = new AccountRole();
                roleAdd.setCreateAgentcy(createAgentcy);
                roleAdd.setCreateSubAcc(createSubAcc);
                //---
                Account oneAdmin = new Account();
                oneAdmin.setUrl_dlr(url_dlr);
                oneAdmin.setParentId(parentId);
                oneAdmin.setUserName(account);
                oneAdmin.setPassWord(pass);
                oneAdmin.setPassSend(pass_send);
                oneAdmin.setFullName(fullname);
                oneAdmin.setPhone(phone);
                oneAdmin.setEmail(email);
                oneAdmin.setMaxBrand(totalsms);
                oneAdmin.setIp_Allow(ip_allow);
                oneAdmin.setPhone_Send(mobiSend);
                oneAdmin.setDescription(desc);
                oneAdmin.setAddress(address);
                oneAdmin.setUserType(userType);
                oneAdmin.setCreateBy(userlogin.getUserName());
                oneAdmin.setUpdateBy(userlogin.getUserName());
                oneAdmin.setStatus(status);
                oneAdmin.setCpCode(cpCode);
                oneAdmin.setAddressRange(addRessRange);
                oneAdmin.setMethod(method);
                oneAdmin.setTps(tps);
                oneAdmin.setRole(roleAdd);
                //------------
                Account admDao = new Account();
                if (admDao.addNew2(oneAdmin)) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.accounts.val,
                                    UserAction.TYPE.ADD.val,
                                    UserAction.RESULT.SUCCESS.val,
                                    "Thêm mới tài khoản thành công /admin/customer/agency/index.jsp ");
                    log.logAction(request);
                    session.setAttribute("mess", "Thêm mới tài khoản thành công!");
                } else {
                    UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.accounts.val,
                                    UserAction.TYPE.ADD.val,
                                    UserAction.RESULT.FAIL.val,
                                    "Thêm mới dữ liệu lỗi /admin/customer/agency/index.jsp ");
                    log.logAction(request);
                    session.setAttribute("mess", "Thêm mới dữ liệu lỗi!");
                }
                response.sendRedirect(request.getContextPath() + "/admin/customer/agency/index.jsp");
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
                            <%if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }%>
                        </div>
                        <form action="" method="post">
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th colspan="4" style="font-weight: bold" scope="col" class="rounded redBoldUp">
                                            Cấp Account Cho Đại Lý Hoặc Quản Lý Đại Lý
                                        </th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td>Đại Lý:</td>
                                        <td colspan="5">
                                            <%
                                                ArrayList<PartnerManager> allCp = PartnerManager.getAllCache();
                                                PartnerManager parner = null;
                                                if (allCp != null && !allCp.isEmpty()) {
                                            %>
                                            <select disabled style="width: 320px" id="_cp_code" name="cpCode">
                                                <option value="">******** Tất cả ********</option>
                                                <%
                                                    for (PartnerManager onePartner : allCp) {
                                                        if (!Tool.checkNull(onePartner.getCode())) {
                                                            if(onePartner.getCode().equals(cpCode)) parner=onePartner;
                                                %>
                                                <option
                                                    value="<%=onePartner.getCode()%>" <%=onePartner.getCode().equals(cpCode) ? "selected=selected" : ""%>
                                                    img-data="<%=(onePartner.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>" >[<%=onePartner.getCode()%>] <%=onePartner.getName()%></option>
                                                <%}
                                                        }
                                                    }
                                                    if(parner==null){
                                                        session.setAttribute("mess", "Tài khoản đại lý phải thuộc 1 Partner nhất định!");
                                                        response.sendRedirect(request.getContextPath()+"/admin/partner-manager/");}
                                                %>
                                            </select>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            TPS
                                            <input id="add_tps" size="7" value="50" type="text" name="tps"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            Giao Thức kết nối: 
                                            <select name="method">
                                                <option value="HTTP">HTTP</option>
                                                <option value="SMPP">SMPP</option>
                                                <option value="SOAP">SOAP</option>
                                            </select>                                      
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            URL DeLivery Report:
                                        </td>
                                        <td colspan="5">
                                            <input id="url_dlr" size="30" value="" type="text" name="url_dlr"/>      
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">User: </td>
                                        <td colspan="5">
                                            <input id="add_name" autocomplete="off" size="12" type="text" name="name"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            MK đăng nhập:
                                            <input id="add_pass" autocomplete="off" size="12" type="password" name="pass"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            MK TK Gửi Brand <span class="redBoldUp">(Cấp cho CP):</span>
                                            <input autocomplete="off" size="20" type="password" name="pass_send"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>Tên tài khoản:</td>
                                        <td colspan="2"><input size="47" type="text" value="<%=parner.getName() %>" name="fullname"/></td>
                                        <td class="redBoldUp" align="left">Loại tài khoản: </td>
                                        <td colspan="2">
                                            <select style="width: 146px" id="add_status" name="user_type">
                                                <%
                                                    if (partner != null && partner.hasChild()) {
                                                %>
                                                <option value="<%=Account.TYPE.AGENCY_MANAGER.val%>">Quản lý Đại lý</option>
                                                <option value="<%=Account.TYPE.AGENCY.val%>">Đại lý</option>
                                                <%
                                                } else {
                                                %>
                                                <option value="<%=Account.TYPE.AGENCY.val%>">Đại lý</option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td></td>
                                        <td align="left">Mobile:</td>
                                        <td colspan="2">
                                            <input id="add_phone" value="<%=parner.getPhone()%>" size="12" type="text" name="phone"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            Email:
                                            <input id="add_email" size="20" type="text" value="<%=parner.getEmail()%>" name="email"/>
                                        </td>
                                        <td align="left">ADDRESS RANGE:</td>
                                        <td colspan="2"><input id="add_addRessRange" size="30" type="text" name="addRessRange"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">IP Allow</td>
                                        <td colspan="2">
                                            <textarea cols="40" name="ip_allow"></textarea>
                                        </td>
                                        <td align="left">Mô tả: </td>
                                        <td colspan="3"><textarea id="add_desc" cols="40" name="desc"></textarea></td>
                                    </tr>
                                    <!--                                    <tr>
                                                                            <td></td>
                                                                            <td align="left">Số điện thoại gửi tin</td>
                                                                            <td colspan="5">
                                                                                <textarea cols="57" name="mobiSend"></textarea>
                                                                            </td>
                                                                        </tr>-->
                                    <!--                                    <tr>
                                                                            <td></td>
                                                                            <td align="left">Address: </td>
                                                                            <td colspan="5"><textarea id="add_address" cols="57" name="address"></textarea></td>
                                                                        </tr>                                     -->
                                    <tr>
                                        <td></td>
                                        <td align="left">Trạng thái: </td>
                                        <td colspan="5">
                                            <select id="add_status" name="status">
                                                <option value="1">Kích hoạt</option>
                                                <option value="0">Khóa</option>
                                            </select>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            Total Message
                                            <input size="10" value="-99" type="text" name="totalsms"/>
                                            &nbsp;&nbsp;&nbsp;<b class="redBold">-99: Không gới hạn</b>
                                            <% if (partner.hasChild()) { %>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            Create Agentcy: <input onclick="checkBoxClick(this);" type="checkbox" name="createAgentcy" value="0"/>
                                            &nbsp;&nbsp;&nbsp;
                                            Create SubAcc: <input onclick="checkBoxClick(this);" type="checkbox" name="createSubAcc" value="0"/>
                                            <%} else {
                                            %>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            Create SubAcc: <input onclick="checkBoxClick(this);" type="checkbox" name="createSubAcc" value="0"/>
                                            <%
                                                }%>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="7" align="center">
                                            <input class="button" type="submit" name="submit" value="Thêm mới"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/customer/agency/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
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