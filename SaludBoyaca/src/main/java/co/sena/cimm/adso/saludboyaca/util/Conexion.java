package co.sena.cimm.adso.saludboyaca.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    static {
        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("Driver PostgreSQL cargado OK");
        } catch (ClassNotFoundException e) {
            System.err.println("Driver no encontrado: " + e.getMessage());
        }
    }

    public static Connection getConexion() {
        // Leer las variables aquí, no como static final
        String url      = System.getenv("DB_URL");
        String user     = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");

        // Para depurar — quítalo después
        System.out.println("DB_URL: " + url);
        System.out.println("DB_USER: " + user);

        try {
            return DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            System.err.println("Error de conexion: " + e.getMessage());
            return null;
        }
    }
}