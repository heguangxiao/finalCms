<%@page import="gk.myname.vn.entity.ThongKeTheoNgay"%>
<%@page import="gk.myname.vn.entity.CDRSubmit"%>
<%@page import="gk.myname.vn.entity.MsgBrandSubmit"%>
<%@page import="gk.myname.vn.entity.BrandLabel"%><%@page import="gk.myname.vn.utils.DateProc"%><%@page import="gk.myname.vn.utils.Tool"%><%@page import="gk.myname.vn.utils.RequestTool"%><%@page import="gk.myname.vn.admin.Account"%><%@page import="java.sql.*"%><%@page import="java.io.FileOutputStream"%><%@page import="java.io.File"%><%@page import="java.util.Date"%><%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%><%@page import="java.util.Set"%><%@page import="java.util.Map"%><%@page import="java.util.HashMap"%><%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%><%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.util.ArrayList"%>
<%@page autoFlush="true"  %><%@page contentType="text/html; charset=utf-8" %> 
<%
    try {
        Account userlogin = Account.getAccount(session);
        if (userlogin == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        ArrayList<CDRSubmit> all = null;
        CDRSubmit smDao = new CDRSubmit();
        String userSender = RequestTool.getString(request, "userSender");
        String cp_code = RequestTool.getString(request, "cp_code");
        String label = RequestTool.getString(request, "_label");
        int type = RequestTool.getInt(request, "type", -1);
        String provider = RequestTool.getString(request, "provider");
        String groupBr = RequestTool.getString(request, "groupBr");
        String oper = RequestTool.getString(request, "oper");
        String nation = RequestTool.getString(request, "nation");
//        int result = RequestTool.getInt(request, "result", 0);
        String stRequest = RequestTool.getString(request, "stRequest");
        String endRequest = RequestTool.getString(request, "endRequest");
        int ltypeb = RequestTool.getInt(request, "ltypeb");
        all = smDao.statisticSubm_ByDay2(userSender, cp_code, label, type, provider, oper, 1, groupBr, stRequest, endRequest, nation, ltypeb);
        
        String fn = "";
        Account acc = Account.getAccount(userSender);
        if (acc!=null){
            fn = acc.getFullName();
        }
        out.clear();
        out = pageContext.pushBody();
        createExcel(all, response, stRequest, endRequest, label, fn);
        return;
    } catch (Exception ex) {
        System.out.println(ex.getMessage());
    }
%>

<%!
    public static void createExcel(ArrayList<CDRSubmit> allMoLog, HttpServletResponse response, String stRequest, String endRequest, String label, String fullName) {
        String dateNow = DateProc.createDDMMYYYY();

        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet(dateNow.replaceAll("/", ""));

        ArrayList<Object[]> data = new ArrayList();

        ThongKeTheoNgay one = null;
        ArrayList<ThongKeTheoNgay> list = new ArrayList<>();

        int stt = 1;

        int batDau = Integer.parseInt(stRequest.substring(0, 2));
        int ketThuc = Integer.parseInt(endRequest.substring(0, 2));

        int totalVte = 0;
        int totalGpc = 0;
        int totalVms = 0;
        int totalVnm = 0;
        int totalBl = 0;
        int totalDdg = 0;
        int total = 0;

        for (int i = batDau; i <= ketThuc; i++) {
            one = new ThongKeTheoNgay("0"+i+stRequest.substring(2));
            one.setNhan(label);
            one.setViettel("0");
            one.setVinaphone("0");
            one.setMobifone("0");
            one.setVietnamMobile("0");
            one.setGmobile("0");
            one.setItelecom("0");
            one.setTong("0");
            list.add(one);
        }
        
        for (ThongKeTheoNgay tktn : list) {
            for (CDRSubmit elem : allMoLog) {
                if (tktn.getNgay().equals(elem.getLogDate())) {
                    if (elem.getOper().equals("VTE")) {
                        tktn.setViettel(elem.getTotalMsg()+"");
                    }
                    if (elem.getOper().equals("GPC")) {
                        tktn.setVinaphone(elem.getTotalMsg()+"");
                    }
                    if (elem.getOper().equals("VMS")) {
                        tktn.setMobifone(elem.getTotalMsg()+"");
                    }
                    if (elem.getOper().equals("VNM")) {
                        tktn.setVietnamMobile(elem.getTotalMsg()+"");
                    }
                    if (elem.getOper().equals("BL")) {
                        tktn.setGmobile(elem.getTotalMsg()+"");
                    }
                    if (elem.getOper().equals("DDG")) {
                        tktn.setItelecom(elem.getTotalMsg()+"");
                    }
                }
            }
        }

        for (ThongKeTheoNgay elem : list) {
            int vte = Integer.parseInt(elem.getViettel());
            int gpc = Integer.parseInt(elem.getVinaphone());
            int vms = Integer.parseInt(elem.getMobifone());
            int vnm = Integer.parseInt(elem.getVietnamMobile());
            int bl = Integer.parseInt(elem.getGmobile());
            int ddg = Integer.parseInt(elem.getItelecom());
            
            int tong = vte + gpc + vms + vnm + bl + ddg;
            
            totalVte+= vte;
            totalGpc+= gpc;
            totalVms+= vms;
            totalVnm+= vnm;
            totalBl+= bl;
            totalDdg+=ddg;
            total+= tong;

            elem.setTong(tong+"");
        }

        data.add(new Object[]{
            "BIÊN BẢN XÁC NHẬN SẢN LƯỢNG TIN NHẮN THƯƠNG HIỆU BRANDNAME",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        });

        data.add(new Object[]{
            "THÁNG " + Integer.parseInt(stRequest.substring(3, 5)) + " - " + Integer.parseInt(stRequest.substring(6, 10)),
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        });

        data.add(new Object[]{
            " - Căn cứ theo hợp đồng hợp tác số: ... giữa CÔNG TY CP TRUYỀN THÔNG VÀ THƯƠNG MẠI HTC VÀ " + fullName + " về việc hợp tác cung cấp dịch vụ quản lý tin nhắn ",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        });

        data.add(new Object[]{
            " - Hôm nay, ngày " + dateNow.substring(0, 2) + " tháng " + dateNow.substring(3, 5) + " năm " + dateNow.substring(6, 10) + ", CÔNG TY CP TRUYỀN THÔNG VÀ THƯƠNG MẠI HTC VÀ " + fullName + " cùng ký biên bản xác nhận số liệu sản lượng Tin nhắn thương hiệu được gửi thành công. Cụ thể như sau:",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        });

        data.add(new Object[]{
            "",
            "",
            "",
            "SẢN LƯỢNG TIN NHẮN",
            "",
            "",
            "",
            "",
            "",
            ""
        });

        data.add(new Object[]{
            "STT",
            "NGÀY",
            "NHÃN",
            "VIETTEL",
            "MOBIFONE",
            "VINAFONE",
            "VIETNAM MOBILE",
            "ITELECOM",
            "GMOBILE",
            "TỔNG"
        });

        data.add(new Object[]{
            "I - SẢN LƯỢNG TIN NHẮN BRANDNAME SMS - CHĂM SÓC KHÁCH HÀNG",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        });

        for (ThongKeTheoNgay elem : list) {
            data.add(new Object[]{
                "" + stt++,
                elem.getNgay(),
                elem.getNhan(),
                elem.getViettel(),
                elem.getMobifone(),
                elem.getVinaphone(),
                elem.getVietnamMobile(),
                elem.getItelecom(),
                elem.getGmobile(),
                elem.getTong()
            });
        }

        data.add(new Object[]{
            "TỔNG CỘNG",
            "",
            "",
            ""+totalVte,
            ""+totalVms,
            ""+totalGpc,
            ""+totalVnm,
            ""+totalDdg,
            ""+totalBl,
            ""+total
        });

        data.add(new Object[]{
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        });

        data.add(new Object[]{
            "ĐẠI DIỆN CÔNG TY CP TRUYỀN THÔNG VÀ THƯƠNG MẠI HTC",
            "",
            "",
            "",
            "",
            "",
            "",
            "ĐẠI DIỆN " + fullName,
            "",
            ""
        });

        data.add(new Object[]{
            "Xác nhận sản lượng",
            "",
            "",
            "",
            "",
            "",
            "",
            "Xác nhận sản lượng",
            "",
            ""
        });

        int rownum = 0;
        for (Object[] objArr : data) {
            Row row = sheet.createRow(rownum++);
            int cellnum = 0;
            for (Object obj : objArr) {
                Cell cell = row.createCell(cellnum++);
                if (obj instanceof Date) {
                    cell.setCellValue((Date) obj);
                } else if (obj instanceof Boolean) {
                    cell.setCellValue((Boolean) obj);
                } else if (obj instanceof String) {
                    cell.setCellValue((String) obj);
                } else if (obj instanceof Double) {
                    cell.setCellValue((Double) obj);
                } else {
                    cell.setCellValue((String) obj);
                }
            }
        }

        try {
            ServletOutputStream os = null;
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=" + dateNow + "LogByDay-" + fullName + "-" + stRequest + "-" + endRequest + ".xls");
            os = response.getOutputStream();
            os.flush();
            workbook.write(os);
            System.out.println("Excel written successfully..");
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    private static String getType(int type) {
        if (type == BrandLabel.TYPE.CSKH.val) {
            return "CSKH";
        } else if (type == BrandLabel.TYPE.QC.val) {
            return "Tin QC";
        } else {
            return type + "";
        }
    }
%>