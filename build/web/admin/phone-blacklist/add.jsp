<%@page import="gk.myname.vn.entity.TempContent"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.PhoneBlackList"%>
<%@page import="gk.myname.vn.utils.SMSUtils"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page contentType="text/html; charset=utf-8" %>
<html>
    <head><%@include file="/admin/includes/header.jsp" %></head>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/admin/resource/select2/select2.css" />
    <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2_locale_vi.js"></script>
    <script type="text/javascript" language="javascript">
        //------
        $(document).ready(function () {
            $("#_label").select2({
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
                session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            PhoneBlackList oneKeys = null;
            if (request.getParameter("submit") != null) {
                
                String phone = RequestTool.getString(request, "phone");
                String label = RequestTool.getString(request, "label");
                phone = SMSUtils.phoneTo84(phone);
                
                oneKeys = new PhoneBlackList();
                oneKeys.setNumber(phone);
                oneKeys.setLabel(label);
                
                boolean check = oneKeys.existsByPhoneAndLabel(phone, label);
                
                if (check) {
                    session.setAttribute("mess", "Phone "+phone+" của nhà mạng "+label+" này đã tồn tại!");
                    response.sendRedirect(request.getContextPath() + "/admin/phone-blacklist/index.jsp");
                    return;
                }
                
                if (oneKeys.addNew(oneKeys)) {
                    session.setAttribute("mess", "Thêm mới dữ liệu thành công!");
                    response.sendRedirect(request.getContextPath() + "/admin/phone-blacklist/index.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/phone-blacklist/index.jsp");
                    session.setAttribute("mess", "Thêm mới dữ liệu thất bại!");
                }
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
                            <%                                if (session.getAttribute("mess") != null) {
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
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Thêm mới phone vào blacklist</th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Số Điện thoại</td>
                                        <td colspan="2">
                                            <input size="35" type="text" placeholder="84xxxxxxxxx" name="phone" id="phone" value=""/>
                                        </td>
                                    </tr>
                                    <tr id="trError" style="display: none">
                                        <td></td>
                                        <td></td>
                                        <td colspan="2">
                                            <span class="redBold" id="msgErrror"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <span class="redBold">Brandname</span>
                                        </td>
                                        <td>
                                            <select style="width: 180px" id="_label" name="label">
                                                <option value="">Apply to Tất cả</option>
                                                <%
                                                    ArrayList<String> allBrandname = null;
                                                    TempContent pDao = new TempContent();
                                                    allBrandname = pDao.getAllBrandDistand();
                                                    for (String one : allBrandname) {
                                                %>
                                                <option id="_<%=one%>"  value="<%=one%>"><%=one%> </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input onclick="return checkPhone()" class="button" type="submit" name="submit" value="Thêm mới"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/phone-blacklist/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
                                        </td>
                                        <script>
                                            function checkPhone() {
                                                let phone = document.getElementById('phone').value;
                                                
                                                if (phone.length > 11 || phone.length < 9) {
                                                    document.getElementById('trError').style.display = '';
                                                    document.getElementById('msgErrror').innerHTML = "Độ dài số điện thoại không đúng";
                                                    return false;
                                                } else {
                                                    document.getElementById('trError').style.display = "none";
                                                    document.getElementById('msgErrror').innerHTML = '';
                                                }
                                                if (/^[0-9]*$/.test(phone) === false) {
                                                    document.getElementById('trError').style.display = '';
                                                    document.getElementById('msgErrror').innerHTML = "Chỉ được nhập số";
                                                    return false;
                                                }
                                                if (phone.startsWith('84')) {
                                                    document.getElementById('trError').style.display = 'none';
                                                    document.getElementById('msgErrror').innerHTML = '';
                                                    return true;
                                                } else {
                                                    document.getElementById('trError').style.display = '';
                                                    document.getElementById('msgErrror').innerHTML = 'Đầu số không đúng định dạng';
                                                    return false;
                                                }
                                            }
                                        </script>
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