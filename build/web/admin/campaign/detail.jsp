<%@page import="java.util.Date"%>
<%@page import="gk.myname.vn.entity.Nations"%>
<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="gk.myname.vn.entity.Provider"%><%@page import="gk.myname.vn.entity.PartnerManager"%><%@page import="gk.myname.vn.utils.SMSUtils"%><%@page import="java.util.Calendar"%><%@page import="gk.myname.vn.utils.DateProc"%><%@page import="gk.myname.vn.entity.MsgBrandSubmit"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="gk.myname.vn.config.MyContext"%><%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.entity.BrandLabel"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%><%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "Lịch sử gửi tin nhắn QC"); %>
        <%@include file="/admin/includes/header.jsp" %>
        <script>
            var now = new Date();
            var month = now.getUTCMonth()-2;
            var year = now.getUTCFullYear();
            var str = year + '/' + month + '/' + 1;
            $(document).ready(function () {
                $('.dateproc').datetimepicker({
                    lang: 'vi',
                    timepicker: false,
                    format: 'd/m/Y',
                    formatDate: 'Y/m/d',
                    minDate: str, // yesterday is minimum date
                    maxDate: '+1970/01/02' // and tommorow is maximum date calendar
                });
                 $('.ItemPopup').showPopup({
                    top: 100,
                    closeButton: ".close_popup", //khai báo nút close cho popup
                    scroll: 0, //cho phép scroll khi mở popup, mặc định là không cho phép
                    width: 500,
                    height: 'auto',
                    closeOnEscape: true
                });
                
                $("#_provider").select2({
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
                        var opt = $("#_provider option:selected");
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
               
            });
            function validMonth() {
                var stRequest = $("#stRequest").val();
                var endRequest = $("#endRequest").val();
                var arrstRequest = stRequest.split("/");
                var arrendRequest = endRequest.split("/");
                if (stRequest !== "" && stRequest !== null) {
                    if (endRequest === "" || endRequest === null) {
                        jAlert("Bạn cần chọn ngày kết thúc...");
                        return false;
                    }
                    if (arrstRequest[1] !== arrendRequest[1]) {
                        jAlert("Bạn chỉ thống kê được dữ liệu từng tháng...");
                        return false;
                    }
                    if (arrstRequest[2] !== arrendRequest[2]) {
                        jAlert("Năm bạn chọn không hợp lệ...");
                        return false;
                    }
                }
            }
            function changeBrand() {
                var selectBr = $("#_label option:selected");
                if (selectBr.val() !== "") {
                    var user = selectBr.attr("user_owner");
                    var url = "<%=request.getContextPath()%>/admin/statistic/ajax/list-cp.jsp?user=" + user;
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_userSender");
                    $("#_userSender").select2('val', user);
                } else {
                    var url = "<%=request.getContextPath()%>/admin/statistic/ajax/list-cp.jsp?user=" + user;
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_userSender");
                    $("#_userSender").select2('val', "");
                }
            }
            function isBlank(str) {
                return (!str || /^\s*$/.test(str));
            }
            function changeCP() {
                var selectBr = $("#_userSender option:selected");
                var user = selectBr.val();
                if (user !== "") {
                    var url = "<%=request.getContextPath()%>/admin/statistic/ajax/listBrand.jsp?user=" + user;
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_label");
                } else {
                    var url = "<%=request.getContextPath()%>/admin/statistic/ajax/listBrand.jsp?user=0";
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_label");
                }
                $("#_label").select2("val", "");
            }
            
            function changeTelco(i) {
                var url = "<%=request.getContextPath()%>/admin/statistic/ajax/listTelco.jsp?code=" + i;
                AjaxAction(url, "telco");
            }
        </script>
<script type="text/javascript" language="javascript">
    function demtin(i) {        
        document.getElementById('showtin').innerHTML = i.length;
    }
</script>
        <%
            ArrayList<MsgBrandSubmit> all = new ArrayList<>();
            ArrayList<MsgBrandSubmit> all1 = null;
            ArrayList<MsgBrandSubmit> all2 = null;
            MsgBrandSubmit logDao = new MsgBrandSubmit();
            int currentPage = Tool.string2Integer(request.getParameter("page"), 1);
            if (currentPage < 1) {
                currentPage = 1;
            }
            int err_code = RequestTool.getInt(request, "err_code", -2);
            int type = RequestTool.getInt(request, "type", 1);
            int result = RequestTool.getInt(request, "result", -1);
            int bid = RequestTool.getInt(request, "_label");
            BrandLabel brLabel = BrandLabel.getFromCache(bid);
            //--
            String label = "";
            if (brLabel != null) {
                label = brLabel.getBrandLabel();
            }
            String phone = RequestTool.getString(request, "phone");
            int ltypeb = RequestTool.getInt(request, "ltypeb");
            
            String provider = RequestTool.getString(request, "provider");
            String telco = RequestTool.getString(request, "telco");
            String nation = RequestTool.getString(request, "nation");
            String stRequest = RequestTool.getString(request, "stRequest");
            if (Tool.checkNull(stRequest)) {
                stRequest = DateProc.createDDMMYYYY();
            }
            String endRequest = RequestTool.getString(request, "endRequest");
            if (Tool.checkNull(endRequest)) {
                endRequest = DateProc.createDDMMYYYY();
            }
            String tranId = RequestTool.getString(request, "tranId");
            String cp_code = RequestTool.getString(request, "cp_code");
            String userSender = RequestTool.getString(request, "userSender");
            all1 = logDao.getMsgSubmitLog2(currentPage, maxRow, userSender, cp_code, label, 1, result, provider, stRequest, endRequest, phone,
                    telco, err_code,tranId, nation, ltypeb);
            all2 = logDao.getMsgSubmitLog3(currentPage, maxRow, userSender, cp_code, label, 1, result, provider, stRequest, endRequest, phone,
                    telco, err_code,tranId, nation, ltypeb);
            for (MsgBrandSubmit elem : all1) {
                    all.add(elem);
                }
            for (MsgBrandSubmit elem : all2) {
                    all.add(elem);
                }
            int totalPage = 0;
            int totalRow1 = logDao.countMsgSubmitLog2(userSender, cp_code, label, 1, result, provider, stRequest, endRequest, phone, telco, err_code, tranId, nation, ltypeb);
            int totalRow2 = logDao.countMsgSubmitLog3(userSender, cp_code, label, 1, result, provider, stRequest, endRequest, phone, telco, err_code, tranId, nation, ltypeb);
            int totalRow = totalRow1 + totalRow2;
            totalPage = (int) totalRow / maxRow;
            if (totalRow % maxRow != 0) {
                totalPage++;
            }
            String urlExport = request.getContextPath() + "/admin/campaign/exp/exp_submit.jsp?";
            String dataGet = "";
            dataGet += "page=" + currentPage;
            dataGet += "&err_code=" + err_code;
            dataGet += "&type=" + type;
            dataGet += "&result=" + result;
            dataGet += "&_label=" + bid;
            dataGet += "&phone=" + phone;
            dataGet += "&provider=" + provider;
            dataGet += "&telco=" + telco;
            dataGet += "&stRequest=" + stRequest;
            dataGet += "&endRequest=" + endRequest;
            dataGet += "&totalRow=" + totalRow;
            dataGet += "&cp_code=" + cp_code;
            dataGet += "&userSender=" + userSender;
            dataGet += "&tranId=" + tranId;
            dataGet += "&nation=" + nation;
            urlExport += dataGet;
        %>
    </head>
    <body>
        <div id="popup_content_view" class="popup"></div>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <!-- Tìm kiếm-->
                        <form onsubmit="return validMonth();"  action="<%=request.getContextPath() + "/admin/campaign/detail.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"><b>Lịch sử gửi tin nhắn QC</b></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td><span class="redBold">Ngày gửi từ</span> </td>
                                        <td colspan="3">
                                            <input value="<%=stRequest%>" class="dateproc" size="8" id="stRequest" type="text" name="stRequest"/>
                                            &nbsp;&nbsp;&nbsp;<span class="redBold">Đến</span>
                                            <input value="<%=endRequest%>" class="dateproc" size="8" id="endRequest" type="text" name="endRequest"/>
<!--                                            <select style="display: none" name="type">
                                                <option value="-1">Tất cả</option>
                                                <option <%=type == 0 ? "selected='selected'" : ""%> value="0">Tin CSKH</option>
                                                <option <%=type == 1 ? "selected='selected'" : ""%> value="1">Tin Quảng cáo</option>
                                            </select>-->
                                            &nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Kết quả</span>
                                            <select class="select3" style="width: 100px" name="result">
                                                <option value="-1">Tất cả</option>
                                                <option <%=result == 1 ? "selected='selected'" : ""%> value="1">Thành công</option>
                                                <option <%=result == 0 ? "selected='selected'" : ""%> value="0">Thất bại</option>
                                            </select>
                                            &nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Nation</span>                                    
                                            <select onchange="changeTelco(this.value)" class="select3" style="width: 170px" id="nation" name="nation">
                                                <option value="">Tất cả</option>
                                                <% 
                                                    ArrayList<Nations> nations = Nations.getAll();
                                                    for (Nations elem : nations) {
                                                %>
                                                <option <%=nation.equalsIgnoreCase(elem.getCountry_code()) ? "selected='selected'" : ""%> value="<%=elem.getCountry_code()%>">[<%=elem.getCountry_code()%>] <%=elem.getCountry_name()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            &nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Telco</span>
                                            <select class="select3" style="width: 170px" name="telco" id="telco">
                                                <option value="">Tất cả</option>
                                                <%
                                                    ArrayList<Telco_Nations> telco_Nations = Telco_Nations.getTelco_na();
                                                    for (Telco_Nations elem : telco_Nations) {                                                            
                                                %>
                                                <option <%=telco.equalsIgnoreCase(elem.getTelco_code()) ? "selected='selected'" : ""%> value="<%=elem.getTelco_code()%>">[<%=elem.getCountry_code()%>] <%=elem.getTelco_name()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <span class="redBold">Type</span>
                                        </td>
                                        <td>
                                            <select class="select3" style="width: 175px" id="ltypeb" name="ltypeb">
                                                <option value="0">Brand Name</option>
                                                <option <%=ltypeb == 1 ? "selected='true'" : ""%> value="1">Long Code</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><span class="redBold">Số điện thoại</span></td>
                                        <td>
                                            <input size="10" type="text" name="phone"/>
                                            &nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Nhãn</span>
                                            <select onchange="changeBrand()" style="width: 180px" id="_label" name="_label">
                                                <option value="">Tất cả</option>
                                                <%   ArrayList<BrandLabel> allLabel = BrandLabel.getAll();
                                                    for (BrandLabel one : allLabel) {
                                                %>
                                                <option user_sender="<%=one.getUserOwner()%>" <%=label.equals(one.getBrandLabel()) && (one.getUserOwner().equals(userSender)) ? "selected='selected'" : ""%> 
                                                        value="<%=one.getId()%>"
                                                        img-data="<%=(one.getStatus() == 1 ? "" : request.getContextPath()+"/admin/resource/images/lock1.png")%>" >
                                                    <%=one.getBrandLabel()%> - [<%=one.getUserOwner()%>]
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Đại lý</span>&nbsp;&nbsp;
                                            <%
                                                ArrayList<PartnerManager> allCp = PartnerManager.getAllCache();
                                                if (allCp != null && !allCp.isEmpty()) {
                                            %>
                                            <select style="width: 420px;float: right" id="_agentcy_id" name="cp_code">
                                                <option value="">Tất cả</option>
                                                <%
                                                    for (PartnerManager onePartner : allCp) {
                                                        if (!Tool.checkNull(onePartner.getCode())) {
                                                %>
                                                <option <%=(cp_code.equals(onePartner.getCode())) ? "selected ='selected'" : ""%> 
                                                    value="<%=onePartner.getCode()%>"
                                                    img-data="<%=(onePartner.getStatus() == 1 ? "" : request.getContextPath()+"/admin/resource/images/lock1.png")%>" >[<%=onePartner.getCode()%>] <%=onePartner.getName()%></option>
                                                <%}
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><span class="redBold">Tài khoản</span></td>
                                        <td>
                                            <%
                                                // Lay ra Tai Khoản Dai Ly Hoac Quản Lý Cấp 1
                                                ArrayList<Account> allUser = Account.getAllCP();
                                            %>
                                            <select style="width: 350px" onchange="changeCP()" id="_userSender" name="userSender">
                                                <option value="">Tất cả</option>
                                                <%
                                                    for (Account oneUser : allUser) {
                                                %>
                                                <option user_sender="<%=oneUser.getAccID()%>" <%=(userSender.equals(oneUser.getUserName())) ? "selected ='selected'" : ""%> 
                                                        value="<%=oneUser.getUserName()%>" img-data="<%=(oneUser.getStatus() == 1 ? "" : request.getContextPath()+ "/admin/resource/images/lock1.png")%>" >[<%=oneUser.getUserName()%>] <%=oneUser.getFullName()%></option>
                                                <%}%>
                                            </select>
                                            &nbsp;&nbsp;
                                            <span class="redBold">Hướng gửi</span>
                                            <%
                                                ArrayList<Provider> allPrv = Provider.getALL();
                                                if (allPrv != null && !allPrv.isEmpty()) {
                                            %>
                                            <select style="width: 250px" id="_provider" name="provider">
                                                <option value="">Tất cả</option>
                                                <%
                                                    for (Provider one : allPrv) {
                                                %>
                                                <option <%=(provider.equals(one.getCode())) ? "selected ='selected'" : ""%> 
                                                    value="<%=one.getCode()%>" 
                                                    img-data="<%=(one.getStatus() == 1 ? "" : request.getContextPath()+"/admin/resource/images/lock1.png")%>" ><%=one.getName()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <%
                                                }
                                            %>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <span class="redBold">Mã Lỗi</span>
                                            &nbsp;&nbsp;
                                            <input size="4" style="float: right" name="err_code" type="text">
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="3">
                                            <input class="button" type="submit" name="submit" value="Tìm kiếm"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <input onclick="window.open('<%=urlExport%>')" class="button" type="button" name="button" value="Xuất Excel"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>      
                        <%@include file="/admin/includes/page.jsp" %>
                        <!--End tim kiếm-->
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
                                    <th scope="col" class="rounded">Brand Name</th>
                                    <th scope="col" class="rounded">Partner</th>
                                    <th scope="col" class="rounded">Nhà mạng</th>
                                    <th scope="col" class="rounded">Số nhận tin</th>
                                    <th scope="col" class="rounded">Total SMS</th>
                                    <th scope="col" class="rounded">Số ký tự tin nhắn</th>
                                    <!--<th scope="col" class="rounded">Total Price</th>-->
                                    <th scope="col" class="rounded">Time Request</th>
                                    <th scope="col" class="rounded">Time Send</th> 
                                    <th scope="col" class="rounded">Kết quả gửi</th> 
                                    <!--<th scope="col" class="rounded">Loại tin</th>-->
                                    <th scope="col" class="rounded">Xem MT</th>
                                    <th scope="col" class="rounded">GW</th>
                                    <th scope="col" class="rounded">NODE</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int count = 1; //Bien dung de dem so dong
                                    for (Iterator<MsgBrandSubmit> iter = all.iterator(); iter.hasNext();) {
                                        MsgBrandSubmit oneBrand = iter.next();
                                %>
                                <tr>
                                    <td class="boder_right"><%=count++%></td>
                                    <td class="boder_right" style="color: blue;font-weight: bold" align="left">
                                        <%=oneBrand.getLabel()%>
                                    </td>
                                    <td class="boder_right" align="left">
                                        <%=oneBrand.getUserSender()%>
                                    </td>
                                    <td class="boder_right" align="center">
                                        <%=oneBrand.getOper()%>
                                    </td>
                                    <td class="boder_right" align="center">
                                        <%=oneBrand.getPhone()%>
                                    </td>
                                    <td class="boder_right" align="left">
                                        <%=oneBrand.getTotalSms()%>
                                    </td>
                                    <td class="boder_right" align="left">
                                        <%=oneBrand.getMessage().length()%>
                                    </td>
<!--                                    <td class="boder_right" align="left">
                                        <%=oneBrand.getTotalPrice()%>
                                    </td>-->
                                    <td class="boder_right">
                                        <%=oneBrand.getCreateAt() == 0 ? DateProc.Timestamp2DDMMYYYYHH24Mi(oneBrand.getRequestTime()) : new Date(oneBrand.getCreateAt())%>
                                        <%--<%=DateProc.Timestamp2DDMMYYYYHH24MiSS(oneBrand.getRequestTime())%>--%>
                                    </td>
                                    <td class="boder_right">
                                        <%=oneBrand.getEndAt() == 0 ? DateProc.Timestamp2DDMMYYYYHH24Mi(oneBrand.getTimeSend()) : new Date(oneBrand.getEndAt())%>
                                        <%--<%=DateProc.Timestamp2DDMMYYYYHH24MiSS(oneBrand.getTimeSend())%>--%>
                                    </td>
                                    <td class="boder_right" align="left"><span class="redBold"><%=oneBrand.getResult()%></span> &nbsp;(<%=oneBrand.getErrInfo()%>)</td>
                                    <!--<td class="boder_right" align="center"><%=getType(oneBrand.getType())%></td>-->
                                    <td class="boder_right">
                                        <a class="ItemPopup" url-data="<%=request.getContextPath() + "/admin/statistic/mt/ViewMTSubmit.jsp?id=" + oneBrand.getId() + "&date=" + DateProc.Timestamp2DDMMYY(oneBrand.getRequestTime())%>" 
                                           href="#popup_content_view" id="open_popup_view" name="open_popup">Xem MT</a>
                                    </td>
                                    <td align="center" class="boder_right">
                                        <%=oneBrand.getSendTo()%>
                                    </td>
                                    <td align="center">
                                        <%=oneBrand.getLbNode()%>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div><!-- end of right content-->
                    <%@include file="/admin/includes/page.jsp" %>
                </div>   <!--end of center content -->
                <div class="clear"></div>
            </div> <!--end of main content-->
            <%@include file="/admin/includes/footer.jsp" %>
        </div>
    </body>
</html>
<%!    private String getType(int type) {
        if (type == BrandLabel.TYPE.CSKH.val) {
            return "CSKH";
        } else if (type == BrandLabel.TYPE.QC.val) {
            return "Tin QC";
        } else {
            return type + "";
        }
    }
%>