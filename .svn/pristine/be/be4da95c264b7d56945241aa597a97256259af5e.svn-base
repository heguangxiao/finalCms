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
public class PriceTelcoDb {
    
    static final Logger logger = Logger.getLogger(PriceTelcoDb.class);
    public static ArrayList<PriceTelcoDb> CACHE = new ArrayList<>();

    static {
        CACHE = getALL();
    }

    private void reload() {
        CACHE.clear();
        CACHE = getALL();
    }
    
    public static ArrayList<PriceTelcoDb> getALL() {
        ArrayList<PriceTelcoDb> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM price_nation_telco WHERE 1 = 1";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                PriceTelcoDb one = new PriceTelcoDb();
                one.setId(rs.getInt("ID"));
                one.setType(rs.getInt("TYPE"));
                one.setProviderId(rs.getInt("PROVIDER_ID"));
                one.setAccountId(rs.getInt("ACCOUNT_ID"));
                one.setCountryCode(rs.getString("COUNTRY_CODE"));
                one.setTelcoCode(rs.getString("TELCO_CODE"));
                one.setPriceCskh(rs.getString("PRICE_CSKH"));
                one.setPriceQc(rs.getString("PRICE_QC"));
                one.setProviderCode(rs.getString("PROVIDER_CODE"));
                one.setAccUsername(rs.getString("ACC_USERNAME"));
                result.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public static ArrayList<PriceTelcoDb> getAllWithProIdAndCode(String pro_code, int pro_id) {
        ArrayList<PriceTelcoDb> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM price_nation_telco WHERE PROVIDER_CODE = ? AND PROVIDER_ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, pro_code);
            pstm.setInt(2, pro_id);
            rs = pstm.executeQuery();
            while (rs.next()) {
                PriceTelcoDb one = new PriceTelcoDb();
                one.setId(rs.getInt("ID"));
                one.setType(rs.getInt("TYPE"));
                one.setProviderId(rs.getInt("PROVIDER_ID"));
                one.setAccountId(rs.getInt("ACCOUNT_ID"));
                one.setCountryCode(rs.getString("COUNTRY_CODE"));
                one.setTelcoCode(rs.getString("TELCO_CODE"));
                one.setPriceCskh(rs.getString("PRICE_CSKH"));
                one.setPriceQc(rs.getString("PRICE_QC"));
                one.setProviderCode(rs.getString("PROVIDER_CODE"));
                one.setAccUsername(rs.getString("ACC_USERNAME"));
                result.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public static ArrayList<PriceTelcoDb> getAllWithAccIdAndUserForCskh(String acc_user, int acc_id) {
        ArrayList<PriceTelcoDb> result = new ArrayList<>();
        ArrayList<PriceTelcoDb> arrayList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM price_nation_telco WHERE ACC_USERNAME = ? AND ACCOUNT_ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, acc_user);
            pstm.setInt(2, acc_id);
            rs = pstm.executeQuery();
            while (rs.next()) {
                PriceTelcoDb one = new PriceTelcoDb();
                one.setId(rs.getInt("ID"));
                one.setType(rs.getInt("TYPE"));
                one.setProviderId(rs.getInt("PROVIDER_ID"));
                one.setAccountId(rs.getInt("ACCOUNT_ID"));
                one.setCountryCode(rs.getString("COUNTRY_CODE"));
                one.setTelcoCode(rs.getString("TELCO_CODE"));
                one.setPriceCskh(rs.getString("PRICE_CSKH"));
                one.setPriceQc(rs.getString("PRICE_QC"));
                one.setProviderCode(rs.getString("PROVIDER_CODE"));
                one.setAccUsername(rs.getString("ACC_USERNAME"));
                result.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        result.stream().filter((priceTelcoDb) -> (priceTelcoDb.getPriceCskh() != null)).filter((priceTelcoDb) -> (!priceTelcoDb.getPriceCskh().equals(""))).forEachOrdered((priceTelcoDb) -> {
            arrayList.add(priceTelcoDb);
        });
        return arrayList;
    }
    
    public static ArrayList<PriceTelcoDb> getAllWithAccIdAndUserForQc(String acc_user, int acc_id) {
        
        ArrayList<PriceTelcoDb> result = new ArrayList<>();
        ArrayList<PriceTelcoDb> arrayList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM price_nation_telco WHERE ACC_USERNAME = ? AND ACCOUNT_ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, acc_user);
            pstm.setInt(2, acc_id);
            rs = pstm.executeQuery();
            while (rs.next()) {
                PriceTelcoDb one = new PriceTelcoDb();
                one.setId(rs.getInt("ID"));
                one.setType(rs.getInt("TYPE"));
                one.setProviderId(rs.getInt("PROVIDER_ID"));
                one.setAccountId(rs.getInt("ACCOUNT_ID"));
                one.setCountryCode(rs.getString("COUNTRY_CODE"));
                one.setTelcoCode(rs.getString("TELCO_CODE"));
                one.setPriceCskh(rs.getString("PRICE_CSKH"));
                one.setPriceQc(rs.getString("PRICE_QC"));
                one.setProviderCode(rs.getString("PROVIDER_CODE"));
                one.setAccUsername(rs.getString("ACC_USERNAME"));
                result.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        result.stream().filter((priceTelcoDb) -> (priceTelcoDb.getPriceQc() != null)).filter((priceTelcoDb) -> (!priceTelcoDb.getPriceQc().equals(""))).forEachOrdered((priceTelcoDb) -> {
            arrayList.add(priceTelcoDb);
        });
        return arrayList;
    }
    
    public static PriceTelcoDb getbyId(int id) {
        PriceTelcoDb result = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM price_nation_telco WHERE ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = new PriceTelcoDb();
                result.setId(rs.getInt("ID"));
                result.setType(rs.getInt("TYPE"));
                result.setProviderId(rs.getInt("PROVIDER_ID"));
                result.setAccountId(rs.getInt("ACCOUNT_ID"));
                result.setCountryCode(rs.getString("COUNTRY_CODE"));
                result.setTelcoCode(rs.getString("TELCO_CODE"));
                result.setPriceCskh(rs.getString("PRICE_CSKH"));
                result.setPriceQc(rs.getString("PRICE_QC"));
                result.setProviderCode(rs.getString("PROVIDER_CODE"));
                result.setAccUsername(rs.getString("ACC_USERNAME"));
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }    
    
    public static PriceTelcoDb getbyTelcoAccIdAndUser(String telco, String acc_user, int acc_id) {
        PriceTelcoDb result = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM price_nation_telco WHERE TELCO_CODE = ? AND ACC_USERNAME = ? AND ACCOUNT_ID = ? ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, telco);
            pstm.setString(2, acc_user);
            pstm.setInt(3, acc_id);
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = new PriceTelcoDb();
                result.setId(rs.getInt("ID"));
                result.setType(rs.getInt("TYPE"));
                result.setProviderId(rs.getInt("PROVIDER_ID"));
                result.setAccountId(rs.getInt("ACCOUNT_ID"));
                result.setCountryCode(rs.getString("COUNTRY_CODE"));
                result.setTelcoCode(rs.getString("TELCO_CODE"));
                result.setPriceCskh(rs.getString("PRICE_CSKH"));
                result.setPriceQc(rs.getString("PRICE_QC"));
                result.setProviderCode(rs.getString("PROVIDER_CODE"));
                result.setAccUsername(rs.getString("ACC_USERNAME"));
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }  
    
    public static PriceTelcoDb getbyTelcoProIdAndCode(String telco, String pro_code, int pro_id) {
        PriceTelcoDb result = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM price_nation_telco WHERE TELCO_CODE = ? AND PROVIDER_CODE = ? AND PROVIDER_ID = ? ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, telco);
            pstm.setString(2, pro_code);
            pstm.setInt(3, pro_id);
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = new PriceTelcoDb();
                result.setId(rs.getInt("ID"));
                result.setType(rs.getInt("TYPE"));
                result.setProviderId(rs.getInt("PROVIDER_ID"));
                result.setAccountId(rs.getInt("ACCOUNT_ID"));
                result.setCountryCode(rs.getString("COUNTRY_CODE"));
                result.setTelcoCode(rs.getString("TELCO_CODE"));
                result.setPriceCskh(rs.getString("PRICE_CSKH"));
                result.setPriceQc(rs.getString("PRICE_QC"));
                result.setProviderCode(rs.getString("PROVIDER_CODE"));
                result.setAccUsername(rs.getString("ACC_USERNAME"));
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }  
    
