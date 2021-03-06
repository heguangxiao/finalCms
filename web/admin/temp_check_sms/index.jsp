<%@page import="gk.myname.vn.entity.TemplateCheckSMS"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="java.util.Iterator"%>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <%@include file="/admin/includes/header.jsp" %>
    </head>
    <body>
        <%       
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền vào module này!");
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }
            
            int max = 20;
            ArrayList<TemplateCheckSMS> all = null;
            TemplateCheckSMS dao = new TemplateCheckSMS();
            
            ArrayList<String> groups = dao.findAllGroup();
            
            int currentPage = RequestTool.getInt(request, "page", 1);
            
            String key = RequestTool.getString(request, "key");
            String group = RequestTool.getString(request, "group");
            
            int vitri = Tool.string2Integer(RequestTool.getString(request, "vitri", "0"));
            
            all = dao.findAll(max, currentPage, vitri, key, group);
            
            int totalPage = 0;
            int totalRow = dao.count(vitri, key, group);
            
            totalPage = (int) totalRow / max;
            if (totalRow % max != 0) {
                totalPage++;
            }
            RequestTool.debugParam(request);
            String urlExport = request.getContextPath() + "/admin/temp_check_sms/export.jsp?";
            String dataGet = "";
            dataGet += "&key=" + key;
            dataGet += "&group=" + group;
            dataGet += "&vitri=" + vitri;
            urlExport += dataGet;
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <!-- Tìm kiếm-->
                        <form action="<%=request.getContextPath() + "/admin/temp_check_sms/index.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"><b>Check loại tin nhắn</b></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Nhóm</td>
                                        <td>
                                            <select class="select3" style="width: 150px" name="group" >
                                                <option value="">Tất cả</option>
                                                <%
                                                    for (String elem : groups) {
                                                %>
                                                    <option <%=group.equals(elem) ? "selected='true'" : ""%> value="<%=elem%>"><%=elem%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Từ khóa</td>
                                        <td><input type="text" name="key"/></td>
                                        <td class="redBold">
                                        Vị trí
                                        <select name="vitri">
                                            <option value="0">Tất cả</option>
                                            <option value="1">Đầu tin nhắn</option>
                                            <option value="2">Giữa tin nhắn</option>
                                            <option value="3">Cuối tin nhắn</option>
                                        </select>
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="4">
                                            <input class="button" type="submit" name="submit" value="Tìm kiếm"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <input class="button" onclick="location.href = '<%=request.getContextPath() + "/admin/temp_check_sms/add.jsp"%>'" type="button" name="Thêm mới" value="Thêm mới"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <input onclick="window.open('<%=urlExport%>')" class="button" type="button" name="btnExport" value="Xuất Excel"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>      
                        <!--End tim kiếm-->
                        <%@include file="/admin/includes/page.jsp" %>
                        <div align="center" style="margin-bottom: 2px; color: red;font-weight: bold">
                            <%  
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <!--Content-->
                        <table align="center" id="rounded-corner" summary="Msc Joint Stock Company" >
                            <thead>
                                <tr>
                                    <th scope="col" class="rounded-company">STT</th>
                                    <th scope="col" class="rounded">Từ khóa</th>
                                    <th scope="col" class="rounded">Tên gợi nhớ</th>
                                    <th scope="col" class="rounded">Nhóm</th>
                                    <th scope="col" class="rounded">Mô tả</th>
                                    <th scope="col" class="rounded">Vị trí</th>
                                    <th scope="col" class="rounded-q4">Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int count = 1; 
                                    
                                    for (Iterator<TemplateCheckSMS> iter = all.iterator(); iter.hasNext();) {
                                        TemplateCheckSMS one = iter.next();
                                        int tmp = (currentPage - 1) * 25 + count++;
                                %>
                                    <tr>
                                        <td class="boder_right"><%=tmp%></td>
                                        <td class="boder_right" align="left">
                                            <%=one.getKey()%>
                                        </td>
                                        <td class="boder_right">
                                            <%=one.getName()%>
                                        </td>
                                        <td class="boder_right">
                                            <%=one.getGroup()%>
                                        </td>
                                        <td class="boder_right">
                                            <%=one.getDescription()%>
                                        </td>
                                        <td class="boder_right">
                                            <%if (one.getVitri()== 1) {%>
                                            Đầu tin nhắn
                                            <%} else if (one.getVitri()== 2) {%>
                                            Giữa tin nhắn
                                            <%} else if (one.getVitri()== 3) {%>
                                            Cuối tin nhắn
                                            <%} else {}%>
                                        </td>
                                        <td>
                                            <a title="Sửa"  href="<%=request.getContextPath()%>/admin/temp_check_sms/edit.jsp?id=<%=one.getId()%>">
                                                <img width="24" src="<%= request.getContextPath()%>/admin/resource/images/user_edit.png" title="Sửa" border="0" />
                                            </a>
                                        </td>
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