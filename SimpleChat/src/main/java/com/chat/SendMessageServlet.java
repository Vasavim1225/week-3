package com.chat;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/SendMessageServlet")
public class SendMessageServlet extends HttpServlet {

    private int getUserId(Connection con, String username) throws SQLException {
        PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE username=?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        return rs.next() ? rs.getInt(1) : -1;
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            res.setStatus(401);
            return;
        }

        String sender   = (String) session.getAttribute("username");
        String receiver = req.getParameter("receiver");
        String message  = req.getParameter("message");

        if (receiver == null || receiver.trim().isEmpty()
                || message == null || message.trim().isEmpty()) {
            res.setStatus(400);
            return;
        }
        receiver = receiver.trim();

        try (Connection con = DButil.getConnection()) {
            int senderId = getUserId(con, sender);
            int receiverId = getUserId(con, receiver);
            if (senderId == -1 || receiverId == -1) {
                res.setStatus(400);
                res.getWriter().write("Unknown user");
                return;
            }

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO messages(sender_id, receiver_id, message) VALUES(?,?,?)");
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.setString(3, message.trim());
            ps.executeUpdate();
            res.getWriter().write("OK");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}