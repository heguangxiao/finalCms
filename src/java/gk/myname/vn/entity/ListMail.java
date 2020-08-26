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
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author HTC-PC
 */
public class ListMail {
    private int id;
    private String name;
    private String des;
    private String createdAt;
    private String createdBy;
    private String updatedAt;
    private String updatedBy;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDes() {
        return des;
    }
  
    public String getDesIndex() {
        return des.replace(",", "<br/>");
    }
    
    public String getDesEdit(HttpServletRequest request) {
        
        String desEdit = "";
        String emailDel = "";
        
        char[] ch = des.toCharArray();
        
        for (int i = 0; i < ch.length; i++) {
            if ((ch[i]+"").equals(",")) {
                desEdit+= "<a title='Xóa' class='ask' href='"+
                request.getContextPath()+
                "/admin/listEmail/delMail.jsp?id="+
                this.id+
                "&email="+
                emailDel+
                "'>"+
                "<img width='10' src='"+
                request.getContextPath() +
                "/admin/resource/images/remove.png' alt='' title='Xóa' border='0' />"+
                "</a><br/>";
                emailDel = "";
            } else {
                desEdit+= ch[i];
                emailDel+= ch[i];
            }
        }
        
        return desEdit;
    }

    public void setDes(String des) {
        this.des = des;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(String updatedBy) {
        this.updatedBy = updatedBy;
    }
    
    public static ArrayList<ListMail> getAll() {
        ArrayList<ListMail> list = new ArrayList();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from list_mail where 1 = 1 order by id desc";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            rs = pstm.executeQuery();
            while (rs.next()) {
                ListMail listMail = new ListMail();
                listMail.setId(rs.getInt("ID"));
                listMail.setName(rs.getString("NAME"));
                listMail.setDes(rs.getString("DES"));
                listMail.setCreatedBy(rs.getString("CREATEDBY"));
                listMail.setCreatedAt(rs.getString("CREATEDAT"));
                listMail.setUpdatedBy(rs.getString("UPDATEDBY"));
                listMail.setUpdatedAt(rs.getString("UPDATEDAT"));
                list.add(listMail);
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return list;
    }
    
    public static ListMail findById(int id) {
        ListMail listMail = null;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from list_mail where 1 = 1 and ID = ?";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();
            if (rs.next()) {
                listMail = new ListMail();
                listMail.setId(rs.getInt("ID"));
                listMail.setName(rs.getString("NAME"));
                listMail.setDes(rs.getString("DES"));
                listMail.setCreatedBy(rs.getString("CREATEDBY"));
                listMail.setCreatedAt(rs.getString("CREATEDAT"));
                listMail.setUpdatedBy(rs.getString("UPDATEDBY"));
                listMail.setUpdatedAt(rs.getString("UPDATEDAT"));
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return listMail;
    }
    
    public static boolean existsByName(String name) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from list_mail L where 1 = 1 and L.name = ?";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, name);
            rs = pstm.executeQuery();
            if (rs.next()) {
                result = true;
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
    
    public static boolean create(ListMail listMail){
        boolean result = false;
        
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = " INSERT INTO list_mail(NAME, DES, CREATEDBY, CREATEDAT, UPDATEDBY, UPDATEDAT) VALUES(?, ?, ?, ?, ?, ?) ";
            
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            System.out.println(sql);
            pstm.setString(i++, listMail.getName());
            System.out.println(listMail.getName());
            pstm.setString(i++, listMail.getDes());
            System.out.println(listMail.getDes());
            pstm.setString(i++, listMail.getCreatedBy());
            System.out.println(listMail.getCreatedBy());
            pstm.setString(i++, java.time.LocalDate.now()+"");
            System.out.println(java.time.LocalDate.now()+"");
            pstm.setString(i++, listMail.getUpdatedBy());
            System.out.println(listMail.getUpdatedBy());
            pstm.setString(i++, java.time.LocalDate.now()+"");
            System.out.println(java.time.LocalDate.now()+"");
            
            result = pstm.executeUpdate() == 1;
            
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBPool.freeConn(pstm, conn);
        }
        return result;
    }
    
    public static boolean update(ListMail listMail) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstm = null;
        try {
            String sql = " UPDATE list_mail SET NAME = ? , DES = ? , UPDATEDBY = ? , UPDATEDAT = ? "
                       + " WHERE ID = ? ";
            
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            
            pstm.setString(i++, listMail.getName());
            pstm.setString(i++, listMail.getDes());
            pstm.setString(i++, listMail.getUpdatedBy());
            pstm.setString(i++, java.time.LocalDate.now()+"");
            
            pstm.setInt(i++, listMail.getId());
            
            result = pstm.executeUpdate() == 1;
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBPool.freeConn(pstm, conn);
        }
        return result;
    }
    
    public static boolean delete(int id) {
        boolean result = false;
        String sql = "DELETE FROM list_mail WHERE ID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBPool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            int tm = pstmt.executeUpdate();
            while (tm == 1) {
                result = true;
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBPool.freeConn(pstmt, conn);
        }
        return result;
    }
    
    public static ArrayList<ListMail> findAll(int max, int page, String name) {
        ArrayList<ListMail> list = new ArrayList();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select * from list_mail where 1 = 1 ";
            if (!Tool.checkNull(name)) {
                sql += " AND (NAME LIKE ? OR DES LIKE ?)";
            }             
            sql += " ORDER BY ID DESC LIMIT ?,?";
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (!Tool.checkNull(name)) {
                pstm.setString(i++, "%" + name + "%");
                pstm.setString(i++, "%" + name + "%");
            }
            pstm.setInt(i++, (page - 1) * max);
            pstm.setInt(i++, max);
            rs = pstm.executeQuery();
            while (rs.next()) {
                ListMail listMail = new ListMail();
                listMail.setId(rs.getInt("ID"));
                listMail.setName(rs.getString("NAME"));
                listMail.setDes(rs.getString("DES"));
                listMail.setCreatedBy(rs.getString("CREATEDBY"));
                listMail.setCreatedAt(rs.getString("CREATEDAT"));
                listMail.setUpdatedBy(rs.getString("UPDATEDBY"));
                listMail.setUpdatedAt(rs.getString("UPDATEDAT"));
                list.add(listMail);
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return list;
    }
    
    public static int count(String name) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        try {
            String sql = "select count(*) from list_mail where 1 = 1 ";
            if (!Tool.checkNull(name)) {
                sql += " AND (NAME LIKE ? OR DES LIKE ?)";
            }
            conn = DBPool.getConnection();
            pstm = conn.prepareStatement(sql);
            int i = 1;
            if (!Tool.checkNull(name)) {
                pstm.setString(i++, "%" + name + "%");
                pstm.setString(i++, "%" + name + "%");
            }
            rs = pstm.executeQuery();
            while (rs.next()) {
                result = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        } finally {
            DBPool.freeConn(rs, pstm, conn);
        }
        return result;
    }
}
