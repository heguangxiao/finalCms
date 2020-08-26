<%@page import="gk.myname.vn.entity.TempContent"%>
<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="java.util.Iterator"%>
<%@page import="gk.myname.vn.utils.SMSUtils"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.PhoneBlackList"%>
<%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "Quản lý số Black List"); %>
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
            ArrayList<PhoneBlackList> all = null;
            PhoneBlackList pDao = new PhoneBlackList();
            int currentPage = RequestTool.getInt(request, "page", 1);
            String phone = RequestTool.getString(request, "phone");
            String telcos = RequestTool.getString(request, "telco");
            String label = RequestTool.getString(request, "label");
            
            all = pDao.findAll(currentPage, max, phone, telcos, label);
            int totalPage = 0;
            int totalRow = pDao.countAll(phone, telcos, label);
            totalPage = (int) totalRow / max;
            if (totalRow % max != 0) {
                totalPage++;
            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <!-- Tìm kiếm-->
                        <form action="<%=request.getContextPath() + "/admin/phone-blacklist/index.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"><b>Quản lý số Black List</b></th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">
                                            Số Điện thoại
                                        </td>
                                        <td>
                                            <input size="20" type="text" name="phone"/>
                                        </td>
                                    </tr>
                                    <tr style="display: none">
                                        <td></td>
                                        
                                        <td>
                                            
                                            <span class="redBold">Telco</span>
                                        </td>
                                        <td>
                                            <select class="select3" style="width: 150px" name="telco">
                                                <option value="">---Tất cả---</option>
                                                <%
                                                    ArrayList<Telco_Nations> arrayList = Telco_Nations.getTelco_na();
                                                    for (Telco_Nations elem : arrayList) {
                                                %>
                                                <option <%=telcos.equals(elem.getTelco_code()) ? "selected='selected'" : ""%> value="<%=elem.getTelco_code()%>">[<%=elem.getCountry_code()%>] <%=elem.getTelco_name()%></option>
                                                <%
                                                        }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Brand Name</td>
                                        <td>
                                            <select style="width: 180px" id="_label" name="label">
                                                <option value="">Tất cả</option>
                                                <%
                                                    ArrayList<String> allBrandname = null;
                                                    TempContent dao = new TempContent();
                                                    allBrandname = dao.getAllBrandDistand();
                                                    for (String one : allBrandname) {
                                                %>
                                                <option id="_<%=one%>"  value="<%=one%>"><%=one%> </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="3">
                                            <input class="button" type="submit" name="submit" value="Tìm kiếm"/>
                                            &nbsp;&nbsp;
                                            <input class="button" onclick="location.href = '<%=request.getContextPath() + "/admin/phone-blacklist/add.jsp"%>'" type="button" name="Thêm mới" value="Thêm mới"/>
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
                                    <th scope="col" class="rounded">Số điện thoại</th>
                                    <!--<th scope="col" class="rounded">Nhà mạng</th>-->
                                    <th scope="col" class="rounded">Brandname</th>
                                    <%= buildHeader(request,userlogin,false,true)%>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int count = 1; //Bien dung de dem so dong
                                    for (Iterator<PhoneBlackList> iter = all.iterator(); iter.hasNext();) {
                                        PhoneBlackList oneAlert = iter.next();
                                        int tmp = (currentPage - 1) * 25 + count++;
                                %>
                                <tr>
                                    <td class="boder_right"><%=tmp%></td>
                                    <td class="boder_right" align="left">
                                        <%=oneAlert.getNumber()%>
                                    </td>
                                    <td style="display: none" class="boder_right">
                                        <%=oneAlert.getTelco()%>
                                    </td>
                                    <td class="boder_right">
                                        <%=oneAlert.getLabel() == null ? "" : oneAlert.getLabel()%>
                                    </td>
                                    
                                    <%=buildControl(request, userlogin,
                                            null,
                                            "/admin/phone-blacklist/del.jsp?id=" + oneAlert.getId()
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