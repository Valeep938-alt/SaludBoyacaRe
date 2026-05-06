package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.model.LogAcceso;
import co.sena.cimm.adso.saludboyaca.util.Conexion;

public class LogAccesoDAO {
    
    public boolean insertar(LogAcceso log) {
        String sql = "INSERT INTO log_accesos (id_usuario, username, accion, ip, resultado) VALUES (?,?,?,?,?)";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setObject(1, log.getIdUsuario(), Types.INTEGER);
            ps.setString(2, log.getUsername());
            ps.setString(3, log.getAccion());
            ps.setString(4, log.getIp());
            ps.setString(5, log.getResultado());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error insertar log: " + e.getMessage());
        }
        return false;
    }
    
    public List<LogAcceso> listarTodos() {
        List<LogAcceso> lista = new ArrayList<>();
        String sql = "SELECT * FROM log_accesos ORDER BY fecha DESC";
        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            System.err.println("Error listar logs: " + e.getMessage());
        }
        return lista;
    }
    
    public List<LogAcceso> listarPorUsuario(String username) {
        List<LogAcceso> lista = new ArrayList<>();
        String sql = "SELECT * FROM log_accesos WHERE username=? ORDER BY fecha DESC";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            System.err.println("Error listar por usuario: " + e.getMessage());
        }
        return lista;
    }
    
    public List<LogAcceso> listarPorFecha(java.util.Date fecha) {
        List<LogAcceso> lista = new ArrayList<>();
        String sql = "SELECT * FROM log_accesos WHERE fecha::date=? ORDER BY fecha DESC";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(fecha.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            System.err.println("Error listar por fecha: " + e.getMessage());
        }
        return lista;
    }
    
    private LogAcceso mapear(ResultSet rs) throws SQLException {
        LogAcceso log = new LogAcceso();
        log.setId(rs.getInt("id"));
        log.setIdUsuario(rs.getObject("id_usuario") != null ? rs.getInt("id_usuario") : null);
        log.setUsername(rs.getString("username"));
        log.setAccion(rs.getString("accion"));
        log.setIp(rs.getString("ip"));
        log.setResultado(rs.getString("resultado"));
        log.setFecha(rs.getTimestamp("fecha"));
        return log;
    }
}
