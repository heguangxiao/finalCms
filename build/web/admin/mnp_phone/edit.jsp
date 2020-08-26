<%@page import="java.sql.Array"%>
<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="gk.myname.vn.entity.MnpPhone"%>
<%@page import="gk.myname.vn.entity.Groups_Providers"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="gk.myname.vn.entity.GroupProvider"%>
<%@page import="gk.myname.vn.entity.Provider"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.PhoneBlackList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page contentType="text/html; charset=utf-8" %>
<html>
    <head><%@include file="/admin/includes/header.jsp" %></head>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/admin/resource/select2/select2.css" />
    <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2_locale_vi.js"></script>
    <script type="text/javascript" language="javascript">
        //------
       $(document).ready(function () {
            $("#opermnp").select2({
                formatResult: function (item) {
                    return ('<div>' + item.text + '</div>');
                },
                formatSelection: function (item) {
                    return (item.text);
                },
                dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
                escapeMarkup: function (m) {
                    return m;
                }
            });
            $("#operorg").select2({
                formatResult: function (item) {
                    return ('<div>' + item.text + '</div>');
                },
                formatSelection: function (item) {
                    return (item.text);
                },
                dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
                escapeMarkup: function (m) {
                    return m;
                }
            });
        });
    </script>
    <body>
        <%            //--
            if (!userlogin.checkAdd(request)) {
                UserAction log = new UserAction(userlogin.getUserName(),
                        "mnp_phones",
                        UserAction.TYPE.EDIT.val,
                        UserAction.RESULT.FAIL.val,
                        "Bạn không có quyền truy cập trang này!");
                log.logAction(request);
                session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            int id = RequestTool.getInt(request, "id");
            
            MnpPhone dao = new MnpPhone();
            String message = "";
            if (id <= 0) {
                UserAction log = new UserAction(userlogin.getUserName(),
                        "mnp_phones",
                        UserAction.TYPE.EDIT.val,
                        UserAction.RESULT.FAIL.val,
                        "Nội dung tìm kiếm không tồn tại!");
                log.logAction(request);
                session.setAttribute("mess", "Nội dung bạn tìm kiếm không tồn tại ! ");
                response.sendRedirect(request.getContextPath() + "/admin/mnp_phone/");
                return;
            }
            ArrayList<MnpPhone> arrayList = dao.getAll();
            String checkPhone = "";
            MnpPhone mnpPhone = dao.findById(id);
            
            for (MnpPhone elem : arrayList) {
                    if (!elem.getPhone().equals(mnpPhone.getPhone())) {
                        checkPhone += elem.getPhone() + ",";
                    }
                }
            if (request.getParameter("submit") != null) {
                
                String phone = RequestTool.getString(request, "phone");
                                
                if (checkPhone.contains(phone)) {                    
                    message += "Số này đã tồn tại, vui lòng tìm kiếm để chỉnh sửa <br/> "; 
                    UserAction log = new UserAction(userlogin.getUserName(),
                        "mnp_phones",
                        UserAction.TYPE.ADD.val,
                        UserAction.RESULT.FAIL.val,
                        "Số " + phone + " đã tồn tại, vui lòng tìm kiếm để chỉnh sửa!");
                    log.logAction(request);
                } else {
                    String opermnp = RequestTool.getString(request, "opermnp");
                    String operorg = RequestTool.getString(request, "operorg");
                    if (Tool.checkNull(opermnp) || Tool.checkNull(operorg)) {
                        message += "Bạn phải nhập đầy đủ thông tin để thêm mới <br/> "; 
                        UserAction log = new UserAction(userlogin.getUserName(),
                            "mnp_phones",
                            UserAction.TYPE.ADD.val,
                            UserAction.RESULT.FAIL.val,
                            "Nhập thông tin không đầy đủ!");
                        log.logAction(request);
                    } else {
                        String sources = RequestTool.getString(request, "sources");

                        
                        phone = phone.replaceAll("o", "0");
                        phone = phone.replaceAll("\\+", "");
                        if (!phone.startsWith("+")) {
                            if(phone.startsWith("0")) {
                                phone = phone.substring(1,phone.length());
                            }
                            if(phone.startsWith("84")) {
                                phone = "+" + phone;
                            }else{
                                phone = "+84" + phone;
                            }
                        }
                        
                        mnpPhone.setPhone(phone);
                        mnpPhone.setOperMnp(opermnp);
                        mnpPhone.setOperOrg(operorg);
                        mnpPhone.setSources(sources);

                        if (dao.edit(mnpPhone)) {                    
                            message += "Sửa thông tin thành công <br/>";  
                            UserAction log = new UserAction(userlogin.getUserName(),
                                "mnp_phones",
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.SUCCESS.val,
                                "Thêm số "+phone+" thành công!");
                            log.logAction(request);
                        } else {
                            message += "Sửa thông tin không thành công <br/>"; 
                            UserAction log = new UserAction(userlogin.getUserName(),
                                "mnp_phones",
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.FAIL.val,
                                "Thêm số "+phone+" không thành công!");
                            log.logAction(request);
                        }
                    }   
                }     
                session.setAttribute("mess", message);
                response.sendRedirect(request.getContextPath() + "/admin/mnp_phone/index.jsp");
                return;    
            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <div id="messError" align="center" style="margin-bottom: 2px; color: red;font-weight: bold">
                            <%                    
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <form action="" method="post">
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Sửa thông tin số mnp</th>                                        
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Số điện thoại : </td>
                                        <td colspan="2">
                                            <input size="30" type="text" id="phoneInput" name="phone" value="<%=mnpPhone.getPhone()%>"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>                                        
                                        <td></td>
                                        <td style="color: red">*Nhập số điện thoại theo ví dụ : </td>
                                        <td style="color: red">VD 1: 0975034483. VD 2: 84975034483</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Nhà mạng ban đầu :</td>
                                        <td colspan="5">
                                            <select onchange="changeTelco(this.value)" style="width: 250px" name="operorg" id="operorg">
                                                <option value="">***** Chọn nhà mạng *****</option>
                                                <%
                                                    ArrayList<Telco_Nations> allpro1 = Telco_Nations.getTelco_na();
                                                    for (Telco_Nations one : allpro1) {
                                                %>
                                                <option
                                                    <%=one.getTelco_code().equals(mnpPhone.getOperOrg()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getTelco_code()%>">
                                                    [<%=one.getTelco_code()%>][<%=one.getTelco_name()%>] 
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Nhà mạng chuyển tới:</td>
                                        <td colspan="5">
                                            <select style="width: 250px" name="opermnp" id="opermnp">
                                                <option value="">***** Chọn nhà mạng *****</option>
                                                <%
                                                    ArrayList<Telco_Nations> allpro = Telco_Nations.getTelco_na();
                                                    for (Telco_Nations one : allpro) {
                                                %>
                                                <option 
                                                    <%=one.getTelco_code().equals(mnpPhone.getOperMnp()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getTelco_code()%>">
                                                    [<%=one.getTelco_code()%>][<%=one.getTelco_name()%>] 
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Nguồn : </td>
                                        <td colspan="2">
                                            <input readonly="true" size="30" type="text" name="sources" value="CMS"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input onclick="return convertPhone()" class="button" type="submit" name="submit" value="Sửa"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/mnp_phone/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
                                        </td>
                                        <td></td>
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
    
    <script type="text/javascript" language="javascript">
        function changeTelco(i) {
            var url = "<%=request.getContextPath()%>/admin/mnp_phone/listTelco.jsp?code=" + i;
            AjaxAction(url, "opermnp");
        }
        
        function convertPhone() {
            let phone = document.getElementById('phoneInput').value;
            
            if (!phone.startsWith('+')) {
                if (phone.startsWith('0')) {
                    phone = phone.substring(1, phone.length);
                }
                if (phone.startsWith('84')) {
                    phone = '+' + phone;
                } else {
                    phone = '+84' + phone;
                }
            }            
            
            document.getElementById('phoneInput').value = phone;
            
            if (phone.startsWith('+84')) {
                if (phone.length !== 12) {
                    document.getElementById('messError').innerHTML = 'Độ dài số điện thoại không chính xác';
                    return false;
                }
            }
            
            let operorg = document.getElementById('operorg').value;
            let opermnp = document.getElementById('opermnp').value;
            
            if (operorg === '' || opermnp === '') {
                document.getElementById('messError').innerHTML = 'Bạn phải nhập đầy đủ thông tin khi tạo mới';
                return false;
            }
                        
            return true;
        }
    </script>
</html>