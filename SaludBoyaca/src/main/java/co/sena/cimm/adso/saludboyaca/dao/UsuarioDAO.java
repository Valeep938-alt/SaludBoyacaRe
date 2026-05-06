package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.model.Usuario;
import co.sena.cimm.adso.saludboyaca.util.Conexion;

public class UsuarioDAO {

    // INSERTAR
    public boolean insertar(Usuario u) {
        String sql = "INSERT INTO usuarios (nombres, apellidos, documento, email, username, "
                + "password, rol, especialidad, lang_preferido, activo) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, u.getNombres());
            ps.setString(2, u.getApellidos());
            ps.setString(3, u.getDocumento());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getUsername());
            ps.setString(6, u.getPassword());
            ps.setString(7, u.getRol());
            ps.setString(8, u.getEspecialidad());
            ps.setString(9, u.getLangPreferido());
            ps.setBoolean(10, u.isActivo());

            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    u.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error insertar usuario: " + e.getMessage());
        }
        return false;
    }

    // ACTUALIZAR
    public boolean actualizar(Usuario u) {
        String sql = "UPDATE usuarios SET nombres=?, apellidos=?, documento=?, email=?, username=?, "
                + "password=?, rol=?, especialidad=?, lang_preferido=?, activo=? WHERE id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getNombres());
            ps.setString(2, u.getApellidos());
            ps.setString(3, u.getDocumento());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getUsername());
            ps.setString(6, u.getPassword());
            ps.setString(7, u.getRol());
            ps.setString(8, u.getEspecialidad());
            ps.setString(9, u.getLangPreferido());
            ps.setBoolean(10, u.isActivo());
            ps.setInt(11, u.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizar usuario: " + e.getMessage());
        }
        return false;
    }

    // ELIMINAR
    public boolean eliminar(int id) {
        String sql = "DELETE FROM usuarios WHERE id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminar usuario: " + e.getMessage());
        }
        return false;
    }

    // BUSCAR POR ID
    public Usuario buscarPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error buscar usuario: " + e.getMessage());
        }
        return null;
    }

    // BUSCAR POR USERNAME (para login)
    public Usuario buscarPorUsername(String username) {
        String sql = "SELECT * FROM usuarios WHERE username=? AND activo=1";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error buscar por username: " + e.getMessage());
        }
        return null;
    }

    // VALIDAR LOGIN
    public Usuario validarLogin(String username, String password) {
        String sql = "SELECT * FROM usuarios WHERE username=? AND password=? AND activo=1";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error validar login: " + e.getMessage());
        }
        return null;
    }

    // LISTAR TODOS
    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY rol, apellidos";
        try (Connection conn = Conexion.getConexion(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar usuarios: " + e.getMessage());
        }
        return lista;
    }

    // LISTAR POR ROL
    public List<Usuario> listarPorRol(String rol) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios WHERE rol=? ORDER BY apellidos";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rol);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar por rol: " + e.getMessage());
        }
        return lista;
    }

    // LISTAR MÉDICOS
    public List<Usuario> listarMedicos() {
        return listarPorRol("MEDICO");
    }

    // LISTAR RECEPCIONISTAS
    public List<Usuario> listarRecepcionistas() {
        return listarPorRol("RECEPCIONISTA");
    }

    // LISTAR ENFERMEROS
    public List<Usuario> listarEnfermeros() {
        return listarPorRol("ENFERMERO");
    }

    public List<Usuario> listarMedicosPorEspecialidad(int idEspecialidad) {
        List<Usuario> lista = new ArrayList<>();
        // La tabla usuarios tiene campo 'especialidad' como texto libre, no FK.
        // Necesitas hacer JOIN con especialidades para filtrar por id.
        // OPCIÓN A: si el campo especialidad en usuarios guarda el NOMBRE de la especialidad:
        String sql = "SELECT u.* FROM usuarios u "
                + "JOIN especialidades e ON e.nombre = u.especialidad "
                + "WHERE u.rol = 'MEDICO' AND u.activo = 1 AND e.id = ? "
                + "ORDER BY u.apellidos";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idEspecialidad);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listarMedicosPorEspecialidad: " + e.getMessage());
        }
        return lista;
    }

    // MAPEAR RESULTSET
    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setNombres(rs.getString("nombres"));
        u.setApellidos(rs.getString("apellidos"));
        u.setDocumento(rs.getString("documento"));
        u.setEmail(rs.getString("email"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setRol(rs.getString("rol"));
        u.setEspecialidad(rs.getString("especialidad"));
        u.setLangPreferido(rs.getString("lang_preferido"));
        u.setActivo(rs.getBoolean("activo"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
