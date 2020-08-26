<%@page import="gk.myname.vn.entity.Groups_Providers"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="gk.myname.vn.entity.GroupProvider"%>
<%@page import="gk.myname.vn.entity.Provider"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.PhoneBlackList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page contentType="text/html; charset=utf-8" %>
<html>
    <head><%@include file="/admin/includes/header.jsp" %></head>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/admin/resource/select2/select2.css" />
    <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath()%>/admin/resource/select2/select2_locale_vi.js"></script>
    <script type="text/javascript" language="javascript">
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
    </script>
    <body>
        <%      
            if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền truy cập trang này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            int id = RequestTool.getInt(request, "id");
            
            GroupProvider dao = new GroupProvider();
            Groups_Providers daos = new Groups_Providers();
            Provider pro = new Provider();
            String message = "";
            GroupProvider groupProvider = dao.findById(id);
            if (id <= 0) {
                session.setAttribute("mess", "Nội dung bạn tìm kiếm không tồn tại ! ");
                response.sendRedirect(request.getContextPath() + "/admin/group_provider/");
                return;
            }
            
            if (request.getParameter("submit") != null) {
                
                String name = RequestTool.getString(request, "name");
                
                if (Tool.checkNull(name)) {
                    session.setAttribute("mess", "Tên nhóm nhà cung cấp không được để trống");
                    response.sendRedirect(request.getContextPath() + "/admin/group_provider/edit.jsp?id="+id);
                    return;
                }
                
                if (!name.equals(groupProvider.getName())) {
                    if (dao.existNameGroup(name)) {
                        session.setAttribute("mess", "Tên nhóm nhà cung cấp đã tồn tại");
                        response.sendRedirect(request.getContextPath() + "/admin/group_provider/edit.jsp?id="+id);
                        return;
                    }
                }
                
                String description = RequestTool.getString(request, "description");
                String providerId1 = RequestTool.getString(request, "providerId1");
                String providerId2 = RequestTool.getString(request, "providerId2");
                String providerId3 = RequestTool.getString(request, "providerId3");
                String providerId4 = RequestTool.getString(request, "providerId4");
                String providerId5 = RequestTool.getString(request, "providerId5");
                String providerId6 = RequestTool.getString(request, "providerId6");
                String providerId7 = RequestTool.getString(request, "providerId7");
                String providerId8 = RequestTool.getString(request, "providerId8");
                String providerId9 = RequestTool.getString(request, "providerId9");
                String providerId10 = RequestTool.getString(request, "providerId10");
                int number1 = Tool.string2Integer(RequestTool.getString(request, "number1"));
                int number2 = Tool.string2Integer(RequestTool.getString(request, "number2"));
                int number3 = Tool.string2Integer(RequestTool.getString(request, "number3"));
                int number4 = Tool.string2Integer(RequestTool.getString(request, "number4"));
                int number5 = Tool.string2Integer(RequestTool.getString(request, "number5"));
                int number6 = Tool.string2Integer(RequestTool.getString(request, "number6"));
                int number7 = Tool.string2Integer(RequestTool.getString(request, "number7"));
                int number8 = Tool.string2Integer(RequestTool.getString(request, "number8"));
                int number9 = Tool.string2Integer(RequestTool.getString(request, "number9"));
                int number10 = Tool.string2Integer(RequestTool.getString(request, "number10"));
                int checkSL = Tool.string2Integer(RequestTool.getString(request, "checkSL"));
                String stt = RequestTool.getString(request, "status");
                int status = Tool.string2Integer(stt);
                
                groupProvider.setName(name);
                groupProvider.setDescription(description);
                groupProvider.setStatus(status);
                groupProvider.setUpdatedBy(userlogin.getAccID());
                
                if (dao.edit(groupProvider)) {                    
                    message += "Sửa thông tin nhóm " + groupProvider.getName() + " thành công <br/>";
                    Groups_Providers gp = null;
                    Provider provider = null;
                    
                    for (Groups_Providers delGroups_Providers : groupProvider.getGroups_Providerses()) {
                        daos.delete(groupProvider.getId(), delGroups_Providers.getProvider_id());
                    }
                    
                    if (!Tool.checkNull(providerId1)) {
                        provider = pro.getByCode(providerId1);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number1);                     
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId1 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId1 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        } 
                    } 
                    
                    if (!Tool.checkNull(providerId2)) {
                        provider = pro.getByCode(providerId2);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number2);
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId2 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId2 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        }
                    }
                    
                    if (!Tool.checkNull(providerId3)) {
                        provider = pro.getByCode(providerId3);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number3);
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId3 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId3 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        }
                    } 
                    
                    if (!Tool.checkNull(providerId4)) {
                        provider = pro.getByCode(providerId4);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number4);
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId4 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId4 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        }
                    } 
                    
                    if (!Tool.checkNull(providerId5)) {
                        provider = pro.getByCode(providerId5);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number5);
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId5 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId5 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        }
                    } 
                    
                    if (!Tool.checkNull(providerId6)) {
                        provider = pro.getByCode(providerId6);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number6);
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId6 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId6 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        }
                    } 
                    
                    if (!Tool.checkNull(providerId7)) {
                        provider = pro.getByCode(providerId7);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number7);
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId7 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId7 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        }
                    } 
                    
                    if (!Tool.checkNull(providerId8)) {
                        provider = pro.getByCode(providerId8);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number8);
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId8 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId8 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        } 
                    } 
                    
                    if (!Tool.checkNull(providerId9)) {
                        provider = pro.getByCode(providerId9);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number9);
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId9 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId9 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        }
                    } 
                    
                    if (!Tool.checkNull(providerId10)) {
                        provider = pro.getByCode(providerId10);
                        if (provider != null) {
                            gp = new Groups_Providers(groupProvider.getId(), provider.getId(), number10);
                            if (daos.add(gp)) {                                            
//                                message += "Sửa provider " +providerId10 + " vào nhóm thành công <br/>";
                            } else {                                    
//                                message += "Sửa provider " +providerId10 + " vào nhóm không thành công vì nhà cung cấp này đã có <br/>";
                            }
                        } 
                    } 
                } else {
                    message += "Sửa thông tin nhóm " + groupProvider.getName() + " không thành công <br/>";
                }
                
                session.setAttribute("mess", message);
                response.sendRedirect(request.getContextPath() + "/admin/group_provider/index.jsp");
                return;

            }
        %>
        <div id="main_container">
            <%@include file="/admin/includes/checkLogin.jsp" %>
            <div class="main_content">
                <%@include file="/admin/includes/menu.jsp" %>
                <div class="center_content">
                    <div class="right_content">
                        <div align="center" style="margin-bottom: 2px; color: red;font-weight: bold">
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
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Sửa thông tin nhóm nhà cung cấp</th>                                        
                                        <th scope="col" class="rounded"></th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td align="left">Tên nhóm </td>
                                        <td colspan="2">
                                            <input size="50" type="text" placeholder="Group Name" name="name" value="<%=groupProvider.getName()%>"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Mô tả </td>
                                        <td colspan="2">
                                            <input size="50" type="text" placeholder="Description" name="description" value="<%=groupProvider.getDescription()%>"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Nhà cung cấp 1 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId1" id="providerId1">
                                                <option value="">***** Chọn nhà cung cấp 1 *****</option>
                                                <%
                                                    ArrayList<Provider> allpro = Provider.getCACHE();
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option 
                                                    <%=groupProvider.getGroups_Providerses().size() <= 0 ? "" : groupProvider.getGroups_Providerses().get(0).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number1" value="<%=groupProvider.getGroups_Providerses().size() <= 0 ? "" : groupProvider.getGroups_Providerses().get(0).getNumber()%>"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Nhà cung cấp 2 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId2" id="providerId2">
                                                <option value="">***** Chọn nhà cung cấp 2 *****</option>
                                                <%
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option 
                                                    <%=groupProvider.getGroups_Providerses().size() <= 1 ? "" : groupProvider.getGroups_Providerses().get(1).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number2" value="<%=groupProvider.getGroups_Providerses().size() <= 1 ? "" : groupProvider.getGroups_Providerses().get(1).getNumber()%>"/>
                                        </td>
                                        <td>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 2 ? "" : "style='display:none'"%> id="add3" align="center">
                                                <img onclick="addNCC(3)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr <%=groupProvider.getGroups_Providerses().size() <= 2 ? "style='display:none'" : ""%> id="ncc3">
                                        <td></td>
                                        <td align="left">Nhà cung cấp 3 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId3" id="providerId3">
                                                <option value="">***** Chọn nhà cung cấp 3 *****</option>
                                                <%
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option 
                                                    <%=groupProvider.getGroups_Providerses().size() <= 2 ? "" : groupProvider.getGroups_Providerses().get(2).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number3" value="<%=groupProvider.getGroups_Providerses().size() <= 2 ? "" : groupProvider.getGroups_Providerses().get(2).getNumber()%>"/>
                                        </td>
                                        <td>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 3 ? "" : "style='display:none'"%> id="del3" align="center">
                                                <img onclick="deleteNCC(3)" src="<%= request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px"/></a>
                                            </div>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 3 ? "" : "style='display:none'"%> id="add4" align="center">
                                                <img onclick="addNCC(4)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr <%=groupProvider.getGroups_Providerses().size() <= 3 ? "style='display:none'" : ""%> id="ncc4">
                                        <td></td>
                                        <td align="left">Nhà cung cấp 4 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId4" id="providerId4">
                                                <option value="">***** Chọn nhà cung cấp 4 *****</option>
                                                <%
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option 
                                                    <%=groupProvider.getGroups_Providerses().size() <= 3 ? "" : groupProvider.getGroups_Providerses().get(3).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number4" value="<%=groupProvider.getGroups_Providerses().size() <= 3 ? "" : groupProvider.getGroups_Providerses().get(3).getNumber()%>"/>
                                        </td>
                                        <td>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 4 ? "" : "style='display:none'"%> id="del4" align="center">
                                                <img onclick="deleteNCC(4)" src="<%= request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px"/></a>
                                            </div>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 4 ? "" : "style='display:none'"%> id="add5" align="center">
                                                <img onclick="addNCC(5)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr <%=groupProvider.getGroups_Providerses().size() <= 4 ? "style='display:none'" : ""%> id="ncc5" >
                                        <td></td>
                                        <td align="left">Nhà cung cấp 5 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId5" id="providerId5">
                                                <option value="">***** Chọn nhà cung cấp 5 *****</option>
                                                <%
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option 
                                                    <%=groupProvider.getGroups_Providerses().size() <= 4 ? "" : groupProvider.getGroups_Providerses().get(4).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number5" value="<%=groupProvider.getGroups_Providerses().size() <= 4 ? "" : groupProvider.getGroups_Providerses().get(4).getNumber()%>"/>
                                        </td>
                                        <td>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 5 ? "" : "style='display:none'"%> id="del5" align="center">
                                                <img onclick="deleteNCC(5)" src="<%= request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px"/></a>
                                            </div>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 5 ? "" : "style='display:none'"%> id="add6" align="center">
                                                <img onclick="addNCC(6)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr <%=groupProvider.getGroups_Providerses().size() <= 5 ? "style='display:none'" : ""%> id="ncc6">
                                        <td></td>
                                        <td align="left">Nhà cung cấp 6 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId6" id="providerId6">
                                                <option value="">***** Chọn nhà cung cấp 6 *****</option>
                                                <%
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option 
                                                    <%=groupProvider.getGroups_Providerses().size() <= 5 ? "" : groupProvider.getGroups_Providerses().get(5).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number6" value="<%=groupProvider.getGroups_Providerses().size() <= 5 ? "" : groupProvider.getGroups_Providerses().get(5).getNumber()%>"/>
                                        </td>
                                        <td>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 6 ? "" : "style='display:none'"%> id="del6" align="center">
                                                <img onclick="deleteNCC(6)" src="<%= request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px"/></a>
                                            </div>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 6 ? "" : "style='display:none'"%> id="add7" align="center">
                                                <img onclick="addNCC(7)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr <%=groupProvider.getGroups_Providerses().size() <= 6 ? "style='display:none'" : ""%> id="ncc7">
                                        <td></td>
                                        <td align="left">Nhà cung cấp 7 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId7" id="providerId7">
                                                <option value="">***** Chọn nhà cung cấp 7 *****</option>
                                                <%
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option 
                                                    <%=groupProvider.getGroups_Providerses().size() <= 6 ? "" : groupProvider.getGroups_Providerses().get(6).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number7" value="<%=groupProvider.getGroups_Providerses().size() <= 6 ? "" : groupProvider.getGroups_Providerses().get(6).getNumber()%>"/>
                                        </td>
                                        <td>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 7 ? "" : "style='display:none'"%> id="del7" align="center">
                                                <img onclick="deleteNCC(7)" src="<%= request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px"/></a>
                                            </div>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 7 ? "" : "style='display:none'"%> id="add8" align="center">
                                                <img onclick="addNCC(8)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png" /></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr <%=groupProvider.getGroups_Providerses().size() <= 7 ? "style='display:none'" : ""%> id="ncc8">
                                        <td></td>
                                        <td align="left">Nhà cung cấp 8 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId8" id="providerId8">
                                                <option value="">***** Chọn nhà cung cấp 8 *****</option>
                                                <%
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option 
                                                    <%=groupProvider.getGroups_Providerses().size() <= 7 ? "" : groupProvider.getGroups_Providerses().get(7).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number8" value="<%=groupProvider.getGroups_Providerses().size() <= 7 ? "" : groupProvider.getGroups_Providerses().get(7).getNumber()%>"/>
                                        </td>
                                        <td>  
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 8 ? "" : "style='display:none'"%> id="del8" align="center">
                                                <img onclick="deleteNCC(8)" src="<%= request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px"/></a>
                                            </div>                                       
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 8 ? "" : "style='display:none'"%> id="add9" align="center">
                                                <img onclick="addNCC(9)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr <%=groupProvider.getGroups_Providerses().size() <= 8 ? "style='display:none'" : ""%> id="ncc9">
                                        <td></td>
                                        <td align="left">Nhà cung cấp 9 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId9" id="providerId9">
                                                <option value="">***** Chọn nhà cung cấp 9 *****</option>
                                                <%
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option
                                                    <%=groupProvider.getGroups_Providerses().size() <= 8 ? "" : groupProvider.getGroups_Providerses().get(8).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number9" value="<%=groupProvider.getGroups_Providerses().size() <= 8 ? "" : groupProvider.getGroups_Providerses().get(8).getNumber()%>"/>
                                        </td>
                                        <td>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 9 ? "" : "style='display:none'"%> id="del9" align="center">
                                                <img onclick="deleteNCC(9)" src="<%= request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px;"/></a>
                                            </div>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 9 ? "" : "style='display:none'"%> id="add10" align="center">
                                                <img onclick="addNCC(10)" src="<%= request.getContextPath()%>/admin/resource/images/Add.png"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr <%=groupProvider.getGroups_Providerses().size() <= 9 ? "style='display:none'" : ""%> id="ncc10">
                                        <td></td>
                                        <td align="left">Nhà cung cấp 10 </td>
                                        <td colspan="2">
                                            <select style="width: 298px" class="select3" name="providerId10" id="providerId10">
                                                <option value="">***** Chọn nhà cung cấp 10 *****</option>
                                                <%
                                                    for (Provider one : allpro) {
                                                        if(one.getStatus() != 1) continue;
                                                %>
                                                <option 
                                                    <%=groupProvider.getGroups_Providerses().size() <= 9 ? "" : groupProvider.getGroups_Providerses().get(9).getProvider().getCode().equals(one.getCode()) ? "selected='selected'" : ""%>
                                                    value="<%=one.getCode()%>" img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>">
                                                    <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            Tần suất : <input size="7" type="text" name="number10" value="<%=groupProvider.getGroups_Providerses().size() <= 9 ? "" : groupProvider.getGroups_Providerses().get(9).getNumber()%>"/>
                                        </td>
                                        <td>
                                            <div <%=groupProvider.getGroups_Providerses().size() <= 10 ? "" : "style='display:none'"%> id="del10" align="center">
                                                <img onclick="deleteNCC(10)" src="<%= request.getContextPath()%>/admin/resource/images/delete.jpg" style="width: 16px;height: 16px"/></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Trạng thái </td>
                                        <td colspan="2">
                                            <select name="status" id="status">
                                                <option <%=groupProvider.getStatus()== 1 ? "selected='selected'" : ""%> value="1">Active</option>
                                                <option <%=groupProvider.getStatus() == 0 ? "selected='selected'" : ""%> value="0">Khóa</option>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr style="display: none">
                                        <td></td>
                                        <td align="left"></td>
                                        <td colspan="2">
                                            <input type="text" id="checkSL" name="checkSL" value="2"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <SCRIPT language="javascript">
                                            function addNCC(num) {
                                                document.getElementById('add'+num).style.display = 'none';
                                                document.getElementById('del'+num).style.display = '';
                                                document.getElementById('ncc'+num).style.display = '';
                                                document.getElementById('checkSL').value = num;
                                                let i = num - 1;
                                                document.getElementById('del'+i).style.display = 'none';
                                            }

                                            function deleteNCC(num) {                                  
                                                let i = num - 1;
                                                document.getElementById('providerId'+num).value = ''; 
                                                document.getElementById('checkSL').value = i;         
                                                document.getElementById('add'+num).style.display = '';
                                                document.getElementById('del'+num).style.display = 'none';
                                                document.getElementById('ncc'+num).style.display = 'none';
                                                document.getElementById('del'+i).style.display = '';     
                                            }

                                    </SCRIPT>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input class="button" type="submit" name="submit" value="Sửa"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/group_provider/index.jsp"%>'" type="reset" name="reset" value="Hủy"/>
                                        </td>
                                        <td></td>
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