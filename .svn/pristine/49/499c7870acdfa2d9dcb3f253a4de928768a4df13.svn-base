<%@page import="gk.myname.vn.entity.GroupProvider"%>
<%@page import="gk.myname.vn.entity.RouteNationTelco"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gk.myname.vn.entity.BrandLabel"%><%@page import="gk.myname.vn.utils.RequestTool"%><%@page contentType="text/html; charset=utf-8" %>
<%
    int brId = RequestTool.getInt(request, "brid");
    String br_name = RequestTool.getString(request, "br_name");
    String user = RequestTool.getString(request, "user");
    ArrayList<RouteNationTelco> routeNationTelcos = RouteNationTelco.getAllByBrandnameAndUserowner(br_name, user);
    if (routeNationTelcos.size() > 0) {
    RouteNationTelco vte = null;
    RouteNationTelco mobi = null;
    RouteNationTelco vina = null;
    for (RouteNationTelco elem : routeNationTelcos) {
        if (elem.getTelcoCode().equals("VTE")) {
            vte = elem;
        }
        if (elem.getTelcoCode().equals("VMS")) {
            mobi = elem;
        }
        if (elem.getTelcoCode().equals("GPC")) {
            vina = elem;
        }
    }
%>
    <% if (vte!=null) {%>
        <div style="float: left;border-right: 1px solid #cd0a0a;width: 180px">
            <div style="float: left;color: #F78D1D;font-weight: bold;width: 53px">VIETTEL:</div>
            <div style="float: left">
                CSKH =>
                <%
                    if (!vte.getCskh().endsWith("GROUP")) {
                %> 
                <%=vte.getCskh().equals("0") ? "<span style='color: red;font-weight: bold'>Không Cấp</span>" : "<span style='color: blue;font-weight: bold'>" + vte.getCskh() + "</span>"%>
                <%
                    } else {
                        int nnn = vte.getCskh().lastIndexOf("GROUP");
                        String aaa = vte.getCskh().substring(0, nnn);
                        GroupProvider groupProvider = GroupProvider.findById(Integer.parseInt(aaa));
                        if (groupProvider != null) {
                %>
                <span style="color: blue;font-weight: bold">Nhóm : <%=groupProvider!= null ? groupProvider.getName() : "Không cấp"%></span>
                <%
                        }
                    }
                %>
                <br/>
                Chặn tin trùng => <%= vte.getDuplicate() == 1 ? "<span style='color: red;font-weight: bold'>No</span>" : "<span style='color: blue;font-weight: bold'>Yes</span>"%>
            </div>
        </div>
    <%}%>
    
    <% if (mobi!=null) {%>
        <div style="float: left;border-right: 1px solid #cd0a0a;width: 180px">
            <div style="float: left;color: #F78D1D;font-weight: bold;width: 53px">MOBI:</div>
            <div style="float: left">
                CSKH =>
                <%
                    if (!mobi.getCskh().endsWith("GROUP")) {
                %> 
                <%=mobi.getCskh().equals("0") ? "<span style='color: red;font-weight: bold'>Không Cấp</span>" : "<span style='color: blue;font-weight: bold'>" + mobi.getCskh() + "</span>"%>
                <%
                    } else {
                        int nnn = mobi.getCskh().lastIndexOf("GROUP");
                        String aaa = mobi.getCskh().substring(0, nnn);
                        GroupProvider groupProvider = GroupProvider.findById(Integer.parseInt(aaa));
                        if (groupProvider != null) {
                %>
                <span style="color: blue;font-weight: bold">Nhóm : <%=groupProvider!= null ? groupProvider.getName() : "Không cấp"%></span>
                <%
                        }
                    }
                %>
                <br/>
                Chặn tin trùng => <%= mobi.getDuplicate() == 1 ? "<span style='color: red;font-weight: bold'>No</span>" : "<span style='color: blue;font-weight: bold'>Yes</span>"%>
            </div>
        </div>
    <%}%>
    
    <% if (vina!=null) {%>
        <div style="float: left">
            <div style="float: left;color: #F78D1D;font-weight: bold;width: 53px">VINA:</div>
            <br/>
            <div style="float: left">
                CSKH =>
                <%
                    if (!vina.getCskh().endsWith("GROUP")) {
                %> 
                <%=vina.getCskh().equals("0") ? "<span style='color: red;font-weight: bold'>Không Cấp</span>" : "<span style='color: blue;font-weight: bold'>" + vina.getCskh() + "</span>"%>
                <%
                    } else {
                        int nnn = vina.getCskh().lastIndexOf("GROUP");
                        String aaa = vina.getCskh().substring(0, nnn);
                        GroupProvider groupProvider = GroupProvider.findById(Integer.parseInt(aaa));
                        if (groupProvider != null) {
                %>
                <span style="color: blue;font-weight: bold">Nhóm : <%=groupProvider!= null ? groupProvider.getName() : "Không cấp"%></span>
                <%
                        }
                    }
                %>
                <br/>
                Chặn tin trùng => <%= vina.getDuplicate() == 1 ? "<span style='color: red;font-weight: bold'>No</span>" : "<span style='color: blue;font-weight: bold'>Yes</span>"%>
            </div>
        </div>
    <%}%>
<%
    }
%>
