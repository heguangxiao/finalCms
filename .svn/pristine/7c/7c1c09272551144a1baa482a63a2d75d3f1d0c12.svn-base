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
import java.sql.Timestamp;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;

/**
 *
 * @author tuanp
 */
public class UserAction {

    static final Logger logger = Logger.getLogger(UserAction.class);

    public UserAction() {
    }

    public UserAction(String user, String table, String type, String result, String info) {
        this.userName = user;
        this.tableAction = table;
        this.actionType = type;
        this.result = result;
        this.info = info;
    }

    public void logAction(HttpServletRequest request) {
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "INSERT INTO user_action(USER_NAME,USER_IP,URL_ACTION,TABLE_ACTION,ACTION_TYPE,ACTION_DATE,RESULT,INFO)"
                + "                    VALUES(   ?     ,   ?   ,    ?     ,     ?      ,     ?     ,   NOW()   ,  ?   ,  ? )";
        try {
            String url = Tool.getFullURL(request);
            String ipHere = Tool.getClientIpAddr(request);
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setString(i++, userName);
            pstm.setString(i++, ipHere);
            pstm.setString(i++, url);
            pstm.setString(i++, tableAction);
            pstm.setString(i++, actionType);
            pstm.setString(i++, result);
            pstm.setString(i++, info);
            pstm.execute();
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
    }
    
    public static ArrayList<UserAction> findAll() {
        ArrayList<UserAction> array = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "select * from user_action where 1=1";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                UserAction one = new UserAction();
                
                one.setId(rs.getInt("ID"));
                one.setUserName(rs.getString("USER_NAME"));
                one.setIp(rs.getString("USER_IP"));
                one.setUrlAction(rs.getString("URL_ACTION"));
                one.setTableAction(rs.getString("TABLE_ACTION"));
                one.setActionType(rs.getString("ACTION_TYPE"));
                one.setResult(rs.getString("RESULT"));
                one.setInfo(rs.getString("INFO"));
                one.setActionDate(rs.getTimestamp("ACTION_DATE"));
                
                array.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return array;
    }
    
    public static UserAction findById(int id) {
        UserAction one = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "select * from user_action where 1=1 and ID = ?";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            pstm.setInt(i++, id);
            rs = pstm.executeQuery();
            while (rs.next()) {
                one = new UserAction();
                
                one.setId(rs.getInt("ID"));
                one.setUserName(rs.getString("USER_NAME"));
                one.setIp(rs.getString("USER_IP"));
                one.setUrlAction(rs.getString("URL_ACTION"));
                one.setTableAction(rs.getString("TABLE_ACTION"));
                one.setActionType(rs.getString("ACTION_TYPE"));
                one.setResult(rs.getString("RESULT"));
                one.setInfo(rs.getString("INFO"));
                one.setActionDate(rs.getTimestamp("ACTION_DATE"));                
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return one;
    }
    
    public static ArrayList<String> getUsernames(){
        ArrayList<String> arrayList = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "select DISTINCT USER_NAME from user_action where 1=1";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                arrayList.add(rs.getString("USER_NAME"));
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return arrayList;
    }
    
    public static ArrayList<String> getTables(){
        ArrayList<String> arrayList = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "select DISTINCT TABLE_ACTION from user_action where 1=1";
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                arrayList.add(rs.getString("TABLE_ACTION"));
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return arrayList;
    }
    
    public static ArrayList<UserAction> getAll(int page, int row, String username, String table, String type, String result, String stRequest, String endRequest) {
        ArrayList<UserAction> all = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM user_action WHERE 1=1 ";
        
        if (!Tool.checkNull(username)) {
            sql += " AND USER_NAME = ? ";
        }
        
        if (!Tool.checkNull(table)) {
            sql += " AND TABLE_ACTION = ?";
        }
        
        if (!Tool.checkNull(type)) {
            sql += " AND ACTION_TYPE = ?";
        }
        
        if (!Tool.checkNull(result)) {
            sql += " AND RESULT = ?";
        }
        
        if (!Tool.checkNull(stRequest)) {
            sql += " AND DATEDIFF(ACTION_DATE,STR_TO_DATE(?, '%d/%m/%Y')) >=0";
        }
        
        if (!Tool.checkNull(endRequest)) {
            sql += " AND DATEDIFF(ACTION_DATE,STR_TO_DATE(?, '%d/%m/%Y')) <=0";
        }
        
        sql += " ORDER BY ID DESC LIMIT ?,?";
        Tool.debug(sql);
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            if (!Tool.checkNull(username)) {
                pstm.setString(i++, username);
            }
            if (!Tool.checkNull(table)) {
                pstm.setString(i++, table);
            }
            if (!Tool.checkNull(type)) {
                pstm.setString(i++, type);
            }
            if (!Tool.checkNull(result)) {
                pstm.setString(i++, result);
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
                UserAction one = new UserAction();
                
                one.setId(rs.getInt("ID"));
                one.setUserName(rs.getString("USER_NAME"));
                one.setIp(rs.getString("USER_IP"));
                one.setUrlAction(rs.getString("URL_ACTION"));
                one.setTableAction(rs.getString("TABLE_ACTION"));
                one.setActionType(rs.getString("ACTION_TYPE"));
                one.setResult(rs.getString("RESULT"));
                one.setInfo(rs.getString("INFO"));
                one.setActionDate(rs.getTimestamp("ACTION_DATE"));
                
                all.add(one);          
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        
        return all;
    }
    
    public static int countAll(String username, String table, String type, String result, String stRequest, String endRequest) {
        int num = 0;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = "SELECT count(*) FROM user_action WHERE 1=1 ";
        
        if (!Tool.checkNull(username)) {
            sql += " AND USER_NAME = ? ";
        }
        
        if (!Tool.checkNull(table)) {
            sql += " AND TABLE_ACTION = ?";
        }
        
        if (!Tool.checkNull(type)) {
            sql += " AND ACTION_TYPE = ?";
        }
        
        if (!Tool.checkNull(result)) {
            sql += " AND RESULT = ?";
        }
        
        if (!Tool.checkNull(stRequest)) {
            sql += " AND DATEDIFF(ACTION_DATE,STR_TO_DATE(?, '%d/%m/%Y')) >=0";
        }
        
        if (!Tool.checkNull(endRequest)) {
            sql += " AND DATEDIFF(ACTION_DATE,STR_TO_DATE(?, '%d/%m/%Y')) <=0";
        }
        
        try {
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            if (!Tool.checkNull(username)) {
                pstm.setString(i++, username);
            }
            if (!Tool.checkNull(table)) {
                pstm.setString(i++, table);
            }
            if (!Tool.checkNull(type)) {
                pstm.setString(i++, type);
            }
            if (!Tool.checkNull(result)) {
                pstm.setString(i++, result);
            }
            if (!Tool.checkNull(stRequest)) {
                pstm.setString(i++, stRequest);
            }
            if (!Tool.checkNull(endRequest)) {
                pstm.setString(i++, endRequest);
            }

            rs = pstm.executeQuery();
            if (rs.next()) {
                num = rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        
        return num;
    }

    public enum TABLE {
        accounts("accounts"),
        brand_label("brand_label"),
        brand_label_declare("brand_label_declare"),
        campaign("campaign"),
        client("client"),
        config_db("config_db"),
        group_acc_detail("group_acc_detail"),
        group_account("group_account"),
        group_customer("group_customer"),
        group_permission("group_permission"),
        ip_declare("ip_declare"),
        ip_manager("ip_manager"),
        list_customer("list_customer"),
        modules("modules"),
        monitor_app("monitor_app"),
        msg_brand_customer("msg_brand_customer"),
        partner_manager("partner_manager"),
        provider("provider"),
        user_permission("user_permission"), //--
        phone_blacklist("phoneblacklist"), //--
        ;

        public String val;

        private TABLE(String val) {
            this.val = val;
        }
    }

    public enum TYPE {
        ADD("ADD"),
        EDIT("EDIT"),
        DEL("DEL"),
        LOGIN("LOGIN"),
        EXPORT("EXPORT"),
        UPLOAD("UPLOAD"),
        VIEW("VIEW"),//--
        ;

        public String val;

        private TYPE(String val) {
            this.val = val;
        }
    }

    public enum RESULT {
        SUCCESS("SUCCESS"),
        FAIL("FAIL"),
        EXCEPTION("EXCEPTION"),
        REJECT("REJECT"),;

        public String val;

        private RESULT(String val) {
            this.val = val;
        }
    }

    int id;
    String userName;
    String ip;
    String urlAction;
    String tableAction;
    String actionType;
    Timestamp actionDate;
    String result;
    String info;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getUrlAction() {
        return urlAction;
    }

    public void setUrlAction(String urlAction) {
        this.urlAction = urlAction;
    }

    public String getTableAction() {
        return tableAction;
    }

    public void setTableAction(String tableAction) {
        this.tableAction = tableAction;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public Timestamp getActionDate() {
        return actionDate;
    }

    public void setActionDate(Timestamp actionDate) {
        this.actionDate = actionDate;
    }

}
