<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.entity.PriceTelcoDb"%>
<%@page import="gk.myname.vn.entity.Provider_Telco"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="gk.myname.vn.admin.PriceTelco"%>
<%@page import="gk.myname.vn.admin.BillingAcc"%>
<%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "Thông tin billing của tài khoản"); %>
        <%@include file="/admin/includes/header.jsp" %>
        <style>
        </style>
    </head>
    <body>
        <%  if (!userlogin.checkView(request)) {
                UserAction log = new UserAction(userlogin.getUserName(),
                    UserAction.TABLE.accounts.val,
                    UserAction.TYPE.VIEW.val,
                    UserAction.RESULT.REJECT.val,
                    "Permit  deny!");
                log.logAction(request);
                session.setAttribute("mess", "Bạn không có quyền truy cập module này!");
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }
            DecimalFormat format = new DecimalFormat("$,000");
            String key = RequestTool.getString(request, "key");
            int status = RequestTool.getInt(request, "status", 1);
            out.println(key + "" + status);
            ArrayList all = null;
            BillingAcc dao = new BillingAcc();
            int currentPage = Tool.string2Integer(request.getParameter("page"), 1);
            if (currentPage < 1) {
                currentPage = 1;
            }
            maxRow = 20;
            int totalPage = 0;
            int totalRow = dao.countAllAgentcy(key, status);
            totalPage = (int) totalRow / maxRow;
            if (totalRow % maxRow != 0) {
                totalPage++;
            }
            all = dao.getAllAgentcyHaveId(currentPage, maxRow, key, status);
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <form action="<%=request.getContextPath() + "/admin/billing/index.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"><b>Tìm kiếm tài khoản KH</b></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td class="redBold">Từ khoá</td>
                                        <td>
                                            <input type="text" name="key" size="55"/>
                                            &nbsp;&nbsp;
                                            <span class="redBold">Trạng Thái</span>
                                            <select name="status">
                                                <option <%=status == 1 ? "selected='selected'" : ""%> value="1">Trả trước</option>
                                                <option <%=status == 0 ? "selected='selected'" : ""%> value="0">Trả sau</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="3">
                                            <input class="button" type="submit" name="submit" value="Tìm kiếm"/>
                                            <%--=buildAddControl(request, userlogin, "/admin/customer/agency/add.jsp")--%>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>      
                        <!--End tim kiếm-->
                        <div align="center" style="height: auto;margin-bottom: 2px; color: red;font-weight: bold">
                            <%                                
                                if (session.getAttribute("mess") != null) {
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
                                    <th scope="col" class="rounded">User</th>
                                    <th scope="col" class="rounded">Tên khách hàng</th>
                                    <th scope="col" class="rounded">Thanh toán</th>
                                    <th scope="col" class="rounded">Số dư</th>
                                    <th scope="col" class="rounded">Đơn giá SMS</th>
                                    <th scope="col" class="rounded">Trạng thái</th>
                                    <th scope="col" class="rounded-q4">Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%                                    
                                    ArrayList<PriceTelcoDb> ptdsCSKH = null;
                                    ArrayList<PriceTelcoDb> ptdsQC = null;
                                    int count = 1; //Bien dung de dem so dong
                                    for (Iterator<BillingAcc> iter = all.iterator(); iter.hasNext();) {
                                        BillingAcc oneAdmin = iter.next();
                                        int index = (currentPage - 1) * maxRow + count++;
                                %>
                                <tr>
                                    <td class="boder_right"><%=index%></td>
                                    <td align="left" class="boder_right"><%=oneAdmin.getUsername()%></td>
                                    <td align="left" class="boder_right"><%= oneAdmin.getFullname()%></td>
                                    <td class="boder_right"><% if (oneAdmin.getPrepaid() == 0) {
                                            out.println("Trả sau");
                                        } else {
                                            out.println("<font color='blue'>Trả trước</font>");
                                            }%></td>
                                    <td class="boder_right"><%=Tool.dinhDangTienTe(oneAdmin.getBalance()+"")%></td>
                                    <%
                                        ptdsCSKH = PriceTelcoDb.getAllWithAccIdAndUserForCskh(oneAdmin.getUsername(), oneAdmin.getId());
                                        ptdsQC = PriceTelcoDb.getAllWithAccIdAndUserForQc(oneAdmin.getUsername(), oneAdmin.getId());
                                    %>
                                    <td class="boder_right" width="400">
                                        <b style="color: black">Giá Bán cho tin Cskh </b><br/>
                                        <%
                                            for (PriceTelcoDb elem : ptdsCSKH) {
                                                PriceTelco pt = PriceTelco.json2Objec(elem.getPriceCskh());
                                        %>
                                            &nbsp;&nbsp;
                                            &nbsp;&nbsp;
                                            <b><%=elem.getTelcoCode()%> : </b><br/>
                                            &nbsp;&nbsp;
                                            &nbsp;&nbsp;
                                            &nbsp;&nbsp;
                                            &nbsp;&nbsp;
                                            <%=pt.getGroup0Price() > 0 ? "N0 : "+Tool.dinhDangTienTe(pt.getGroup0Price()+"")+" , "  : ""%> 
                                            <%=pt.getGroup1Price() > 0 ? "N1 : "+Tool.dinhDangTienTe(pt.getGroup1Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup2Price() > 0 ? "N2 : "+Tool.dinhDangTienTe(pt.getGroup2Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup3Price() > 0 ? "N3 : "+Tool.dinhDangTienTe(pt.getGroup3Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup4Price() > 0 ? "N4 : "+Tool.dinhDangTienTe(pt.getGroup4Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup5Price() > 0 ? "N5 : "+Tool.dinhDangTienTe(pt.getGroup5Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup6Price() > 0 ? "N6 : "+Tool.dinhDangTienTe(pt.getGroup6Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup7Price() > 0 ? "N7 : "+Tool.dinhDangTienTe(pt.getGroup7Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup8Price() > 0 ? "N8 : "+Tool.dinhDangTienTe(pt.getGroup8Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup9Price() > 0 ? "N9 : "+Tool.dinhDangTienTe(pt.getGroup9Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup10Price() > 0 ? "N10 : "+Tool.dinhDangTienTe(pt.getGroup10Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup11Price() > 0 ? "N11 : "+Tool.dinhDangTienTe(pt.getGroup11Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup12Price() > 0 ? "N12 : "+Tool.dinhDangTienTe(pt.getGroup12Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup13Price() > 0 ? "N13 : "+Tool.dinhDangTienTe(pt.getGroup13Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup14Price() > 0 ? "N14 : "+Tool.dinhDangTienTe(pt.getGroup14Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup15Price() > 0 ? "N15 : "+Tool.dinhDangTienTe(pt.getGroup15Price()+"")+" , "  : ""%>
                                            <%=pt.getGroupLCPrice() > 0 ? "NLC : "+Tool.dinhDangTienTe(pt.getGroupLCPrice()+"")+" , "  : ""%>
                                            <br/>
                                        <%
                                            }
                                        %>
                                        <b style="color: black">Giá Bán cho tin Qc </b><br/>
                                        <%
                                            for (PriceTelcoDb elem : ptdsQC) {
                                                PriceTelco pt = PriceTelco.json2Objec(elem.getPriceQc());
                                        %>
                                            &nbsp;&nbsp;
                                            &nbsp;&nbsp;
                                            <b><%=elem.getTelcoCode()%> : </b><br/> 
                                            &nbsp;&nbsp;
                                            &nbsp;&nbsp;
                                            &nbsp;&nbsp;                                           
                                            &nbsp;&nbsp;
                                            <%=pt.getGroup0Price() > 0 ? "N0 : "+Tool.dinhDangTienTe(pt.getGroup0Price()+"")+" , "  : ""%> 
                                            <%=pt.getGroup1Price() > 0 ? "N1 : "+Tool.dinhDangTienTe(pt.getGroup1Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup2Price() > 0 ? "N2 : "+Tool.dinhDangTienTe(pt.getGroup2Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup3Price() > 0 ? "N3 : "+Tool.dinhDangTienTe(pt.getGroup3Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup4Price() > 0 ? "N4 : "+Tool.dinhDangTienTe(pt.getGroup4Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup5Price() > 0 ? "N5 : "+Tool.dinhDangTienTe(pt.getGroup5Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup6Price() > 0 ? "N6 : "+Tool.dinhDangTienTe(pt.getGroup6Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup7Price() > 0 ? "N7 : "+Tool.dinhDangTienTe(pt.getGroup7Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup8Price() > 0 ? "N8 : "+Tool.dinhDangTienTe(pt.getGroup8Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup9Price() > 0 ? "N9 : "+Tool.dinhDangTienTe(pt.getGroup9Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup10Price() > 0 ? "N10 : "+Tool.dinhDangTienTe(pt.getGroup10Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup11Price() > 0 ? "N11 : "+Tool.dinhDangTienTe(pt.getGroup11Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup12Price() > 0 ? "N12 : "+Tool.dinhDangTienTe(pt.getGroup12Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup13Price() > 0 ? "N13 : "+Tool.dinhDangTienTe(pt.getGroup13Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup14Price() > 0 ? "N14 : "+Tool.dinhDangTienTe(pt.getGroup14Price()+"")+" , "  : ""%>
                                            <%=pt.getGroup15Price() > 0 ? "N15 : "+Tool.dinhDangTienTe(pt.getGroup15Price()+"")+" , "  : ""%>
                                            <%=pt.getGroupLCPrice() > 0 ? "NLC : "+Tool.dinhDangTienTe(pt.getGroupLCPrice()+"")+" , "  : ""%>
                                            <br/>
                                        <%
                                            }
                                        %>
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
                                            "/admin/billing/edit.jsp?account=" + oneAdmin.getUsername(),
                                            ""
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