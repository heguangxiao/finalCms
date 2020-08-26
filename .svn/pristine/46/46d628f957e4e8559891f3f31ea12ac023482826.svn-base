<%@page import="gk.myname.vn.entity.Provider"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.Template_sms"%>
<%@page import="gk.myname.vn.utils.SMSUtils"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page contentType="text/html; charset=utf-8" %>
<html>
    <head>
        <%@include file="/admin/includes/header.jsp" %></head>
    <script type="text/javascript">
            $(document).ready(function () {
                $("#providerCode").select2({
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
                        var opt = $("#providerCode option:selected");
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
        <%                if (!userlogin.checkAdd(request)) {
                session.setAttribute("mess", "Bạn không có quyền thêm module này!");
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                return;
            }
            if (request.getParameter("submit") != null) {
                //---------------------------
                int id_template_send = Tool.string2Integer(request.getParameter("id_template_send"));
                int id_provider = Tool.string2Integer(request.getParameter("id_provider"));
                String content = Tool.validStringRequest(request.getParameter("content"));
                String key1 = Tool.validStringRequest(request.getParameter("key1"));
                String key2 = Tool.validStringRequest(request.getParameter("key2"));
                String key3 = Tool.validStringRequest(request.getParameter("key3"));
                String key4 = Tool.validStringRequest(request.getParameter("key4"));
                String key5 = Tool.validStringRequest(request.getParameter("key5"));
                String key6 = Tool.validStringRequest(request.getParameter("key6"));
                String key7 = Tool.validStringRequest(request.getParameter("key7"));
                String key8 = Tool.validStringRequest(request.getParameter("key8"));
                String key9 = Tool.validStringRequest(request.getParameter("key9"));
                String key10 = Tool.validStringRequest(request.getParameter("key10"));
                int status = Tool.string2Integer(request.getParameter("status"));
                String description = Tool.validStringRequest(request.getParameter("description"));
                
                if (content == null || content.equals("") || description == null || content.equals("")) {                    
                    session.setAttribute("mess", "Mô tả và nội dung không được để trống");
                    response.sendRedirect(request.getContextPath() + "/admin/template_sms/add.jsp");
                    return;
                }
                
                if (key1 == null || key1.equals("")) {
                    session.setAttribute("mess", "Phải nhập ít nhất key 1 cho template");
                    response.sendRedirect(request.getContextPath() + "/admin/template_sms/add.jsp");
                    return;
                }
                
                Template_sms oneTem = new Template_sms();
                oneTem.setId_template_send(id_template_send);
                oneTem.setId_provider(id_provider);
                oneTem.setContent(content);
                oneTem.setKey1(key1);
                oneTem.setKey2(key2);
                oneTem.setKey3(key3);
                oneTem.setKey4(key4);
                oneTem.setKey5(key5);
                oneTem.setKey6(key6);
                oneTem.setKey7(key7);
                oneTem.setKey8(key8);
                oneTem.setKey9(key9);
                oneTem.setKey10(key10);
                oneTem.setCreatedby(userlogin.getUserName());
                oneTem.setStatus(status);
                oneTem.setDescription(description);

                //------------
                Template_sms temDao = new Template_sms();
                if (temDao.add(oneTem)) {
                    session.setAttribute("mess", "Thêm mới dữ liệu thành công!");
                    response.sendRedirect(request.getContextPath() + "/admin/template_sms/index.jsp");
                    return;
                } else {
                    session.setAttribute("mess", "Thêm mới dữ liệu lỗi!");
                    response.sendRedirect(request.getContextPath() + "/admin/template_sms/index.jsp");
                    return;
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
                           <%if (session.getAttribute("mess") != null) {
                                    out.print(session.getAttribute("mess"));
                                    session.removeAttribute("mess");
                                }%>
                        </div>
                        <form action="" method="post">
                            <table  align="center" id="rounded-corner">
                                <thead>
                                    <tr>
                                        <th scope="col" class="rounded-company"></th>
                                        <th scope="col" class="rounded"></th>
                                        <th style="font-weight: bold" scope="col" class="rounded redBoldUp">Thêm mới mẫu tin nhắn</th>
                                        <th scope="col" class="rounded-q4"></th>
                                    </tr>
                                </thead>
                                <tbody> 
                                    <tr>                                        
                                        <td></td>
                                        <td style="color: red">* Tạo mới template nội dung tin nhắn. VD ở cuối trang </td>
                                        <td></td>
                                        <td></td>
                                    </tr>      
                                    <tr>
                                        <td></td>
                                        <td align="left">Nội dung tin nhắn</td>
                                        <td>
                                            <textarea cols="57" name="content"></textarea>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>                                        
                                        <td></td>
                                        <td style="color: red">*Nhập nội dung theo dạng : </td>
                                        <td style="color: red">#KEYWORD1#...#KEYWORD2#...#KEYWORD3#.....#KEYWORD9#...#KEYWORD#...</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Mô tả</td>
                                        <td>
                                            <textarea cols="57" name="description"></textarea>
                                        </td>
                                        <td></td>
                                    </tr>    
                                    <tr>                                        
                                        <td></td>
                                        <td style="color: red">*Mô tả template này của ncc nào </td>
                                        <td style="color: red">hoặc đơn giản là tên gợi nhớ của template</td>
                                        <td></td>
                                    </tr>  
                                    <tr>
                                        <td></td>
                                        <td align="left">Mã nhà cung cấp </td>
                                         <td>
                                            <select style="width: 420px" name="id_provider" id="providerCode">
                                                <option value="">***** Chọn nhà cung cấp*****</option>
                                                <%
                                                    ArrayList<Provider> allpro = Provider.getCACHE();
                                                    for (Provider one : allpro) {
                                                %>
                                                <option value="<%=one.getId()%>" 
                                                        img-data="<%=(one.getStatus() == 1 ? "" : "/admin/resource/images/lock1.png")%>" >[<%=one.getId()%>][<%=one.getCode()%>] <%=one.getName()%> <%= one.getStatus() == 1 ? "" : "[LOCK]"%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </td>
                                        <td></td>
                                    </tr>   
                                    <tr>                                        
                                        <td></td>
                                        <td style="color: red">*Chọn nhà cung cấp nếu template này</td>
                                        <td style="color: red">là của nhà cung cấp đưa cho</td>
                                        <td></td>
                                    </tr>                     
                                    <tr>
                                        <td></td>
                                        <td align="left">ID Temp Ncc:</td>
                                        <td><input autocomplete="off" size="50" type="text" name="id_template_send"/></td>
                                        <td></td>
                                    </tr>   
                                    <tr>                                        
                                        <td></td>
                                        <td style="color: red">*Nhập mã ID template </td>
                                        <td style="color: red">của ncc để dùng khi gửi sms sang ncc</td>
                                        <td></td>
                                    </tr>   
                                    <tr>
                                        <td></td>
                                        <td>Tên biến 1</td>
                                        <td><input type="text" name="key1"/>
                                            &nbsp;&nbsp;
                                            Tên biến 2
                                            <input type="text" name="key2"/>
                                        </td>
                                        <td></td>
                                    </tr>          
                                    <tr>                                        
                                        <td></td>
                                        <td style="color: red">*Tên biến 1 là bắt buộc, các tên biến khác có thể không cần,</td>
                                        <td style="color: red">nhập tên biến theo đúng thứ tự từ 1 cho đến 10</td>
                                        <td></td>
                                    </tr>                          
                                    <tr>
                                        <td></td>
                                        <td>Tên biến 3</td>
                                        <td><input type="text" name="key3"/>
                                            &nbsp;&nbsp;
                                            Tên biến 4
                                            <input type="text" name="key4"/>
                                        </td>
                                        <td></td>
                                    </tr>                               
                                    <tr>
                                        <td></td>
                                        <td>Tên biến 5</td>
                                        <td><input type="text" name="key5"/>
                                            &nbsp;&nbsp;
                                            Tên biến 6
                                            <input type="text" name="key6"/>
                                        </td>
                                        <td></td>
                                    </tr>                               
                                    <tr>
                                        <td></td>
                                        <td>Tên biến 7</td>
                                        <td><input type="text" name="key7"/>
                                            &nbsp;&nbsp;
                                            Tên biến 8
                                            <input type="text" name="key8"/>
                                        </td>
                                        <td></td>
                                    </tr>                               
                                    <tr>
                                        <td></td>
                                        <td>Tên biến 9</td>
                                        <td><input type="text" name="key9"/>
                                            &nbsp;&nbsp;
                                            Tên biến 10
                                            <input type="text" name="key10"/>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td align="left">Trạng thái: </td>
                                        <td colspan="2">
                                            <select name="status">
                                                <option value="1">Kích hoạt</option>
                                                <option value="0">Khóa</option>
                                            </select>
                                        </td>
                                    </tr>                                    
                                    <tr>
                                        <td colspan="4" align="center">
                                            <input class="button" type="submit" name="submit" value="Thêm mới"/>
                                            <input class="button" onclick="window.location.href = '<%=request.getContextPath() + "/admin/template_sms/"%>'" type="reset" name="reset" value="Hủy"/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                        <br/>
                        <br/>
                        <br/>
                        <br/>
                        <br/>
                        <br/>
                        <table  align="center" id="rounded-corner">
                            <tbody>                            
                                <tr>
                                    <td colspan="4" align="center">
                                        <img style="width: auto;height: auto" src="<%= request.getContextPath()%>/admin/resource/images/addtemplatesms.png"alt="Xem"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>  
                <div class="clear"></div>
            </div> 
            <%@include file="/admin/includes/footer.jsp" %>
        </div>
    </body>
</html>