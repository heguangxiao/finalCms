<%@page import="gk.myname.vn.config.MyContext"%>
<%@page import="gk.myname.vn.entity.CustodyMessage"%>
<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.admin.MoneyAddLog"%>
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
<%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.admin.AccountRole"%><%@page import="gk.myname.vn.entity.PartnerManager"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <% session.setAttribute("title", "Trừ tiền vào tài khoản"); %>
        <%@include file="/admin/includes/header.jsp" %>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/admin/resource/css/jquery-ui-1.8.16.custom.css">
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.core.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.position.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.widget.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.autocomplete.min.js"></script>
        <script type ='text/javascript'>
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
            
            BillingAcc admDao = new BillingAcc();
            BillingAcc oneAccount = null;

            if (request.getParameter("submit") != null) {
                //----------Log--------------
                String accountname = Tool.validStringRequest(request.getParameter("accountname"));
                if (accountname.equals("0")) {
                    session.setAttribute("mess", "Bạn chưa chọn tài khoản thụ hưởng");
                    response.sendRedirect(request.getContextPath() + "/admin/billing/minusMoney.jsp");
                    return;
                }
                int moneyAdd = Tool.string2Integer(request.getParameter("moneyadd"), 0);
                String notecomment = request.getParameter("notecomment");
                //Call API cong tien
                String urlCallApi = MyContext.URL_SERVER;
                
                CustodyMessage cm = new CustodyMessage();
                cm.setUserapi(userlogin.getUserName());
                cm.setCommand(CustodyMessage.TOPDOWN_ACTION);
                cm.setKeyapi(CustodyMessage.TOPDOWN_KEY);

                cm.setUsername(accountname);
                cm.setMoney(moneyAdd);
                cm.setNoted(notecomment);
                
                String addMoneyAPI = doPostJson(cm, MyContext.URL_SERVER);

                int resultAdd = Tool.string2Integer(addMoneyAPI, 0);
                
                if (resultAdd == 1) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                        UserAction.TABLE.accounts.val,
                        UserAction.TYPE.EDIT.val,
                        UserAction.RESULT.SUCCESS.val,
                        "App Trả Về 1");
                    log.logAction(request);

                    session.setAttribute("mess", "App đang xử lý trừ tiền cho tài khoản " + accountname);
                } else {
                    UserAction log = new UserAction(userlogin.getUserName(),
                        UserAction.TABLE.accounts.val,
                        UserAction.TYPE.EDIT.val,
                        UserAction.RESULT.FAIL.val,
                        "Call App Trả Về Khác 1 : " +addMoneyAPI);
                    log.logAction(request);

                    session.setAttribute("mess", "Server đang bảo trì, vui lòng quay lại sau. Thanks! ");
                }
                
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
                            <%if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }%>
                        </div>
                        <form action="" method="post">
                            <table align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th colspan="4" style="font-weight: bold"  scope="col" class="rounded">Trừ tiền cho tài khoản </th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    
                                    <tr>
                                        <td></td>
                                        <td align="left">Chọn tài khoản:</td>
                                        <td colspan="5">
                                            <select class="select3" style="width: 400px" name="accountname" id="_cp_code">
                                                <option value="0">-- Chọn tài khoản Sở hữu --</option>
                                                <%
                                                    ArrayList<BillingAcc> allCp = BillingAcc.getAllPrepaid();
                                                    for (BillingAcc one : allCp) {
                                                        if (one.getStatus() != Account.STATUS.ACTIVE.val) {
                                                            continue;
                                                        };
                                                %>
                                                <option value="<%=one.getUsername()%>" 
                                                    img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>" > [<%=one.getUsername()%>] <%=one.getFullname()%> </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Số tiền:</td>
                                        <td colspan="5">
                                            <input onkeyup="this.value=FormatNumber(this.value);" type="text" name="moneyadd" value=""/>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td></td>
                                        <td align="left">Ghi chú:</td>
                                        <td colspan="5">
                                            <textarea name="notecomment"></textarea>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="7" align="center">
                                            <input class="button" type="submit" name="submit" value="Trừ tiền"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/billing/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
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