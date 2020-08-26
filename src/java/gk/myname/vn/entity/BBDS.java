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
 * @author nguoi
 */
public class BBDS {
    static final Logger logger = Logger.getLogger(BBDS.class);

    private int total;
    private String telco;
    private int result;
    private int type;
    private String group;

    public ArrayList<BBDS> bbds(String userSender, String cpCode, int type, String stRequest,
            String endRequest, String oper, int result, String groupBr, int ltypeb) {
        ArrayList<BBDS> all = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        String sql = " SELECT SUM(TOTAL_SMS) AS TOTAL_SMS,OPER,RESULT,BR_GROUP,TYPE  ";
        sql += " FROM MSG_BRAND_SUBMIT " + buidPartition(stRequest) + " A WHERE 1=1 AND RESULT = 1 ";
        
        if (!Tool.checkNull(userSender)) {
            sql += " AND USER_SENDER = ?";
        }
        if (!Tool.checkNull(cpCode)) {
            sql += " AND (CP_CODE = ? OR CP_CODE Like ?)";
        }
        if (!Tool.checkNull(stRequest)) {
            sql += " AND DATEDIFF(REQUEST_TIME,STR_TO_DATE(?, '%d/%m/%Y %H:%i:%s') ) >=0";
        }
        if (!Tool.checkNull(endRequest)) {
            sql += " AND DATEDIFF(REQUEST_TIME,STR_TO_DATE(?, '%d/%m/%Y %H:%i:%s')) <=0";
        }
        if (ltypeb == 1) {
            sql += " AND LONGCODE = 1";
        } else {
            sql += " AND (ISNULL(LONGCODE) OR LONGCODE = 0)";
        }
        sql += " GROUP BY OPER,BR_GROUP,RESULT";
        
        try {            
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (!Tool.checkNull(userSender)) {
                pstm.setString(i++, userSender);
            }
            if (!Tool.checkNull(cpCode)) {
                pstm.setString(i++, cpCode);
                pstm.setString(i++, cpCode + "_%");
            }
            if (!Tool.checkNull(stRequest)) {
                pstm.setString(i++, stRequest + " 00:00:00");
            }
            if (!Tool.checkNull(endRequest)) {
                pstm.setString(i++, endRequest + " 23:59:59");
            }
            rs = pstm.executeQuery();
            while (rs.next()) {
                BBDS one = new BBDS();
                one.setTelco(rs.getString("OPER"));
                one.setTotal(rs.getInt("TOTAL_SMS"));
                one.setResult(rs.getInt("RESULT"));
                one.setType(rs.getInt("TYPE"));
                one.setGroup(rs.getString("BR_GROUP"));
                
                all.add(one);
            }
        } catch (SQLException e) {
            logger.error(Tool.getLogMessage(e));
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return all;
    }

    private static String buidPartition(String date) {
        String result = "";
        if (!Tool.checkNull(date)) {
            try {
                String[] arr = date.split("/");
                if (arr.length == 3) {
                    if (arr[2].length() == 4) {
                        arr[2] = arr[2].substring(2);
                    }
                    result = "PARTITION(P_" + arr[1] + "_" + arr[2] + ")";
                }
            } catch (Exception e) {
                logger.error(Tool.getLogMessage(e));
            }
        }
        return result;
    }

    public String getYear(String date) {
        String result = "";
        if (!Tool.checkNull(date)) {
            try {
                String[] arr = date.split("/");
                if (arr.length == 3) {
                    if (arr[2].length() == 4) {
                        result = arr[2];
                    }
                }
            } catch (Exception e) {
                logger.error(Tool.getLogMessage(e));
            }
        }
        return result;
    }

    public String getMonth(String date) {
        String result = "";
        if (!Tool.checkNull(date)) {
            try {
                String[] arr = date.split("/");
                if (arr.length == 3) {
                    if (arr[1].length() == 2) {
                        result = arr[1];
                    }
                }
            } catch (Exception e) {
                logger.error(Tool.getLogMessage(e));
            }
        }
        return result;
    }

    public BBDS() {
    }

    public BBDS(int total, String telco, int result, int type, String group, int year, int month) {
        this.total = total;
        this.telco = telco;
        this.result = result;
        this.type = type;
        this.group = group;
    }

    @Override
    public String toString() {
        return "BBDS{" + "total=" + total + ", telco=" + telco + ", result=" + result + ", type=" + type + ", group=" + group + '}';
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public String getTelco() {
        return telco;
    }

    public void setTelco(String telco) {
        this.telco = telco;
    }

    public int getResult() {
        return result;
    }

    public void setResult(int result) {
        this.result = result;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

}