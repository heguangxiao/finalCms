<%@page import="gk.myname.vn.config.MyContext"%>
<%@page import="gk.myname.vn.entity.CustodyMessage"%>
<%@page import="gk.myname.vn.entity.CheckCampaign"%>
<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.entity.PriceTelcoDb"%>
<%@page import="gk.myname.vn.admin.PriceTelco"%>
<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="javax.ws.rs.core.MediaType"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="com.fasterxml.jackson.core.JsonGenerator"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="gk.myname.vn.admin.BillingAcc"%>
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
            $(document).ready(function () {
                $(".select3").select2({
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
                        var opt = $(".select3 option:selected");
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
                    var strphanthapphan = strTemp.substring(strTemp.lastIndexOf("."), strTemp.length);
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
            function showP(name) {
                document.getElementById('show'+name).style.display = 'none';
                document.getElementById('hide'+name).style.display = '';
                for (let el of document.querySelectorAll('.price'+name)) el.style.display = '';
            }

            function hideP(name) {
                document.getElementById('show'+name).style.display = '';
                document.getElementById('hide'+name).style.display = 'none';
                for (let el of document.querySelectorAll('.price'+name)) el.style.display = 'none';
            }

        </SCRIPT>
    </head>
    <body>
        <%
            if (!userlogin.checkEdit(request)) {                
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.REJECT.val,
                                "Permit deny!");
                log.logAction(request);
                session.setAttribute("mess", "Bạn không có quyền thêm module này!");
                response.sendRedirect(request.getContextPath() + "/admin/billing/index.jsp");
                return;
            }
            String message = "";
            String account = Tool.validStringRequest(request.getParameter("account"));
            BillingAcc admDao = new BillingAcc();
            BillingAcc oneAccount = null;
            oneAccount = admDao.getByUsernameHaveID(account);
                        
            if (oneAccount == null) {               
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.REJECT.val,
                                "Yêu cầu không hợp lệ. Không lấy được thông tin tài khoản!");
                log.logAction(request);
                session.setAttribute("mess", "Yêu cầu không hợp lệ. Không lấy được thông tin tài khoản");
                response.sendRedirect(request.getContextPath() + "/admin/billing/index.jsp");
                return;
            }
            
            if (CheckCampaign.existsByUserSenderInMsgBrandAdsQueue(account)) {
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.FAIL.val,
                                "Tài khoản có chiến dịch quảng cáo đang chờ chạy nên không thể sửa!");
                log.logAction(request);
                session.setAttribute("mess", "Tài khoản có chiến dịch quảng cáo đang chờ chạy nên không thể sửa!");
                response.sendRedirect(request.getContextPath() + "/admin/billing/index.jsp");
                return;
                
            }
            
            if (CheckCampaign.existsByUserSenderInMsgBrandCustomer(account)) {            
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.accounts.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.FAIL.val,
                                "Tài khoản có tin hoặc chiến dịch chăm sóc khách hàng đang chờ chạy nên không thể sửa!");
                log.logAction(request);
                session.setAttribute("mess", "Tài khoản có tin hoặc chiến dịch chăm sóc khách hàng đang chờ chạy nên không thể sửa!");
                response.sendRedirect(request.getContextPath() + "/admin/billing/index.jsp");
                return;
                
            }
            
            ArrayList<PriceTelcoDb> ptdsCSKH = PriceTelcoDb.getAllWithAccIdAndUserForCskh(oneAccount.getUsername(), oneAccount.getId());
            ArrayList<PriceTelcoDb> ptdsQC = PriceTelcoDb.getAllWithAccIdAndUserForQc(oneAccount.getUsername(), oneAccount.getId());
            
            ArrayList<Telco_Nations> allT = Telco_Nations.getTelco_na();
            
            int price, n1price, n2price, n3price, n4price, n5price, n6price, n7price, n8price, n9price, n10price, n11price, n12price, n13price, n14price, n15price, nlcprice;
            PriceTelco priceTelco = new PriceTelco();
            PriceTelcoDb priceTelcoDb = new PriceTelcoDb();
            PriceTelcoDb dao = new PriceTelcoDb();

            if (request.getParameter("submit") != null) {
                int resultAdd = 0;
                //----------Log--------------
                String accountname = Tool.validStringRequest(request.getParameter("accountname"));
                int prepaid = Tool.string2Integer(request.getParameter("prepaid"), 0);
                int monthlyActivePrice = Tool.string2Integer(request.getParameter("monthlyprice"), 0);
                int alarmmoney = Tool.string2Integer(request.getParameter("alarmmoney"), 0);

                oneAccount.setPrepaid(prepaid);
                oneAccount.setMonthly_price_active(monthlyActivePrice);
                oneAccount.setAlarmmoney(alarmmoney);

                if (prepaid == 1) {
                    String urlCallApi = MyContext.URL_SERVER;
                    CustodyMessage cm = new CustodyMessage();
                    cm.setUserapi(userlogin.getUserName());
                    cm.setCommand(CustodyMessage.RELOAD_ACTION);
                    cm.setKeyapi(CustodyMessage.RELOAD_KEY);

                    cm.setUsername(oneAccount.getUsername());

                    String addMoneyAPI = doPostJson(cm, MyContext.URL_SERVER);
                    resultAdd = Tool.string2Integer(addMoneyAPI, 0);
                }
                if (resultAdd == 1) {
                    if (admDao.addPrice(oneAccount)) {               
                        UserAction log = new UserAction(userlogin.getUserName(),
                            UserAction.TABLE.accounts.val,
                            UserAction.TYPE.EDIT.val,
                            UserAction.RESULT.SUCCESS.val,
                            "Sửa thông tin billing của tài khoản "+oneAccount.getUsername()+" thành công!");
                        log.logAction(request);
                        message += "Sửa tài khoản thành công <br/>";
                        //Call API thong bao billing cap nhat thong tin acc de billing khi trang thai la tra truoc

                        for (int i = 1; i < ( ptdsCSKH.size() + 1 ); i++) {
                            String telco = Tool.validStringRequest(request.getParameter("telco"+i));
                            priceTelcoDb = dao.getbyId(ptdsCSKH.get(i-1).getId());
                            if (!telco.equals("")) {  

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

                                if (!priceTelcoDb.getPriceCskh().equals(priceTelco.toJson())) {
                                    priceTelcoDb.setPriceCskh(priceTelco.toJson());                            
                                    if (dao.updatePriceTelco(priceTelcoDb)) {
                                        message += "cập nhật giá bán cskh mạng " + ptdsCSKH.get(i-1).getTelcoCode() + " của account " + oneAccount.getUsername() + " thành công <br/>";
                                        log = new UserAction(userlogin.getUserName(),
                                            "route_nation_telco",
                                            UserAction.TYPE.EDIT.val,
                                            UserAction.RESULT.SUCCESS.val,
                                            "cập nhật giá bán cskh mạng " + ptdsCSKH.get(i-1).getTelcoCode() + " của account " + oneAccount.getUsername() + " thành công <br/>");
                                        log.logAction(request);
                                    }
                                }
                            } else {
                                priceTelcoDb.setPriceCskh("");
                                if (dao.updatePriceTelco(priceTelcoDb)) {
                                    message += "đã xóa giá bán cskh mạng " + ptdsCSKH.get(i-1).getTelcoCode() + " của account " + oneAccount.getUsername() + " thành công <br/>";
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.DEL.val,
                                        UserAction.RESULT.SUCCESS.val,
                                        "đã xóa giá bán cskh mạng " + ptdsCSKH.get(i-1).getTelcoCode() + " của account " + oneAccount.getUsername() + " thành công <br/>");
                                    log.logAction(request);
                                }
                            }
                        }

                        String telcocskh = Tool.validStringRequest(request.getParameter("telco"));
                        if (!telcocskh.equals("")) {                
                            price = Tool.string2Integer(request.getParameter("price"), 0);
                            n1price = Tool.string2Integer(request.getParameter("n1price"), 0);
                            n2price = Tool.string2Integer(request.getParameter("n2price"), 0);
                            n3price = Tool.string2Integer(request.getParameter("n3price"), 0);
                            n4price = Tool.string2Integer(request.getParameter("n4price"), 0);
                            n5price = Tool.string2Integer(request.getParameter("n5price"), 0);
                            n6price = Tool.string2Integer(request.getParameter("n6price"), 0);
                            n7price = Tool.string2Integer(request.getParameter("n7price"), 0);
                            n8price = Tool.string2Integer(request.getParameter("n8price"), 0);
                            n9price = Tool.string2Integer(request.getParameter("n9price"), 0);
                            n10price = Tool.string2Integer(request.getParameter("n10price"), 0);
                            n11price = Tool.string2Integer(request.getParameter("n11price"), 0);
                            n12price = Tool.string2Integer(request.getParameter("n12price"), 0);
                            n13price = Tool.string2Integer(request.getParameter("n13price"), 0);
                            n14price = Tool.string2Integer(request.getParameter("n14price"), 0);
                            n15price = Tool.string2Integer(request.getParameter("n15price"), 0);
                            nlcprice = Tool.string2Integer(request.getParameter("nlcprice"), 0);

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

                            if (!dao.checkExistForAcc(telcocskh, oneAccount.getUsername(), oneAccount.getId())) {                             
                                priceTelcoDb.setTelcoCode(telcocskh);
                                priceTelcoDb.setPriceCskh(priceTelco.toJson());
                                priceTelcoDb.setType(0);
                                priceTelcoDb.setAccountId(oneAccount.getId());
                                priceTelcoDb.setAccUsername(oneAccount.getUsername());

                                if (dao.addPriceTelco(priceTelcoDb)) {
                                    message += "thêm mới giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " thành công <br/>";
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.ADD.val,
                                        UserAction.RESULT.SUCCESS.val,
                                        "thêm mới giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " thành công <br/>");
                                    log.logAction(request);
                                } else {
                                    message += "thêm mới giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " bị lỗi <br/>";
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.ADD.val,
                                        UserAction.RESULT.FAIL.val,
                                        "thêm mới giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " bị lỗi <br/>");
                                    log.logAction(request);
                                }
                            } else {
                                priceTelcoDb = dao.getbyTelcoAccIdAndUser(telcocskh, oneAccount.getUsername(), oneAccount.getId());
                                if (priceTelcoDb != null) {
                                    if (priceTelcoDb.getPriceCskh() == null || priceTelcoDb.getPriceCskh().equals("")) { 
                                        priceTelcoDb.setPriceCskh(priceTelco.toJson());
                                        if (dao.updatePriceTelco(priceTelcoDb)) {
                                            message += "bổ sung giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " thành công <br/>";
                                            log = new UserAction(userlogin.getUserName(),
                                                "route_nation_telco",
                                                UserAction.TYPE.EDIT.val,
                                                UserAction.RESULT.SUCCESS.val,
                                                "bổ sung giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " thành công <br/>");
                                            log.logAction(request);
                                        } else {
                                            message += "bổ sung giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " bị lỗi <br/>";
                                            log = new UserAction(userlogin.getUserName(),
                                                "route_nation_telco",
                                                UserAction.TYPE.EDIT.val,
                                                UserAction.RESULT.FAIL.val,
                                                "bổ sung giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " bị lỗi <br/>");
                                            log.logAction(request);
                                        }
                                    } else {
                                        message += "giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " đã có <br/>";
                                        log = new UserAction(userlogin.getUserName(),
                                            "route_nation_telco",
                                            UserAction.TYPE.ADD.val,
                                            UserAction.RESULT.FAIL.val,
                                            "giá bán cskh mạng " + telcocskh + " của account " + oneAccount.getUsername() + " đã có <br/>");
                                        log.logAction(request);
                                    }
                                }

                            }
                        }

                        for (int i = 1; i < ( ptdsQC.size() + 1 ); i++) {
                            String telco = Tool.validStringRequest(request.getParameter("telcoQc"+i));
                            priceTelcoDb = dao.getbyId(ptdsQC.get(i-1).getId());
                            if (!telco.equals("")) {  

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

                                if (!priceTelcoDb.getPriceQc().equals(priceTelco.toJson())) {
                                    priceTelcoDb.setPriceQc(priceTelco.toJson());
                                    if (dao.updatePriceTelco(priceTelcoDb)) {
                                        message += "cập nhật giá bán qc mạng " + ptdsQC.get(i-1).getTelcoCode() + " của account " + oneAccount.getUsername() + " thành công <br/>";
                                        log = new UserAction(userlogin.getUserName(),
                                            "route_nation_telco",
                                            UserAction.TYPE.EDIT.val,
                                            UserAction.RESULT.SUCCESS.val,
                                            "cập nhật giá bán qc mạng " + ptdsQC.get(i-1).getTelcoCode() + " của account " + oneAccount.getUsername() + " thành công <br/>");
                                        log.logAction(request);
                                    }
                                }
                            } else {
                                priceTelcoDb.setPriceQc("");
                                if (dao.updatePriceTelco(priceTelcoDb)) {
                                    message += "đã xóa giá bán qc mạng " + ptdsQC.get(i-1).getTelcoCode() + " của account " + oneAccount.getUsername() + " thành công <br/>";
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.DEL.val,
                                        UserAction.RESULT.SUCCESS.val,
                                        "đã xóa giá bán qc mạng " + ptdsQC.get(i-1).getTelcoCode() + " của account " + oneAccount.getUsername() + " thành công <br/>");
                                    log.logAction(request);
                                }
                            }
                        }

                        String telcoqc = Tool.validStringRequest(request.getParameter("telcoQc"));
                        if (!telcoqc.equals("")) {                
                            price = Tool.string2Integer(request.getParameter("priceQc"), 0);
                            n1price = Tool.string2Integer(request.getParameter("n1priceQc"), 0);
                            n2price = Tool.string2Integer(request.getParameter("n2priceQc"), 0);
                            n3price = Tool.string2Integer(request.getParameter("n3priceQc"), 0);
                            n4price = Tool.string2Integer(request.getParameter("n4priceQc"), 0);
                            n5price = Tool.string2Integer(request.getParameter("n5priceQc"), 0);
                            n6price = Tool.string2Integer(request.getParameter("n6priceQc"), 0);
                            n7price = Tool.string2Integer(request.getParameter("n7priceQc"), 0);
                            n8price = Tool.string2Integer(request.getParameter("n8priceQc"), 0);
                            n9price = Tool.string2Integer(request.getParameter("n9priceQc"), 0);
                            n10price = Tool.string2Integer(request.getParameter("n10priceQc"), 0);
                            n11price = Tool.string2Integer(request.getParameter("n11priceQc"), 0);
                            n12price = Tool.string2Integer(request.getParameter("n12priceQc"), 0);
                            n13price = Tool.string2Integer(request.getParameter("n13priceQc"), 0);
                            n14price = Tool.string2Integer(request.getParameter("n14priceQc"), 0);
                            n15price = Tool.string2Integer(request.getParameter("n15priceQc"), 0);
                            nlcprice = Tool.string2Integer(request.getParameter("nlcpriceQc"), 0);

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

                            if (!dao.checkExistForAcc(telcoqc, oneAccount.getUsername(), oneAccount.getId())) {                             
                                priceTelcoDb.setTelcoCode(telcoqc);
                                priceTelcoDb.setPriceQc(priceTelco.toJson());
                                priceTelcoDb.setType(0);
                                priceTelcoDb.setAccountId(oneAccount.getId());
                                priceTelcoDb.setAccUsername(oneAccount.getUsername());

                                if (dao.addPriceTelco(priceTelcoDb)) {
                                    message += "thêm mới giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " thành công <br/>";
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.ADD.val,
                                        UserAction.RESULT.SUCCESS.val,
                                        "thêm mới giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " thành công <br/>");
                                    log.logAction(request);
                                } else {
                                    message += "thêm mới giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " bị lỗi <br/>";
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.ADD.val,
                                        UserAction.RESULT.FAIL.val,
                                        "thêm mới giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " bị lỗi <br/>");
                                    log.logAction(request);
                                }
                            } else {
                                priceTelcoDb = dao.getbyTelcoAccIdAndUser(telcoqc, oneAccount.getUsername(), oneAccount.getId());
                                if (priceTelcoDb != null) {
                                    if (priceTelcoDb.getPriceQc() == null || priceTelcoDb.getPriceQc().equals("")) { 
                                        priceTelcoDb.setPriceQc(priceTelco.toJson());
                                        if (dao.updatePriceTelco(priceTelcoDb)) {
                                            message += "bổ sung giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " thành công <br/>";
                                            log = new UserAction(userlogin.getUserName(),
                                                "route_nation_telco",
                                                UserAction.TYPE.ADD.val,
                                                UserAction.RESULT.SUCCESS.val,
                                                "bổ sung giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " thành công <br/>");
                                            log.logAction(request);
                                        } else {
                                            message += "bổ sung giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " bị lỗi <br/>";
                                            log = new UserAction(userlogin.getUserName(),
                                                "route_nation_telco",
                                                UserAction.TYPE.ADD.val,
                                                UserAction.RESULT.FAIL.val,
                                                "bổ sung giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " bị lỗi <br/>");
                                            log.logAction(request);
                                        }
                                    } else {
                                        message += "giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " đã có <br/>";
                                        log = new UserAction(userlogin.getUserName(),
                                            "route_nation_telco",
                                            UserAction.TYPE.ADD.val,
                                            UserAction.RESULT.FAIL.val,
                                            "giá bán qc mạng " + telcoqc + " của account " + oneAccount.getUsername() + " đã có <br/>");
                                        log.logAction(request);
                                    }
                                }

                            }
                        }
                    } else {
                        message = "Sửa tài khoản lỗi.";
                    }
                } else {
                    message = "Server đang bảo trì, vui lòng quay lại sau.";
                }

                session.setAttribute("mess", message);
                response.sendRedirect(request.getContextPath() + "/admin/billing/index.jsp");
                return;
            }
        %>
        <%-- JSP DATA --%>
        <%!            
            static final ObjectMapper mapper = new ObjectMapper(); 
            String doPostJson(CustodyMessage cm,String url_call) {
                String result = "Error";
                try {
                    mapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);

                    String data = cm.toJsonStr();

                    HttpURLConnection conn = null;
                    try {

                        URL url = new URL(url_call);

                        conn = (HttpURLConnection) url.openConnection();
                        conn.setRequestMethod("POST");
                        conn.setRequestProperty("accept", MediaType.APPLICATION_JSON);
                        conn.setRequestProperty("Content-Type", MediaType.APPLICATION_JSON);
                        conn.setUseCaches(false);
                        conn.setDoOutput(true);

                        try ( 
                            //Send request
                            DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
                            wr.writeBytes(data);
                        }

                        //Get Response  
                        InputStream is = conn.getInputStream();
                        StringBuilder response;
                        try (BufferedReader rd = new BufferedReader(new InputStreamReader(is))) {
                            response = new StringBuilder(); // or StringBuffer if not Java 5+
                            String line;
                            while ((line = rd.readLine()) != null) {
                                response.append(line);
                                response.append('\r');
                            }
                        } 
                        // or StringBuffer if not Java 5+
                        result = response.toString();
                    } catch (Exception e) {
                        e.printStackTrace();
                        return null;
                    } finally {
                        if (conn != null) {
                            conn.disconnect();
                        }
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                return result;
            }

        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <div align="center" style="height: 20px;margin-bottom: 2px; color: red;font-weight: bold">
                            <%
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <form action="" method="post">
                            <table align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th colspan="1" class="rounded-company"></th>
                                        <th colspan="10" style="font-weight: bold">Cập nhật thông tin Đại lý </th>
                                        <th colspan="1" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="1" class="rounded-company"></td>
                                        <td colspan="10" style="font-weight: bold">Cập nhật thông tin Đại lý </td>
                                        <td colspan="1" class="rounded-q4"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="2" align="left">Tài khoản:</td>
                                        <td colspan="8">
                                            <input readonly type="text" name="accountname" value="<%=oneAccount.getUsername()%>"/>
                                        </td>
                                        <td colspan="1"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="2" align="left">Kiểu thanh toán:</td>
                                        <td colspan="8">
                                            <select name="prepaid" >
                                                <option <%=oneAccount.getPrepaid() == 0 ? "selected='selected'" : ""%> value="0">Trả sau</option>
                                                <option <%=oneAccount.getPrepaid() == 1 ? "selected='selected'" : ""%> value="1">Trả trước</option>
                                            </select>
                                        </td>
                                        <td colspan="1"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="2" align="left">Phí duy trì Brandname:</td>
                                        <td colspan="8">
                                            <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="monthlyprice" size="15" value="<%=Tool.dinhDangTienTe(oneAccount.getMonthly_price_active()+"")%>">
                                        </td>
                                        <td colspan="1"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="2" align="left">Mức cảnh báo tiền:</td>
                                        <td colspan="8">
                                            <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="alarmmoney" size="15" value="<%=Tool.dinhDangTienTe(oneAccount.getAlarmmoney()+"")%>">
                                        </td>
                                        <td colspan="1"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="2"><h3>Nhập giá bán tin CSKH</h3></td>
                                        <td colspan="8"></td>
                                        <td colspan="1">
                                            <div id="showPriceCskh" style="float: right">
                                                <img onclick="showP('PriceCskh')" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/>
                                            </div>
                                            <div id="hidePriceCskh" style="float: right;display: none">
                                                <img onclick="hideP('PriceCskh')" src="<%=request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px;"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        for (int i = 1; i < ( ptdsCSKH.size() + 1 ); i++) {
                                            PriceTelco pt = PriceTelco.json2Objec(ptdsCSKH.get(i-1).getPriceCskh());
                                    %>
                                        <tr>
                                            <td colspan="1"></td>
                                            <td colspan="1" align="left" class="boder_right">
                                                <select style="width: 150px" class="select3" name="telco<%=i%>">
                                                    <option value="">-- Chọn mạng --</option>
                                                    <%
                                                        for (Telco_Nations one : allT) {
                                                    %>
                                                    <option <%=(ptdsCSKH.get(i-1).getTelcoCode().equals(one.getTelco_code()) ? "selected='selected'" : "")%> 
                                                        value="<%=one.getTelco_code()%>" > [<%=one.getCountry_code()%>] <%=one.getTelco_name()%> </option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
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
                                    
                                    <tr class="pricePriceCskh" style="display: none">
                                        <td colspan="1"></td>
                                        <td colspan="1" align="left" class="boder_right">
                                            <select style="width: 150px" class="select3" name="telco">
                                                <option value="">-- Chọn mạng --</option>
                                                <%
                                                    for (Telco_Nations one : allT) {
                                                %>
                                                <option value="<%=one.getTelco_code()%>" > [<%=one.getCountry_code()%>] <%=one.getTelco_name()%> </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td colspan="1">
                                            Nhóm 0 :  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="price" size="5" value="<%=Tool.dinhDangTienTe("0")%>">
                                        </td>
                                        <td colspan="1">
                                            <div id="showPriceNewCskh" style="float: right">
                                                <img onclick="show('NewCskh')" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/>
                                            </div>
                                            <div id="hidePriceNewCskh" style="float: right;display: none">
                                                <img onclick="hide('NewCskh')" src="<%=request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px;"/></a>
                                            </div>
                                        </td>
                                        <td colspan="1">
                                            <div class="sppNewCskh" style="display: none">
                                                Nhóm 01:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n1price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 02:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n2price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 03:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n3price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 04:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n4price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                            </div>
                                        </td>
                                        <td colspan="1">
                                            <div class="sppNewCskh" style="display: none">
                                                Nhóm 05:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n5price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 06:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n6price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 07:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n7price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 08:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n8price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                            </div>
                                        </td>
                                        <td colspan="1">
                                            <div class="sppNewCskh" style="display: none">
                                                Nhóm 09:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n9price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 10:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n10price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 11:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n11price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 12:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n12price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                            </div>
                                        </td>
                                        <td colspan="1">
                                            <div class="sppNewCskh" style="display: none">
                                                Nhóm 13:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n13price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 14:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n14price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 15:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n15price" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm LC:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="nlcprice" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                            </div>
                                        </td>
                                        <td colspan="4"></td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="2"><h3>Nhập giá bán tin QC</h3></td>
                                        <td colspan="8"></td>
                                        <td colspan="1">
                                            <div id="showPriceQc" style="float: right">
                                                <img onclick="showP('PriceQc')" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/>
                                            </div>
                                            <div id="hidePriceQc" style="float: right;display: none">
                                                <img onclick="hideP('PriceQc')" src="<%=request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px;"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        for (int i = 1; i < ( ptdsQC.size() + 1 ); i++) {
                                            PriceTelco pt = PriceTelco.json2Objec(ptdsQC.get(i-1).getPriceQc());
                                    %>
                                        <tr>
                                            <td colspan="1"></td>
                                            <td colspan="1" align="left" class="boder_right">
                                                <select style="width: 150px" class="select3" name="telcoQc<%=i%>">
                                                    <option value="">-- Chọn mạng --</option>
                                                    <%
                                                        for (Telco_Nations one : allT) {
                                                    %>
                                                    <option <%=(ptdsQC.get(i-1).getTelcoCode().equals(one.getTelco_code()) ? "selected='selected'" : "")%> 
                                                        value="<%=one.getTelco_code()%>" > [<%=one.getCountry_code()%>] <%=one.getTelco_name()%> </option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
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
                                    <tr class="pricePriceQc" style="display: none">
                                        <td colspan="1"></td>
                                        <td colspan="1" align="left" class="boder_right">
                                            <select style="width: 150px" class="select3" name="telcoQc">
                                                <option value="">-- Chọn mạng --</option>
                                                <%
                                                    for (Telco_Nations one : allT) {
                                                %>
                                                <option value="<%=one.getTelco_code()%>" > [<%=one.getCountry_code()%>] <%=one.getTelco_name()%> </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td colspan="1">
                                            Nhóm 0 :  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>">
                                        </td>
                                        <td colspan="1">
                                            <div id="showPriceNewQc" style="float: right">
                                                <img onclick="show('NewQc')" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/>
                                            </div>
                                            <div id="hidePriceNewQc" style="float: right;display: none">
                                                <img onclick="hide('NewQc')" src="<%=request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px;"/></a>
                                            </div>
                                        </td>
                                        <td colspan="1">
                                            <div class="sppNewQc" style="display: none">
                                                Nhóm 01:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n1priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 02:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n2priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 03:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n3priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 04:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n4priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                            </div>
                                        </td>
                                        <td colspan="1">
                                            <div class="sppNewQc" style="display: none">
                                                Nhóm 05:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n5priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 06:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n6priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 07:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n7priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 08:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n8priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                            </div>
                                        </td>
                                        <td colspan="1">
                                            <div class="sppNewQc" style="display: none">
                                                Nhóm 09:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n9priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 10:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n10priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 11:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n11priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 12:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n12priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                            </div>
                                        </td>
                                        <td colspan="1">
                                            <div class="sppNewQc" style="display: none">
                                                Nhóm 13:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n13priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 14:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n14priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm 15:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="n15priceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                                Nhóm LC:  <input class="form-control" onkeyup="this.value=FormatNumber(this.value);" type="text" name="nlcpriceQc" size="5" value="<%=Tool.dinhDangTienTe("0")%>"/><br/>
                                            </div>
                                        </td>
                                        <td colspan="4"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="12" align="center">
                                            <input class="button" type="submit" name="submit" value="Cập nhật"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/billing/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
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