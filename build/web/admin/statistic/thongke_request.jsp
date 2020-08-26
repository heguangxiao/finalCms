<%@page import="gk.myname.vn.entity.Nations"%>
<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="gk.myname.vn.entity.PartnerManager"%><%@page import="gk.myname.vn.entity.MsgBrandRequest"%><%@page import="gk.myname.vn.entity.Provider"%><%@page import="gk.myname.vn.utils.DateProc"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="gk.myname.vn.config.MyContext"%><%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.entity.BrandLabel"%><%@page import="java.util.Iterator"%><%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
    <head>
        <% session.setAttribute("title", "Thống kê Log Request từ khách hàng sang"); %>
        <%@include file="/admin/includes/header.jsp" %>
        <script type="text/javascript" language="javascript">
            var now = new Date();
            var month = now.getUTCMonth()-2;
            var year = now.getUTCFullYear();
            var str = year + '/' + month + '/' + 1;
            $(document).ready(function () {
                $('#dataTable').DataTable({
                    "order": [[3, "desc"]],
                    "bPaginate": false,
                    "bLengthChange": false,
                    "bFilter": true,
                    "bInfo": false,
                    "bAutoWidth": false
                });
            });

            $(document).ready(function () {
                $('.dateproc').datetimepicker({
                    lang: 'vi',
                    timepicker: false,
                    format: 'd/m/Y',
                    formatDate: 'Y/m/d',
                    minDate: str, // yesterday is minimum date
                    maxDate: '+1970/01/02' // and tommorow is maximum date calendar
                });
            });
            //------
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
                    document.getElementById('_agentcy_id').disabled = true;
                    var user = selectBr.attr("user_owner");
                    $("#_userSender").select2('val', user);
                } else {
                    document.getElementById('_agentcy_id').disabled = false;
                    var user = selectBr.attr("user_owner");
                    $("#_userSender").select2('val', user);
                }
            }
                        
            function changeDL() {                
                var selectBr = $("#_agentcy_id option:selected");
                if (selectBr.val() !== "") {   
                    document.getElementById('_userSender').disabled = true;
                    document.getElementById('_label').disabled = true;
                } else {                    
                    document.getElementById('_userSender').disabled = false;
                    document.getElementById('_label').disabled = false;
                }                 
            }
            function changeCP() {
                var selectBr = $("#_userSender option:selected");
                var user = selectBr.val();
                if (user !== "") {
                    document.getElementById('_agentcy_id').disabled = true;
                    var url = "<%=request.getContextPath()%>/admin/statistic/ajax/listBrand.jsp?user=" + user;
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_label");
                } else {
                    document.getElementById('_agentcy_id').disabled = false;
                    var url = "<%=request.getContextPath()%>/admin/statistic/ajax/listBrand.jsp?user=0";
                    url += "&_=" + Math.floor(Math.random() * 10000);
                    AjaxAction(url, "_label");
                }
                $("#_label").select2("val", "");
            }
            
            function changeTelco(i) {
                var url = "<%=request.getContextPath()%>/admin/statistic/ajax/listTelco.jsp?code=" + i;
                AjaxAction(url, "oper");
            }
        </script>
    </head>
    <body>
        <%            //-
            ArrayList<MsgBrandRequest> allLog = null;
            MsgBrandRequest reqDao = new MsgBrandRequest();
            int type = RequestTool.getInt(request, "type", -1);
            int bid = RequestTool.getInt(request, "_label");
            BrandLabel brLabel = BrandLabel.getFromCache(bid);
            //--
            String label = "";
            if (brLabel != null) {
                label = brLabel.getBrandLabel();
            }
            int result = RequestTool.getInt(request, "result", 0);
            String oper = RequestTool.getString(request, "oper");
            String nation = RequestTool.getString(request, "nation"); 
            String stRequest = RequestTool.getString(request, "stRequest");
            String groupBr = RequestTool.getString(request, "groupBr");
            if (Tool.checkNull(stRequest)) {
                stRequest = DateProc.createDDMMYYYY();
            }
            String endRequest = RequestTool.getString(request, "endRequest");
            if (Tool.checkNull(endRequest)) {
                endRequest = DateProc.createDDMMYYYY();
            }
            String cp_code = RequestTool.getString(request, "cp_code");
            String userSender = RequestTool.getString(request, "userSender");
            int ltypeb = RequestTool.getInt(request, "ltypeb");
            
            allLog = reqDao.statisticReq2(userSender, cp_code, label, 0, stRequest, endRequest, oper, result, nation, ltypeb, groupBr);
            
            String urlExport = request.getContextPath() + "/admin/statistic/exp/export_tk_request.jsp?";
            urlExport += "type=" + type;
            urlExport += "&_label=" + label;
            urlExport += "&result=" + result;
            urlExport += "&oper=" + oper;
            urlExport += "&stRequest=" + stRequest;
            urlExport += "&endRequest=" + endRequest;
            urlExport += "&cp_code=" + cp_code;
            urlExport += "&userSender=" + userSender;
            urlExport += "&nation=" + nation;
            urlExport += "&groupBr=" + groupBr;
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <!-- Tìm kiếm-->
                        <form onsubmit="return  validMonth();" action="<%=request.getContextPath() + "/admin/statistic/thongke_request.jsp"%>" method="post">
                            <table id="rounded-corner" align="center">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"><b>Thống kê Log Request từ khách hàng sang</b></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <span class="redBold">Từ ngày</span>
                                        </td>
                                        <td> 
                                            <input style="width: 160px" value="<%=stRequest%>" id="stRequest" class="dateproc" type="text" name="stRequest"/>
                                            &nbsp;&nbsp;
                                            <span class="redBold">Đến</span>
                                            <input style="width: 160px" value="<%=endRequest%>" id="endRequest" class="dateproc" type="text" name="endRequest"/>
                                            &nbsp;
                                            <span class="redBold" style="display: none">Loại</span>
                                            <select style="display: none" id="type" name="type">
                                                <option <%=type == -1 ? "selected='selected'" : ""%> value="-1">Tất cả</option>
                                                <option <%=type == 0 ? "selected='selected'" : ""%> value="0">Tin CSKH</option>
                                                <option <%=type == 1 ? "selected='selected'" : ""%> value="1">Tin QC</option>
                                            </select>
                                            &nbsp;   
                                            <span class="redBold">Kết Quả</span>
                                            <select class="select3" style="width: 175px" id="result" name="result">
                                                <option value="">Tất Cả</option>
                                                <option <%=result == 1 ? "selected='selected'" : ""%> value="1">Thành Công</option>
                                                <option <%=result == -1 ? "selected='selected'" : ""%> value="-1">Thất bại</option>
                                            </select>
                                            &nbsp;&nbsp;
                                            <span class="redBold">Nhóm</span>
                                            <select class="select3" style="width: 175px" id="groupBr" name="groupBr">
                                                <option value="">Tất cả</option>
                                                <option value="0">N0</option>
                                                <option value="N1">N1</option>
                                                <option value="N2">N2</option>
                                                <option value="N3">N3</option>
                                                <option value="N4">N4</option>
                                                <option value="N5">N5</option>
                                                <option value="N6">N6</option>
                                                <option value="N7">N7</option>
                                                <option value="N8">N8</option>
                                                <option value="N9">N9</option>
                                                <option value="N10">N10</option>
                                                <option value="N11">N11</option>
                                                <option value="N12">N12</option>
                                                <option value="N13">N13</option>
                                                <option value="N14">N14</option>
                                                <option value="N15">N15</option>
                                                <option value="NLC">NLC</option>
                                            </select>                             
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>
                                            <span class="redBold">Type</span>
                                        </td>
                                        <td>
                                            <select class="select3" style="width: 168px" id="ltypeb" name="ltypeb">
                                                <option value="0">Brand Name</option>
                                                <option <%=ltypeb == 1 ? "selected='true'" : ""%> value="1">Long Code</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><span class="redBold">Nation</span>  </td>
                                        <td>                                          
                                            <select onchange="changeTelco(this.value)" class="select3" style="width: 400px" id="nation" name="nation">
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
                                            <span class="redBold">Telco</span>                                            
                                            <select class="select3" style="width: 400px; float: right" id="oper" name="oper">
                                                <option value="">Tất cả</option>
                                                <%
                                                    ArrayList<Telco_Nations> telco_Nations = Telco_Nations.getTelco_na();
                                                    for (Telco_Nations elem : telco_Nations) {                                                            
                                                %>
                                                <option <%=oper.equalsIgnoreCase(elem.getTelco_code()) ? "selected='selected'" : ""%> value="<%=elem.getTelco_code()%>">[<%=elem.getCountry_code()%>] <%=elem.getTelco_name()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><span class="redBold">Nhãn gửi</span></td>
                                        <td>
                                           <select onchange="changeBrand()" style="width: 400px" id="_label" name="_label">
                                                <option brand_id="" user_owner="" value="" img-data="">Tất cả</option>
                                                <%
                                                    ArrayList<BrandLabel> allLabel = BrandLabel.getAll();
                                                    for (BrandLabel one : allLabel) {
                                                %>
                                                <option user_owner="<%=one.getUserOwner()%>" 
                                                        <%=(label.equals(one.getBrandLabel()) && one.getUserOwner().equals(userSender)) ? "selected='selected'" : ""%> 
                                                        value="<%=one.getId()%>"
                                                        img-data="<%=(one.getStatus() == 1 ? "" : request.getContextPath()+"/admin/resource/images/lock1.png")%>" >
                                                    <%=one.getBrandLabel()%> [<%=one.getUserOwner()%>]
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>                            
                                            <span class="redBold">Đại lý</span> 
                                            <%
                                                ArrayList<PartnerManager> allAgentCy = PartnerManager.getAllCache();
                                                if (allAgentCy != null && !allAgentCy.isEmpty()) {
                                            %>
                                            <select onchange="changeDL()" style="width: 400px; float: right" id="_agentcy_id" name="cp_code">
                                                <option value="">Tất cả</option>
                                                <%
                                                    for (PartnerManager onePartner : allAgentCy) {
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
                                                ArrayList<Account> allCp = Account.getAllCP();
                                                if (allCp != null && !allCp.isEmpty()) {
                                            %>
                                            <select onchange="changeCP()" style="width: 400px" id="_userSender" name="userSender">
                                                <option id="_tk_all" value="" >Tất cả</option>
                                                <%
                                                    for (Account oneAcc : allCp) {
                                                %>
                                                <option id="_tk_<%=oneAcc.getUserName()%>" <%=userSender.equals(oneAcc.getUserName()) ? "selected='true'" : ""%> 
                                                    value="<%=oneAcc.getUserName()%>" 
                                                    img-data="<%=(oneAcc.getStatus() == 1 ? "" : request.getContextPath()+ "/admin/resource/images/lock1.png")%>" >
                                                    [<%=oneAcc.getUserName()%>] <%=oneAcc.getFullName()%> 
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <%
                                                }
                                            %>                                            
                                        </td>
                                    </tr>
                                    <tr align="center">
                                        <td colspan="3">
                                            <input class="button" type="submit" name="submit" value="Thống kê"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <input onclick="window.open('<%=urlExport%>')" class="button" type="button" name="button" value="Xuất Excel"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>      
                        <!--End tim kiếm-->
                        <div align="center" style="height: 20px;margin-bottom: 2px; color: red;font-weight: bold">
                            <%               
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <!--Content-->
                        <table align="center" id="dataTable" summary="Msc Joint Stock Company" >
                            <thead>
                                <tr>
                                    <th scope="col" class="rounded-company">STT</th>
                                    <th scope="col" class="rounded">Brand Name</th>
                                    <th scope="col" class="rounded">Nhà mạng</th>
                                    <th scope="col" class="rounded">Tổng tin nhắn</th>
                                    <th scope="col" class="rounded">Kết quả gửi</th> 
                                    <!--<th scope="col" class="rounded">Loại tin</th>-->
                                    <th scope="col" class="rounded">Nhóm</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int count = 1; //Bien dung de dem so dong
                                    int total = 0;
                                    int total2 = 0;
                                    for (Iterator<MsgBrandRequest> iter = allLog.iterator(); iter.hasNext();) {
                                        MsgBrandRequest oneBrand = iter.next();
                                        if (oneBrand.getResult() == 99) {
                                            total += oneBrand.getTotalSms();
                                        } else {
                                            total2 += oneBrand.getTotalSms();
                                        }
                                %>
                                <tr>
                                    <td class="boder_right boder_left"><%=count++%></td>
                                    <td class="boder_right" align="left">
                                        <%=oneBrand.getLabel()%>
                                    </td>
                                    <td class="boder_right" align="center">
                                        <%=oneBrand.getOper()%>
                                    </td>
                                    <td class="boder_right" align="left">
                                        <%=oneBrand.getTotalSms()%>
                                    </td>
                                    <td class="boder_right" align="left"><span class="redBold"><%=oneBrand.getResult()%></span> &nbsp;(<%=oneBrand.getResult() == 99 ? "RECEIVED" : "ERROR"%>)</td>
                                    <!--<td class="boder_right" align="center"><%=getType(oneBrand.getType())%></td>-->
                                    <td align="center"><%=oneBrand.getBrGroup() == null ? "0" : oneBrand.getBrGroup() %></td>
                                </tr>
                                <%
                                    }
                                %>                                
                            </tbody>
                        </table>
                        <table id="rounded-corner">
                            <tr>
                                <td class="boder_right" colspan="3" style="font-weight: bold;color: blue;width: 352px">Tổng MT thành công</td>
                                <td colspan="5" style="font-weight: bold;color: blue" align="left"><%=total%></td>
                            </tr>
                            <tr>
                                <td class="boder_right" colspan="3" style="font-weight: bold;color: red;width: 352px">Tổng MT thất bại</td>
                                <td colspan="5" style="font-weight: bold;color: red" align="left"><%=total2%></td>
                            </tr>
                        </table>
                    </div><!-- end of right content-->
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