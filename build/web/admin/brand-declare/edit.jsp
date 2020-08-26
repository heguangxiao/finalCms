<%@page import="gk.myname.vn.entity.Template_sms"%>
<%@page import="gk.myname.vn.utils.DateProc"%>
<%@page import="java.util.Iterator"%>
<%@page import="gk.myname.vn.entity.GroupProvider"%>
<%@page import="gk.myname.vn.entity.Provider"%>
<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="gk.myname.vn.entity.RouteNationTelco"%>
<%@page import="gk.myname.vn.entity.BrandLabel"%>
<%@page import="gk.myname.vn.entity.UserAction"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <%@include file="/admin/includes/header.jsp" %>
        <%            //---------------Admin
            if (userlogin == null) {
                //CongNX: Ghi log action vao db
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.brand_label.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.REJECT.val,
                                "Permit deny!");
                log.logAction(request);
                //CongNX: ket thuc ghi log db voi action thao tac tu web
                session.setAttribute("error", "Bạn cần đăng nhập để truy cập hệ thống");
                out.print("<script>top.location='" + request.getContextPath() + "/admin/login.jsp';</script>");
                return;
            }
        %>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/admin/resource/css/jquery-ui-1.8.16.custom.css">
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.core.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.position.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.widget.min.js"></script>
        <script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/admin/resource/js/suggest/jquery.ui.autocomplete.min.js"></script>
        <SCRIPT language="javascript">
            function show(num, n) {
                var i = parseInt(n);
                document.getElementById('numb').value = i;
                var e = i+1;
                var u = i-1;
                document.getElementById('dtgt'+num+i).style.display = '';
                document.getElementById('show'+num+i).style.display = 'none';
                if (e < 8) {
                    document.getElementById('show'+num+e).style.display = ''; 
                }
                document.getElementById('hide'+num+i).style.display = '';
                if (u > 0) {
                    document.getElementById('hide'+num+u).style.display = 'none';
                }
            }

            function hide(num, n) {
                var i = parseInt(n);
                var e = i+1;
                var u = i-1;
                document.getElementById('numb').value = u;
                if (e < 8) {
                    document.getElementById('show'+num+e).style.display = 'none'; 
                } 
                if (u > 0) {
                    document.getElementById('hide'+num+u).style.display = '';
                } 
                document.getElementById('dtgt'+num+i).style.display = 'none';
                document.getElementById('show'+num+i).style.display = '';
                document.getElementById('hide'+num+i).style.display = 'none';
            }
        </SCRIPT>
    </head>
    <body>
        <%           
            if (!userlogin.checkEdit(request)) {
                //CongNX: Ghi log action vao db
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.brand_label.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.REJECT.val,
                                "Permit deny!");
                log.logAction(request);
                //CongNX: ket thuc ghi log db voi action thao tac tu web
                session.setAttribute("mess", "Bạn không có quyền truy cập module này!");
                response.sendRedirect(request.getContextPath() + "/admin/brand/index.jsp");
                return;
            }
            
            int id = RequestTool.getInt(request, "id");
            BrandLabel oneBrand = new BrandLabel();
            oneBrand = oneBrand.getById(id);
            String message = "";
            ArrayList<BrandLabel> allLabelDao = BrandLabel.getAll();
            ArrayList<BrandLabel> allLabel = new ArrayList<>();
            String check = "";
            for (BrandLabel elem : allLabelDao) {
                    if (!check.contains(elem.getBrandLabel())) {
                        check += elem.getBrandLabel();
                        allLabel.add(elem);
                    }
                }
            
            if (oneBrand == null) {
                //CongNX: Ghi log action vao db
                UserAction log = new UserAction(userlogin.getUserName(),
                                UserAction.TABLE.brand_label.val,
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.REJECT.val,
                                "Request not valid");
                log.logAction(request);
                //CongNX: ket thuc ghi log db voi action thao tac tu web
                session.setAttribute("mess", "Yêu cầu không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/admin/brand-declare/index.jsp");
                return;
            }
            
            ArrayList<Template_sms> allpro = Template_sms.getALL();
            ArrayList<RouteNationTelco> routeNationTelcos = RouteNationTelco.getAllByBrandnameAndUserowner(oneBrand.getBrandLabel(), oneBrand.getUserOwner());
            
            String valueOjectOld = oneBrand.toStringJson();
            if (request.getParameter("submit") != null) {
                String telco;
                int duplicate;
                String cskh;
                String qc;
                String group;
                int rq;
                int stt;
                String tmpid;
                String lbid;
                String lbusername;
                String cskhunicode;
                String groupunicode;
                int denhan;
                int ckdenhan;
                int id_template;
                
                String brandName = Tool.validStringRequest(request.getParameter("brandName"));
                
                if (Tool.checkNull(brandName)) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                            UserAction.TABLE.brand_label.val,
                            UserAction.TYPE.EDIT.val,
                            UserAction.RESULT.REJECT.val,
                            "Chưa nhập brandname!");
                    log.logAction(request);
                    session.setAttribute("mess", "Bạn chưa nhập brandname");
                    response.sendRedirect(request.getContextPath() + "/admin/brand-declare/add.jsp");
                    return;
                }
                
                if (brandName.length() > 15) {
                    UserAction log = new UserAction(userlogin.getUserName(),
                    UserAction.TABLE.brand_label.val,
                    UserAction.TYPE.EDIT.val,
                    UserAction.RESULT.FAIL.val,
                    "Brand Name có đọ dài tối đa = 15!");
                    log.logAction(request);
                    session.setAttribute("mess", "Brand Name có đọ dài tối đa = 15!");
                    response.sendRedirect(request.getContextPath() + "/admin/brand-declare/add.jsp");
                    return;
                }
                
                int priority = Tool.string2Integer(request.getParameter("priority"));
                int status = Tool.string2Integer(request.getParameter("status"));
                int checktemp = Tool.string2Integer(request.getParameter("checktemp"));
                int dlr = Tool.string2Integer(request.getParameter("dlr"));
                String ownerUser = Tool.validStringRequest(request.getParameter("ownerUser"));
                Account ownerAcc = Account.getAccount(ownerUser);
                
                String stRequest = RequestTool.getString(request, "stRequest");
                int type = Tool.string2Integer(request.getParameter("cktype"));
                
                oneBrand.setBrandLabel(brandName);
                oneBrand.setUserOwner(ownerAcc.getUserName());  
                oneBrand.setCp_code(ownerAcc.getCpCode());  
                oneBrand.setStatus(status);
                oneBrand.setPriority(priority);
                oneBrand.setCheckTemp(checktemp);
                oneBrand.setUpdateDate(DateProc.createTimestamp());
                oneBrand.setUpdateBy(userlogin.getAccID());
                oneBrand.setType(type);
                oneBrand.setExp(stRequest);
                oneBrand.setDlr(dlr);
                
                BrandLabel brandDao = new BrandLabel();
                String valueOjectNew = oneBrand.toStringJson();
                RouteNationTelco rntDao = new RouteNationTelco();
                RouteNationTelco rnt = null;
                
                if (brandDao.update2(oneBrand)) {
                    message += "Cập nhật lại brand " + brandName + " thành công<br/>";
                    //CongNX: Ghi log action vao db                        
                    UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.brand_label.val,
                                    UserAction.TYPE.EDIT.val,
                                    UserAction.RESULT.SUCCESS.val,
                                    "OLD= " + valueOjectOld + ", NEW=" + valueOjectNew);
                    log.logAction(request);
                    //CongNX: ket thuc ghi log db voi action thao tac tu web                    
                    for (int i = 1; i < (routeNationTelcos.size() + 1); i++) {
                        telco = Tool.validStringRequest(request.getParameter("telco"+i));
                        duplicate = Tool.string2Integer(request.getParameter("duplicate"+i));
                        cskh = Tool.validStringRequest(request.getParameter("cskh"+i));
                        qc = Tool.validStringRequest(request.getParameter("qc"+i));
                        group = Tool.validStringRequest(request.getParameter("group"+i));
                        tmpid = Tool.validStringRequest(request.getParameter("tmpid"+i));
                        lbid = Tool.validStringRequest(request.getParameter("lbid"+i));
                        lbusername = Tool.validStringRequest(request.getParameter("lbusername"+i));
                        rq = Tool.string2Integer(request.getParameter("rq"+i));
                        stt = Tool.string2Integer(request.getParameter("stt"+i));
                        cskhunicode = Tool.validStringRequest(request.getParameter("cskhunicode"+i));
                        groupunicode = Tool.validStringRequest(request.getParameter("groupunicode"+i));
                        denhan = Tool.string2Integer(request.getParameter("denhan"+i));
                        ckdenhan = Tool.string2Integer(request.getParameter("ckdenhan"+i));
                        id_template = Tool.string2Integer(request.getParameter("id_template"+i));
                        if (!telco.equals("")) {
                            rnt = rntDao.getbyBrandnameAndUserownerAndTelco(brandName, ownerAcc.getUserName(), telco);
                            if (rnt != null) {
                                rnt.setTelcoCode(telco);
                                rnt.setDuplicate(duplicate);
                                rnt.setCskh(cskh);
                                rnt.setQc(qc);
                                rnt.setGroup(group);
                                rnt.setTempId(tmpid);
                                rnt.setLabelId(lbid);
                                rnt.setLabelUsername(lbusername);
                                rnt.setRequest(rq);
                                rnt.setStatus(stt);
                                rnt.setBrandname(brandName);
                                rnt.setUser_owner(ownerAcc.getUserName());
                                rnt.setCskhunicode(cskhunicode);
                                rnt.setGroupunicode(groupunicode);
                                rnt.setDenhan(denhan);
                                rnt.setCkdenhan(ckdenhan);
                                rnt.setTemplateId(id_template);

                                if (rntDao.updateRouteNationTelco(rnt)) {
//                                    message += "Cập nhật mạng " + telco + " thành công<br/>";               
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.EDIT.val,
                                        UserAction.RESULT.SUCCESS.val,
                                        "Cập nhật mạng " + telco + " thành công!");
                                    log.logAction(request);
                                } else {
//                                    message += "Cập nhật mạng " + telco + " lỗi<br/>";            
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.EDIT.val,
                                        UserAction.RESULT.FAIL.val,
                                        "Cập nhật mạng " + telco + " lỗi!");
                                    log.logAction(request);
                                }
                            } else {
                                rntDao.del_ever(routeNationTelcos.get(i-1).getId());

                                rnt = new RouteNationTelco();
                                rnt.setTelcoCode(telco);
                                rnt.setDuplicate(duplicate);
                                rnt.setCskh(cskh);
                                rnt.setQc(qc);
                                rnt.setGroup(group);
                                rnt.setTempId(tmpid);
                                rnt.setLabelId(lbid);
                                rnt.setLabelUsername(lbusername);
                                rnt.setRequest(rq);
                                rnt.setStatus(stt);
                                rnt.setBrandname(brandName);
                                rnt.setUser_owner(ownerAcc.getUserName());
                                rnt.setCskhunicode(cskhunicode);
                                rnt.setGroupunicode(groupunicode);
                                rnt.setDenhan(denhan);
                                rnt.setCkdenhan(ckdenhan);
                                rnt.setTemplateId(id_template);

                                if (rntDao.addRouteNationTelco(rnt)) {
//                                    message += "Sửa mạng " + telco + " thành công<br/>";            
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.EDIT.val,
                                        UserAction.RESULT.SUCCESS.val,
                                        "Sửa mạng " + telco + " thành công!");
                                    log.logAction(request);
                                } else {
//                                    message += "Sửa mạng " + telco + " lỗi<br/>";            
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.EDIT.val,
                                        UserAction.RESULT.FAIL.val,
                                        "Sửa mạng " + telco + " lỗi!");
                                    log.logAction(request);
                                }
                            }
                        } else {
//                            message += "Xóa mạng " + telco + " thành công<br/>";
                            rntDao.del_ever(routeNationTelcos.get(i-1).getId());          
                            log = new UserAction(userlogin.getUserName(),
                                "route_nation_telco",
                                UserAction.TYPE.EDIT.val,
                                UserAction.RESULT.FAIL.val,
                                "Xóa mạng " + telco + " thành công<br/>");
                            log.logAction(request);
                        }
                    }
                    
                    int numb  = Tool.string2Integer(request.getParameter("numb"));
                    
                    if (numb > 0) {
                        for (int i = 1; i <= numb; i++) {                            
                            String newtelco = Tool.validStringRequest(request.getParameter("telconew"+i));
                            if (!newtelco.equals("")) {
                                rnt = rntDao.getbyBrandnameAndUserownerAndTelco(brandName, ownerAcc.getUserName(), newtelco);
                                if (rnt == null) {
                                    duplicate = Tool.string2Integer(request.getParameter("duplicatenew"+i));
                                    cskh = Tool.validStringRequest(request.getParameter("cskhnew"+i));
                                    qc = Tool.validStringRequest(request.getParameter("qcnew"+i));
                                    group = Tool.validStringRequest(request.getParameter("groupnew"+i));
                                    tmpid = Tool.validStringRequest(request.getParameter("tmpidnew"+i));
                                    lbid = Tool.validStringRequest(request.getParameter("lbidnew"+i));
                                    lbusername = Tool.validStringRequest(request.getParameter("lbusernamenew"+i));
                                    rq = Tool.string2Integer(request.getParameter("rqnew"+i));
                                    stt = Tool.string2Integer(request.getParameter("sttnew"+i));
                                    cskhunicode = Tool.validStringRequest(request.getParameter("cskhunicodenew"+i));
                                    groupunicode = Tool.validStringRequest(request.getParameter("groupunicodenew"+i));
                                    denhan = Tool.string2Integer(request.getParameter("denhannew"+i));
                                    ckdenhan = Tool.string2Integer(request.getParameter("ckdenhannew"+i));
                                    id_template = Tool.string2Integer(request.getParameter("id_templatenew"+i));

                                    rnt = new RouteNationTelco();
                                    rnt.setTelcoCode(newtelco);
                                    rnt.setDuplicate(duplicate);
                                    rnt.setCskh(cskh);
                                    rnt.setQc(qc);
                                    rnt.setGroup(group);
                                    rnt.setTempId(tmpid);
                                    rnt.setLabelId(lbid);
                                    rnt.setLabelUsername(lbusername);
                                    rnt.setRequest(rq);
                                    rnt.setStatus(stt);
                                    rnt.setBrandname(brandName);
                                    rnt.setUser_owner(ownerAcc.getUserName());
                                    rnt.setCskhunicode(cskhunicode);
                                    rnt.setGroupunicode(groupunicode);
                                    rnt.setDenhan(denhan);
                                    rnt.setCkdenhan(ckdenhan);
                                    rnt.setTemplateId(id_template);

                                    if (rntDao.addRouteNationTelco(rnt)) {
        //                                message += "Thêm mới mạng " + newtelco + " thành công<br/>";           
                                        log = new UserAction(userlogin.getUserName(),
                                            "route_nation_telco",
                                            UserAction.TYPE.EDIT.val,
                                            UserAction.RESULT.SUCCESS.val,
                                            "Thêm mới mạng " + newtelco + " thành công!");
                                        log.logAction(request);
                                    } else {
        //                                message += "Thêm mới mạng " + newtelco + " lỗi<br/>";           
                                        log = new UserAction(userlogin.getUserName(),
                                            "route_nation_telco",
                                            UserAction.TYPE.EDIT.val,
                                            UserAction.RESULT.FAIL.val,
                                            "Thêm mới mạng " + newtelco + " lỗi!");
                                        log.logAction(request);
                                    }
                                } else {
        //                            message += "Mạng " + newtelco + " của brand " + brandName + " đã tồn tại<br/>";         
                                    log = new UserAction(userlogin.getUserName(),
                                        "route_nation_telco",
                                        UserAction.TYPE.EDIT.val,
                                        UserAction.RESULT.FAIL.val,
                                        "Mạng " + newtelco + " của brand " + brandName + " đã tồn tại!");
                                    log.logAction(request);
                                }
                            }
                        }
                    }                 
                    
                    session.setAttribute("mess", message);   
                    
                    if (status == 1) {
                        response.sendRedirect(request.getContextPath() + "/admin/brand/index.jsp");
                        return;
                    }
                    
                    response.sendRedirect(request.getContextPath() + "/admin/brand-declare/index.jsp");
                    return;
                } else {
                    //CongNX: Ghi log action vao db
                    UserAction log = new UserAction(userlogin.getUserName(),
                                    UserAction.TABLE.brand_label.val,
                                    UserAction.TYPE.EDIT.val,
                                    UserAction.RESULT.FAIL.val,
                                    "Brandname= "+oneBrand.getBrandLabel());
                    log.logAction(request);
                    //CongNX: ket thuc ghi log db voi action thao tac tu web
                    session.setAttribute("mess", "Cập nhật dữ liệu lỗi!");
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
                            <%                               
                                if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }
                            %>
                        </div>
                        <form action="" method="post">                            
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th colspan="1" class="rounded-company"></th>
                                        <th colspan="10" class="redBoldUp">Cập nhật Brand</th>
                                        <th colspan="1" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>                                        
                                        <td colspan="2" align="left">Brand Name</td>
                                        <td class="boder_right" colspan="2">
                                            <input value="<%=oneBrand.getBrandLabel()%>" size="15" type="text" name="brandName"/>
                                        </td>
                                        <td colspan="2" align="left">Account</td>
                                        <td colspan="3" align="left">
                                            <select class="select3" name="ownerUser">
                                                <option value="0">-- Chọn tài khoản Sở hữu --</option>
                                                <%
                                                    ArrayList<Account> allCp = Account.getAllCP();
                                                    for (Account one : allCp) {
                                                %>
                                                <option <%=(oneBrand.getUserOwner().equals(one.getUserName()) ? "selected='selected'" : "")%> 
                                                    value="<%=one.getUserName()%>" 
                                                    img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>" > [<%=one.getUserName()%>] <%=one.getFullName()%> </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td colspan="3" align="left"></td>   
                                    </tr>                                    
                                    <tr>
                                        <td colspan="2" align="left"></td>
                                        <td class="boder_right" colspan="2">                                            
                                            <input <%=oneBrand.getType() == 1 ? "checked='checked'" : ""%> 
                                                onclick="checkBoxClick(this);" type="checkbox" name="cktype" value="<%=oneBrand.getType()%>"/> LONGCODE <br/>
                                        </td>
                                        <td colspan="2" align="left">Hết hạn</td>
                                        <td colspan="2" align="left">
                                            <input readonly class="dateproc" value="<%=oneBrand.getExp() == null ? "" : oneBrand.getExp()%>" size="8" id="stRequest" type="text" name="stRequest"/>
                                        </td>
                                        <td colspan="1" align="left">
                                            DeLivery Report
                                        </td>
                                        <td colspan="1" align="left">
                                            <select name="dlr">
                                                <option value="0">Không</option>
                                                <option <%=oneBrand.getDlr()== 1 ? " selected='selected'" : ""%> value="1">Có</option>
                                            </select>
                                        </td>
                                        <td colspan="2" align="left"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="left">Mức độ ưu tiên</td>
                                        <td class="boder_right" colspan="2" align="left"> 
                                            <select name="priority">
                                                <option <%=oneBrand.getPriority() == 1 ? " selected='selected'" : ""%> value="1">Cấp độ 1</option>
                                                <option <%=oneBrand.getPriority() == 2 ? " selected='selected'" : ""%> value="2">Cấp độ 2</option>
                                                <option <%=oneBrand.getPriority() == 3 ? " selected='selected'" : ""%> value="3">Cấp độ 3</option>
                                                <option <%=oneBrand.getPriority() == 4 ? " selected='selected'" : ""%> value="4">Cấp độ 4</option>
                                            </select>
                                        </td>
                                        <td colspan="2" align="left">
                                            Trạng thái
                                        </td>
                                        <td colspan="2" align="left">
                                            <select name="status">">
                                                <option <%=oneBrand.getStatus() == 2 ? " selected='selected'" : ""%> value="2">Chờ kích hoạt</option>
                                                <option <%=oneBrand.getStatus() == 1 ? " selected='selected'" : ""%> value="1">Kích hoạt</option>
                                            </select>
                                        </td>
                                        <td colspan="1" align="left">
                                            Check Temp
                                        </td>
                                        <td colspan="1" align="left">
                                            <select name="checktemp">
                                                <option <%=oneBrand.getCheckTemp()== 1 ? " selected='selected'" : ""%> value="1">Có</option>
                                                <option <%=oneBrand.getCheckTemp()== 0 ? " selected='selected'" : ""%> value="0">Không</option>
                                            </select>
                                        </td>
                                        <td colspan="2" align="left"></td>
                                    </tr>                                    
                                    <tr>
                                        <td style="background: #60c8f2 none repeat" class="redBoldUp" colspan="1"></td>
                                        <td style="background: #60c8f2 none repeat" class="redBoldUp" colspan="11">ĐỊNH TUYẾN GỬI TIN</td>
                                    </tr>
                                    <tr>
                                        <td align="center" class="boder_right" colspan="2"><b>Mạng</b></td>
                                        <td align="center" class="boder_right" colspan="2"><b>CSKH(Mặc định)</b></td>
                                        <td align="center" class="boder_right" colspan="2"><b>CSKH(Unicode)</b></td>
                                        <td align="center" class="boder_right" colspan="2"><b>Đè nhãn</b></td>
                                        <td align="center" colspan="4"><b>Y/c thêm của Ncc</b></td>
                                        <input type="text" name="numb" id="numb" style="display: none" readonly="true" value="0"/>
                                    </tr>
                                    <%
                                        for (int i = 1; i < ( routeNationTelcos.size() + 1 ); i++) {
                                    %>
                                    <tr>
                                        <td align="center" class="boder_right" colspan="2">
                                            <select style="width: 150px" class="select3" name="telco<%=i%>">
                                                <option value="">-- Chọn mạng --</option>
                                                <%
                                                    ArrayList<Telco_Nations> allT = Telco_Nations.getTelco_na();
                                                    for (Telco_Nations one : allT) {
                                                %>
                                                <option <%=routeNationTelcos.get(i-1).getTelcoCode().equals(one.getTelco_code()) ? " selected='selected'" : ""%> value="<%=one.getTelco_code()%>" > [<%=one.getCountry_code()%>] <%=one.getTelco_name()%> </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <select style="width: 150px" class="select3" name="stt<%=i%>" >
                                                <option <%=routeNationTelcos.get(i-1).getStatus()== 1 ? " selected='selected'" : ""%> value="1">Kích hoạt</option>
                                                <option <%=routeNationTelcos.get(i-1).getStatus()== 0 ? " selected='selected'" : ""%> value="0">Khóa</option>
                                                <option <%=routeNationTelcos.get(i-1).getStatus()== 2 ? " selected='selected'" : ""%> value="2">Chờ kích hoạt</option>
                                                <option <%=routeNationTelcos.get(i-1).getStatus()== 3 ? " selected='selected'" : ""%> value="3">Đang kích hoạt</option>
                                            </select>
                                            <select style="width: 150px" class="select3" name="duplicate<%=i%>">
                                                <option <%=routeNationTelcos.get(i-1).getDuplicate()== 0 ? " selected='selected'" : ""%> value="0">Chặn trùng</option>
                                                <option <%=routeNationTelcos.get(i-1).getDuplicate()== 1 ? " selected='selected'" : ""%> value="1">Không chặn</option>
                                            </select>
                                            <select style="width: 150px" class="select3" name="group<%=i%>">
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("0") ? " selected='selected'" : ""%> value="0">NHÓM</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N1") ? " selected='selected'" : ""%> value="N1">N1</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N2") ? " selected='selected'" : ""%> value="N2">N2</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N3") ? " selected='selected'" : ""%> value="N3">N3</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N4") ? " selected='selected'" : ""%> value="N4">N4</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N5") ? " selected='selected'" : ""%> value="N5">N5</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N6") ? " selected='selected'" : ""%> value="N6">N6</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N7") ? " selected='selected'" : ""%> value="N7">N7</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N8") ? " selected='selected'" : ""%> value="N8">N8</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N9") ? " selected='selected'" : ""%> value="N9">N9</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N10") ? " selected='selected'" : ""%> value="N10">N10</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N11") ? " selected='selected'" : ""%> value="N11">N11</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N12") ? " selected='selected'" : ""%> value="N12">N12</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N13") ? " selected='selected'" : ""%> value="N13">N13</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N14") ? " selected='selected'" : ""%> value="N14">N14</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("N15") ? " selected='selected'" : ""%> value="N15">N15</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroup().equals("NLC") ? " selected='selected'" : ""%> value="NLC">NLC</option>
                                            </select>
                                        </td>
                                        <td align="center" class="boder_right" colspan="2">
                                            <select style="width: 150px" class="select3" name="cskh<%=i%>">
                                                <option value="0">Không cho Phép</option>
                                                <%
                                                    for (Provider one : Provider.CACHE) {
                                                        out.print("<option " + (one.getCode().equals(routeNationTelcos.get(i-1).getCskh()) ? "selected='selected'" : "") + " value='" + one.getCode() + " '>" + one.getName() + "</option>");
                                                    }
                                                %>
                                                <%
                                                    for (GroupProvider one : GroupProvider.CACHE) {
                                                        out.print("<option " + ((one.getId()+"GROUP").equals(routeNationTelcos.get(i-1).getCskh()) ? "selected='selected'" : "") + " value='" + (one.getId()+"GROUP")+ " '>[GROUP] -- " + one.getName() + " -- [NHÓM]</option>");
                                                    }
                                                %>
                                            </select>
                                            <br/>
                                            <input <%=routeNationTelcos.get(i-1).getRequest() == 1 ? "checked='checked'" : ""%>  
                                                onclick="checkBoxClick(this);" type="checkbox" name="rq<%=i%>" 
                                                value="<%=routeNationTelcos.get(i-1).getRequest()%>"/>Tính 1 tin
                                        </td>
                                        <td align="center" class="boder_right" colspan="2">
                                            <select style="width: 150px;float: left" class="select3" name="cskhunicode<%=i%>">
                                                <option value="0">Không cho Phép</option>
                                                <%
                                                    for (Provider one : Provider.CACHE) {
                                                        out.print("<option " + (one.getCode().equals(routeNationTelcos.get(i-1).getCskhunicode()) ? "selected='selected'" : "") + " value='" + one.getCode() + " '>" + one.getName() + "</option>");
                                                    }
                                                %>
                                                <%
                                                    for (GroupProvider one : GroupProvider.CACHE) {
                                                        out.print("<option " + ((one.getId()+"GROUP").equals(routeNationTelcos.get(i-1).getCskhunicode()) ? "selected='selected'" : "") + " value='" + (one.getId()+"GROUP")+ " '>[GROUP] -- " + one.getName() + " -- [NHÓM]</option>");
                                                    }
                                                %>
                                            </select>
                                            <br/>
                                            <select style="width: 78px;float: left;display: none" class="select3" name="groupunicode<%=i%>">
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("0") ? " selected='selected'" : ""%> value="0">NHÓM</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N1") ? " selected='selected'" : ""%> value="N1">N1</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N2") ? " selected='selected'" : ""%> value="N2">N2</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N3") ? " selected='selected'" : ""%> value="N3">N3</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N4") ? " selected='selected'" : ""%> value="N4">N4</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N5") ? " selected='selected'" : ""%> value="N5">N5</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N6") ? " selected='selected'" : ""%> value="N6">N6</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N7") ? " selected='selected'" : ""%> value="N7">N7</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N8") ? " selected='selected'" : ""%> value="N8">N8</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N9") ? " selected='selected'" : ""%> value="N9">N9</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N10") ? " selected='selected'" : ""%> value="N10">N10</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N11") ? " selected='selected'" : ""%> value="N11">N11</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N12") ? " selected='selected'" : ""%> value="N12">N12</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N13") ? " selected='selected'" : ""%> value="N13">N13</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N14") ? " selected='selected'" : ""%> value="N14">N14</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("N15") ? " selected='selected'" : ""%> value="N15">N15</option>
                                                <option <%=routeNationTelcos.get(i-1).getGroupunicode().equals("NLC") ? " selected='selected'" : ""%> value="NLC">NLC</option>
                                            </select>
                                        </td>
                                        <td align="left" class="boder_right" colspan="2">
                                            <input <%=routeNationTelcos.get(i-1).getCkdenhan() == 1 ? "checked='checked'" : ""%>  
                                                onclick="checkBoxClick(this);" type="checkbox" name="ckdenhan<%=i%>" 
                                                value="<%=routeNationTelcos.get(i-1).getCkdenhan()%>"/> Có đè
                                            <br/>
                                            <select style="width: 150px" class="select3" name="denhan<%=i%>">
                                                <option value="" img-data="">Tất cả</option>
                                                <%
                                                    for (BrandLabel one : allLabel) {
                                                %>
                                                <option <%=routeNationTelcos.get(i-1).getDenhan() == one.getId() ? " selected='selected'" : ""%>
                                                        value="<%=one.getId()%>"
                                                        img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>" >
                                                    <%=one.getBrandLabel()%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td align="center" colspan="4">
                                            <input type="text" size="15" name="tmpid<%=i%>" placeholder="ID Temp" value="<%=routeNationTelcos.get(i-1).getTempId()%>"/><br/>
                                            <input type="text" size="15" name="lbid<%=i%>" placeholder="ID Label" value="<%=routeNationTelcos.get(i-1).getLabelId()%>"/><br/>
                                            <input type="text" size="15" name="lbusername<%=i%>" placeholder="Username of Label" value="<%=routeNationTelcos.get(i-1).getLabelUsername()%>"/><br/> 
                                            <!--<select style="width: 143px" class="select3" name="id_template<%=i%>">
                                                <option value="">Chọn tin nhắn mẫu</option>
                                                <%
                                                    //for (Template_sms one : allpro) {
                                                %>
                                                <option <%//=routeNationTelcos.get(i-1).getTemplateId()== one.getId() ? " selected='selected'" : ""%>
                                                    value="<%//=one.getId()%>" 
                                                    img-data="<%//=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>" >[<%//=one.getDescription()%>] <%//= one.getStatus() == 1 ? "" : "[LOCK]"%></option>
                                                <%
                                                    //}
                                                %>
                                            </select>-->
                                        </td>
                                        <td style="display: none" align="center" colspan="2">
                                            <select style="width: 150px" class="select3" name="qc<%=i%>">
                                                <option value="0">Không cho Phép</option>
                                                <%
                                                    for (Provider one : Provider.CACHE) {
                                                        out.print("<option " + (one.getCode().equals(routeNationTelcos.get(i-1).getQc()) ? "selected='selected'" : "") + " value='" + one.getCode() + " '>" + one.getName() + "</option>");
                                                    }
                                                %>
                                                <%
                                                    for (GroupProvider one : GroupProvider.CACHE) {
                                                        out.print("<option " + ((one.getId()+"GROUP").equals(routeNationTelcos.get(i-1).getQc()) ? "selected='selected'" : "") + " value='" + (one.getId()+"GROUP")+ " '>[GROUP] -- " + one.getName() + " -- [NHÓM]</option>");
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <% 
                                        }
                                    %>
                                    <%
                                        for (int i = 1; i < 8; i++) {
                                    %>
                                    <tr id="dtgtnew<%=i%>" style="display: none">
                                        <td align="center" class="boder_right" colspan="2">
                                            <select style="width: 150px" class="select3" name="telconew<%=i%>">
                                                <option value="">-- Chọn mạng --</option>
                                                <%
                                                    ArrayList<Telco_Nations> allT = Telco_Nations.getTelco_na();
                                                    for (Telco_Nations one : allT) {
                                                %>
                                                <option value="<%=one.getTelco_code()%>" > [<%=one.getCountry_code()%>] <%=one.getTelco_name()%> </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <select style="width: 150px" class="select3" name="sttnew<%=i%>" >
                                                <option value="1">Kích hoạt</option>
                                                <option value="0">Khóa</option>
                                                <option value="2">Chờ kích hoạt</option>
                                                <option value="3">Đang kích hoạt</option>
                                            </select>
                                            <select style="width: 150px" class="select3" name="duplicatenew<%=i%>">
                                                <option value="0">Chặn trùng</option>
                                                <option value="1">Không chặn</option>
                                            </select>
                                            <select style="width: 150px" class="select3" name="groupnew<%=i%>">
                                                <option value="0">NHÓM</option>
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
                                        <td align="center" class="boder_right" colspan="2">
                                            <select style="width: 150px" class="select3" name="cskhnew<%=i%>">
                                                <option value="0">Không cho Phép</option>
                                                <%
                                                    for (Provider one : Provider.CACHE) {
                                                        out.print("<option value='" + one.getCode() + " '>" + one.getName() + "</option>");
                                                    }
                                                %>
                                                <%
                                                    for (GroupProvider one : GroupProvider.CACHE) {
                                                        out.print("<option value='" + (one.getId()+"GROUP")+ " '>[GROUP] -- " + one.getName() + " -- [NHÓM]</option>");
                                                    }
                                                %>
                                            </select>
                                            <br/>
                                            <input onclick="checkBoxClick(this);" type="checkbox" name="rqnew<%=i%>" value="0"/>Tính 1 tin
                                        </td>
                                        <td align="center" class="boder_right" colspan="2">
                                            <select style="width: 150px;float: left" class="select3" name="cskhunicodenew<%=i%>">
                                                <option value="0">Không cho Phép</option>
                                                <%
                                                    for (Provider one : Provider.CACHE) {
                                                        out.print("<option value='" + one.getCode() + " '>" + one.getName() + "</option>");
                                                    }
                                                %>
                                                <%
                                                    for (GroupProvider one : GroupProvider.CACHE) {
                                                        out.print("<option value='" + (one.getId()+"GROUP")+ " '>[GROUP] -- " + one.getName() + " -- [NHÓM]</option>");
                                                    }
                                                %>
                                            </select>
                                            <br/>
                                            <select style="width: 78px;float: left; display: none" class="select3" name="groupunicodenew<%=i%>">
                                                <option value="0">NHÓM</option>
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
                                        <td align="left" class="boder_right" colspan="2">
                                            <input onclick="checkBoxClick(this);" type="checkbox" name="ckdenhannew<%=i%>" value="0"/> Có đè<br/>
                                            <select style="width: 150px" class="select3" name="denhannew<%=i%>">
                                                <option value="" img-data="">Tất cả</option>
                                                <%
                                                    for (BrandLabel one : allLabel) {
                                                %>
                                                <option value="<%=one.getId()%>"
                                                        img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>" >
                                                    <%=one.getBrandLabel()%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td align="center" colspan="4">
                                            <input type="text" size="15" name="tmpidnew<%=i%>" placeholder="ID Temp" value=""/><br/>
                                            <input type="text" size="15" name="lbidnew<%=i%>" placeholder="ID Label" value=""/><br/>
                                            <input type="text" size="15" name="lbusernamenew<%=i%>" placeholder="Username of Label" value=""/><br/> 
                                            <!--<select style="width: 143px" class="select3" name="id_templatenew<%=i%>">
                                                <option value="">Chọn tin nhắn mẫu</option>
                                                <%
                                                    //for (Template_sms one : allpro) {
                                                %>
                                                <option 
                                                    value="<%//=one.getId()%>" 
                                                    img-data="<%//=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>" >[<%//=one.getDescription()%>] <%//= one.getStatus() == 1 ? "" : "[LOCK]"%></option>
                                                <%
                                                    //}
                                                %>
                                            </select>-->
                                        </td>
                                        <td style="display: none" align="center" colspan="2">
                                            <select style="width: 150px;" class="select3" name="qcnew<%=i%>">
                                                <option value="0">Không cho Phép</option>
                                                <%
                                                    for (Provider one : Provider.CACHE) {
                                                        out.print("<option value='" + one.getCode() + " '>" + one.getName() + "</option>");
                                                    }
                                                %>
                                                <%
                                                    for (GroupProvider one : GroupProvider.CACHE) {
                                                        out.print("<option value='" + (one.getId()+"GROUP")+ " '>[GROUP] -- " + one.getName() + " -- [NHÓM]</option>");
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                    <tr>
                                        <td colspan="12" align="center">
                                            <div id="shownew1" style="float: right">
                                                <img onclick="show('new', 1)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/>
                                            </div>
                                            <div id="hidenew1" style="float: right;display: none">
                                                <img onclick="hide('new', 1)" src="<%=request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px;"/></a>
                                            </div> 
                                            <%
                                                for (int i =2; i < 8; i ++) {
                                            %>
                                                <div id="shownew<%=i%>" style="float: right; display: none">
                                                    <img onclick="show('new', <%=i%>)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/>
                                                </div>
                                                <div id="hidenew<%=i%>" style="float: right;display: none">
                                                    <img onclick="hide('new', <%=i%>)" src="<%=request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px;"/></a>
                                                </div> 
                                            <%
                                                }
                                            %>
                                            <input class="button" type="submit" name="submit" value="Cập nhật"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/brand-declare/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
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