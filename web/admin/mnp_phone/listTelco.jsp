<%@page import="gk.myname.vn.entity.Telco_Nations"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page contentType="text/html; charset=utf-8" %>
<%    
    String code = RequestTool.getString(request, "code");
%>
    <option value="">Tất cả</option>
<%
    if (!Tool.checkNull(code)) {
        
        String country_code = Telco_Nations.getCountryCodeByTelcoCode(code);
        ArrayList<Telco_Nations> allLabel = Telco_Nations.getTelcosByCountryCode(country_code);
        for (Telco_Nations elem : allLabel) {
%>
            <option value="<%=elem.getTelco_code()%>">[<%=elem.getCountry_code()%>] [<%=elem.getTelco_code()%>] <%=elem.getTelco_name()%></option>
<%
        }
    } else {
        ArrayList<Telco_Nations> telco_Nations = Telco_Nations.getTelco_na();
        for (Telco_Nations elem : telco_Nations) {
%>
            <option value="<%=elem.getTelco_code()%>">[<%=elem.getCountry_code()%>] [<%=elem.getTelco_code()%>] <%=elem.getTelco_name()%></option>
<%      
        }
    }
%>
