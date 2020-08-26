<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="java.util.Iterator"%>
<%@page import="gk.myname.vn.utils.SMSUtils"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.TempContent"%>
<%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "Quản lý mẫu nội dung tin nhắn"); %>
        <%@include file="/admin/includes/header.jsp" %>
    </head>
    <body>
        <%  //-          
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền thêm module này!");
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }
            int max = 50;
            ArrayList<TempContent> all = null;
            ArrayList<String> allBrandname = null;
            TempContent pDao = new TempContent();
            int currentPage = RequestTool.getInt(request, "page", 1);
            String telco = RequestTool.getString(request, "telco");
            String temp = RequestTool.getString(request, "temp");
            int status = RequestTool.getInt(request, "status", -1);
            
            String brandname = RequestTool.getString(request, "brandname");
            all = pDao.findAll(currentPage, max, telco, temp, brandname, status);
            allBrandname = pDao.getAllBrandDistand();
            int totalPage = 0;
            int totalRow = pDao.countAll(telco, temp, brandname, status);
            totalPage = (int) totalRow / max;
            if (totalRow % max != 0) {
                totalPage++;
            }
            
            String urlExport = request.getContextPath() + "/admin/temp-content/exp/export.jsp?";
            urlExport += "&currentPage=" + currentPage;
            urlExport += "&max=" + max;
            urlExport += "&telco=" + telco;
            urlExport += "&temp=" + temp;
            urlExport += "&brandname=" + brandname;
            urlExport += "&status=" + status;
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <!-- Tìm kiếm-->
                        <form action="<%=request.getContextPath() + "/admin/temp-content/index.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded"><b>Quản lý mẫu nội dung tin nhắn</b></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4 redBoldUp"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <span class="redBold">Telco</span>
                                            <select style="width: 150px" class="select3" name="telco">
                                                <option value="">---Tất cả---</option>
                                                <%
                                                    ArrayList<Telco_Nations> arrayList = Telco_Nations.getTelco_na();
                                                    for (Telco_Nations elem : arrayList) {
                                                %>
                                                <option <%=telco.equals(elem.getTelco_code()) ? "selected='selected'" : ""%> value="<%=elem.getTelco_code()%>"><%=elem.getTelco_name()%></option>
                                                <%
                                                        }
                                                %>
                                            </select>
                                        </td>
                                        <td>
                                            <span class="redBold">Temp </span>
                                            <input size="30" type="text" name="temp"/>
                                        </td>
                                        
                                        <td>
                                            <span class="redBold">Brandname</span>
                                            <select style="width: 150px" id="_label" name="brandname">
                                                <option value="">Apply to Tất cả</option>
                                                <%
                                                    for (String one : allBrandname) {
                                                %>
                                                <option id="_<%=one%>"  <%=brandname.equals(one) ? "selected='selected'" : ""%> value="<%=one%>"><%=one%> </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td>
                                            &nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Status</span>
                                            <select name="status">
                                                <option value="-1">---Tất cả---</option>
                                                <option <%=status==0 ? "selected='selected'" : ""%> value="0">Không kích hoạt</option>
                                                <option <%=status==1 ? "selected='selected'" : ""%> value="1">Kích hoạt</option>
                                                
                                            </select>
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="5">
                                            <input class="button" type="submit" name="submit" value="Tìm kiếm"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <input class="button" onclick="location.href = '<%=request.getContextPath() + "/admin/temp-content/add.jsp"%>'" type="button" name="Thêm mới" value="Thêm mới"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <input onclick="window.open('<%=urlExport%>')" class="button" type="button" name="button" value="Xuất Excel"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>      
                        <!--End tim kiếm-->
                        <%@include file="/admin/includes/page.jsp" %>
                        <div align="center" style="height: 20px;margin-bottom: 2px; color: red;font-weight: bold">
                            <%                                if (session.getAttribute("mess") != null) {
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
                                    <th scope="col" class="rounded">TELCO</th>
                                    <th scope="col" class="rounded">TEMP</th>
                                    <th scope="col" class="rounded">BRANDNAME</th>
                                    <th scope="col" class="rounded">STATUS</th>
                                    <%= buildHeader(request,userlogin,true,true)%>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int count = 1; //Bien dung de dem so dong
                                    for (Iterator<TempContent> iter = all.iterator(); iter.hasNext();) {
                                        TempContent oneAlert = iter.next();
                                        int tmp = (currentPage - 1) * 25 + count++;
                                %>
                                <tr>
                                    <td class="boder_right"><%=tmp%></td>
                                    <td class="boder_right" align="left">
                                        <%=oneAlert.getOper()%>
                                    </td>
                                    <td class="boder_right">
                                        <%=oneAlert.getTemp()%>
                                    </td>
                                    <td class="boder_right">
                                        <%=oneAlert.getBrandname()%>
                                    </td>
                                    <td class="boder_right">
                                        <%if (oneAlert.getActive()== 1) {%>
                                            <img src="<%= request.getContextPath()%>/admin/resource/images/active.png"/>
                                            <%} else if (oneAlert.getActive()== Tool.STATUS.DEL.val) {
                                            %> <img width="16" src="<%= request.getContextPath()%>/admin/resource/images/shutdown.png"/><%
                                            } else {%>
                                            <img width="32" src="<%= request.getContextPath()%>/admin/resource/images/key_lock.png"/>
                                            <%}%>
                                    </td>
                                    <%=buildControl(request, userlogin,
                                            "/admin/temp-content/edit.jsp?id=" + oneAlert.getId(),
                                            "/admin/temp-content/del.jsp?id=" + oneAlert.getId()
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