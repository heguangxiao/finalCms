<%@page import="java.io.InputStream"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="javax.ws.rs.core.MediaType"%>
<%@page import="gk.myname.vn.entity.JSONUtil"%>
<%@page import="com.fasterxml.jackson.core.JsonGenerator"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="java.util.HashMap"%>
<%@page import="gk.myname.vn.entity.RouteTable"%><%@page import="java.io.Reader"%><%@page import="java.io.InputStreamReader"%><%@page import="java.io.BufferedReader"%><%@page import="java.net.HttpURLConnection"%><%@page import="java.net.URL"%><%@page import="java.io.IOException"%><%@page import="java.net.URLEncoder"%><%@page import="java.util.LinkedHashMap"%><%@page import="java.util.Map"%><%@page import="gk.myname.vn.utils.SMSUtils"%><%@page import="gk.myname.vn.utils.DateProc"%><%@page import="java.util.Collection"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="gk.myname.vn.config.MyContext"%><%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.entity.BrandLabel"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "Test tin"); %>
        <%@include file="/admin/includes/header.jsp" %>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/admin/resource/select2/select2.css" />
        <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2_locale_vi.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/js/utilities.js"></script>
    </head>
    <body onLoad="timer();">
        <%
            String userSender = "";
            String alertMsg = "";
            if (request.getParameter("submit") != null) {
                userSender = RequestTool.getString(request, "userSender");
                int brandId = RequestTool.getInt(request, "brandId");
                int dataEncode = RequestTool.getInt(request, "endCode", 0);
                String phone = RequestTool.getString(request, "phone");
                String mtSend = RequestTool.getString(request, "mtSend");
                String url_call = RequestTool.getString(request, "url_call");
                String sendTime = "";
                // --
                Account acc = Account.getAccount(userSender);
                BrandLabel brand = new BrandLabel().getById(brandId);
                if (acc != null) {
                    if (brandId == 0) {
                        session.setAttribute("mess", "Bạn chưa chọn một Brand để gửi đi...");
                    } else {
                        String[] arrPhone = phone.split(",");
                        if (arrPhone != null && arrPhone.length <= 3) {
                            ArrayList<String> listImport = SMSUtils.validList(phone);
                            ///--
                            RequestTool.debugParam(request);
                            for (String onePhone : listImport) {                                    
                                String msg = doPostJson(acc.getUserName(), acc.getPassSend(), onePhone, brand.getBrandLabel(), mtSend,dataEncode, sendTime, url_call);
                                alertMsg+= msg + "<br/>";
                            }
                            session.setAttribute("mess", alertMsg + "<br/>Không biết Add thành công hay ko - Xem nhận được chưa?");
                        } else {
                            session.setAttribute("mess", "Chưa nhập số điện thoại hoặc test nhiều hơn 3 số...");
                        }
                    }
                } else {
                    session.setAttribute("mess", "Không lấy được thông tin CP để gửi...");
                }
            }
        %>
        <%-- JSP DATA --%>
        <%!            static final ObjectMapper mapper = new ObjectMapper(); 
            String doPostJson(String username, String password, String msisdn, String brand, String msgbody, int dataEncode, String sendTime,String url_call) {
                String result = "Error";
                try {
                    String seqid = brand + "-" + msisdn + "-" + System.nanoTime();
//            String seqid = "";
                    Map dataMap = new HashMap();
                    dataMap.put("user", username);
                    dataMap.put("pass", password);
                    dataMap.put("tranId", seqid);
                    dataMap.put("brandName", brand);
                    dataMap.put("phone", msisdn);
                    dataMap.put("mess", msgbody);
                    dataMap.put("dataEncode", dataEncode);
                    dataMap.put("sendTime", sendTime);
                    mapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
                    String strJson = mapper.writeValueAsString(dataMap);
                    //--
//            System.out.println("doGetJson: " + jobj.toString());
                    String data = strJson;
//            data = JSONUtil.escape(data);
//                    System.out.println("escape param:" + data);
//                    System.out.println("unescape param:" + JSONUtil.unescape(data));
                    HttpURLConnection conn = null;
                    try {
                        //Create connection
                        URL url = new URL(url_call);
                        conn = (HttpURLConnection) url.openConnection();
                        conn.setRequestMethod("POST");
                        conn.setRequestProperty("accept", MediaType.APPLICATION_JSON);
                        conn.setRequestProperty("Content-Type", MediaType.APPLICATION_JSON);
                        conn.setUseCaches(false);
                        conn.setDoOutput(true);
                        try ( //Send request
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
                        } // or StringBuffer if not Java 5+
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
                        <!-- Tìm kiếm-->
                        <div align="center" style="height: auto;margin-bottom: 2px; color: red;font-weight: bold">
                            <%                                
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <form name="frmSend" action="" method="post">
                            <table id="rounded-corner" align="center" >
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded"></th>
                                        <th colspan="2" scope="col" class="rounded-q4"><b>Gửi Tin Nhắn Test</b></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Khách Hàng</td>
                                        <td>
                                            <%
                                                ArrayList<Account> allCp = Account.getAllCP();
                                                if (allCp != null && !allCp.isEmpty()) {
                                            %>
                                            <select style="width: 400px" onchange="changeCP()" id="_userSender" name="userSender">
                                                <option value="">Tất cả</option>
                                                <%
                                                    for (Account oneAcc : allCp) {
                                                        if (!Tool.checkNull(oneAcc.getCpCode()) && oneAcc.getStatus() == Account.STATUS.ACTIVE.val) {
                                                %>
                                                <option <%=(oneAcc.getUserName().equals(userSender)) ? "selected ='selected'" : ""%>
                                                    value="<%=oneAcc.getUserName()%>"
                                                    img-data="<%=(oneAcc.getStatus() == 1 ? "" : request.getContextPath()+"/admin/resource/images/lock1.png")%>" >[<%=oneAcc.getUserName()%>] <%=oneAcc.getFullName()%></option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                            <%
                                                }
                                            %>
                                        </td>

                                    </tr>

                                    <tr>
                                        <td>Label</td>                            
                                        <td>
                                            <select onchange="changeBrand()" style="width: 280px" id="_label" name="brandId">
                                                <option value="">Tất cả</option>
                                                <%ArrayList<BrandLabel> allLabel = BrandLabel.getAll();
                                                    for (BrandLabel one : allLabel) {
                                                %>
                                                <option brand_id="<%=one.getId()%>" user_owner="<%=one.getUserOwner()%>" value="<%=one.getId()%>"><%=one.getBrandLabel()%> &nbsp;&nbsp;[<%=one.getUserOwner()%>] <%=one.getStatus() == 1 ? "" : "[Lock]"%></option>
                                                <%
                                                    }
                                                %>
                                            </select>                                          
                                        </td>                                        
                                    </tr>
                                    <tr>
                                        <td>Hướng Gửi</td>
                                        <td id="showRoute"></td>
                                    </tr>
                                    <tr>
                                        <td>NODE TEST</td>                            
                                        <td>
                                            <select name="url_call">
<!--                                                <option value="http://127.0.0.1:9981/service/sms_api">NODE 1 Campagin - SV1</option>
                                                <option value="http://127.0.0.1:9982/service/sms_api">NODE 2 - SV1</option>
                                                <option value="http://127.0.0.1:9986/service/sms_api">NODE 5 - SV1</option>
                                                <option value="http://10.221.11.11:9983/service/sms_api">NODE 3 - SV2</option>
                                                <option value="http://10.221.11.11:9984/service/sms_api">NODE 4 - SV2</option>-->
                                                <option value="http://127.0.0.1:9981/service/sms_api">NODE DEV - SV1</option>
                                            </select>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            Data Encode
                                            <select name="endCode" id="endCode">
                                                <option value="0">Không dấu</option>
                                                <option value="1">Có dấu</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Số điện thoại(Max 3 Số - Cách nhau bởi dấu ,)</td>                            
                                        <td>
                                            <input size="80" type="text" name="phone"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nội dung tin nhắn
                                            <br/><br/>Số ký tự còn lại: 
                                            (<span style="color: red" id="smsInfo">765
                                            </span>)<br/>
                                            <br/>Số ký tự đã dùng: 
                                            <span style="color: blue" id="useLength">0</span>
                                            <br/>
                                            <br/>
                                            <span style="font-weight: bold;color: red;margin-left: 20px" id="smsInfoLength">0 SMS</span>
                                        </td>                            
                                        <td>
                                            <span class="label label-warning" id="warnningStr">(Nội dung tin nhắn tối đa 765 ký tự tương đương 5 SMS)</span><br/><br/>
                                            <textarea class="span11" onkeyup="checkLength(maxLen, this, 'smsInfo')" id="_content_sms" cols="95" rows="5" name="mtSend"></textarea>
                                            <br/>
                                            <span style="font-weight: bold;color: red;margin-left: 20px" id="unicodeInfo"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <input class="button" type="submit" name="submit" value="Gửi thử"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                        <!--End tim kiếm-->
                    </div><!-- end of right content-->
                </div>   <!--end of center content -->
                <div class="clear"></div>
            </div> <!--end of main content-->
            <%@include file="/admin/includes/footer.jsp" %>
        </div>
        <script type="text/javascript" language="javascript">
            var maxLen = 765;
            function checkLength(maxLen, ele, el_err) {
                var isUnicode = false, isGSM = true;
                var ctent = $(ele).val();
                var a = document.getElementById('_content_sms').value;
                var num = a.length;
                isGSM = isGSMAlphabet(a);
                for (var charPos = 0; charPos < num ; charPos++) {
                    if (a.charCodeAt(charPos) > 127 && a[charPos] !== "€") {
                        isUnicode = true;
                        break;
                    }
                }
                
                $("#unicodeInfo").html(!isGSM ? 'Có ký tự không phải GSM encode' : isUnicode ? 'Có ký tự unicode!' : '');
                
                var lines = a.split(/\r\n|\r|\n/).length - 1;
                var curentLen = countLength(a) + lines;                        
                
                if(isGSM){
                    if (isUnicode) {
                        document.getElementById('warnningStr').innerHTML = '(Nội dung tin nhắn tối đa 335 ký tự tương đương 5 SMS)';
                        document.getElementById('endCode').value = '1';
                        
                        if (curentLen <= 70) {
                            $("#smsInfoLength").html('1 SMS');
                        } else {
                            if (67 < curentLen && curentLen <= 134) {
                                $("#smsInfoLength").html('2 SMS');
                            } else if (curentLen > 134 && curentLen <= 201) {
                                $("#smsInfoLength").html('3 SMS');
                            } else if (curentLen > 201 && curentLen <= 268) {
                                $("#smsInfoLength").html('4 SMS');
                            } else if (curentLen > 268 && curentLen <= 335) {
                                $("#smsInfoLength").html('5 SMS');
                            } else {
                                $("#smsInfoLength").html('Invalid Message Length');
                            }
                        } 
                    } else {
                        document.getElementById('endCode').value = '0';
                        document.getElementById('warnningStr').innerHTML = '(Nội dung tin nhắn tối đa 765 ký tự tương đương 5 SMS)';

                        if (curentLen <= 160) {
                            $("#smsInfoLength").html('1 SMS');
                        } else {
                            if (153 < curentLen && curentLen <= 306) {
                                $("#smsInfoLength").html('2 SMS');
                            } else if (curentLen > 306 && curentLen <= 459) {
                                $("#smsInfoLength").html('3 SMS');
                            } else if (curentLen > 459 && curentLen <= 612) {
                                $("#smsInfoLength").html('4 SMS');
                            } else if (curentLen > 612 && curentLen <= 765) {
                                $("#smsInfoLength").html('5 SMS');
                            } else {
                                $("#smsInfoLength").html('Invalid Message Length');
                            }
                        }
                    }
                }else{
                    document.getElementById('warnningStr').innerHTML = '(Nội dung tin nhắn tối đa 335 ký tự tương đương 5 SMS)';
                    document.getElementById('endCode').value = '1';
                    if (curentLen <= 70) {
                        $("#smsInfoLength").html('1 SMS');
                    } else {
                        if (67 < curentLen && curentLen <= 134) {
                            $("#smsInfoLength").html('2 SMS');
                        } else if (curentLen > 134 && curentLen <= 201) {
                            $("#smsInfoLength").html('3 SMS');
                        } else if (curentLen > 201 && curentLen <= 268) {
                            $("#smsInfoLength").html('4 SMS');
                        } else if (curentLen > 268 && curentLen <= 335) {
                            $("#smsInfoLength").html('5 SMS');
                        } else {
                            $("#smsInfoLength").html('Invalid Message Length');
                        }
                    }
                }
                $("#useLength").html(curentLen);
                
                if(isGSM){
                    if (isUnicode) {
                        if (curentLen > 335) {
                            var subctent = (ctent).substr(0, 335 - lines);
                            $(ele).val(subctent);
                            jAlert('Bạn đang nhập quá số ký tự tối đa cho phép');
                        }
                        $("#" + el_err).html(335 - curentLen);                        
                    } else {
                        if (curentLen > maxLen) {
                            var subctent = (ctent).substr(0, 765 - lines);
                            $(ele).val(subctent);
                            jAlert('Bạn đang nhập quá số ký tự tối đa cho phép');
                        }
                        $("#" + el_err).html(765 - curentLen);
                    }
                }else{
                    if (curentLen > 335) {
                        var subctent = (ctent).substr(0, 335 - lines);
                        $(ele).val(subctent);
                        jAlert('Bạn đang nhập quá số ký tự tối đa cho phép');
                    }
                    $("#" + el_err).html(335 - curentLen);
                }
                
                
            }
            function countLength(mess) {
                var smsLength = 0;
                for (var charPos = 0; charPos < mess.length; charPos++) {
                    switch (mess[charPos]) {
                        case "[":
                        case "]":
                        case "\\":
                        case "^":
                        case "{":
                        case "}":
                        case "|":
                        case "€":
                        case "~":
                            smsLength += 2;
                            break;
                        default:
                            smsLength += 1;
                    }
                }
                return smsLength;
            }
            function timer() {
                setInterval(checkLength, 500);
            }
            $(document).ready(function () {
                $("#_userSender").select2({
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
                        var opt = $("#_userSender option:selected");
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

            function changeBrand() {
                var selectBr = $("#_label option:selected");
                if (selectBr.val() !== "") {
                    var user = selectBr.attr("user_owner");
                    var url = "<%= request.getContextPath()%>/admin/statistic/ajax/list-cp.jsp?user=" + user;
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_userSender");

                    $("#_userSender").select2('val', user);
                     
                    var brand_name = selectBr.attr("brand_name");
                    var user_owner = selectBr.attr("user_owner");
                    var url = "<%= request.getContextPath()%>/admin/brand/getRouteTable.jsp?br_name=" + brand_name + "&user=" + user_owner;
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "showRoute");
                } else {
                    var url = "<%= request.getContextPath()%>/admin/statistic/ajax/list-cp.jsp?user=" + user;
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_userSender");
                    $("#_userSender").select2('val', "");
                }
            }
            function changeCP() {
                var selectBr = $("#_userSender option:selected");
                var user = selectBr.val();
                if (user !== "") {
                    var url = "<%= request.getContextPath()%>/admin/statistic/ajax/listBrand.jsp?user=" + user;
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_label");
                } else {
                    var url = "<%= request.getContextPath()%>/admin/statistic/ajax/listBrand.jsp?user=0";
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_label");
                }
                $("#_label").select2("val", "");
            }
        </script>
    </body>
</html>