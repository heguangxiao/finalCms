<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.Nations"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page contentType="text/html; charset=utf-8" %>
<html>
    <head>
        <%@include file="/admin/includes/header.jsp" %>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/admin/resource/css/jquery-ui-1.8.16.custom.css">
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.core.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.position.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.widget.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.autocomplete.min.js"></script>
        <script type ='text/javascript'>
            function validForm() {
                var err_username = $("#err_username").attr("value");
                if (err_username === 1) {
                    jAlert("Mã nước đã tồn tại!");
                    return false;
                }
                var brr_username = $("#brr_username").attr("value");
                if (brr_username === 1) {
                    jAlert("Đầu số nước đã tồn tại!");
                    return false;
                }
            }
            $(document).ready(function () {
                $('#country_code').keyup(function () {
                    var country_code = $(this).val();
                    $.ajax({
                        type: "POST",
                        url: '<%=request.getContextPath() + "/admin/nations/check_dup.jsp"%>',
                        data: "country_code=" + country_code,
                        success: function (data) {
                            if (data == 1) {
                                $("#err_username").html('<b>Đã tồn tại<b>');
                                $("#err_username").attr("value", "1");
                            } else {
                                $("#err_username").html('<img width=\"16\" src=\"<%=request.getContextPath()%>/admin/resource/images/active.png\"/>');
                                $("#err_username").attr("value", "0");
                            }
                        }
                    });
                });
                $('#country_prefix').keyup(function () {
                    var country_prefix = $(this).val();
                    $.ajax({
                        type: "POST",
                        url: '<%=request.getContextPath() + "/admin/nations/check_duppre.jsp"%>',
                        data: "country_prefix=" + country_prefix,
                        success: function (data) {
                            if (data == 1) {
                                $("#brr_username").html('<b>Đã tồn tại<b>');
                                $("#brr_username").attr("value", "1");
                            } else {
                                $("#brr_username").html('<img width=\"16\" src=\"<%=request.getContextPath()%>/admin/resource/images/active.png\"/>');
                                $("#brr_username").attr("value", "0");
                            }
                        }
                    });
                });
            });
        </script>
    </head>
    <body>
        <%            //--
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            Nations oneNa = null;
            if (request.getParameter("submit") != null) {
                //---------------------------
                String country_code = RequestTool.getString(request, "country_code");
                String country_prefix = RequestTool.getString(request, "country_prefix");
                String country_name = RequestTool.getString(request, "country_name");
                
                if (Tool.checkNull(country_code) || Tool.checkNull(country_prefix) || Tool.checkNull(country_name)) {
                    session.setAttribute("mess", "Không được để trống mã nước, đầu số và tên nước!");
                    response.sendRedirect(request.getContextPath() + "/admin/nations/add.jsp");
                    return;
                }
                Nations dao = new Nations();
                if (dao.getByCountry_code(country_code.toUpperCase()) != null) {
                    session.setAttribute("mess", "Mã nước này đã tồn tại!");
                    response.sendRedirect(request.getContextPath() + "/admin/nations/add.jsp");
                    return;
                } 
                
                //---
                oneNa = new Nations();
                oneNa.setCountry_code(country_code.toUpperCase());
                oneNa.setCountry_prefix(country_prefix);
                oneNa.setCountry_name(country_name);
                //------------
                if (oneNa.addNa(oneNa)) {
                    session.setAttribute("mess", "Thêm mới nước thành công!");
                    response.sendRedirect(request.getContextPath() + "/admin/nations/list.jsp");
                    return;
                } else {
                    session.setAttribute("mess", "Thêm mới nước lỗi!");
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
                            <%                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <form onsubmit="return validForm()" action="" method="post">
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Thêm mới nước</th>
                                        <th></th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Mã nước: </td>
                                        <td colspan="2"><input style="text-transform: uppercase" size="75" id="country_code" type="text" name="country_code"/>
                                            <span class="redBold" id="err_username" value="0"></span>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Đầu số của nước: </td>
                                        <td colspan="2">
                                            <input size="75" type="text" id="country_prefix" name="country_prefix"/>
                                            <span class="redBold" id="brr_username" value="0"></span>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tên nước: </td>
                                        <td colspan="2"><input size="75" type="text" name="country_name"/></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="4" align="center">
                                            <input class="button" type="submit" name="submit" value="Thêm mới"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/nations/list.jsp"%>'" type="reset" name="reset" value="Hủy"/>
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
