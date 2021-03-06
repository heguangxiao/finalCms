/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gk.myname.vn.entity;

import gk.myname.vn.db.DBPool;
import gk.myname.vn.utils.Tool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.log4j.Logger;

/**
 *
 * @author Hieu
 */
public class RouteNationTelco {
    static final Logger logger = Logger.getLogger(RouteNationTelco.class);
    public static ArrayList<RouteNationTelco> CACHE = new ArrayList<>();
    
    static {
        CACHE = getALL();
    }

    private void reload() {
        CACHE.clear();
        CACHE = getALL();
    }
    
    public static ArrayList<RouteNationTelco> getALL() {
        ArrayList<RouteNationTelco> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM route_nation_telco WHERE 1 = 1";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                RouteNationTelco one = new RouteNationTelco();
                one.setId(rs.getInt("ID"));
                one.setCountryCode(rs.getString("COUNTRY_CODE"));
                one.setTelcoCode(rs.getString("TELCO_CODE"));
                one.setGroup(rs.getString("GROUPSMS"));
                one.setCskh(rs.getString("CSKH"));
                one.setQc(rs.getString("QC"));
                one.setRequest(rs.getInt("REQUEST"));
                one.setStatus(rs.getInt("STT"));
                one.setBrandname(rs.getString("BRANDNAME"));
                one.setLabelId(rs.getString("LABEL_ID_NCC"));
                one.setLabelUsername(rs.getString("LABEL_USERNAME_NCC"));
                one.setTempId(rs.getString("TEMP_ID_NCC"));
                one.setDuplicate(rs.getInt("CHECKDUPLICATE"));
                one.setUser_owner(rs.getString("USER_OWNER"));
                one.setCskhunicode(rs.getString("CSKH_UNICODE"));
                one.setGroupunicode(rs.getString("GROUP_UNICODE"));
                one.setDenhan(rs.getInt("DENHAN"));
                one.setCkdenhan(rs.getInt("CK_DENHAN"));
                result.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public static RouteNationTelco getbyId(int id) {
        RouteNationTelco result = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM route_nation_telco WHERE ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = new RouteNationTelco();
                result.setId(rs.getInt("ID"));
                result.setCountryCode(rs.getString("COUNTRY_CODE"));
                result.setTelcoCode(rs.getString("TELCO_CODE"));
                result.setGroup(rs.getString("GROUPSMS"));
                result.setCskh(rs.getString("CSKH"));
                result.setQc(rs.getString("QC"));
                result.setRequest(rs.getInt("REQUEST"));
                result.setStatus(rs.getInt("STT"));
                result.setBrandname(rs.getString("BRANDNAME"));
                result.setLabelId(rs.getString("LABEL_ID_NCC"));
                result.setLabelUsername(rs.getString("LABEL_USERNAME_NCC"));
                result.setTempId(rs.getString("TEMP_ID_NCC"));
                result.setDuplicate(rs.getInt("CHECKDUPLICATE"));
                result.setUser_owner(rs.getString("USER_OWNER"));
                result.setCskhunicode(rs.getString("CSKH_UNICODE"));
                result.setGroupunicode(rs.getString("GROUP_UNICODE"));
                result.setDenhan(rs.getInt("DENHAN"));
                result.setCkdenhan(rs.getInt("CK_DENHAN"));
                result.setTemplateId(rs.getInt("ID_TEMPLATE"));
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public static boolean getbyBrandnameAndUserownerAndGroupBrAndTelco(String brandname, String userowner, String groupBr, String telco) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM route_nation_telco WHERE BRANDNAME = ? AND USER_OWNER = ? AND TELCO_CODE = ? AND GROUPSMS = ? ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, brandname);
            pstm.setString(2, userowner);
            pstm.setString(3, telco);
            pstm.setString(4, groupBr);
            rs = pstm.executeQuery();
            if (rs.next()) {
                flag = true;
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }
    
    public static boolean getbyBrandnameAndUserownerAndGroupBr(String brandname, String userowner, String groupBr) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM route_nation_telco WHERE BRANDNAME = ? AND USER_OWNER = ? AND GROUPSMS = ? ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, brandname);
            pstm.setString(2, userowner);
            pstm.setString(3, groupBr);
            rs = pstm.executeQuery();
            if (rs.next()) {
                flag = true;
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }
    
