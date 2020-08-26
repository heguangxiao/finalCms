/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gk.myname.vn.entity;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import gk.myname.vn.utils.Tool;
import java.io.IOException;
import org.apache.log4j.Logger;

/**
 *
 * @author @author LienHoa(CongNX)
 */
public class CustodyMessage {
    static final Logger logger = Logger.getLogger(CustodyMessage.class);
    static final ObjectMapper mapper = new ObjectMapper();
    
    public static String INFO_ACTION = "INFO";
    public static String RELOAD_ACTION = "RELOAD";
    public static String TOPUP_ACTION = "TOPUP";
    public static String TOPDOWN_ACTION = "TOPDOWN";
    public static String CUSTODY_ACTION = "CUSTODY";
    public static String CANCLECAMP_ACTION = "CANCLECAMP";  
    
    public static String INFO_KEY = "20c728b3375bae2022bc6a3e19463bde";
    public static String RELOAD_KEY = "cd024c5b56744bf9f0899a5045dc8096";
    public static String TOPUP_KEY = "3d2e0ad52f9f86b13718dc5634dc7806";
    public static String TOPDOWN_KEY = "779dfcbea11e8d9c603b0a907fef2bc6";
    public static String CUSTODY_KEY = "779dfcbea11e8d9c603b0a907fef2bc6";
    public static String CANCLECAMP_KEY = "779dfcbea11e8d9c603b0a907fef2bc6";      
    
    //Thong so chung
    private String userapi;
    private String keyapi;
    private String command;
    
    //Thong so rieng
    private String username;
    private String brandname;
    private String telcosms;//Danh sach mang va so luong tin nhan cua mang do VTE:11;VMS:98;VNP:65
    private String messageid;//Campagin id
    private String typecharg;//CSKH hay QC
    private int money;
    private String noted;

    public int getMoney() {
        return money;
    }

    public void setMoney(int money) {
        this.money = money;
    }

    public String getNoted() {
        return noted;
    }

    public void setNoted(String noted) {
        this.noted = noted;
    }

    public CustodyMessage() {
    }

    public String getUserapi() {
        return userapi;
    }

    public void setUserapi(String userapi) {
        this.userapi = userapi;
    }

    public String getKeyapi() {
        return keyapi;
    }

    public void setKeyapi(String keyapi) {
        this.keyapi = keyapi;
    }

    public String getCommand() {
        return command;
    }

    public void setCommand(String command) {
        this.command = command;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getBrandname() {
        return brandname;
    }

    public void setBrandname(String brandname) {
        this.brandname = brandname;
    }

    public String getTelcosms() {
        return telcosms;
    }

    public void setTelcosms(String telcosms) {
        this.telcosms = telcosms;
    }

    public String getMessageid() {
        return messageid;
    }

    public void setMessageid(String messageid) {
        this.messageid = messageid;
    }

    public String getTypecharg() {
        return typecharg;
    }

    public void setTypecharg(String typecharg) {
        this.typecharg = typecharg;
    }
    
    public String toJsonStr() {
        try {
            mapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
            String jsonInString = mapper.writeValueAsString(this);
            return jsonInString;
        } catch (JsonProcessingException e) {
            logger.error(Tool.getLogMessage(e));
            return "Error " + this.getClass().getName() + " Json Object:" + e.getMessage();
        }
    }
    
    public static CustodyMessage toObject(String jsonStr) {
        CustodyMessage result = null;
        try {
            mapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
            result = mapper.readValue(jsonStr, CustodyMessage.class);
        } catch (IOException e) {
            logger.error(Tool.getLogMessage(e));
        }
        return result;
    }
}