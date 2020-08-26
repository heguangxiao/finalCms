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

public class UniLabel {
    static final Logger logger = Logger.getLogger(UniLabel.class);
    static final ObjectMapper mapper = new ObjectMapper();
    
    String operCode;
    String routeUni;
    String group;
    String label;
    String ckLabel;
    
    public UniLabel(){
        this.operCode = "OTHER";
        this.routeUni = "0";
        this.group = "0";
        this.label = "0";
        this.ckLabel = "0";
    }
        
    public static UniLabel json2Objec(String str) {
        UniLabel result = null;
        try {
            mapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
            result = mapper.readValue(str, UniLabel.class);
            if (result == null) {
                result = new UniLabel();
            }
        } catch (IOException e) {
            result = new UniLabel();
            logger.error(Tool.getLogMessage(e));
        }
        return result;
    }
    
    public String toJson() {
        try {
            mapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
            String jsonInString = mapper.writeValueAsString(this);
            return jsonInString;
        } catch (JsonProcessingException e) {
            logger.error(Tool.getLogMessage(e));
            return "Error RequestMessage Json Objec:" + e.getMessage();
        }
    }

    @Override
    public String toString() {
        return "UniLabel{" + "operCode=" + operCode + ", routeUni=" + routeUni + ", group=" + group + ", label=" + label + ", ckLabel=" + ckLabel + '}';
    }

    public String getOperCode() {
        return operCode;
    }

    public void setOperCode(String operCode) {
        this.operCode = operCode;
    }

    public String getCkLabel() {
        return ckLabel;
    }

    public void setCkLabel(String ckLabel) {
        this.ckLabel = ckLabel;
    }

    public String getRouteUni() {
        return routeUni;
    }

    public void setRouteUni(String routeUni) {
        this.routeUni = routeUni;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }
}
