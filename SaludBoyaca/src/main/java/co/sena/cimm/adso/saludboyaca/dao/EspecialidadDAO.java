package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.model.Especialidad;
import co.sena.cimm.adso.saludboyaca.util.Conexion;

public class EspecialidadDAO {
    
    public boolean insertar(Especialidad e) {
        String sql = "INSERT INTO especialidades (nombre, descripcion) VALUES (?,?)";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getNombre());
            ps.setString(2, e.getDescripcion());
            if (ps.executeUpdate() > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) e.setId(rs.getInt(1));
                return true;
            }
        } catch (SQLException ex) {
            System.err.println("Error insertar especialidad: " + ex.getMessage());
        }
        return false;
    }
    
    public boolean actualizar(Especialidad e) {
        String sql = "UPDATE especialidades SET nombre=?, descripcion=? WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getNombre());
            ps.setString(2, e.getDescripcion());
            ps.setInt(3, e.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.err.println("Error actualizar especialidad: " + ex.getMessage());
        }
        return false;
    }
    
    public boolean eliminar(int id) {
        String sql = "DELETE FROM especialidades WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminar especialidad: " + e.getMessage());
        }
        return false;
    }
    
    public Especialidad buscarPorId(int id) {
        String sql = "SELECT * FROM especialidades WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) {
            System.err.println("Error buscar especialidad: " + e.getMessage());
        }
        return null;
    }
    
    public List<Especialidad> listarTodos() {
        List<Especialidad> lista = new ArrayList<>();
        String sql = "SELECT * FROM especialidades ORDER BY nombre";
        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            System.err.println("Error listar especialidades: " + e.getMessage());
        }
        return lista;
    }
    
    private Especialidad mapear(ResultSet rs) throws SQLException {
        Especialidad e = new Especialidad();
        e.setId(rs.getInt("id"));
        e.setNombre(rs.getString("nombre"));
        e.setDescripcion(rs.getString("descripcion"));
        return e;
    }
}
