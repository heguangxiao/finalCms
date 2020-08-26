<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="gk.myname.vn.utils.DateProc"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gk.myname.vn.entity.KeysBlackList"%>
<%@page contentType="text/html; charset=utf-8" %>
<%
    try {
        ArrayList<KeysBlackList> all = null;
        
        KeysBlackList dao = new KeysBlackList();
        
        int currentPage = RequestTool.getInt(request, "page", 1);
        String telco = RequestTool.getString(request, "telco");
        String keyVn = RequestTool.getString(request, "keyvn");
        String keyEn = RequestTool.getString(request, "keyen");
        String brandname = RequestTool.getString(request, "brandname");
        
        all = dao.findAllEx(telco, keyVn, keyEn, brandname);
        out.clear();
        out = pageContext.pushBody();
        createExcel(all, response);
        return;
    } catch (Exception ex) {
        System.out.println(ex.getMessage());
    }
%>

<%!
    public static void createExcel(ArrayList<KeysBlackList> allMoLog, HttpServletResponse response) {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet(DateProc.createDDMMYYYY().replaceAll("/", ""));
//        Map<String, Object[]> data = new HashMap<String, Object[]>();
        ArrayList<Object[]> data = new ArrayList();
        double total = 0;
        int i = 1;
        data.add(new Object[]{
            "STT",
            "TELCO",
            "TIẾNG VIETNAM",
            "TIẾNG ANH",
            "BRANDNAME"
        });
        for (KeysBlackList onemo : allMoLog) {
            //Dat gia tri cho tung hang
            data.add(new Object[]{
                i++,
                onemo.getTelco(),
                onemo.getKey_vn(),
                onemo.getKey_en(),
                onemo.getBrandname()
            });
        }
        int rownum = 0;
        for (Object[] objArr : data) {
            Row row = sheet.createRow(rownum++);
            int cellnum = 0;
            for (Object obj : objArr) {
                Cell cell = row.createCell(cellnum++);
                if (obj instanceof Timestamp) {
                    cell.setCellValue((Date) obj);
                } else if (obj instanceof Boolean) {
                    cell.setCellValue((Boolean) obj);
                } else if (obj instanceof String) {
                    cell.setCellValue((String) obj);
                } else if (obj instanceof Double) {
                    cell.setCellValue((Double) obj);
                } else if (obj instanceof Integer) {
                    cell.setCellValue((Integer) obj);
                } else {
                    cell.setCellValue((String) obj);
                }
            }
        }

        try {
            ServletOutputStream os = null;
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=List_Key_Black-" + DateProc.createDDMMYYYY() + ".xlsx");
            os = response.getOutputStream();
            os.flush();
            workbook.write(os);
            System.out.println("Excel written successfully..");
        } catch (Exception e) {
            // e.printStackTrace();
            System.out.println(e.getMessage());
        }
    }
%>