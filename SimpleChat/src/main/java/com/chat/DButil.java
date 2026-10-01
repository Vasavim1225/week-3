package com.chat;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DButil {

    private static final String URL =
            "jdbc:mysql://db01.dbhost.dev:5051/db_454v6rz5e"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC";

    private static final String USER = "user_454v6rz5e";
    private static final String PASS = "p454v6rz5e";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found.", e);
        }

        return DriverManager.getConnection(URL, USER, PASS);
    }

    public static Connection getConnection1() throws SQLException {
        return getConnection();
    }

    protected static Connection getConnection11() throws SQLException {
        return getConnection();
    }
}
