<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="gk.myname.vn.entity.BrandLabel"%><%@page import="java.io.File"%><%@page import="gk.myname.vn.config.MyContext"%><%@page import="gk.myname.vn.utils.RequestTool"%>
<%
    int id = RequestTool.getInt(request, "bid");
    BrandLabel oneBrand = new BrandLabel();
    oneBrand = oneBrand.getById(id);
    String fileName = RequestTool.getString(request, "f");
    String rootPath = MyContext.ROOT_DIR + BrandLabel.BRAND_FILE_UPLOAD + "/" + oneBrand.getBrandLabel().toLowerCase() + "-" + id + "/" + fileName;
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    Tool.debug("rootPath:"+rootPath);
    File f = new File(rootPath);
    if (f.exists()) {
            if (f.delete()) {
                session.setAttribute("mess", "Xóa File thành công");
            } else {
                session.setAttribute("mess", "Delete operation is failed.");
            }
        response.sendRedirect(request.getContextPath() + "/admin/brand/index.jsp");
    } else {
        session.setAttribute("mess", "Xóa File th?t b?i");
        response.sendRedirect(request.getContextPath() + "/admin/brand/addDocument.jsp?bid=" + id);        
    }
%>