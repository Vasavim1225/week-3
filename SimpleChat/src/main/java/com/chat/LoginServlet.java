package com.chat;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            res.sendRedirect("login.jsp?error=1");
            return;
        }
        username = username.trim();

        try (Connection con = DButil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE username=?");
            ps.setString(1, username);
            if (!ps.executeQuery().next()) {
                PreparedStatement ins = con.prepareStatement("INSERT INTO users(username) VALUES(?)");
                ins.setString(1, username);
                ins.executeUpdate();
            }
            req.getSession().setAttribute("username", username);
            res.sendRedirect("chat.jsp");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession s = req.getSession(false);
        if (s != null) s.invalidate();
        res.sendRedirect("login.jsp");
    }
}