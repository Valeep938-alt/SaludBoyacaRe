package co.sena.cimm.adso.saludboyaca.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL      = System.getenv("DB_URL");
    private static final String USER     = System.getenv("DB_USER");
    private static final String PASSWORD = System.getenv("DB_PASSWORD");

    static {
        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("Driver PostgreSQL cargado OK");
        } catch (ClassNotFoundException e) {
            System.err.println("Driver no encontrado: " + e.getMessage());
        }
    }

    // Cada llamada devuelve una conexión NUEVA — el try-with-resources del DAO la cierra sola
    public static Connection getConexion() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.err.println("Error de conexion: " + e.getMessage());
            return null;
        }
    }
}