    public static boolean getbyBrandnameAndUserownerAndProviderAndGroupBrAndTelco(String brandname, String userowner, String provider, String groupBr, String telco) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM route_nation_telco WHERE BRANDNAME = ? AND USER_OWNER = ? ";
        
        if (!Tool.checkNull(provider)) {
            sql += " AND CSKH = ? ";
        }
        if (!Tool.checkNull(telco)) {
            sql += " AND TELCO_CODE = ?";
        }
        if (!Tool.checkNull(groupBr)) {
            sql += " AND GROUPSMS = ? ";
        }
        
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, brandname);
            pstm.setString(i++, userowner);
            if (!Tool.checkNull(provider)) {
                pstm.setString(i++, provider);
            }
            if (!Tool.checkNull(telco)) {
                pstm.setString(i++, telco);
            }
            if (!Tool.checkNull(groupBr)) {
                pstm.setString(i++, groupBr);
            }
            rs = pstm.executeQuery();
            if (rs.next()) {
                flag = true;
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }
    
    public static boolean getbyBrandnameAndUserownerAndNation(String brandname, String userowner, String nation) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM route_nation_telco WHERE BRANDNAME = ? AND USER_OWNER = ? AND COUNTRY_CODE = ?";
                
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, brandname);
            pstm.setString(i++, userowner);
            pstm.setString(i++, nation);
            rs = pstm.executeQuery();
            if (rs.next()) {                
                flag = true;
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }
    
    public static RouteNationTelco getbyBrandnameAndUserownerAndTelco(String brandname, String userowner, String telco) {
        RouteNationTelco result = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM route_nation_telco WHERE BRANDNAME = ? AND USER_OWNER = ? AND TELCO_CODE = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, brandname);
            pstm.setString(2, userowner);
            pstm.setString(3, telco);
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = new RouteNationTelco();
                result.setId(rs.getInt("ID"));
                result.setCountryCode(rs.getString("COUNTRY_CODE"));
                result.setTelcoCode(rs.getString("TELCO_CODE"));
                result.setGroup(rs.getString("GROUPSMS"));
                result.setCskh(rs.getString("CSKH"));
                result.setQc(rs.getString("QC"));
                result.setRequest(rs.getInt("REQUEST"));
                result.setStatus(rs.getInt("STT"));
                result.setBrandname(rs.getString("BRANDNAME"));
                result.setLabelId(rs.getString("LABEL_ID_NCC"));
                result.setLabelUsername(rs.getString("LABEL_USERNAME_NCC"));
                result.setTempId(rs.getString("TEMP_ID_NCC"));
                result.setDuplicate(rs.getInt("CHECKDUPLICATE"));
                result.setUser_owner(rs.getString("USER_OWNER"));
                result.setCskhunicode(rs.getString("CSKH_UNICODE"));
                result.setGroupunicode(rs.getString("GROUP_UNICODE"));
                result.setDenhan(rs.getInt("DENHAN"));
                result.setCkdenhan(rs.getInt("CK_DENHAN"));
                result.setTemplateId(rs.getInt("ID_TEMPLATE"));
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public static ArrayList<RouteNationTelco> getAllByBrandnameAndUserowner(String brandname,String userowner) {
        ArrayList<RouteNationTelco> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM route_nation_telco WHERE 1 = 1 AND BRANDNAME = ? AND USER_OWNER = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, brandname);
            pstm.setString(2, userowner);
            rs = pstm.executeQuery();
            while (rs.next()) {
                RouteNationTelco one = new RouteNationTelco();
                one.setId(rs.getInt("ID"));
                one.setCountryCode(rs.getString("COUNTRY_CODE"));
                one.setTelcoCode(rs.getString("TELCO_CODE"));
                one.setGroup(rs.getString("GROUPSMS"));
                one.setCskh(rs.getString("CSKH"));
                one.setQc(rs.getString("QC"));
                one.setRequest(rs.getInt("REQUEST"));
                one.setStatus(rs.getInt("STT"));
                one.setBrandname(rs.getString("BRANDNAME"));
                one.setLabelId(rs.getString("LABEL_ID_NCC"));
                one.setLabelUsername(rs.getString("LABEL_USERNAME_NCC"));
                one.setTempId(rs.getString("TEMP_ID_NCC"));
                one.setDuplicate(rs.getInt("CHECKDUPLICATE"));
                one.setUser_owner(rs.getString("USER_OWNER"));
                one.setCskhunicode(rs.getString("CSKH_UNICODE"));
                one.setGroupunicode(rs.getString("GROUP_UNICODE"));
                one.setDenhan(rs.getInt("DENHAN"));
                one.setCkdenhan(rs.getInt("CK_DENHAN"));
                one.setTemplateId(rs.getInt("ID_TEMPLATE"));
                result.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public boolean del_ever(int id) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "DELETE FROM route_nation_telco WHERE ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setInt(1, id);
            if (pstm.executeUpdate() > 0) {
                reload();
            }
            result = true;
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public boolean addRouteNationTelco(RouteNationTelco one) {
        String countrycode = Telco_Nations.getCountryCodeByTelcoCode(one.getTelcoCode());
        one.setCountryCode(countrycode);
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "INSERT INTO route_nation_telco(COUNTRY_CODE, TELCO_CODE, GROUPSMS, CSKH, QC, REQUEST, STT, BRANDNAME, LABEL_ID_NCC, LABEL_USERNAME_NCC, TEMP_ID_NCC, CHECKDUPLICATE, USER_OWNER, CSKH_UNICODE, GROUP_UNICODE, DENHAN, CK_DENHAN, ID_TEMPLATE) "
                   + "            VALUES            (           ?,          ?,        ?,    ?,  ?,       ?,   ?,         ?,            ?,                  ?,           ?,              ?,          ?,            ?,             ?,      ?,         ?,           ?) ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, one.getCountryCode());
            pstm.setString(i++, one.getTelcoCode());
            pstm.setString(i++, one.getGroup());
            pstm.setString(i++, one.getCskh());
            pstm.setString(i++, one.getQc());
            pstm.setInt(i++, one.getRequest());
            pstm.setInt(i++, one.getStatus());
            pstm.setString(i++, one.getBrandname());
            pstm.setString(i++, one.getLabelId());
            pstm.setString(i++, one.getLabelUsername());
            pstm.setString(i++, one.getTempId());
            pstm.setInt(i++, one.getDuplicate());
            pstm.setString(i++, one.getUser_owner());
            pstm.setString(i++, one.getCskhunicode());
            pstm.setString(i++, one.getGroupunicode());
            pstm.setInt(i++, one.getDenhan());
            pstm.setInt(i++, one.getCkdenhan());
            pstm.setInt(i++, one.getTemplateId());
            if (pstm.executeUpdate() == 1) {
                result = true;
                reload();
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public boolean updateRouteNationTelco(RouteNationTelco one) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "UPDATE route_nation_telco SET "
                + " COUNTRY_CODE = ?, TELCO_CODE = ?, GROUPSMS = ?, "
                + " CSKH = ?, QC = ?, REQUEST = ?, STT = ? , BRANDNAME = ?, "
                + " LABEL_ID_NCC = ?, LABEL_USERNAME_NCC = ?, TEMP_ID_NCC = ?, "
                + " CHECKDUPLICATE = ?, USER_OWNER = ?, CSKH_UNICODE = ?, "
                + " GROUP_UNICODE = ?, DENHAN = ?, CK_DENHAN = ?, "
                + " ID_TEMPLATE = ?"
                + " WHERE ID = ? ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, one.getCountryCode());
            pstm.setString(i++, one.getTelcoCode());
            pstm.setString(i++, one.getGroup());
            pstm.setString(i++, one.getCskh());
            pstm.setString(i++, one.getQc());
            pstm.setInt(i++, one.getRequest());
            pstm.setInt(i++, one.getStatus());
            pstm.setString(i++, one.getBrandname());
            pstm.setString(i++, one.getLabelId());
            pstm.setString(i++, one.getLabelUsername());
            pstm.setString(i++, one.getTempId());
            pstm.setInt(i++, one.getDuplicate());
            pstm.setString(i++, one.getUser_owner());
            pstm.setString(i++, one.getCskhunicode());
            pstm.setString(i++, one.getGroupunicode());
            pstm.setInt(i++, one.getDenhan());
            pstm.setInt(i++, one.getCkdenhan());
            pstm.setInt(i++, one.getTemplateId());
            
            pstm.setInt(i++, one.getId());
            result = pstm.executeUpdate() == 1;
            if (result) {
                reload();
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    private int id;
    private String countryCode;
    private String telcoCode;
    private String group;
    private String cskh;
    private String qc;
    private int request;
    private int status;
    private String brandname;
    private String labelId;
    private String labelUsername;
    private String tempId;
    private int duplicate;
    private String user_owner;
    private String cskhunicode;
    private String groupunicode;
    private int ckdenhan;
    private int denhan; 
    private int templateId; 

    public static ArrayList<RouteNationTelco> getCACHE() {
        return CACHE;
    }

    public static void setCACHE(ArrayList<RouteNationTelco> CACHE) {
        RouteNationTelco.CACHE = CACHE;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getTelcoCode() {
        return telcoCode;
    }

    public void setTelcoCode(String telcoCode) {
        this.telcoCode = telcoCode;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public String getCskh() {
        return cskh;
    }

    public void setCskh(String cskh) {
        this.cskh = cskh;
    }

    public String getQc() {
        return qc;
    }

    public void setQc(String qc) {
        this.qc = qc;
    }

    public int getRequest() {
        return request;
    }

    public void setRequest(int request) {
        this.request = request;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getBrandname() {
        return brandname;
    }

    public void setBrandname(String brandname) {
        this.brandname = brandname;
    }

    public String getLabelId() {
        return labelId;
    }

    public void setLabelId(String labelId) {
        this.labelId = labelId;
    }

    public String getLabelUsername() {
        return labelUsername;
    }

    public void setLabelUsername(String labelUsername) {
        this.labelUsername = labelUsername;
    }

    public String getTempId() {
        return tempId;
    }

    public void setTempId(String tempId) {
        this.tempId = tempId;
    }

    public int getDuplicate() {
        return duplicate;
    }

    public void setDuplicate(int duplicate) {
        this.duplicate = duplicate;
    }

    public String getUser_owner() {
        return user_owner;
    }

    public void setUser_owner(String user_owner) {
        this.user_owner = user_owner;
    }

    public String getCskhunicode() {
        return cskhunicode;
    }

    public void setCskhunicode(String cskhunicode) {
        this.cskhunicode = cskhunicode;
    }

    public String getGroupunicode() {
        return groupunicode;
    }

    public void setGroupunicode(String groupunicode) {
        this.groupunicode = groupunicode;
    }

    public int getCkdenhan() {
        return ckdenhan;
    }

    public void setCkdenhan(int ckdenhan) {
        this.ckdenhan = ckdenhan;
    }

    public int getDenhan() {
        return denhan;
    }

    public void setDenhan(int denhan) {
        this.denhan = denhan;
    }

    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        if(Tool.checkNull(templateId)) {
            templateId = 0;
        }
        this.templateId = templateId;
    }
}
