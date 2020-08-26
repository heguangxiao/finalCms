<%@page import="gk.myname.vn.entity.PriceTelcoDb"%>
<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="gk.myname.vn.entity.Provider_Telco"%>
<%@page import="gk.myname.vn.entity.Provider"%>
<%@page import="gk.myname.vn.admin.PriceTelco"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="javax.ws.rs.core.MediaType"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="gk.myname.vn.entity.JSONUtil"%>
<%@page import="com.fasterxml.jackson.core.JsonGenerator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="gk.myname.vn.admin.BillingAcc"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.admin.AccountRole"%>
<%@page import="gk.myname.vn.entity.PartnerManager"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
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
        <script>
            var inputnumber = 'Giá trị nhập vào không phải là số';
            function FormatNumber(str) {
                    var strTemp = GetNumber(str);
                    if (strTemp.length <= 3)
                            return strTemp;
                    strResult = "";
                    for (var i = 0; i < strTemp.length; i++)
                            strTemp = strTemp.replace(",", "");
                    var m = strTemp.lastIndexOf(".");
                    if (m == -1) {
                            for (var i = strTemp.length; i >= 0; i--) {
                                    if (strResult.length > 0 && (strTemp.length - i - 1) % 3 == 0)
                                            strResult = "," + strResult;
                                    strResult = strTemp.substring(i, i + 1) + strResult;
                            }
                    } else {
                            var strphannguyen = strTemp.substring(0, strTemp.lastIndexOf("."));
                            var strphanthapphan = strTemp.substring(strTemp.lastIndexOf("."),
                                            strTemp.length);
                            var tam = 0;
                            for (var i = strphannguyen.length; i >= 0; i--) {

                                    if (strResult.length > 0 && tam == 4) {
                                            strResult = "," + strResult;
                                            tam = 1;
                                    }

                                    strResult = strphannguyen.substring(i, i + 1) + strResult;
                                    tam = tam + 1;
                            }
                            strResult = strResult + strphanthapphan;
                    }
                    return strResult;
            }

            function GetNumber(str) {
                    var count = 0;
                    for (var i = 0; i < str.length; i++) {
                            var temp = str.substring(i, i + 1);
                            if (!(temp == "," || temp == "." || (temp >= 0 && temp <= 9))) {
                                    alert(inputnumber);
                                    return str.substring(0, i);
                            }
                            if (temp == " ")
                                    return str.substring(0, i);
                            if (temp == ".") {
                                    if (count > 0)
                                            return str.substring(0, ipubl_date);
                                    count++;
                            }
                    }
                    return str;
            }

            function IsNumberInt(str) {
                    for (var i = 0; i < str.length; i++) {
                            var temp = str.substring(i, i + 1);
                            if (!(temp == "." || (temp >= 0 && temp <= 9))) {
                                    alert(inputnumber);
                                    return str.substring(0, i);
                            }
                            if (temp == ",") {
                                    return str.substring(0, i);
                            }
                    }
                    return str;
            }
        </script>                            
        <SCRIPT language="javascript">
            function show(name) {
                for (let el of document.querySelectorAll('.spp'+name)) el.style.display = '';
                document.getElementById('showPrice'+name).style.display = 'none';
                document.getElementById('hidePrice'+name).style.display = '';
            }

            function hide(name) {
                for (let el of document.querySelectorAll('.spp'+name)) el.style.display = 'none';
                document.getElementById('showPrice'+name).style.display = '';
                document.getElementById('hidePrice'+name).style.display = 'none';
            }
        </SCRIPT>
    </head>
    <body>
        <%
            if (!userlogin.checkEdit(request)) {
                session.setAttribute("mess", "Bạn không có quyền thêm module này!");
                response.sendRedirect(request.getContextPath() + "/admin/provider/index.jsp");
                return;
            }
            String code = Tool.validStringRequest(request.getParameter("code"));
            Provider proDao = new Provider();
            Provider onePro = null;
            onePro = proDao.getByCode(code);            
            if (onePro == null) {
                session.setAttribute("mess", "Yêu cầu không hợp lệ. Không lấy được thông tin nhà cung cấp");
                response.sendRedirect(request.getContextPath() + "/admin/provider/index.jsp");
                return;
            }
            String message = "";
            ArrayList<PriceTelcoDb> ptds = PriceTelcoDb.getAllWithProIdAndCode(onePro.getCode(), onePro.getId());
            
            int price, n1price, n2price, n3price, n4price, n5price, n6price, n7price, n8price, n9price, n10price, n11price, n12price, n13price, n14price, n15price, nlcprice;
            PriceTelco priceTelco = new PriceTelco();
            PriceTelcoDb priceTelcoDb = new PriceTelcoDb();
            PriceTelcoDb dao = new PriceTelcoDb();
            

            if (request.getParameter("submit") != null) {
                              
                for (int i = 1; i < ( ptds.size() + 1 ); i++) {
                                        
                    priceTelcoDb = dao.getbyId(ptds.get(i-1).getId());
                    price = Tool.string2Integer(request.getParameter("price"+i), 0);
                    n1price = Tool.string2Integer(request.getParameter("n1price"+i), 0);
                    n2price = Tool.string2Integer(request.getParameter("n2price"+i), 0);
                    n3price = Tool.string2Integer(request.getParameter("n3price"+i), 0);
                    n4price = Tool.string2Integer(request.getParameter("n4price"+i), 0);
                    n5price = Tool.string2Integer(request.getParameter("n5price"+i), 0);
                    n6price = Tool.string2Integer(request.getParameter("n6price"+i), 0);
                    n7price = Tool.string2Integer(request.getParameter("n7price"+i), 0);
                    n8price = Tool.string2Integer(request.getParameter("n8price"+i), 0);
                    n9price = Tool.string2Integer(request.getParameter("n9price"+i), 0);
                    n10price = Tool.string2Integer(request.getParameter("n10price"+i), 0);
                    n11price = Tool.string2Integer(request.getParameter("n11price"+i), 0);
                    n12price = Tool.string2Integer(request.getParameter("n12price"+i), 0);
                    n13price = Tool.string2Integer(request.getParameter("n13price"+i), 0);
                    n14price = Tool.string2Integer(request.getParameter("n14price"+i), 0);
                    n15price = Tool.string2Integer(request.getParameter("n15price"+i), 0);
                    nlcprice = Tool.string2Integer(request.getParameter("nlcprice"+i), 0);

                    priceTelco.setGroup0Price(price);
                    priceTelco.setGroup1Price(n1price);
                    priceTelco.setGroup2Price(n2price);
                    priceTelco.setGroup3Price(n3price);
                    priceTelco.setGroup4Price(n4price);
                    priceTelco.setGroup5Price(n5price);
                    priceTelco.setGroup6Price(n6price);
                    priceTelco.setGroup7Price(n7price);
                    priceTelco.setGroup8Price(n8price);
                    priceTelco.setGroup9Price(n9price);
                    priceTelco.setGroup10Price(n10price);
                    priceTelco.setGroup11Price(n11price);
                    priceTelco.setGroup12Price(n12price);
                    priceTelco.setGroup13Price(n13price);
                    priceTelco.setGroup14Price(n14price);
                    priceTelco.setGroup15Price(n15price);
                    priceTelco.setGroupLCPrice(nlcprice); 
                                        
                    if (priceTelcoDb.getPriceCskh() == null) {
                        priceTelcoDb.setPriceCskh("");
                    }

                    if (!priceTelcoDb.getPriceCskh().equals(priceTelco.toJson())) {
                        priceTelcoDb.setPriceCskh(priceTelco.toJson());
                        if (dao.updatePriceTelco(priceTelcoDb)) {
                            message += "cập nhật giá bán cskh mạng " + ptds.get(i-1).getTelcoCode() + " của nhà cung cấp " + onePro.getName()+ " thành công <br/>";
                        } else {
                            message += "cập nhật giá bán cskh mạng " + ptds.get(i-1).getTelcoCode() + " của nhà cung cấp " + onePro.getName()+ " bị lỗi <br/>";
                        }
                    }
                }
                
                for (int i = 1; i < ( ptds.size() + 1 ); i++) {
                    priceTelcoDb = dao.getbyId(ptds.get(i-1).getId());
                    
                    price = Tool.string2Integer(request.getParameter("priceQc"+i), 0);
                    n1price = Tool.string2Integer(request.getParameter("n1priceQc"+i), 0);
                    n2price = Tool.string2Integer(request.getParameter("n2priceQc"+i), 0);
                    n3price = Tool.string2Integer(request.getParameter("n3priceQc"+i), 0);
                    n4price = Tool.string2Integer(request.getParameter("n4priceQc"+i), 0);
                    n5price = Tool.string2Integer(request.getParameter("n5priceQc"+i), 0);
                    n6price = Tool.string2Integer(request.getParameter("n6priceQc"+i), 0);
                    n7price = Tool.string2Integer(request.getParameter("n7priceQc"+i), 0);
                    n8price = Tool.string2Integer(request.getParameter("n8priceQc"+i), 0);
                    n9price = Tool.string2Integer(request.getParameter("n9priceQc"+i), 0);
                    n10price = Tool.string2Integer(request.getParameter("n10priceQc"+i), 0);
                    n11price = Tool.string2Integer(request.getParameter("n11priceQc"+i), 0);
                    n12price = Tool.string2Integer(request.getParameter("n12priceQc"+i), 0);
                    n13price = Tool.string2Integer(request.getParameter("n13priceQc"+i), 0);
                    n14price = Tool.string2Integer(request.getParameter("n14priceQc"+i), 0);
                    n15price = Tool.string2Integer(request.getParameter("n15priceQc"+i), 0);
                    nlcprice = Tool.string2Integer(request.getParameter("nlcpriceQc"+i), 0);

                    priceTelco.setGroup0Price(price);
                    priceTelco.setGroup1Price(n1price);
                    priceTelco.setGroup2Price(n2price);
                    priceTelco.setGroup3Price(n3price);
                    priceTelco.setGroup4Price(n4price);
                    priceTelco.setGroup5Price(n5price);
                    priceTelco.setGroup6Price(n6price);
                    priceTelco.setGroup7Price(n7price);
                    priceTelco.setGroup8Price(n8price);
                    priceTelco.setGroup9Price(n9price);
                    priceTelco.setGroup10Price(n10price);
                    priceTelco.setGroup11Price(n11price);
                    priceTelco.setGroup12Price(n12price);
                    priceTelco.setGroup13Price(n13price);
                    priceTelco.setGroup14Price(n14price);
                    priceTelco.setGroup15Price(n15price);
                    priceTelco.setGroupLCPrice(nlcprice);   
                                
                    if (priceTelcoDb.getPriceQc() == null) {
                        priceTelcoDb.setPriceQc("");
                    }
                    
                    if (!priceTelcoDb.getPriceQc().equals(priceTelco.toJson())) {
                        priceTelcoDb.setPriceQc(priceTelco.toJson());
                        if (dao.updatePriceTelco(priceTelcoDb)) {
                            message += "cập nhật giá bán qc mạng " + ptds.get(i-1).getTelcoCode() + " của nhà cung cấp " + onePro.getName()+ " thành công <br/>";
                        } else {
                            message += "cập nhật giá bán qc mạng " + ptds.get(i-1).getTelcoCode() + " của nhà cung cấp " + onePro.getName()+ " bị lỗi <br/>";
                        }
                    }
                }
                session.setAttribute("mess", message);
                response.sendRedirect(request.getContextPath() + "/admin/provider/index.jsp");
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
                            <table align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th colspan="1" class="rounded-company"></th>
                                        <th colspan="10" class="redBoldUp">Cập nhật thông tin Đại lý</th>
                                        <th colspan="1" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="2" align="left">Tên nhà cung cấp</td>
                                        <td colspan="8">
                                            <input style="display: none" type="text" name="codepro" value="<%=onePro.getCode()%>"/>
                                            <input readonly type="text" name="codename" value="<%=onePro.getName()%>"/>
                                        </td>
                                        <td colspan="1"> </td>
                                    </tr>
                                    <tr>
                                        <td colspan="12" align="center" ><b>BẢNG GIÁ CÁC NHÓM CỦA MỖI NHÀ MẠNG(nhóm 0 là mặc định)</b></td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="2"><h3>Nhập giá mua tin CSKH</h3></td>
                                        <td colspan="8"></td>
                                        <td colspan="1"> </td>
                                    </tr>
                                    <%
                                        for (int i = 1; i < ( ptds.size() + 1 ); i++) {
                                            PriceTelco pt = PriceTelco.json2Objec(ptds.get(i-1).getPriceCskh());
                                    %>
                                        <tr>
                                            <td colspan="1"></td>
                                            <td colspan="1" align="left" class="boder_right">
                                                <%=ptds.get(i-1).getTelcoCode()%>
                                            </td>
                                            <td colspan="1">
                                                Nhóm 0 :  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup0Price()+"")%>">
                                            </td>
                                            <td colspan="1">
                                                <div id="showPriceOldCskh<%=i%>" style="float: right">
                                                    <img onclick="show('OldCskh<%=i%>')" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/>
                                                </div>
                                                <div id="hidePriceOldCskh<%=i%>" style="float: right;display: none">
                                                    <img onclick="hide('OldCskh<%=i%>')" src="<%=request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px;"/></a>
                                                </div>
                                            </td>
                                            <td colspan="1">
                                                <div class="sppOldCskh<%=i%>" style="display: none">
                                                    Nhóm 01:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n1price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup1Price()+"")%>"/><br/>
                                                    Nhóm 02:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n2price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup2Price()+"")%>"/><br/>
                                                    Nhóm 03:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n3price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup3Price()+"")%>"/><br/>
                                                    Nhóm 04:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n4price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup4Price()+"")%>"/><br/>
                                                </div>
                                            </td>
                                            <td colspan="1">
                                                <div class="sppOldCskh<%=i%>" style="display: none">
                                                    Nhóm 05:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n5price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup5Price()+"")%>"/><br/>
                                                    Nhóm 06:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n6price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup6Price()+"")%>"/><br/>
                                                    Nhóm 07:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n7price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup7Price()+"")%>"/><br/>
                                                    Nhóm 08:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n8price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup8Price()+"")%>"/><br/>
                                                </div>
                                            </td>
                                            <td colspan="1">
                                                <div class="sppOldCskh<%=i%>" style="display: none">
                                                    Nhóm 09:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n9price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup9Price()+"")%>"/><br/>
                                                    Nhóm 10:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n10price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup10Price()+"")%>"/><br/>
                                                    Nhóm 11:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n11price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup11Price()+"")%>"/><br/>
                                                    Nhóm 12:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n12price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup12Price()+"")%>"/><br/>
                                                </div>
                                            </td>
                                            <td colspan="1">
                                                <div class="sppOldCskh<%=i%>" style="display: none">
                                                    Nhóm 13:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n13price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup13Price()+"")%>"/><br/>
                                                    Nhóm 14:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n14price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup14Price()+"")%>"/><br/>
                                                    Nhóm 15:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n15price<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup15Price()+"")%>"/><br/>
                                                    Nhóm LC:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="nlcprice<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroupLCPrice()+"")%>"/><br/>
                                                </div>
                                            </td>
                                            <td colspan="4"></td>
                                        </tr>
                                    <%
                                        }
                                    %>
                                    
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="2"><h3>Nhập giá mua tin QC</h3></td>
                                        <td colspan="8"></td>
                                        <td colspan="1"></td>
                                    </tr>
                                    <%
                                        for (int i = 1; i < ( ptds.size() + 1 ); i++) {
                                            PriceTelco pt = PriceTelco.json2Objec(ptds.get(i-1).getPriceQc());
                                    %>
                                        <tr>
                                            <td colspan="1"></td>
                                            <td colspan="1" align="left" class="boder_right">                                                
                                                <%=ptds.get(i-1).getTelcoCode()%>
                                            </td>
                                            <td colspan="1">
                                                Nhóm 0 :  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup0Price()+"")%>">
                                            </td>
                                            <td colspan="1">
                                                <div id="showPriceOldQc<%=i%>" style="float: right">
                                                    <img onclick="show('OldQc<%=i%>')" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/>
                                                </div>
                                                <div id="hidePriceOldQc<%=i%>" style="float: right;display: none">
                                                    <img onclick="hide('OldQc<%=i%>')" src="<%=request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px;"/></a>
                                                </div>
                                            </td>
                                            <td colspan="1">
                                                <div class="sppOldQc<%=i%>" style="display: none">
                                                    Nhóm 01:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n1priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup1Price()+"")%>"/><br/>
                                                    Nhóm 02:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n2priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup2Price()+"")%>"/><br/>
                                                    Nhóm 03:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n3priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup3Price()+"")%>"/><br/>
                                                    Nhóm 04:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n4priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup4Price()+"")%>"/><br/>
                                                </div>
                                            </td>
                                            <td colspan="1">
                                                <div class="sppOldQc<%=i%>" style="display: none">
                                                    Nhóm 05:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n5priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup5Price()+"")%>"/><br/>
                                                    Nhóm 06:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n6priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup6Price()+"")%>"/><br/>
                                                    Nhóm 07:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n7priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup7Price()+"")%>"/><br/>
                                                    Nhóm 08:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n8priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup8Price()+"")%>"/><br/>
                                                </div>
                                            </td>
                                            <td colspan="1">
                                                <div class="sppOldQc<%=i%>" style="display: none">
                                                    Nhóm 09:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n9priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup9Price()+"")%>"/><br/>
                                                    Nhóm 10:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n10priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup10Price()+"")%>"/><br/>
                                                    Nhóm 11:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n11priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup11Price()+"")%>"/><br/>
                                                    Nhóm 12:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n12priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup12Price()+"")%>"/><br/>
                                                </div>
                                            </td>
                                            <td colspan="1">
                                                <div class="sppOldQc<%=i%>" style="display: none">
                                                    Nhóm 13:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n13priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup13Price()+"")%>"/><br/>
                                                    Nhóm 14:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n14priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup14Price()+"")%>"/><br/>
                                                    Nhóm 15:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n15priceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroup15Price()+"")%>"/><br/>
                                                    Nhóm LC:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="nlcpriceQc<%=i%>" size="5" value="<%=Tool.dinhDangTienTe(pt.getGroupLCPrice()+"")%>"/><br/>
                                                </div>
                                            </td>
                                            <td colspan="4"></td>
                                        </tr>
                                    <%
                                        }
                                    %>
                                    <tr>
                                        <td colspan="12" align="center">
                                            <input class="button" type="submit" name="submit" value="Cập nhật"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/provider/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
                </div>  
                <div class="clear"></div>
            </div>
            <%@include file="/admin/includes/footer.jsp" %>
        </div>
    </body>
</html>