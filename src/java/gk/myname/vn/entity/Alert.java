/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gk.myname.vn.entity;

public class Alert {

    public static int ERROR = 0;
    public static int SUCCESS = 1;
    public static int WARNING = 2;

    public Alert(int code, String mess) {
        this.code = code;
        this.message = mess;
    }
    int code;
    String message;

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}
