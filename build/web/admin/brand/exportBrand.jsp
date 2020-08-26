<%@page import="gk.myname.vn.entity.GroupProvider"%>
<%@page import="gk.myname.vn.entity.RouteNationTelco"%>
<%@page import="gk.myname.vn.admin.Account"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="gk.myname.vn.entity.RouteTable"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@page import="gk.myname.vn.utils.DateProc"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="gk.myname.vn.utils.RequestTool"%>
<%@page import="gk.myname.vn.entity.BrandLabel"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html; charset=utf-8" %>
<%
    try {
        ArrayList<BrandLabel> allBrand = null;
        BrandLabel dao = new BrandLabel();
        int currentPage = RequestTool.getInt(request, "page", 1);
        int status = RequestTool.getInt(request, "status", -2);
        String _label = RequestTool.getString(request, "_label");
        String telco = RequestTool.getString(request, "telco");
        String providerCode = RequestTool.getString(request, "providerCode");
        String cpuser = RequestTool.getString(request, "cpuser", "0");
        //Them HOAN
        String group = RequestTool.getString(request, "groupBr", "");
        String stRq = RequestTool.getString(request, "stRequest");
        String endRq = RequestTool.getString(request, "endRequest");
        //HOAN HET
        String nation = RequestTool.getString(request, "nation");
        int type = RequestTool.getInt(request, "type", -2);
                
        allBrand = dao.getAllEx(_label, cpuser, status, providerCode, telco,group,stRq,endRq, nation, type);
        
        out.clear();
        out = pageContext.pushBody();
        createExcel(allBrand, response);
        return;
    } catch (Exception ex) {
        System.out.println(ex.getMessage());
    }
%>

<%!
    public static void createExcel(ArrayList<BrandLabel> allMoLog, HttpServletResponse response) {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet(DateProc.createDDMMYYYY().replaceAll("/", ""));
//        Map<String, Object[]> data = new HashMap<String, Object[]>();
        ArrayList<Object[]> data = new ArrayList();
        int i = 1;
        String status = "";
        data.add(new Object[]{
            "STT",
            "CP_CODE",
            "BRAND NAME",
            "TYPE",
            "HẾT HẠN",
            "TÀI KHOẢN",
            "ĐỊNH TUYẾN",
            "NHÀ CUNG CẤP",
            "CHẶN TRÙNG",
            "NHÓM",
            "CREATE DATE",
//            "CREATE BY",
            "TRẠNG THÁI"
        });
        for (BrandLabel onemo : allMoLog) {
            
            ArrayList<RouteNationTelco> routeNationTelcos = RouteNationTelco.getAllByBrandnameAndUserowner(onemo.getBrandLabel(), onemo.getUserOwner());
            String a0 = "Không cấp";
            if (routeNationTelcos.size() > 0) {
                if (!routeNationTelcos.get(0).getCskh().endsWith("GROUP")) {
                    if (!routeNationTelcos.get(0).getCskh().equals("0")) {
                        a0 = routeNationTelcos.get(0).getCskh();
                    }
                } else {
                    int nnn = routeNationTelcos.get(0).getCskh().lastIndexOf("GROUP");
                    String aaa = routeNationTelcos.get(0).getCskh().substring(0, nnn);
                    GroupProvider groupProvider = GroupProvider.findById(Integer.parseInt(aaa));
                    if (groupProvider != null) {
                        a0 = groupProvider.getName();
                    }
                }
            }

            RouteTable route = onemo.getRoute();
            //Dat gia tri cho status Brand
            if (onemo.getStatus() == BrandLabel.STATUS.BLOCK.val) {
//                System.out.println(BrandLabel.STATUS.BLOCK.desc);
                status = BrandLabel.STATUS.BLOCK.desc;
            } else if (onemo.getStatus() == BrandLabel.STATUS.ACTIVE.val) {
//                System.out.println(BrandLabel.STATUS.ACTIVE.desc);
                status = BrandLabel.STATUS.ACTIVE.desc;
            } else if (onemo.getStatus() == BrandLabel.STATUS.WAIT.val) {
//                System.out.println(BrandLabel.STATUS.WAIT.desc);
                status = BrandLabel.STATUS.WAIT.desc;
            } else if (onemo.getStatus() == BrandLabel.STATUS.PROCESS.val) {
//                System.out.println(BrandLabel.STATUS.PROCESS.desc);
                status = BrandLabel.STATUS.PROCESS.desc;
            } else if (onemo.getStatus() == BrandLabel.STATUS.REJECT.val) {
//                System.out.println(BrandLabel.STATUS.REJECT.desc);
                status = BrandLabel.STATUS.REJECT.desc;
            } else if (onemo.getStatus() == BrandLabel.STATUS.DELETE.val) {
//                System.out.println(BrandLabel.STATUS.DELETE.desc);
                status = BrandLabel.STATUS.DELETE.desc;
            } else {
                status = "Unknow";
            }
            Timestamp ts = onemo.getCreateDate();
            Date date = new Date();
            date.setTime(ts.getTime());
            String formattedDate = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(date);
            //Dat gia tri cho tung hang
            if (routeNationTelcos.size() > 0) {
                data.add(new Object[]{
                    i++,
                    onemo.getCp_code(),
                    onemo.getBrandLabel(),
                    onemo.getType() == 1 ? "LONGCODE" : "BRANDNAME",
                    onemo.getExp(),
                    onemo.getUserOwner(),
                    routeNationTelcos.get(0).getTelcoCode(),
                    a0,
                    routeNationTelcos.get(0).getDuplicate() == 1 ? "Không" : "Có",
                    routeNationTelcos.get(0).getGroup().equals("0") ? "Không phân nhóm" : routeNationTelcos.get(0).getGroup(),
                    formattedDate,
//                    Account.getNameById(onemo.getCreateBy()),
                    status
                });
            } else {
                data.add(new Object[]{
                    i++,
                    onemo.getCp_code(),
                    onemo.getBrandLabel(),
                    onemo.getType() == 1 ? "LONGCODE" : "BRANDNAME",
                    onemo.getExp(),
                    onemo.getUserOwner(),
                    "",
                    "",
                    "",
                    "",
                    formattedDate,
//                    Account.getNameById(onemo.getCreateBy()),
                    status
                });
            }

            if (routeNationTelcos.size() > 1) {    

                for (int y = 1; y < routeNationTelcos.size(); y++ ) {
                    String ay = "Không cấp";
                    if (!routeNationTelcos.get(y).getCskh().endsWith("GROUP")) {
                        if (!routeNationTelcos.get(y).getCskh().equals("0")) {
                            ay = routeNationTelcos.get(y).getCskh();
                        }
                    } else {
                        int nnn = routeNationTelcos.get(y).getCskh().lastIndexOf("GROUP");
                        String aaa = routeNationTelcos.get(y).getCskh().substring(0, nnn);
                        GroupProvider groupProvider = GroupProvider.findById(Integer.parseInt(aaa));
                        if (groupProvider != null) {
                            ay = groupProvider.getName();
                        }
                    }

                    data.add(new Object[]{
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        routeNationTelcos.get(y).getTelcoCode(),
                        ay,
                        routeNationTelcos.get(y).getDuplicate() == 1 ? "Không" : "Có",
                        routeNationTelcos.get(y).getGroup().equals("0") ? "Không phân nhóm" : routeNationTelcos.get(y).getGroup(),
                        "",
                        ""
                    });
                }
            }      
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
            response.setHeader("Content-Disposition", "attachment; filename=ListBrand_DETAIL-" + DateProc.createDDMMYYYY() + ".xlsx");
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