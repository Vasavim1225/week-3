package com.chat;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/GetUsersServlet")
public class GetUsersServlet extends HttpServlet {

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", " ").replace("\r", "").replace("\t", " ");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            res.setStatus(401);
            return;
        }
        String me = (String) session.getAttribute("username");
        res.setContentType("application/json;charset=UTF-8");

        String pair =
            "JOIN users su ON m.sender_id=su.id JOIN users ru ON m.receiver_id=ru.id " +
            "WHERE (su.username=u.username AND ru.username=?) OR (su.username=? AND ru.username=u.username) " +
            "ORDER BY m.message_time DESC, m.id DESC LIMIT 1";

        String sql = "SELECT u.username, " +
                     "(SELECT m.message FROM messages m " + pair + ") AS last_msg, " +
                     "(SELECT m.message_time FROM messages m " + pair + ") AS last_time " +
                     "FROM users u WHERE u.username<>? " +
                     "ORDER BY last_time IS NULL, last_time DESC, u.username";

        try (Connection con = DButil.getConnection()) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, me);
            ps.setString(2, me);
            ps.setString(3, me);
            ps.setString(4, me);
            ps.setString(5, me);
            ResultSet rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) sb.append(",");
                first = false;
                Timestamp t = rs.getTimestamp("last_time");
                sb.append("{\"username\":\"").append(esc(rs.getString("username")))
                  .append("\",\"last\":\"").append(esc(rs.getString("last_msg")))
                  .append("\",\"time\":\"").append(t == null ? "" : t.toString())
                  .append("\"}");
            }
            sb.append("]");
            res.getWriter().write(sb.toString());
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}