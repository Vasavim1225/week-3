package com.chat;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/GetMessagesServlet")
public class GetMessagesServlet extends HttpServlet {

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "").replace("\t", " ");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            res.setStatus(401);
            return;
        }

        String me    = (String) session.getAttribute("username");
        String other = req.getParameter("receiver");

        res.setContentType("application/json;charset=UTF-8");

        if (other == null || other.trim().isEmpty()) {
            res.getWriter().write("[]");
            return;
        }
        other = other.trim();

        String sql = "SELECT su.username AS sender, ru.username AS receiver, " +
                     "m.message, m.message_time " +
                     "FROM messages m " +
                     "JOIN users su ON m.sender_id = su.id " +
                     "JOIN users ru ON m.receiver_id = ru.id " +
                     "WHERE (su.username=? AND ru.username=?) OR (su.username=? AND ru.username=?) " +
                     "ORDER BY m.message_time, m.id";

        try (Connection con = DButil.getConnection()) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, me);
            ps.setString(2, other);
            ps.setString(3, other);
            ps.setString(4, me);

            ResultSet rs = ps.executeQuery();
            StringBuilder sb = new StringBuilder("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) sb.append(",");
                first = false;
                sb.append("{\"sender\":\"").append(esc(rs.getString("sender")))
                  .append("\",\"receiver\":\"").append(esc(rs.getString("receiver")))
                  .append("\",\"message\":\"").append(esc(rs.getString("message")))
                  .append("\",\"time\":\"").append(rs.getTimestamp("message_time"))
                  .append("\"}");
            }
            sb.append("]");
            res.getWriter().write(sb.toString());
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}