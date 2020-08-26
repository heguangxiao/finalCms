<%@page import="gk.myname.vn.entity.Contract"%>
<%@page import="java.io.File"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page contentType="text/html; charset=utf-8" %>
<%    
    String code = RequestTool.getString(request, "code");
    int subID = Integer.parseInt(request.getParameter("subid"));
    int partnerID = Integer.parseInt(request.getParameter("partnerID"));
    String contractNo = request.getParameter("contractNo");
    
    System.out.println("Bắt đầu từ đây");
    
    System.out.println(subID);
    System.out.println(partnerID);
    System.out.println(contractNo);
    
    Contract contr = Contract.getID(subID, partnerID, contractNo);
    
    if (contr == null) {
        System.out.println("null rồi");
    } else {
        System.out.println("ko rỗng nhé");
    }
    
    File file = new File(getServletContext().getRealPath("/") + code);
    
    if (file.delete()) {
        String newPath = contr.getFile_path().replace(file.getName()+",", "");
        System.out.println(newPath);
        
        contr.setFile_path(newPath);  
        
        Contract contract = new Contract();
        
        if (contract.update(contr)) {
            System.out.println("thành công rồi");
        } else {
            System.out.println(" thất bại rồi");
        }
        
        out.print(file.getName() + " is deleted!");
    } else {
        out.print("Delete operation is failed.");
    }
%>
