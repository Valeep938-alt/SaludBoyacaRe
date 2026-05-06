package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.model.Paciente;
import co.sena.cimm.adso.saludboyaca.util.Conexion;

public class PacienteDAO {

    // INSERTAR
    public boolean insertar(Paciente p) {
        String sql = "INSERT INTO pacientes (nombres, apellidos, documento, fecha_nacimiento, "
                   + "telefono, email, eps, vereda_barrio) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, p.getNombres());
            ps.setString(2, p.getApellidos());
            ps.setString(3, p.getDocumento());
            ps.setDate(4, p.getFechaNacimiento());
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getEmail());
            ps.setString(7, p.getEps());
            ps.setString(8, p.getVeredaBarrio());

            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) p.setId(rs.getInt(1));
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error insertar paciente: " + e.getMessage());
        }
        return false;
    }

    // ACTUALIZAR
    public boolean actualizar(Paciente p) {
        String sql = "UPDATE pacientes SET nombres=?, apellidos=?, documento=?, fecha_nacimiento=?, "
                   + "telefono=?, email=?, eps=?, vereda_barrio=? WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getNombres());
            ps.setString(2, p.getApellidos());
            ps.setString(3, p.getDocumento());
            ps.setDate(4, p.getFechaNacimiento());
            ps.setString(5, p.getTelefono());
            ps.setString(6, p.getEmail());
            ps.setString(7, p.getEps());
            ps.setString(8, p.getVeredaBarrio());
            ps.setInt(9, p.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizar paciente: " + e.getMessage());
        }
        return false;
    }

    // ACTUALIZAR SOLO LA FOTO
    public boolean actualizarFoto(int idPaciente, String fotoUrl) {
        String sql = "UPDATE pacientes SET foto_url=? WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fotoUrl);
            ps.setInt(2, idPaciente);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizarFoto: " + e.getMessage());
        }
        return false;
    }

    // ELIMINAR
    public boolean eliminar(int id) {
        String sql = "DELETE FROM pacientes WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminar paciente: " + e.getMessage());
        }
        return false;
    }

    // BUSCAR POR ID
    public Paciente buscarPorId(int id) {
        String sql = "SELECT * FROM pacientes WHERE id=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) {
            System.err.println("Error buscar paciente: " + e.getMessage());
        }
        return null;
    }

    // BUSCAR POR DOCUMENTO
    public Paciente buscarPorDocumento(String documento) {
        String sql = "SELECT * FROM pacientes WHERE documento=?";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, documento);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapear(rs);
        } catch (SQLException e) {
            System.err.println("Error buscar por documento: " + e.getMessage());
        }
        return null;
    }

    // LISTAR TODOS
    public List<Paciente> listarTodos() {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT * FROM pacientes ORDER BY apellidos, nombres";
        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            System.err.println("Error listar pacientes: " + e.getMessage());
        }
        return lista;
    }

    // BUSCAR POR NOMBRE O DOCUMENTO
    public List<Paciente> buscar(String termino) {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT * FROM pacientes WHERE nombres LIKE ? OR apellidos LIKE ? OR documento LIKE ? ORDER BY apellidos";
        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + termino + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) lista.add(mapear(rs));
        } catch (SQLException e) {
            System.err.println("Error buscar pacientes: " + e.getMessage());
        }
        return lista;
    }

    // CONTAR TOTAL
    public int contar() {
        String sql = "SELECT COUNT(*) FROM pacientes";
        try (Connection conn = Conexion.getConexion();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error contar pacientes: " + e.getMessage());
        }
        return 0;
    }

    // MAPEAR RESULTSET
    private Paciente mapear(ResultSet rs) throws SQLException {
        Paciente p = new Paciente();
        p.setId(rs.getInt("id"));
        p.setNombres(rs.getString("nombres"));
        p.setApellidos(rs.getString("apellidos"));
        p.setDocumento(rs.getString("documento"));
        p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
        p.setTelefono(rs.getString("telefono"));
        p.setEmail(rs.getString("email"));
        p.setEps(rs.getString("eps"));
        p.setVeredaBarrio(rs.getString("vereda_barrio"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setFotoUrl(rs.getString("foto_url")); // ← línea agregada
        return p;
    }
}