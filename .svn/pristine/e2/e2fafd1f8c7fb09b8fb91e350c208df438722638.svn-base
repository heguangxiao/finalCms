/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gk.myname.vn.entity;

import gk.myname.vn.db.DBPool;
import static gk.myname.vn.entity.MnpPhone.CACHE;
import static gk.myname.vn.entity.MnpPhone.getAll;
import static gk.myname.vn.entity.MnpPhone.logger;
import gk.myname.vn.utils.Tool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import org.apache.log4j.Logger;

/**
 *
 * @author Hieu
 */
public class MnpPhone {
    
    static final Logger logger = Logger.getLogger(MnpPhone.class);
    public static ArrayList<MnpPhone> CACHE = new ArrayList<>();
    
    private int id;
    private String phone;
    private String operMnp;
    private String operOrg;
    private String sources;
    private String createdat;
    private String updatedat;

    public String getCreatedat() {
        return createdat;
    }

    public void setCreatedat(String createdat) {
        this.createdat = createdat;
    }

    public String getUpdatedat() {
        return updatedat;
    }

    public void setUpdatedat(String updatedat) {
        this.updatedat = updatedat;
    }

    public static ArrayList<MnpPhone> getCACHE() {
        return CACHE;
    }

    public static void setCACHE(ArrayList<MnpPhone> CACHE) {
        MnpPhone.CACHE = CACHE;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getOperMnp() {
        return operMnp;
    }

    public void setOperMnp(String operMnp) {
        this.operMnp = operMnp;
    }

    public String getOperOrg() {
        return operOrg;
    }

    public void setOperOrg(String operOrg) {
        this.operOrg = operOrg;
    }

    public String getSources() {
        return sources;
    }

    public void setSources(String sources) {
        this.sources = sources;
    }

    public MnpPhone() {
    }
    
    static {
        CACHE = getAll();
    }
    
    public static ArrayList<MnpPhone> getAll() {
        ArrayList<MnpPhone> list = new ArrayList();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from mnp_phones where 1 = 1";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                MnpPhone mnpPhone = new MnpPhone();
                mnpPhone.setId(rs.getInt("ID"));
                mnpPhone.setPhone(rs.getString("PHONE"));
                mnpPhone.setOperMnp(rs.getString("OPER_MNP"));
                mnpPhone.setOperOrg(rs.getString("OPER_ORG"));
                mnpPhone.setSources(rs.getString("SOURCES"));
                mnpPhone.setCreatedat(rs.getString("CREATEDAT"));
                mnpPhone.setUpdatedat(rs.getString("UPDATEDAT"));
                list.add(mnpPhone);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return list;
    }
    
    public ArrayList<MnpPhone> findAll(int max, int page, String phone) {
        ArrayList<MnpPhone> list = new ArrayList();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from mnp_phones where 1 = 1";
            if (!Tool.checkNull(phone)) {
                sql += " AND PHONE LIKE ?";
            }
            sql += " ORDER BY ID DESC LIMIT ?,?";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (!Tool.checkNull(phone)) {
                pstm.setString(i++, "%" + phone + "%");
            }
            pstm.setInt(i++, (page - 1) * max);
            pstm.setInt(i++, max);
            rs = pstm.executeQuery();
            while (rs.next()) {
                MnpPhone mnpPhone = new MnpPhone();
                mnpPhone.setId(rs.getInt("ID"));
                mnpPhone.setPhone(rs.getString("PHONE"));
                mnpPhone.setOperMnp(rs.getString("OPER_MNP"));
                mnpPhone.setOperOrg(rs.getString("OPER_ORG"));
                mnpPhone.setSources(rs.getString("SOURCES"));
                mnpPhone.setCreatedat(rs.getString("CREATEDAT"));
                mnpPhone.setUpdatedat(rs.getString("UPDATEDAT"));
                list.add(mnpPhone);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return list;
    }
    
    public int count(String phone) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select count(*) from mnp_phones where 1=1 ";
            if (!Tool.checkNull(phone)) {
                sql += " AND PHONE LIKE ?";
            }
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (!Tool.checkNull(phone)) {
                pstm.setString(i++, "%" + phone + "%");
            }
            rs = pstm.executeQuery();
            while (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public boolean add(MnpPhone mnpPhone) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        Date date = java.util.Calendar.getInstance().getTime(); 
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
        String strDate = dateFormat.format(date);  
        try {
            String sql = " INSERT INTO mnp_phones( PHONE, OPER_MNP, CREATEDAT, OPER_ORG, SOURCES, UPDATEDAT) "
                       + " VALUES(                     ?,        ?,         ?,        ?,       ?,         ?) ";
            
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            pstm.setString(i++, mnpPhone.getPhone());
            pstm.setString(i++, mnpPhone.getOperMnp());
            pstm.setString(i++, strDate);
            
            pstm.setString(i++, mnpPhone.getOperOrg());
            pstm.setString(i++, mnpPhone.getSources());
            pstm.setString(i++, strDate);
            
            
            result = pstm.executeUpdate() == 1;
            
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(pstm, conn);
        }
        return result;
    }
    
    public boolean edit(MnpPhone mnpPhone) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        Date date = java.util.Calendar.getInstance().getTime(); 
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
        String strDate = dateFormat.format(date);  
        
        try {
            String sql = " UPDATE mnp_phones SET PHONE = ?, OPER_MNP = ?, OPER_ORG = ? , UPDATEDAT = ?, SOURCES = ? "
                       + " WHERE ID = ? ";
            
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            pstm.setString(i++, mnpPhone.getPhone());
            pstm.setString(i++, mnpPhone.getOperMnp());
            pstm.setString(i++, mnpPhone.getOperOrg());
            pstm.setString(i++, strDate);
            pstm.setString(i++, mnpPhone.getSources());
            
            pstm.setInt(i++, mnpPhone.getId());
            
            result = pstm.executeUpdate() == 1;
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(pstm, conn);
        }
        return result;
    }
    
    public MnpPhone findById(int id) {
        MnpPhone mnpPhone = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from mnp_phones where 1 = 1 AND ID = ?";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            pstm.setInt(i++, id);
            
            rs = pstm.executeQuery();
            while (rs.next()) {
                
                mnpPhone = new MnpPhone();
                mnpPhone.setId(rs.getInt("ID"));
                mnpPhone.setPhone(rs.getString("PHONE"));
                mnpPhone.setOperMnp(rs.getString("OPER_MNP"));
                mnpPhone.setOperOrg(rs.getString("OPER_ORG"));
                mnpPhone.setSources(rs.getString("SOURCES"));
                mnpPhone.setCreatedat(rs.getString("CREATEDAT"));
                mnpPhone.setUpdatedat(rs.getString("UPDATEDAT"));
                
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return mnpPhone;
    }
    
    public boolean existPhone(String phone) {
        boolean flag = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from mnp_phones where 1 = 1 AND PHONE = ?";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            pstm.setString(i++, phone);
            
            rs = pstm.executeQuery();
            while (rs.next()) {
                flag = true;
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return flag;
    }
}