    public static boolean checkExistForAcc(String telco, String acc_user, int acc_id) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM price_nation_telco WHERE TELCO_CODE = ? AND ACC_USERNAME = ? AND ACCOUNT_ID = ? ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, telco);
            pstm.setString(2, acc_user);
            pstm.setInt(3, acc_id);
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = true;
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
        String sql = "DELETE FROM price_nation_telco WHERE ID = ?";
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
    
    
    public boolean addPriceTelco(PriceTelcoDb one) {
        String countrycode = Telco_Nations.getCountryCodeByTelcoCode(one.getTelcoCode());
        one.setCountryCode(countrycode);
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "INSERT INTO price_nation_telco(COUNTRY_CODE, TELCO_CODE, PRICE_CSKH, PRICE_QC, TYPE, PROVIDER_ID, ACCOUNT_ID, PROVIDER_CODE, ACC_USERNAME) "
                   + "            VALUES            (           ?,          ?,          ?,        ?,    ?,           ?,          ?,             ?,            ?) ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, one.getCountryCode());
            pstm.setString(i++, one.getTelcoCode());
            pstm.setString(i++, one.getPriceCskh());
            pstm.setString(i++, one.getPriceQc());
            pstm.setInt(i++, one.getType());
            pstm.setInt(i++, one.getProviderId());
            pstm.setInt(i++, one.getAccountId());
            pstm.setString(i++, one.getProviderCode());
            pstm.setString(i++, one.getAccUsername());
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
    
    public boolean updatePriceTelco(PriceTelcoDb one) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "UPDATE price_nation_telco SET "
                + " COUNTRY_CODE = ?, TELCO_CODE = ?, PRICE_CSKH = ?, "
                + " PRICE_QC = ?, TYPE = ?, PROVIDER_ID = ?, ACCOUNT_ID = ?, "
                + " PROVIDER_CODE = ?, ACC_USERNAME = ? "
                + " WHERE ID = ? ";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, one.getCountryCode());
            pstm.setString(i++, one.getTelcoCode());
            pstm.setString(i++, one.getPriceCskh());
            pstm.setString(i++, one.getPriceQc());
            pstm.setInt(i++, one.getType());
            pstm.setInt(i++, one.getProviderId());
            pstm.setInt(i++, one.getAccountId());
            pstm.setString(i++, one.getProviderCode());
            pstm.setString(i++, one.getAccUsername());
            
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

    @Override
    public String toString() {
        return "PriceTelco{" + "id=" + id + ", type=" + type + ", providerId=" + providerId + ", accountId=" + accountId + ", countryCode=" + countryCode + ", telcoCode=" + telcoCode + ", priceCskh=" + priceCskh + ", priceQc=" + priceQc + ", providerCode=" + providerCode + ", accUsername=" + accUsername + '}';
    }
    
    private int id;
    private int type;
    private int providerId;
    private int accountId;
    private String countryCode;
    private String telcoCode;
    private String priceCskh;
    private String priceQc;
    private String providerCode;
    private String accUsername;

    public static ArrayList<PriceTelcoDb> getCACHE() {
        return CACHE;
    }

    public static void setCACHE(ArrayList<PriceTelcoDb> CACHE) {
        PriceTelcoDb.CACHE = CACHE;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getProviderId() {
        return providerId;
    }

    public void setProviderId(int providerId) {
        this.providerId = providerId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
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

    public String getPriceCskh() {
        if (priceCskh == null) {
            priceCskh = "";
        }
        return priceCskh;
    }

    public void setPriceCskh(String priceCskh) {
        if (priceCskh == null) {
            priceCskh = "";
        }
        this.priceCskh = priceCskh;
    }

    public String getPriceQc() {
        if (priceQc == null) {
            priceQc = "";
        }
        return priceQc;
    }

    public void setPriceQc(String priceQc) {
        if (priceQc == null) {
            priceQc = "";
        }
        this.priceQc = priceQc;
    }

    public String getProviderCode() {
        return providerCode;
    }

    public void setProviderCode(String providerCode) {
        this.providerCode = providerCode;
    }

    public String getAccUsername() {
        return accUsername;
    }

    public void setAccUsername(String accUsername) {
        this.accUsername = accUsername;
    }
    
}
