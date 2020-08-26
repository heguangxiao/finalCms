package gk.myname.vn.entity;

import gk.myname.vn.db.DBPool;
import static gk.myname.vn.entity.BrandLabel.reload;
import gk.myname.vn.utils.Tool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.log4j.Logger;

public class Telco_Nations {

    static final Logger logger = Logger.getLogger(Telco_Nations.class);

    int id;
    String country_code;
    String telco_code;
    String telco_prefix;
    String telco_name;
    int number_length;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCountry_code() {
        return country_code;
    }

    public void setCountry_code(String country_code) {
        this.country_code = country_code;
    }

    public String getTelco_code() {
        return telco_code;
    }

    public void setTelco_code(String telco_code) {
        this.telco_code = telco_code;
    }

    public String getTelco_prefix() {
        return telco_prefix;
    }

    public void setTelco_prefix(String telco_prefix) {
        this.telco_prefix = telco_prefix;
    }

    public String getTelco_name() {
        return telco_name;
    }

    public void setTelco_name(String telco_name) {
        this.telco_name = telco_name;
    }

    public int getNumber_length() {
        return number_length;
    }

    public void setNumber_length(int number_length) {
        this.number_length = number_length;
    }

    public Telco_Nations(int id, String country_code, String telco_code, String telco_prefix, String telco_name, int number_length) {
        this.id = id;
        this.country_code = country_code;
        this.telco_code = telco_code;
        this.telco_prefix = telco_prefix;
        this.telco_name = telco_name;
        this.number_length = number_length;
    }

    public Telco_Nations() {
    }

    public static ArrayList<Telco_Nations> getTelco_na() {
        ArrayList<Telco_Nations> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT T.* FROM TELCOS T ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                Telco_Nations one = new Telco_Nations();
                one.setId(rs.getInt("ID"));
                one.setCountry_code(rs.getString("COUNTRY_CODE"));
                one.setTelco_code(rs.getString("TELCO_CODE"));
                one.setTelco_prefix(rs.getString("TELCO_PREFIX"));
                one.setTelco_name(rs.getString("TELCO_NAME"));
                one.setNumber_length(rs.getInt("NUMBER_LENGTH"));
                result.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public static ArrayList<Telco_Nations> getTelcosByCountryCode(String countryCode) {
        ArrayList<Telco_Nations> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM TELCOS WHERE 1 = 1 AND COUNTRY_CODE = ? ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, countryCode);
            rs = pstm.executeQuery();
            while (rs.next()) {
                Telco_Nations one = new Telco_Nations();
                one.setId(rs.getInt("ID"));
                one.setCountry_code(rs.getString("COUNTRY_CODE"));
                one.setTelco_code(rs.getString("TELCO_CODE"));
                one.setTelco_prefix(rs.getString("TELCO_PREFIX"));
                one.setTelco_name(rs.getString("TELCO_NAME"));
                one.setNumber_length(rs.getInt("NUMBER_LENGTH"));
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
        String sql = "DELETE FROM TELCOS WHERE ID = ?";
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
    
    public boolean del_ever_NationCode(String code) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "DELETE FROM TELCOS WHERE COUNTRY_CODE = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, code);
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

    public boolean addTel(Telco_Nations one) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "INSERT INTO TELCOS(COUNTRY_CODE,TELCO_CODE,TELCO_PREFIX,TELCO_NAME,NUMBER_LENGTH) "
                + "               VALUES  (          ?,         ?  ,          ?,?        ,? ) ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, one.getCountry_code());
            pstm.setString(i++, one.getTelco_code());
            pstm.setString(i++, one.getTelco_prefix());
            pstm.setString(i++, one.getTelco_name());
            pstm.setInt(i++, one.getNumber_length());
            if (pstm.executeUpdate() == 1) {
                result = true;
                reload();
            }
        } catch (Exception e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }

    public boolean updateTel(Telco_Nations one) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "UPDATE TELCOS SET COUNTRY_CODE = ?,TELCO_CODE = ? ,TELCO_PREFIX = ?,TELCO_NAME = ?,NUMBER_LENGTH = ?"
                + " WHERE ID = ? ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, one.getCountry_code());
            pstm.setString(i++, one.getTelco_code());
            pstm.setString(i++, one.getTelco_prefix());
            pstm.setString(i++, one.getTelco_name());
            pstm.setInt(i++, one.getNumber_length());
            pstm.setInt(i++, one.getId());
            result = pstm.executeUpdate() == 1;
            if (result) {
                reload();
            }
        } catch (Exception e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }

    public static Telco_Nations getbyId(int id) {
        Telco_Nations result = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT T.* FROM TELCOS T WHERE ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = new Telco_Nations();
                result.setId(rs.getInt("ID"));
                result.setCountry_code(rs.getString("COUNTRY_CODE"));
                result.setTelco_code(rs.getString("TELCO_CODE"));
                result.setTelco_prefix(rs.getString("TELCO_PREFIX"));
                result.setTelco_name(rs.getString("TELCO_NAME"));
                result.setNumber_length(rs.getInt("NUMBER_LENGTH"));

            }
        } catch (Exception e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public static String getCountryCodeByTelcoCode(String telcoCode) {
        String result = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT T.* FROM TELCOS T WHERE TELCO_CODE = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, telcoCode);
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = rs.getString("COUNTRY_CODE");
            }
        } catch (Exception e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
}
