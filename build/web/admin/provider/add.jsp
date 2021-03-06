<%@page import="gk.myname.vn.entity.PriceTelcoDb"%>
<%@page import="java.util.Arrays"%>
<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="gk.myname.vn.entity.Nations"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.Provider"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page contentType="text/html; charset=utf-8" %>
<html>
    <head><%@include file="/admin/includes/header.jsp" %></head>
    <body>
        <%            //--
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            String message = "";
            //phần này Tùng thêm vào
            ArrayList<Nations> all = null;
            Nations pDao = new Nations();
            all = pDao.getAll();
            //phần này Tùng thêm vào
            Provider oneProvi = null;
            PriceTelcoDb priceTelcoDb = null;
            if (request.getParameter("submit") != null) {
                //---------------------------
                String name = RequestTool.getString(request, "name");
                
                    if (Tool.checkNull(name)) {
                        session.setAttribute("mess", "Không được để trống tên nhà cung cấp!");
                        response.sendRedirect(request.getContextPath() + "/admin/provider/add.jsp");
                        return;
                    }
                
                String code = RequestTool.getString(request, "code");
                
                    if (Tool.checkNull(code)) {
                        session.setAttribute("mess", "Không được để trống mã cung cấp!");
                        response.sendRedirect(request.getContextPath() + "/admin/provider/add.jsp");
                        return;
                    }
                
                    if (Tool.stringIsSpace(code)) {
                        session.setAttribute("mess", "Mã nhà cung cấp không được có khoản trắng (space)!");
                        response.sendRedirect(request.getContextPath() + "/admin/provider/add.jsp");
                        return;
                    }
                    
                    if (oneProvi.existProviderCode(code)) {
                        session.setAttribute("mess", "Mã nhà cung cấp đã tồn tại !");
                        response.sendRedirect(request.getContextPath() + "/admin/provider/add.jsp");
                        return;
                    }
                
                String classmap = RequestTool.getString(request, "classmap");
                
                    if (Tool.checkNull(classmap)) {
                        session.setAttribute("mess", "Không được để trống vị trí!");
                        response.sendRedirect(request.getContextPath() + "/admin/provider/add.jsp");
                        return;
                    }
                
                int pos = RequestTool.getInt(request, "pos");
                
                    if (Tool.checkNull(pos)) {
                        session.setAttribute("mess", "Không được để trống Class Map!");
                        response.sendRedirect(request.getContextPath() + "/admin/provider/add.jsp");
                        return;
                    }
                
                //phần này Tùng thêm vào
//                String allow_telco = RequestTool.getString(request, "allow_telco");
                String[] allow_telco = RequestTool.getStringArray(request, "allow_telco");
                System.out.println(allow_telco);
                String aaaa = Arrays.toString(allow_telco).replace("[", "").replace("]", "").replace(" ", "");
                //phần này Tùng thêm vào
                int status = RequestTool.getInt(request, "status", 0);
                //---
                oneProvi = new Provider();
                oneProvi.setClassSend(classmap);
                oneProvi.setName(name);
                oneProvi.setCode(code);
                oneProvi.setPos(pos);
                //phần này Tùng thêm vào
                oneProvi.setAllow_telco(aaaa);
                //phần này Tùng thêm vào
                oneProvi.setStatus(status);
                //------------
                if (oneProvi.addProvider(oneProvi)) {
                    oneProvi = oneProvi.getByCode(code);
                    message += "Thêm mới dữ liệu nhà cung cấp thành công!<br/>";
                    
                    if (allow_telco != null) {
                        for (int i = 0; i < allow_telco.length; i++) {
                            priceTelcoDb = PriceTelcoDb.getbyTelcoProIdAndCode(allow_telco[i], code, oneProvi.getId());
                            if (priceTelcoDb == null) {
                                priceTelcoDb = new PriceTelcoDb();
                                priceTelcoDb.setTelcoCode(allow_telco[i]);
                                priceTelcoDb.setType(1);
                                priceTelcoDb.setProviderId(oneProvi.getId());
                                priceTelcoDb.setProviderCode(code);
                                if (priceTelcoDb.addPriceTelco(priceTelcoDb)) {
                                    message += "thêm mạng " + allow_telco[i] + " vào nhà cung cấp " + oneProvi.getName() + " thành công <br/>";
                                } else {
                                    message += "thêm mạng " + allow_telco[i] + " vào nhà cung cấp " + oneProvi.getName() + " lỗi <br/>";
                                }
                            }
                        }
                    }
                    
                    ArrayList<PriceTelcoDb> ptds = PriceTelcoDb.getAllWithProIdAndCode(code, oneProvi.getId());
                    if (ptds != null) {
                        for (PriceTelcoDb elem : ptds) {
                            if (!aaaa.contains(elem.getTelcoCode())) {
                                priceTelcoDb = new PriceTelcoDb();
                                if (priceTelcoDb.del_ever(elem.getId())) {
                                    message += "đã xóa mạng " + elem.getTelcoCode() + " trong nhà cung cấp " + oneProvi.getName() + " thành công <br/>";
                                } else {
                                    message += "chưa xóa mạng " + elem.getTelcoCode() + " trong nhà cung cấp " + oneProvi.getName() + " đâu nhé <br/>";
                                }
                            }
                        }                        
                    }
                    session.setAttribute("mess", message);
                    response.sendRedirect(request.getContextPath() + "/admin/provider/index.jsp");
                    return;
                } else {
                    session.setAttribute("mess", "Thêm mới nhà cung cấp dữ liệu lỗi!");
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
                        <form action="" method="post">
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Thêm mới Nhà cung cấp</th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tên nhà cung cấp: </td>
                                        <td colspan="2"><input size="75" type="text" name="name"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Mã nhà cung cấp: </td>
                                        <td colspan="2"><input size="75" type="text" name="code"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Vị trí: </td>
                                        <td colspan="2"><input size="75" type="text" name="pos"/></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Class Map: </td>
                                        <td colspan="2"><input size="75" type="text" name="classmap"/></td>
                                        <!--                                        Phần này Tùng thêm vào-->
                                    </tr>
                                    <%
                                        int count = 1; //Bien dung de dem so dong
                                        for (Iterator<Nations> iter = all.iterator(); iter.hasNext();) {
                                            Nations oneNa = iter.next();
                                    %>
                                    <tr>
                                        <td></td>
                                        <td align="left"> Cấp hướng nước <%=oneNa.getCountry_name()%>:</td>
                                        <td colspan="2">
                                            <div colspan="1" id="cong<%=oneNa.getId()%>" align="center">
                                                <img onclick="showcong('<%=oneNa.getId()%>')" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/></a>
                                            </div>
                                            <div colspan="1" id="tru<%=oneNa.getId()%>" style="display: none" align="center">
                                                <img style="width: 16px;height: 16px;" onclick="hidetru('<%=oneNa.getId()%>')" src="<%= request.getContextPath()%>/admin/resource/images/delete.jpg"/></a>
                                            </div>
                                            <div id="danhsach<%=oneNa.getId()%>" style="display: none">
                                            <%
                                                ArrayList<Telco_Nations> allpro = Telco_Nations.getTelco_na();
                                                for (Telco_Nations one : allpro) {
                                                    if (one.getCountry_code().equals(oneNa.getCountry_code())) {
                                            %>
                                            <input type="checkbox" name="allow_telco" value="<%=one.getTelco_code()%>"/>
                                            <span style="color: blue;font-weight: bold;"><%=one.getTelco_name()%>&nbsp;&nbsp;[<%=one.getTelco_code()%>]                                           
                                            </span>
                                            <br/>
                                            <br>
                                            <%
                                                        }
                                                    }
                                                }
                                            %>
                                            </div>
                                            <!--                                        Phần này Tùng thêm vào-->
                                        </td>
                                    </tr> 
                                    <script>
                                        function showcong(i){
                                            document.getElementById('cong'+i).style.display = 'none';
                                            document.getElementById('tru'+i).style.display = '';
                                            document.getElementById('danhsach'+i).style.display = '';
                                        }
                                        
                                        function hidetru(i){
                                            document.getElementById('cong'+i).style.display = '';
                                            document.getElementById('tru'+i).style.display = 'none';
                                            document.getElementById('danhsach'+i).style.display = 'none';
                                        }
                                    </script>
                                    <tr>
                                        <td></td>
                                        <td align="left">Trạng thái</td>
                                        <td colspan="2">
                                            <select name="status">
                                                <option value="1">Kích hoạt</option>
                                                <option value="0">Khoá</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input class="button" type="submit" name="submit" value="Thêm mới"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/provider/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
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