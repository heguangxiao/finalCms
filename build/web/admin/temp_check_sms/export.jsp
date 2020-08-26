<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="gk.myname.vn.utils.DateProc"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="gk.myname.vn.utils.Tool"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.TemplateCheckSMS"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %>
<%
    try {
        ArrayList<TemplateCheckSMS> all = null;
        
        TemplateCheckSMS dao = new TemplateCheckSMS();

        ArrayList<String> groups = dao.findAllGroup();

        String key = RequestTool.getString(request, "key");
        String group = RequestTool.getString(request, "group");

        int vitri = Tool.string2Integer(RequestTool.getString(request, "vitri", "0"));

        all = dao.findAll(vitri, key, group);

        out.clear();
        out = pageContext.pushBody();
        createExcel(all, response);
        return;
    } catch (Exception ex) {
        System.out.println(ex.getMessage());
    }
%>

<%!
    public static void createExcel(ArrayList<TemplateCheckSMS> allMoLog, HttpServletResponse response) {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet(DateProc.createDDMMYYYY().replaceAll("/", ""));
//        Map<String, Object[]> data = new HashMap<String, Object[]>();
        ArrayList<Object[]> data = new ArrayList();
        int i = 1;
        String status = "";
        data.add(new Object[]{
            "STT",
            "Từ khóa",
            "Tên gợi nhớ",
            "Nhóm",
            "Mô tả",
            "Vị trí"
        });
        for (TemplateCheckSMS onemo : allMoLog) {
            data.add(new Object[]{
                i++,
                onemo.getKey(),
                onemo.getName(),
                onemo.getGroup(),
                onemo.getDescription(),
                onemo.getVitri() == 1 ? "Đầu tin nhắn" : onemo.getVitri() == 2 ? "Giữa tin nhắn" : onemo.getVitri() == 3 ? "Cuối tin nhắn" : ""
            });
        }

        data.add(new Object[]{
            "", "", "", "", "",
            "", "", "", "", "", "", "", ""
        });

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
            response.setHeader("Content-Disposition", "attachment; filename=ListTinNhan-" + DateProc.createDDMMYYYY() + ".xlsx");
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