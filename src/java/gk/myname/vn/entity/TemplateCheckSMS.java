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
 * @author HTC-PC
 */
public class TemplateCheckSMS {
    static final Logger logger = Logger.getLogger(TemplateCheckSMS.class);
    public static ArrayList<TemplateCheckSMS> CACHE = new ArrayList<>();
    
    static {
        CACHE = getAll();
    }
    
    private int id;
    private String key;
    private String name;
    private String description;
    private int vitri;
    private String group;
    
    public TemplateCheckSMS() {
    }

    public static ArrayList<TemplateCheckSMS> getCACHE() {
        return CACHE;
    }

    public static void setCACHE(ArrayList<TemplateCheckSMS> CACHE) {
        TemplateCheckSMS.CACHE = CACHE;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getVitri() {
        return vitri;
    }

    public void setVitri(int vitri) {
        this.vitri = vitri;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    @Override
    public String toString() {
        return "TemplateCheckSMS{" + "id=" + id + ", key=" + key + ", name=" + name + ", description=" + description + ", vitri=" + vitri + ", group=" + group + '}';
    }
    
    public static ArrayList<TemplateCheckSMS> getAll() {
        ArrayList<TemplateCheckSMS> list = new ArrayList();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from temp_check_sms where 1 = 1";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                TemplateCheckSMS templateCheckSMS = new TemplateCheckSMS();
                templateCheckSMS.setId(rs.getInt("ID"));
                templateCheckSMS.setVitri(rs.getInt("VITRI"));
                templateCheckSMS.setName(rs.getString("NAME"));
                templateCheckSMS.setDescription(rs.getString("DESCRIPTION"));
                templateCheckSMS.setGroup(rs.getString("GROUP"));
                templateCheckSMS.setKey(rs.getString("KEY"));
                list.add(templateCheckSMS);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return list;
    }
    
    public ArrayList<TemplateCheckSMS> findAll(int vitri, String key, String group) {
        ArrayList<TemplateCheckSMS> list = new ArrayList();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from temp_check_sms a where 1 = 1";
            if (!Tool.checkNull(key)) {
                sql += " AND (a.KEY LIKE ? OR a.NAME LIKE ? OR a.DESCRIPTION LIKE ?) ";
            }
            if (!Tool.checkNull(group)) {
                sql += " AND a.GROUP = ? ";
            }
            if (vitri != 0) {
                sql += " AND a.VITRI = ? ";  
            }
            sql += " ORDER BY a.ID DESC ";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (!Tool.checkNull(key)) {
                pstm.setString(i++, "%" + key + "%");
                pstm.setString(i++, "%" + key + "%");
                pstm.setString(i++, "%" + key + "%");
            }
            if (!Tool.checkNull(group)) {
                pstm.setString(i++, group);
            }
            if (vitri != 0) {
                pstm.setInt(i++, vitri);
            }
            rs = pstm.executeQuery();
            while (rs.next()) {
                TemplateCheckSMS templateCheckSMS = new TemplateCheckSMS();
                templateCheckSMS.setId(rs.getInt("ID"));
                templateCheckSMS.setVitri(rs.getInt("VITRI"));
                templateCheckSMS.setName(rs.getString("NAME"));
                templateCheckSMS.setDescription(rs.getString("DESCRIPTION"));
                templateCheckSMS.setGroup(rs.getString("GROUP"));
                templateCheckSMS.setKey(rs.getString("KEY"));
                list.add(templateCheckSMS);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return list;
    }
    
    public ArrayList<TemplateCheckSMS> findAll(int max, int page, int vitri, String key, String group) {
        ArrayList<TemplateCheckSMS> list = new ArrayList();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from temp_check_sms a where 1 = 1";
            if (!Tool.checkNull(key)) {
                sql += " AND (a.KEY LIKE ? OR a.NAME LIKE ? OR a.DESCRIPTION LIKE ?) ";
            }
            if (!Tool.checkNull(group)) {
                sql += " AND a.GROUP = ? ";
            }
            if (vitri != 0) {
                sql += " AND a.VITRI = ? ";  
            }
            sql += " ORDER BY a.ID DESC LIMIT ?,?";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (!Tool.checkNull(key)) {
                pstm.setString(i++, "%" + key + "%");
                pstm.setString(i++, "%" + key + "%");
                pstm.setString(i++, "%" + key + "%");
            }
            if (!Tool.checkNull(group)) {
                pstm.setString(i++, group);
            }
            if (vitri != 0) {
                pstm.setInt(i++, vitri);
            }
            pstm.setInt(i++, (page - 1) * max);
            pstm.setInt(i++, max);
            rs = pstm.executeQuery();
            while (rs.next()) {
                TemplateCheckSMS templateCheckSMS = new TemplateCheckSMS();
                templateCheckSMS.setId(rs.getInt("ID"));
                templateCheckSMS.setVitri(rs.getInt("VITRI"));
                templateCheckSMS.setName(rs.getString("NAME"));
                templateCheckSMS.setDescription(rs.getString("DESCRIPTION"));
                templateCheckSMS.setGroup(rs.getString("GROUP"));
                templateCheckSMS.setKey(rs.getString("KEY"));
                list.add(templateCheckSMS);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return list;
    }
    
    public ArrayList<String> findAllGroup() {
        ArrayList<String> list = new ArrayList();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT DISTINCT A.GROUP from temp_check_sms A where 1 = 1";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("GROUP"));
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return list;
    }
    
    public int count(int vitri, String key, String group) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select count(*) from temp_check_sms a where 1=1 ";
            if (!Tool.checkNull(key)) {
                sql += " AND (a.KEY LIKE ? OR a.NAME LIKE ? OR a.DESCRIPTION LIKE ?) ";
            }
            if (!Tool.checkNull(group)) {
                sql += " AND a.GROUP = ? ";
            }
            if (vitri != 0) {
                sql += " AND a.VITRI = ? ";  
            }
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (!Tool.checkNull(key)) {
                pstm.setString(i++, "%" + key + "%");
                pstm.setString(i++, "%" + key + "%");
                pstm.setString(i++, "%" + key + "%");
            }
            if (!Tool.checkNull(group)) {
                pstm.setString(i++, group);
            }
            if (vitri != 0) {
                pstm.setInt(i++, vitri);
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
    
    public boolean add(TemplateCheckSMS templateCheckSMS) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        
        try {
            String sql = " INSERT INTO temp_check_sms( temp_check_sms.KEY, VITRI, NAME, temp_check_sms.GROUP, DESCRIPTION ) "
                       + " VALUES(                                      ?,     ?,    ?,                    ?,           ? ) ";
            
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            pstm.setString(i++, templateCheckSMS.getKey());
            pstm.setInt(i++, templateCheckSMS.getVitri());
            pstm.setString(i++, templateCheckSMS.getName());
            pstm.setString(i++, templateCheckSMS.getGroup());
            pstm.setString(i++, templateCheckSMS.getDescription());
            
            result = pstm.executeUpdate() == 1;
            
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(pstm, conn);
        }
        return result;
    }
    
    public boolean edit(TemplateCheckSMS templateCheckSMS) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        try {
            String sql = " UPDATE temp_check_sms SET temp_check_sms.KEY = ?, VITRI = ?, NAME = ? , temp_check_sms.GROUP = ?, DESCRIPTION = ? "
                       + " WHERE ID = ? ";
            
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            pstm.setString(i++, templateCheckSMS.getKey());
            pstm.setInt(i++, templateCheckSMS.getVitri());
            pstm.setString(i++, templateCheckSMS.getName());
            pstm.setString(i++, templateCheckSMS.getGroup());
            pstm.setString(i++, templateCheckSMS.getDescription());
            
            pstm.setInt(i++, templateCheckSMS.getId());
            
            result = pstm.executeUpdate() == 1;
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(pstm, conn);
        }
        return result;
    }
    
    public TemplateCheckSMS findById(int id) {
        TemplateCheckSMS templateCheckSMS = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from temp_check_sms where 1 = 1 AND ID = ?";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            pstm.setInt(i++, id);
            
            rs = pstm.executeQuery();
            while (rs.next()) {
                
                templateCheckSMS = new TemplateCheckSMS();
                templateCheckSMS.setId(rs.getInt("ID"));
                templateCheckSMS.setVitri(rs.getInt("VITRI"));
                templateCheckSMS.setName(rs.getString("NAME"));
                templateCheckSMS.setDescription(rs.getString("DESCRIPTION"));
                templateCheckSMS.setGroup(rs.getString("GROUP"));
                templateCheckSMS.setKey(rs.getString("KEY"));
                
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return templateCheckSMS;
    }
    
}
