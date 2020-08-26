/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gk.myname.vn.entity;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import gk.myname.vn.config.MyContext;
import gk.myname.vn.db.DBPool;
import gk.myname.vn.utils.Tool;
import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import org.apache.log4j.Logger;

/**
 *
 * @author Centurion
 */
public class BrandLabel {

    static final Logger logger = Logger.getLogger(BrandLabel.class);
    public static final HashMap<String, ArrayList<BrandLabel>> CACHE = new HashMap<>();
    static final ObjectMapper mapper = new ObjectMapper();
    public static final String BRAND_FILE_UPLOAD = "/upload/brand";
    public static final String BRAND_FILE_DECLARE = "/upload/declare";

    static {
        ArrayList<BrandLabel> all = getAll();
        if (all != null && !all.isEmpty()) {
            for (BrandLabel one : all) {
                ArrayList<BrandLabel> tmp = CACHE.get(one.getUserOwner());
                if (tmp == null) {
                    tmp = new ArrayList<>();
                    tmp.add(one);
                    CACHE.put(one.getUserOwner(), tmp);
                } else {
                    tmp.add(one);
                    CACHE.put(one.getUserOwner(), tmp);
                }
            }
        }
    }

    public static void reload() {
        ArrayList<BrandLabel> all = getAll();
        CACHE.clear();
        if (all != null && !all.isEmpty()) {
            for (BrandLabel one : all) {
                ArrayList<BrandLabel> tmp = CACHE.get(one.getUserOwner());
                if (tmp == null) {
                    tmp = new ArrayList<>();
                    tmp.add(one);
                    CACHE.put(one.getUserOwner(), tmp);
                } else {
                    tmp.add(one);
                    CACHE.put(one.getUserOwner(), tmp);
                }
            }
        }
    }

    public static ArrayList<BrandLabel> getBrandByCpCode(String cpCode) {
        ArrayList<BrandLabel> result = new ArrayList<>();
        Collection<ArrayList<BrandLabel>> coll = CACHE.values();
        // Duyet qua Tung Brand cua Tung User Cache
        for (ArrayList<BrandLabel> oneArr : coll) {
            // Duyet tiep Tung Phan Tu cua Mang
            for (BrandLabel oneBr : oneArr) {
                if (oneBr.getCp_code().equals(cpCode)
                        || oneBr.getCp_code().startsWith(cpCode + "_")) {
                    result.add(oneBr);
                }
            }
        }
        return result;
    }

    public static ArrayList<BrandLabel> getBrandBy(String userAcc) {
        ArrayList<BrandLabel> all = CACHE.get(userAcc);
        ArrayList<BrandLabel> tmp = new ArrayList<>();
        if (all != null && !all.isEmpty()) {
            for (BrandLabel one : all) {
                if (one.getStatus() == 1) {
                    // active
                    tmp.add(one);
                }
            }
        }
        return tmp;
    }
    
    public static ArrayList<BrandLabel> getBrandByUser(String user) {
        ArrayList<BrandLabel> all = CACHE.get(user);
        ArrayList<BrandLabel> tmp = new ArrayList<>();
        if (all != null && !all.isEmpty()) {
            for (BrandLabel one : all) {
                    tmp.add(one);
            }
        }
        return tmp;
    }

    public static ArrayList<BrandLabel> getBrandByList(ArrayList<String> listUser) {
        ArrayList<BrandLabel> result = new ArrayList<>();

        for (String oneUser : listUser) {
            ArrayList<BrandLabel> all = CACHE.get(oneUser);
            if (all != null && !all.isEmpty()) {
                for (BrandLabel one : all) {
                    if (one.getStatus() == 1) // active
                    {
                        result.add(one);
                    }
                }
            }
        }

        return result;
    }

    public static BrandLabel getFromCache(int bid) {
        BrandLabel result = null;
        Collection<ArrayList<BrandLabel>> allVal = CACHE.values();
        for (ArrayList<BrandLabel> oneVal : allVal) {
            for (BrandLabel oneLabel : oneVal) {
                if (oneLabel.getId() == bid) {
                    result = oneLabel;
                    break;
                }
            }
        }
        return result;
    }
    
    public static BrandLabel getFromCache2(String bid) {
        BrandLabel result = null;
        Collection<ArrayList<BrandLabel>> allVal = CACHE.values();
        for (ArrayList<BrandLabel> oneVal : allVal) {
            for (BrandLabel oneLabel : oneVal) {
                if (oneLabel.getUserOwner().equals(bid)) {
                    result = oneLabel;
                    break;
                }
            }
        }
        return result;
    }

    public static BrandLabel getFromCache(String userCp, String label) {
        BrandLabel result = null;
        // Lay Ra Brand Theo CPID
        ArrayList<BrandLabel> list = getBrandBy(userCp);
        for (BrandLabel oneLabel : list) {
            if (oneLabel.getBrandLabel().equals(label)) {
                result = oneLabel;
                break;
            }
        }

        return result;
    }

    public static BrandLabel getFromCacheByLabel(String label) {
        BrandLabel result = null;
        Collection<ArrayList<BrandLabel>> allVal = CACHE.values();
        for (ArrayList<BrandLabel> oneVal : allVal) {
            for (BrandLabel oneLabel : oneVal) {
                label = label.replaceAll(" ", "");
                String currentLabel = oneLabel.getBrandLabel();
                currentLabel = currentLabel.replaceAll(" ", "");
                if (currentLabel.equalsIgnoreCase(label)) {
                    result = oneLabel;
                    break;
                }
            }
        }
        return result;
    }

    public boolean checkHasFile() {
        boolean result = false;
        try {
            String dir = MyContext.ROOT_DIR + BRAND_FILE_UPLOAD + "/" + brandLabel.toLowerCase() + "-" + id;
            File f = new File(dir);
            if (f.exists()) {
                File[] listFiles = f.listFiles();
                if (listFiles != null && listFiles.length > 0) {
                    result = true;
                }
            }
        } catch (Exception e) {
            logger.error(Tool.getLogMessage(e));
        }
        return result;
    }

