/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gk.myname.vn.entity;

import gk.myname.vn.db.DBPool;
import static gk.myname.vn.entity.BrandLabel.logger;
import gk.myname.vn.utils.Tool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author Private
 */
public class PhoneBlackList {

    public ArrayList<PhoneBlackList> findAll(int page, int max, String phone, String oper, String label) {
        ArrayList<PhoneBlackList> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM phoneblacklist WHERE 1=1";
        try {
            if (!Tool.checkNull(phone)) {
                sql += " AND NUMBER like ?";
            }
            if (!Tool.checkNull(oper)) {
                sql += " AND TELCO = ?";
            }
            if (!Tool.checkNull(label)) {
                sql += " AND LABEL = ?";
            }
            
            sql += " ORDER BY ID DESC LIMIT ?,?";
            int i = 1;
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            if (!Tool.checkNull(phone)) {
                pstm.setString(i++, "%"+phone+"%");
            }
            if (!Tool.checkNull(oper)) {
                pstm.setString(i++, oper);
            }
            if (!Tool.checkNull(label)) {
                pstm.setString(i++, label);
            }
            
            pstm.setInt(i++, (page - 1) * max);
            pstm.setInt(i++, max);
            rs = pstm.executeQuery();
            while (rs.next()) {
                PhoneBlackList one = new PhoneBlackList();
                one.setId(rs.getInt("ID"));
                one.setNumber(rs.getString("NUMBER"));
                one.setTelco(rs.getString("TELCO"));
                one.setLabel(rs.getString("LABEL"));
                result.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public boolean existsByPhoneAndLabel(String phone, String label) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM phoneblacklist WHERE 1 = 1 AND NUMBER = ? AND LABEL = ?";
        try {
            int i = 1;
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(i++, phone);
            pstm.setString(i++, label);
            rs = pstm.executeQuery();
            while (rs.next()) {
                result = true;
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }

    public int countAll(String phone, String oper, String label) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT count(*) FROM PHONEBLACKLIST WHERE 1=1";
        try {
            if (!Tool.checkNull(phone)) {
                sql += " AND NUMBER like ?";
            }
            if (!Tool.checkNull(oper)) {
                sql += " AND TELCO = ?";
            }
            if (!Tool.checkNull(label)) {
                sql += " AND LABEL = ?";
            }
            
            int i = 1;
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            if (!Tool.checkNull(phone)) {
                pstm.setString(i++, "%"+phone+"%");
            }
            if (!Tool.checkNull(oper)) {
                pstm.setString(i++, oper);
            }
            if (!Tool.checkNull(label)) {
                pstm.setString(i++, label);
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

    public boolean addNew(PhoneBlackList one) {
        boolean result = Boolean.FALSE;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "INSERT INTO PHONEBLACKLIST(NUMBER,TELCO,LABEL) Values(?,?,?)";
        try {
            int i = 1;
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(i++, one.getNumber());
            pstm.setString(i++, one.getTelco());
            pstm.setString(i++, one.getLabel());
            result = pstm.executeUpdate() == 1;
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }

    public boolean update(PhoneBlackList one) {
        boolean result = Boolean.FALSE;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "UPDATE PHONEBLACKLIST SET NUMBER =?,TELCO =?,LABEL=? WHERE ID = ?";
        try {
            int i = 1;
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(i++, one.getNumber());
            pstm.setString(i++, one.getTelco());
            pstm.setString(i++, one.getLabel());
            pstm.setInt(i++, one.getId());
            result = pstm.executeUpdate() == 1;
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }

    public boolean delete(int id) {
        boolean result = Boolean.FALSE;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "DELETE FROM PHONEBLACKLIST WHERE ID = ?";
        try {
            int i = 1;
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setInt(i++, id);
            result = pstm.executeUpdate() == 1;
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    private int id;
    private String number;
    private String telco;
    private String label;

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getTelco() {
        return telco;
    }

    public void setTelco(String telco) {
        this.telco = telco;
    }
}