    public ArrayList<BrandLabel> getAll(int page, int row, String brand, String cpuser, int status, String provider, String telco) {
        ArrayList<BrandLabel> all = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BRAND_LABEL WHERE 1=1 ";
        if (status != -2) {
            sql += " AND STATUS = ?";
        } else {
            sql += " AND STATUS != 404";
        }
        if (!Tool.checkNull(brand)) {
            sql += " AND BRAND_LABEL  like ? ";
        }
        if (!Tool.checkNull(provider)) {
            sql += " AND (ROUTE_TABLE LIKE '%\"route_CSKH\":\"" + provider + "\",%')";
        }
        if (!cpuser.equals("0")) {
            sql += " AND USER_OWNER = ?";
        }
        if (!Tool.checkNull(telco)) {
            sql += " AND ROUTE_TABLE not like '%\"operCode\":\"" + telco + "\",\"route_CSKH\":\"0\",%'";
        }
        sql += " ORDER BY ID DESC LIMIT ?,?";
        Tool.debug(sql);
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (status != -2) {
                pstm.setInt(i++, status);
            }
            if (!Tool.checkNull(brand)) {
                pstm.setString(i++, brand);
            }
            if (!cpuser.equals("0")) {
                pstm.setString(i++, cpuser);
            }

            pstm.setInt(i++, (page - 1) * row);
            pstm.setInt(i++, row);
            rs = pstm.executeQuery();
            while (rs.next()) {
                BrandLabel one = new BrandLabel();
                one.setId(rs.getInt("ID"));
                one.setUserOwner(rs.getString("USER_OWNER"));
                one.setCp_code(rs.getString("CP_CODE"));
                one.setBrandLabel(rs.getString("BRAND_LABEL"));
                one.setCreateDate(rs.getTimestamp("CREATE_DATE"));
                one.setCreateBy(rs.getInt("CREATE_BY"));
                one.setStatus(rs.getInt("STATUS"));
                one.setFormTemplate(rs.getString("FORM_TEMPLATE"));
                one.setRoute(rs.getString("ROUTE_TABLE"));
                one.setPrice(rs.getInt("PRICE"));
                one.setPriority(rs.getInt("PRIORITY"));
                one.setUpdateBy(rs.getInt("UPDATE_BY"));
                one.setUpdateDate(rs.getTimestamp("UPDATE_DATE"));
                one.setOptionTelco(rs.getString("TELCO_OPTION"));
                one.setCheckTemp(rs.getInt("CHECK_TEMP"));
                all.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return all;
    }
    
    public ArrayList<BrandLabel> getAll(int page, int row, String brand, String cpuser, int status, String provider, String telco, String groupBr, String stRequest, String endRequest) {
        ArrayList<BrandLabel> all = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BRAND_LABEL WHERE 1=1 ";
        if (status != -2) {
            sql += " AND STATUS = ?";
        } else {
            sql += " AND STATUS != 404";
        }
        if (!Tool.checkNull(brand)) {
            sql += " AND BRAND_LABEL  like ? ";
        }
        if (!cpuser.equals("0")) {
            sql += " AND USER_OWNER = ?";
        }
        if (!Tool.checkNull(stRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) >=0";
        }
        if (!Tool.checkNull(endRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) <=0";
        }
        sql += " ORDER BY ID DESC LIMIT ?,?";
        Tool.debug(sql);
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (status != -2) {
                pstm.setInt(i++, status);
            }
            if (!Tool.checkNull(brand)) {
                pstm.setString(i++, brand);
            }
            if (!cpuser.equals("0")) {
                pstm.setString(i++, cpuser);
            }
            if (!Tool.checkNull(stRequest)) {
                pstm.setString(i++, stRequest);
            }
            if (!Tool.checkNull(endRequest)) {
                pstm.setString(i++, endRequest);
            }

            pstm.setInt(i++, (page - 1) * row);
            pstm.setInt(i++, row);
            rs = pstm.executeQuery();
            while (rs.next()) {
                BrandLabel one = new BrandLabel();
                one.setId(rs.getInt("ID"));
                one.setUserOwner(rs.getString("USER_OWNER"));
                one.setCp_code(rs.getString("CP_CODE"));
                one.setBrandLabel(rs.getString("BRAND_LABEL"));
                one.setCreateDate(rs.getTimestamp("CREATE_DATE"));
                one.setCreateBy(rs.getInt("CREATE_BY"));
                one.setStatus(rs.getInt("STATUS"));
                one.setFormTemplate(rs.getString("FORM_TEMPLATE"));
                one.setRoute(rs.getString("ROUTE_TABLE"));
                one.setPrice(rs.getInt("PRICE"));
                one.setPriority(rs.getInt("PRIORITY"));
                one.setUpdateBy(rs.getInt("UPDATE_BY"));
                one.setUpdateDate(rs.getTimestamp("UPDATE_DATE"));
                one.setOptionTelco(rs.getString("TELCO_OPTION"));
                one.setCheckTemp(rs.getInt("CHECK_TEMP"));
                                
                if (!Tool.checkNull(telco) && Tool.checkNull(groupBr)) {
                    RouteNationTelco rnt = RouteNationTelco.getbyBrandnameAndUserownerAndTelco(one.getBrandLabel(), one.getUserOwner(), telco);
                    if (rnt != null) {   
                        all.add(one);
                    }
                } else if (Tool.checkNull(telco) && !Tool.checkNull(groupBr)){
                    boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndGroupBr(one.getBrandLabel(), one.getUserOwner(), groupBr);
                    if (flag) {
                        all.add(one);
                    }
                } else if (!Tool.checkNull(telco) && !Tool.checkNull(groupBr)) {
                    RouteNationTelco rnt = RouteNationTelco.getbyBrandnameAndUserownerAndTelco(one.getBrandLabel(), one.getUserOwner(), telco);
                    if (rnt != null) {   
                        boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndGroupBrAndTelco(one.getBrandLabel(), one.getUserOwner(), groupBr, telco);
                        if (flag) {
                            all.add(one);
                        }
                    }
                } else {      
                    all.add(one);
                }                          
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        ArrayList<BrandLabel> arrayList = new ArrayList<>();
        
        if (!Tool.checkNull(provider)) {
            all.forEach((brandLabel1) -> {
                boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndProviderAndGroupBrAndTelco(brandLabel1.getBrandLabel(), brandLabel1.getUserOwner(), provider, groupBr, telco);
                if (flag) {
                    arrayList.add(brandLabel1);
                }
            });
        } else {
            all.forEach((brandLabel1) -> {
                arrayList.add(brandLabel1);
            });
        }
        
        return arrayList;
    }
    
    public ArrayList<BrandLabel> getAll2(int page, int row, String brand, String cpuser, int status, String provider, String telco, String groupBr, String stRequest, String endRequest, String nation, int type) {
        ArrayList<BrandLabel> all = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BRAND_LABEL WHERE 1=1 ";
        if (status != -2) {
            sql += " AND STATUS = ?";
        } else {
            sql += " AND STATUS != 2";
        }
        if (type != -2) {
            if (type == 0) {
                sql += " AND (TYPE = ? OR ISNULL(TYPE))";
            } else {
                sql += " AND TYPE = ?";
            }
        } 
        if (!Tool.checkNull(brand)) {
            sql += " AND BRAND_LABEL  like ? ";
        }
        if (!cpuser.equals("0")) {
            sql += " AND USER_OWNER = ?";
        }
        if (!Tool.checkNull(stRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) >=0";
        }
        if (!Tool.checkNull(endRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) <=0";
        }
        sql += " ORDER BY ID DESC LIMIT ?,?";
        Tool.debug(sql);
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (status != -2) {
                pstm.setInt(i++, status);
            }
            if (type != -2) {
                pstm.setInt(i++, type);
            }
            if (!Tool.checkNull(brand)) {
                pstm.setString(i++, brand);
            }
            if (!cpuser.equals("0")) {
                pstm.setString(i++, cpuser);
            }
            if (!Tool.checkNull(stRequest)) {
                pstm.setString(i++, stRequest);
            }
            if (!Tool.checkNull(endRequest)) {
                pstm.setString(i++, endRequest);
            }

            pstm.setInt(i++, (page - 1) * row);
            pstm.setInt(i++, row);
            rs = pstm.executeQuery();
            while (rs.next()) {
                BrandLabel one = new BrandLabel();
                one.setId(rs.getInt("ID"));
                one.setUserOwner(rs.getString("USER_OWNER"));
                one.setCp_code(rs.getString("CP_CODE"));
                one.setBrandLabel(rs.getString("BRAND_LABEL"));
                one.setCreateDate(rs.getTimestamp("CREATE_DATE"));
                one.setCreateBy(rs.getInt("CREATE_BY"));
                one.setStatus(rs.getInt("STATUS"));
                one.setFormTemplate(rs.getString("FORM_TEMPLATE"));
                one.setRoute(rs.getString("ROUTE_TABLE"));
                one.setPrice(rs.getInt("PRICE"));
                one.setPriority(rs.getInt("PRIORITY"));
                one.setUpdateBy(rs.getInt("UPDATE_BY"));
                one.setUpdateDate(rs.getTimestamp("UPDATE_DATE"));
                one.setOptionTelco(rs.getString("TELCO_OPTION"));
                one.setCheckTemp(rs.getInt("CHECK_TEMP"));
                one.setExp(rs.getString("EXP_STRING"));
                one.setType(rs.getInt("TYPE"));
                                
                if (!Tool.checkNull(telco) && Tool.checkNull(groupBr)) {
                    RouteNationTelco rnt = RouteNationTelco.getbyBrandnameAndUserownerAndTelco(one.getBrandLabel(), one.getUserOwner(), telco);
                    if (rnt != null) {   
                        all.add(one);
                    }
                } else if (Tool.checkNull(telco) && !Tool.checkNull(groupBr)){
                    boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndGroupBr(one.getBrandLabel(), one.getUserOwner(), groupBr);
                    if (flag) {
                        all.add(one);
                    }
                } else if (!Tool.checkNull(telco) && !Tool.checkNull(groupBr)) {
                    RouteNationTelco rnt = RouteNationTelco.getbyBrandnameAndUserownerAndTelco(one.getBrandLabel(), one.getUserOwner(), telco);
                    if (rnt != null) {   
                        boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndGroupBrAndTelco(one.getBrandLabel(), one.getUserOwner(), groupBr, telco);
                        if (flag) {
                            all.add(one);
                        }
                    }
                } else {      
                    all.add(one);
                }                          
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        ArrayList<BrandLabel> arrayList = new ArrayList<>();
        
        if (!Tool.checkNull(provider)) {
            all.forEach((brandLabel1) -> {
                boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndProviderAndGroupBrAndTelco(brandLabel1.getBrandLabel(), brandLabel1.getUserOwner(), provider, groupBr, telco);
                if (flag) {
                    arrayList.add(brandLabel1);
                }
            });
        } else {
            all.forEach((brandLabel1) -> {
                arrayList.add(brandLabel1);
            });
        }
        
        if (!Tool.checkNull(nation) && Tool.checkNull(telco)) {
            ArrayList<BrandLabel> arrayList2 = new ArrayList<>();
            arrayList.forEach((brandLabel1) -> {
                boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndNation(brandLabel1.getBrandLabel(), brandLabel1.getUserOwner(), nation);
                if (flag) {
                    arrayList2.add(brandLabel1);
                }
            });
            return arrayList2;
        }        
        return arrayList;
    }
    
    public int countAll(String brand, String cpuser, int status, String provider, String telco, String groupBr, String stRequest, String endRequest) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT count(*) FROM BRAND_LABEL WHERE 1=1 ";
        if (status != -2) {
            sql += " AND STATUS = ?";
        } else {
            sql += " AND STATUS != 404";
        }
        if (!Tool.checkNull(brand)) {
            sql += " AND BRAND_LABEL  like ? ";
        }
        if (!cpuser.equals("0")) {
            sql += " AND USER_OWNER = ?";
        }
        if (!Tool.checkNull(stRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) >=0";
        }
        if (!Tool.checkNull(endRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) <=0";
        }
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (status != -2) {
                pstm.setInt(i++, status);
            }
            if (!Tool.checkNull(brand)) {
                pstm.setString(i++, brand);
            }
            if (!cpuser.equals("0")) {
                pstm.setString(i++, cpuser);
            }
            if (!Tool.checkNull(stRequest)) {
                pstm.setString(i++, stRequest);
            }
            if (!Tool.checkNull(endRequest)) {
                pstm.setString(i++, endRequest);
            }
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public int countAll2(String brand, String cpuser, int status, String provider, String telco, String groupBr, String stRequest, String endRequest, String nation,int type) {
        int num = 0;
        ArrayList<BrandLabel> all = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BRAND_LABEL WHERE 1=1 ";
        if (status != -2) {
            sql += " AND STATUS = ?";
        }
        if (type != -2) {
            if (type == 0) {
                sql += " AND (TYPE = ? OR ISNULL(TYPE))";
            } else {
                sql += " AND TYPE = ?";
            }
        } 
        if (!Tool.checkNull(brand)) {
            sql += " AND BRAND_LABEL  like ? ";
        }
        if (!cpuser.equals("0")) {
            sql += " AND USER_OWNER = ?";
        }
        if (!Tool.checkNull(stRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) >=0";
        }
        if (!Tool.checkNull(endRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) <=0";
        }
        sql += " ORDER BY ID DESC";
        Tool.debug(sql);
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (status != -2) {
                pstm.setInt(i++, status);
            }
            if (type != -2) {
                pstm.setInt(i++, type);
            }
            if (!Tool.checkNull(brand)) {
                pstm.setString(i++, brand);
            }
            if (!cpuser.equals("0")) {
                pstm.setString(i++, cpuser);
            }
            if (!Tool.checkNull(stRequest)) {
                pstm.setString(i++, stRequest);
            }
            if (!Tool.checkNull(endRequest)) {
                pstm.setString(i++, endRequest);
            }
            rs = pstm.executeQuery();
            while (rs.next()) {
                BrandLabel one = new BrandLabel();
                one.setId(rs.getInt("ID"));
                one.setUserOwner(rs.getString("USER_OWNER"));
                one.setBrandLabel(rs.getString("BRAND_LABEL"));
                                
                if (!Tool.checkNull(telco) && Tool.checkNull(groupBr)) {
                    RouteNationTelco rnt = RouteNationTelco.getbyBrandnameAndUserownerAndTelco(one.getBrandLabel(), one.getUserOwner(), telco);
                    if (rnt != null) {   
                        all.add(one);
                    }
                } else if (Tool.checkNull(telco) && !Tool.checkNull(groupBr)){
                    boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndGroupBr(one.getBrandLabel(), one.getUserOwner(), groupBr);
                    if (flag) {
                        all.add(one);
                    }
                } else if (!Tool.checkNull(telco) && !Tool.checkNull(groupBr)) {
                    RouteNationTelco rnt = RouteNationTelco.getbyBrandnameAndUserownerAndTelco(one.getBrandLabel(), one.getUserOwner(), telco);
                    if (rnt != null) {   
                        boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndGroupBrAndTelco(one.getBrandLabel(), one.getUserOwner(), groupBr, telco);
                        if (flag) {
                            all.add(one);
                        }
                    }
                } else {      
                    all.add(one);
                }                          
            }
            num = all.size();
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        
        ArrayList<BrandLabel> arrayList = new ArrayList<>();
        
        if (!Tool.checkNull(provider)) {
            all.forEach((brandLabel1) -> {
                boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndProviderAndGroupBrAndTelco(brandLabel1.getBrandLabel(), brandLabel1.getUserOwner(), provider, groupBr, telco);
                if (flag) {      
                    arrayList.add(brandLabel1);
                }
            });
            num = arrayList.size();
        }
        
        if (!Tool.checkNull(nation) && Tool.checkNull(telco)) {
            ArrayList<BrandLabel> arrayList2 = new ArrayList<>();
            arrayList.forEach((brandLabel1) -> {
                boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndNation(brandLabel1.getBrandLabel(), brandLabel1.getUserOwner(), nation);
                if (flag) {
                    arrayList2.add(brandLabel1);
                }
            });
            num = arrayList2.size();
            return num;
        }        
        return num;
    }

    public int countAll(String brand, String cpuser, int status, String provider, String telco) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT count(*) FROM BRAND_LABEL WHERE 1=1 ";
        if (status != -2) {
            sql += " AND STATUS = ?";
        } else {
            sql += " AND STATUS != 404";
        }
        if (!Tool.checkNull(brand)) {
            sql += " AND BRAND_LABEL  like ? ";
        }
        if (!Tool.checkNull(provider)) {
            sql += " AND route_table like ? ";
        }
        if (!cpuser.equals("0")) {
            sql += " AND USER_OWNER = ?";
        }
        if (!Tool.checkNull(telco)) {
            sql += " AND ROUTE_TABLE not like '%\"operCode\":\"" + telco + "\",\"route_CSKH\":\"0\",\"route_QC\":\"0\"%'";
        }
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (status != -2) {
                pstm.setInt(i++, status);
            }
            if (!Tool.checkNull(brand)) {
                pstm.setString(i++, brand);
            }
            if (!Tool.checkNull(provider)) {
                pstm.setString(i++, "%\"route_CSKH\":\"" + provider + "\",%");
            }
            if (!cpuser.equals("0")) {
                pstm.setString(i++, cpuser);
            }
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (Exception e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public ArrayList<BrandLabel> getAllEx(String brand, String cpuser, int status, String provider, String telco, String groupBr, String stRequest, String endRequest, String nation, int type) {
        ArrayList<BrandLabel> all = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BRAND_LABEL WHERE 1=1 ";
        if (status != -2) {
            sql += " AND STATUS = ?";
        } else {
            sql += " AND STATUS != 2";
        }
        if (type != -2) {
            if (type == 0) {
                sql += " AND (TYPE = ? OR ISNULL(TYPE))";
            } else {
                sql += " AND TYPE = ?";
            }
        } 
        if (!Tool.checkNull(brand)) {
            sql += " AND BRAND_LABEL  like ? ";
        }
        if (!cpuser.equals("0")) {
            sql += " AND USER_OWNER = ?";
        }
        if (!Tool.checkNull(stRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) >=0";
        }
        if (!Tool.checkNull(endRequest)) {
            sql += " AND DATEDIFF(CREATE_DATE,STR_TO_DATE(?, '%d/%m/%Y')) <=0";
        }
        sql += " ORDER BY ID DESC ";
        Tool.debug(sql);
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (status != -2) {
                pstm.setInt(i++, status);
            }
            if (type != -2) {
                pstm.setInt(i++, type);
            }
            if (!Tool.checkNull(brand)) {
                pstm.setString(i++, brand);
            }
            if (!cpuser.equals("0")) {
                pstm.setString(i++, cpuser);
            }
            if (!Tool.checkNull(stRequest)) {
                pstm.setString(i++, stRequest);
            }
            if (!Tool.checkNull(endRequest)) {
                pstm.setString(i++, endRequest);
            }

            rs = pstm.executeQuery();
            while (rs.next()) {
                BrandLabel one = new BrandLabel();
                one.setId(rs.getInt("ID"));
                one.setUserOwner(rs.getString("USER_OWNER"));
                one.setCp_code(rs.getString("CP_CODE"));
                one.setBrandLabel(rs.getString("BRAND_LABEL"));
                one.setCreateDate(rs.getTimestamp("CREATE_DATE"));
                one.setCreateBy(rs.getInt("CREATE_BY"));
                one.setStatus(rs.getInt("STATUS"));
                one.setFormTemplate(rs.getString("FORM_TEMPLATE"));
                one.setRoute(rs.getString("ROUTE_TABLE"));
                one.setPrice(rs.getInt("PRICE"));
                one.setPriority(rs.getInt("PRIORITY"));
                one.setUpdateBy(rs.getInt("UPDATE_BY"));
                one.setUpdateDate(rs.getTimestamp("UPDATE_DATE"));
                one.setOptionTelco(rs.getString("TELCO_OPTION"));
                one.setCheckTemp(rs.getInt("CHECK_TEMP"));
                one.setExp(rs.getString("EXP_STRING"));
                one.setType(rs.getInt("TYPE"));
                                
                if (!Tool.checkNull(telco) && Tool.checkNull(groupBr)) {
                    RouteNationTelco rnt = RouteNationTelco.getbyBrandnameAndUserownerAndTelco(one.getBrandLabel(), one.getUserOwner(), telco);
                    if (rnt != null) {   
                        all.add(one);
                    }
                } else if (Tool.checkNull(telco) && !Tool.checkNull(groupBr)){
                    boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndGroupBr(one.getBrandLabel(), one.getUserOwner(), groupBr);
                    if (flag) {
                        all.add(one);
                    }
                } else if (!Tool.checkNull(telco) && !Tool.checkNull(groupBr)) {
                    RouteNationTelco rnt = RouteNationTelco.getbyBrandnameAndUserownerAndTelco(one.getBrandLabel(), one.getUserOwner(), telco);
                    if (rnt != null) {   
                        boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndGroupBrAndTelco(one.getBrandLabel(), one.getUserOwner(), groupBr, telco);
                        if (flag) {
                            all.add(one);
                        }
                    }
                } else {      
                    all.add(one);
                }                       
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        ArrayList<BrandLabel> arrayList = new ArrayList<>();
        
        if (!Tool.checkNull(provider)) {
            all.forEach((brandLabel1) -> {
                boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndProviderAndGroupBrAndTelco(brandLabel1.getBrandLabel(), brandLabel1.getUserOwner(), provider, groupBr, telco);
                if (flag) {
                    arrayList.add(brandLabel1);
                }
            });
        } else {
            all.forEach((brandLabel1) -> {
                arrayList.add(brandLabel1);
            });
        }
        
        if (!Tool.checkNull(nation) && Tool.checkNull(telco)) {
            ArrayList<BrandLabel> arrayList2 = new ArrayList<>();
            arrayList.forEach((brandLabel1) -> {
                boolean flag = RouteNationTelco.getbyBrandnameAndUserownerAndNation(brandLabel1.getBrandLabel(), brandLabel1.getUserOwner(), nation);
                if (flag) {
                    arrayList2.add(brandLabel1);
                }
            });
            return arrayList2;
        }        
        return arrayList;
    }
    //HET PHONG THEM
// -- For CP

    public ArrayList<BrandLabel> getAllForCp(int page, int row, String brand, String cpuser, int status, String cpCode, String telco) {
        ArrayList<BrandLabel> all = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BRAND_LABEL WHERE 1=1 ";
        if (status != -2) {
            sql += " AND STATUS = ?";
        } else {
            sql += " AND STATUS != 404";
        }
        if (!Tool.checkNull(brand)) {
            sql += " AND BRAND_LABEL  like ? ";
        }
        if (!Tool.checkNull(cpCode)) {
            sql += " AND (CP_CODE = ? OR CP_CODE LIKE ?)";
        }
        if (!cpuser.equals("0")) {
            sql += " AND USER_OWNER = ?";
        }
        if (!Tool.checkNull(telco)) {
            sql += " AND ROUTE_TABLE not like '%\"operCode\":\"" + telco + "\",\"route_CSKH\":\"0\",\"route_QC\":\"0\"%'";
        }
        sql += " ORDER BY ID DESC LIMIT ?,?";
        Tool.debug(sql);
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (status != -2) {
                pstm.setInt(i++, status);
            }
            if (!Tool.checkNull(brand)) {
                pstm.setString(i++, brand);
            }
            if (!Tool.checkNull(cpCode)) {
                pstm.setString(i++, cpCode);
                pstm.setString(i++, cpCode + "_%");
            }
            if (!cpuser.equals("0")) {
                pstm.setString(i++, cpuser);
            }
            pstm.setInt(i++, (page - 1) * row);
            pstm.setInt(i++, row);
            rs = pstm.executeQuery();
            while (rs.next()) {
                BrandLabel one = new BrandLabel();
                one.setId(rs.getInt("ID"));
                one.setUserOwner(rs.getString("USER_OWNER"));
                one.setCp_code(rs.getString("CP_CODE"));
                one.setBrandLabel(rs.getString("BRAND_LABEL"));
                one.setCreateDate(rs.getTimestamp("CREATE_DATE"));
                one.setCreateBy(rs.getInt("CREATE_BY"));
                one.setStatus(rs.getInt("STATUS"));
                one.setFormTemplate(rs.getString("FORM_TEMPLATE"));
                one.setRoute(rs.getString("ROUTE_TABLE"));
                one.setPrice(rs.getInt("PRICE"));
                one.setPriority(rs.getInt("PRIORITY"));
                one.setUpdateBy(rs.getInt("UPDATE_BY"));
                one.setUpdateDate(rs.getTimestamp("UPDATE_DATE"));
                one.setOptionTelco(rs.getString("TELCO_OPTION"));
                one.setCheckTemp(rs.getInt("CHECK_TEMP"));
                all.add(one);
            }
        } catch (Exception e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return all;
    }

    public int countAllForCp(String brand, String cpuser, int status, String cpCode, String telco) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT count(*) FROM BRAND_LABEL WHERE 1=1 ";
        if (status != -2) {
            sql += " AND STATUS = ?";
        } else {
            sql += " AND STATUS != 404";
        }
        if (!Tool.checkNull(brand)) {
            sql += " AND BRAND_LABEL  like ? ";
        }
        if (!Tool.checkNull(cpCode)) {
            sql += " AND (CP_CODE = ? OR CP_CODE like ? )";
        }
        if (!cpuser.equals("0")) {
            sql += " AND USER_OWNER = ?";
        }
        if (!Tool.checkNull(telco)) {
            sql += " AND ROUTE_TABLE not like '%\"operCode\":\"" + telco + "\",\"route_CSKH\":\"0\",\"route_QC\":\"0\"%'";
        }
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (status != -2) {
                pstm.setInt(i++, status);
            }
            if (!Tool.checkNull(brand)) {
                pstm.setString(i++, brand);
            }
            if (!Tool.checkNull(cpCode)) {
                pstm.setString(i++, cpCode);
                pstm.setString(i++, cpCode + "_%");
            }
            if (!cpuser.equals("0")) {
                pstm.setString(i++, cpuser);
            }
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (Exception e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }

    //--
    public static ArrayList<BrandLabel> getAll() {
        ArrayList<BrandLabel> all = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BRAND_LABEL WHERE STATUS !=404 order by USER_OWNER";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                BrandLabel one = new BrandLabel();
                one.setId(rs.getInt("ID"));
                one.setUserOwner(rs.getString("USER_OWNER"));
                one.setCp_code(rs.getString("CP_CODE"));
                one.setBrandLabel(rs.getString("BRAND_LABEL"));
                one.setCreateDate(rs.getTimestamp("CREATE_DATE"));
                one.setCreateBy(rs.getInt("CREATE_BY"));
                one.setStatus(rs.getInt("STATUS"));
                one.setFormTemplate(rs.getString("FORM_TEMPLATE"));
                one.setRoute(rs.getString("ROUTE_TABLE"));
                one.setPrice(rs.getInt("PRICE"));
                one.setPriority(rs.getInt("PRIORITY"));
                one.setOptionTelco(rs.getString("TELCO_OPTION"));
                one.setCheckTemp(rs.getInt("CHECK_TEMP"));
                all.add(one);
            }
        } catch (Exception e) {
            Tool.debug(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return all;
    }

    public boolean addNew(BrandLabel one) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "INSERT INTO BRAND_LABEL(USER_OWNER,CP_CODE,BRAND_LABEL,CREATE_DATE,CREATE_BY,STATUS,FORM_TEMPLATE,ROUTE_TABLE,PRICE,PRIORITY,TELCO_OPTION,CHECK_TEMP,TYPE,EXP                       , EXP_STRING)"
                + "                    VALUES(    ?     ,   ?   ,    ?      ,   NOW()   ,    ?    ,   ?  ,     ?       ,      ?    , ?   ,    ?   ,     ?      , ?        , ?  ,STR_TO_DATE(?, '%d/%m/%Y'),  ?        )";
        String routeTable = RouteTable.toStringJson(one.getRoute());
        
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            //--
            int i = 1;
            pstm.setString(i++, one.getUserOwner());
            pstm.setString(i++, one.getCp_code());
            pstm.setString(i++, one.getBrandLabel());
            pstm.setInt(i++, one.getCreateBy());
            pstm.setInt(i++, one.getStatus());
            pstm.setString(i++, one.getFormTemplate());
            pstm.setString(i++, routeTable);
            pstm.setInt(i++, one.getPrice());
            pstm.setInt(i++, one.getPriority());
            pstm.setString(i++, one.getOptionTelco());
            pstm.setInt(i++, one.getCheckTemp());
            pstm.setInt(i++, one.getType());
            pstm.setString(i++, one.getExp());
            pstm.setString(i++, one.getExp());
            if (pstm.executeUpdate() == 1) {
                flag = true;
                reload();
            } else {
                Tool.debug("Khong Thuc Thi Duoc...");
            }
        } catch (SQLException ex) {
            logger.error(Tool.getLogMessage(ex));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }

    public boolean addNew2(BrandLabel one) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "INSERT INTO BRAND_LABEL(USER_OWNER,CP_CODE,BRAND_LABEL,CREATE_DATE,CREATE_BY,STATUS,FORM_TEMPLATE,ROUTE_TABLE,PRICE,PRIORITY,TELCO_OPTION,CHECK_TEMP,TYPE,EXP                       , EXP_STRING, DLR)"
                + "                    VALUES(    ?     ,   ?   ,    ?      ,   NOW()   ,    ?    ,   ?  ,     ?       ,      ?    , ?   ,    ?   ,     ?      , ?        , ?  ,STR_TO_DATE(?, '%d/%m/%Y'),  ?        , ?  )";
        String routeTable = RouteTable.toStringJson(one.getRoute());
        
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            //--
            int i = 1;
            pstm.setString(i++, one.getUserOwner());
            pstm.setString(i++, one.getCp_code());
            pstm.setString(i++, one.getBrandLabel());
            pstm.setInt(i++, one.getCreateBy());
            pstm.setInt(i++, one.getStatus());
            pstm.setString(i++, one.getFormTemplate());
            pstm.setString(i++, routeTable);
            pstm.setInt(i++, one.getPrice());
            pstm.setInt(i++, one.getPriority());
            pstm.setString(i++, one.getOptionTelco());
            pstm.setInt(i++, one.getCheckTemp());
            pstm.setInt(i++, one.getType());
            pstm.setString(i++, one.getExp());
            pstm.setString(i++, one.getExp());
            pstm.setInt(i++, one.getDlr());
            if (pstm.executeUpdate() == 1) {
                flag = true;
                reload();
            } else {
                Tool.debug("Khong Thuc Thi Duoc...");
            }
        } catch (SQLException ex) {
            logger.error(Tool.getLogMessage(ex));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }

    @Override
    public String toString() {
        return "BrandLabel{" + "id=" + id + ", userOwner=" + userOwner + ", cp_code=" + cp_code + ", brandLabel=" + brandLabel + ", createDate=" + createDate + ", createBy=" + createBy + ", status=" + status + ", formTemplate=" + formTemplate + ", route=" + route + ", price=" + price + ", priority=" + priority + ", updateDate=" + updateDate + ", updateBy=" + updateBy + ", optionTelco=" + optionTelco + ", checkTemp=" + checkTemp + ", sendBrandFollowRequest=" + sendBrandFollowRequest + ", uniLabel=" + uniLabel + '}';
    }
      
    public boolean update(BrandLabel one) {
        System.out.println(one.getId());
        System.out.println(one.getType());
        System.out.println(one.getExp());
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "UPDATE BRAND_LABEL SET USER_OWNER = ?, CP_CODE = ?,"
                + " BRAND_LABEL = ?, CREATE_BY = ? , STATUS = ?, FORM_TEMPLATE = ?,"
                + " ROUTE_TABLE = ?, PRICE = ?, PRIORITY = ?, UPDATE_DATE = ?,"
                + " UPDATE_BY = ?, TELCO_OPTION = ?, CHECK_TEMP=?,"
                + " TYPE = ?, EXP = STR_TO_DATE(?, '%d/%m/%Y'), EXP_STRING = ?"
                + " WHERE ID = ?";
        
        System.out.println(sql);
        String routeTable = RouteTable.toStringJson(one.getRoute());
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, one.getUserOwner());
            pstm.setString(i++, one.getCp_code());
            pstm.setString(i++, one.getBrandLabel());
            pstm.setInt(i++, one.getCreateBy());
            pstm.setInt(i++, one.getStatus());
            pstm.setString(i++, one.getFormTemplate());
            pstm.setString(i++, routeTable);
            pstm.setInt(i++, one.getPrice());
            pstm.setInt(i++, one.getPriority());
            pstm.setTimestamp(i++, one.getUpdateDate());
            pstm.setInt(i++, one.getUpdateBy());
            pstm.setString(i++, one.getOptionTelco());
            pstm.setInt(i++, one.getCheckTemp());
            pstm.setInt(i++, one.getType());
            pstm.setString(i++, one.getExp());
            pstm.setString(i++, one.getExp());
            pstm.setInt(i++, one.getId());
            if (pstm.executeUpdate() == 1) {
                flag = true;
                reload();
            }
        } catch (Exception e) {
            Tool.debug(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }
      
    public boolean update2(BrandLabel one) {
        System.out.println(one.getId());
        System.out.println(one.getType());
        System.out.println(one.getExp());
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "UPDATE BRAND_LABEL SET USER_OWNER = ?, CP_CODE = ?,"
                + " BRAND_LABEL = ?, CREATE_BY = ? , STATUS = ?, FORM_TEMPLATE = ?,"
                + " ROUTE_TABLE = ?, PRICE = ?, PRIORITY = ?, UPDATE_DATE = ?,"
                + " UPDATE_BY = ?, TELCO_OPTION = ?, CHECK_TEMP=?,"
                + " TYPE = ?, EXP = STR_TO_DATE(?, '%d/%m/%Y'), EXP_STRING = ?,"
                + " DLR = ? "
                + " WHERE ID = ?";
        
        System.out.println(sql);
        String routeTable = RouteTable.toStringJson(one.getRoute());
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, one.getUserOwner());
            pstm.setString(i++, one.getCp_code());
            pstm.setString(i++, one.getBrandLabel());
            pstm.setInt(i++, one.getCreateBy());
            pstm.setInt(i++, one.getStatus());
            pstm.setString(i++, one.getFormTemplate());
            pstm.setString(i++, routeTable);
            pstm.setInt(i++, one.getPrice());
            pstm.setInt(i++, one.getPriority());
            pstm.setTimestamp(i++, one.getUpdateDate());
            pstm.setInt(i++, one.getUpdateBy());
            pstm.setString(i++, one.getOptionTelco());
            pstm.setInt(i++, one.getCheckTemp());
            pstm.setInt(i++, one.getType());
            pstm.setString(i++, one.getExp());
            pstm.setString(i++, one.getExp());
            pstm.setInt(i++, one.getDlr());
            pstm.setInt(i++, one.getId());
            if (pstm.executeUpdate() == 1) {
                flag = true;
                reload();
            }
        } catch (Exception e) {
            Tool.debug(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }
    
    public boolean bosung(BrandLabel one) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "UPDATE BRAND_LABEL SET UNILABEL = ? WHERE ID = ?";
        String routeUni = RouteUni.toStringJson(one.getRouteUni());
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, routeUni);
            pstm.setInt(i++, one.getId());
            if (pstm.executeUpdate() == 1) {
                flag = true;
                reload();
            }
        } catch (SQLException e) {
            Tool.debug(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }

    public static BrandLabel getById(int id) {
        BrandLabel one = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BRAND_LABEL WHERE ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setInt(i++, id);
            rs = pstm.executeQuery();
            if (rs.next()) {
                one = new BrandLabel();
                one.setId(rs.getInt("ID"));
                one.setUserOwner(rs.getString("USER_OWNER"));
                one.setCp_code(rs.getString("CP_CODE"));
                one.setBrandLabel(rs.getString("BRAND_LABEL"));
                one.setCreateDate(rs.getTimestamp("CREATE_DATE"));
                one.setCreateBy(rs.getInt("CREATE_BY"));
                one.setStatus(rs.getInt("STATUS"));
                one.setFormTemplate(rs.getString("FORM_TEMPLATE"));
                one.setRoute(rs.getString("ROUTE_TABLE"));
                one.setPrice(rs.getInt("PRICE"));
                one.setPriority(rs.getInt("PRIORITY"));
                one.setOptionTelco(rs.getString("TELCO_OPTION"));
                one.setCheckTemp(rs.getInt("CHECK_TEMP"));
                one.setExp(rs.getString("EXP_STRING"));
                one.setType(rs.getInt("TYPE"));
                one.setDlr(rs.getInt("DLR"));
            }
        } catch (Exception e) {
            Tool.debug(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return one;
    }
    
    public static BrandLabel getByIdForBoSung(int id) {
        BrandLabel one = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM BRAND_LABEL WHERE ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setInt(i++, id);
            rs = pstm.executeQuery();
            if (rs.next()) {
                one = new BrandLabel();
                one.setId(rs.getInt("ID"));
                one.setUserOwner(rs.getString("USER_OWNER"));
                one.setCp_code(rs.getString("CP_CODE"));
                one.setBrandLabel(rs.getString("BRAND_LABEL"));
                one.setCreateDate(rs.getTimestamp("CREATE_DATE"));
                one.setCreateBy(rs.getInt("CREATE_BY"));
                one.setStatus(rs.getInt("STATUS"));
                one.setFormTemplate(rs.getString("FORM_TEMPLATE"));
                one.setRoute(rs.getString("ROUTE_TABLE"));
                one.setPrice(rs.getInt("PRICE"));
                one.setPriority(rs.getInt("PRIORITY"));
                one.setOptionTelco(rs.getString("TELCO_OPTION"));
                one.setCheckTemp(rs.getInt("CHECK_TEMP"));
                one.setRouteUni(rs.getString("UNILABEL"));
            }
        } catch (SQLException e) {
            Tool.debug(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return one;
    }

    public boolean delete(int id) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "UPDATE BRAND_LABEL SET STATUS = ? WHERE ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setInt(i++, Tool.STATUS.DEL.val);
            pstm.setInt(i++, id);
            if (pstm.executeUpdate() == 1) {
                flag = true;
                reload();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }

    public boolean delForEver(int id) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "DELETE FROM BRAND_LABEL WHERE ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setInt(i++, id);
            if (pstm.executeUpdate() == 1) {
                flag = true;
                reload();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }

    public static enum TYPE {

        ALL(2, "CSKH, Quảng cáo"),
        CSKH(0, "Tin chăm sóc khách hàng"),
        QC(1, "Tin nhắn Quảng cáo"),;
        public int val;
        public String desc;

        private TYPE(int val, String desc) {
            this.val = val;
            this.desc = desc;
        }

        public static String getDesc(int val) {
            String str = "Unknow";
            for (TYPE one : TYPE.values()) {
                if (one.val == val) {
                    str = one.desc;
                    break;
                }
            }
            return str;
        }
    }

    public static enum STATUS {

        ALL(-2, "Tất cả"),
        BLOCK(0, "Khóa"),
        ACTIVE(1, "Kích hoạt"),
        WAIT(2, "Chờ Duyệt"),
        PROCESS(3, "Đang xử lý"),
        REJECT(4, "Từ chối"),
        DELETE(404, "Bị Xóa"),;

        public int val;
        public String desc;

        private STATUS(int val, String desc) {
            this.val = val;
            this.desc = desc;
        }

        public static String getDesc(int val) {
            String str = "Unknow";
            for (STATUS one : STATUS.values()) {
                if (one.val == val) {
                    str = one.desc;
                    break;
                }
            }
            return str;
        }
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBrandLabel() {
        return brandLabel;
    }

    public void setBrandLabel(String brandLabel) {
        this.brandLabel = brandLabel;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    public int getCreateBy() {
        return createBy;
    }

    public void setCreateBy(int createBy) {
        this.createBy = createBy;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getUserOwner() {
        return userOwner;
    }

    public void setUserOwner(String userOwner) {
        this.userOwner = userOwner;
    }

    public String getCp_code() {
        return cp_code;
    }

    public void setCp_code(String cp_code) {
        this.cp_code = cp_code;
    }

    public String getFormTemplate() {
        return formTemplate;
    }

    public void setFormTemplate(String formTemplate) {
        this.formTemplate = formTemplate;
    }

    public RouteTable getRoute() {
        return route;
    }

    public void setRoute(RouteTable route) {
        this.route = route;
    }

    public void setRoute(String strJson) {
        this.route = RouteTable.json2Object(strJson);
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public Timestamp getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Timestamp updateDate) {
        this.updateDate = updateDate;
    }

    public int getUpdateBy() {
        return updateBy;
    }

    public void setUpdateBy(int updateBy) {
        this.updateBy = updateBy;
    }

    public String getOptionTelco() {
        return optionTelco;
    }

    public OptionTelco buildOption() {
        return OptionTelco.json2Objec(optionTelco);
    }

    public void setOptionTelco(String optionTelco) {
        this.optionTelco = optionTelco;
    }

    public int getCheckTemp() {
        return checkTemp;
    }

    public void setCheckTemp(int checkTemp) {
        this.checkTemp = checkTemp;
    }

    public String getSendBrandFollowRequest() {
        return sendBrandFollowRequest;
    }

    public void setSendBrandFollowRequest(String sendBrandFollowRequest) {
        this.sendBrandFollowRequest = sendBrandFollowRequest;
    }
    
    public CalculatedByRequest buildCalculatedRequest() {
        return CalculatedByRequest.json2Objec(sendBrandFollowRequest);
    }

    public RouteUni getRouteUni() {
        return uniLabel;
    }

    public void setRouteUni(RouteUni uniLabel) {
        this.uniLabel = uniLabel;
    }

    public void setRouteUni(String strJson) {
        this.uniLabel = RouteUni.json2Object(strJson);
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getExp() {
        return exp;
    }

    public void setExp(String exp) {
        this.exp = exp;
    }

    public RouteUni getUniLabel() {
        return uniLabel;
    }

    public void setUniLabel(RouteUni uniLabel) {
        this.uniLabel = uniLabel;
    }

    public int getDlr() {
        return dlr;
    }

    public void setDlr(int dlr) {
        this.dlr = dlr;
    }
    
    int id;
    String userOwner;
    String cp_code;
    String brandLabel;
    Timestamp createDate;
    int createBy;
    int status;
    String formTemplate;
    RouteTable route;
    
    int price;
    int priority;
    Timestamp updateDate;
    int updateBy;
    String optionTelco;     // For VinaPhone etc..
    int checkTemp;     // For VinaPhone etc..
    String sendBrandFollowRequest;
    RouteUni uniLabel;
    int dlr;
    
    int type;
    String exp;
    
    public String toStringJson() {
        if (this != null) {
            try {
                mapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
                String jsonInString = mapper.writeValueAsString(this);
                return jsonInString;
            } catch (JsonProcessingException e) {
                logger.error(Tool.getLogMessage(e));
                return "";
            }
        } else {
            return "";
        }
    }
}