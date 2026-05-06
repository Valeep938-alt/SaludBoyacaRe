package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.model.Horario;
import co.sena.cimm.adso.saludboyaca.util.Conexion;

public class HorarioDAO {

    public boolean insertar(Horario h) {
        String sql = "INSERT INTO horarios (id_medico, dia_semana, hora_inicio, hora_fin, max_citas) VALUES (?,?,?,?,?)";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, h.getIdMedico());
            ps.setInt(2, h.getDiaSemana());
            ps.setTime(3, h.getHoraInicio());
            ps.setTime(4, h.getHoraFin());
            ps.setInt(5, h.getMaxCitas());
            if (ps.executeUpdate() > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    h.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error insertar horario: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizar(Horario h) {
        String sql = "UPDATE horarios SET id_medico=?, dia_semana=?, hora_inicio=?, hora_fin=?, max_citas=? WHERE id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, h.getIdMedico());
            ps.setInt(2, h.getDiaSemana());
            ps.setTime(3, h.getHoraInicio());
            ps.setTime(4, h.getHoraFin());
            ps.setInt(5, h.getMaxCitas());
            ps.setInt(6, h.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizar horario: " + e.getMessage());
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM horarios WHERE id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminar horario: " + e.getMessage());
        }
        return false;
    }

    public Horario buscarPorId(int id) {
        String sql = "SELECT h.*, u.nombres + ' ' + u.apellidos as nom_medico FROM horarios h "
                + "JOIN usuarios u ON h.id_medico = u.id WHERE h.id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearConJoin(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error buscar horario: " + e.getMessage());
        }
        return null;
    }

    public List<Horario> listarTodos() {
        List<Horario> lista = new ArrayList<>();
        String sql = "SELECT h.*, u.nombres + ' ' + u.apellidos as nom_medico FROM horarios h "
                + "JOIN usuarios u ON h.id_medico = u.id ORDER BY h.id_medico, h.dia_semana";
        try (Connection conn = Conexion.getConexion(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(mapearConJoin(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar horarios: " + e.getMessage());
        }
        return lista;
    }

    public List<Horario> listarPorMedico(int idMedico) {
        List<Horario> lista = new ArrayList<>();
        String sql = "SELECT h.*, u.nombres + ' ' + u.apellidos as nom_medico FROM horarios h "
                + "JOIN usuarios u ON h.id_medico = u.id WHERE h.id_medico=? ORDER BY h.dia_semana";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearConJoin(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar por médico: " + e.getMessage());
        }
        return lista;
    }

    public List<Integer> listarDiasPorMedico(int idMedico) {
        List<Integer> dias = new ArrayList<>();
        String sql = "SELECT DISTINCT dia_semana FROM horarios WHERE id_medico = ?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                dias.add(rs.getInt("dia_semana"));
            }
        } catch (SQLException e) {
            System.err.println("Error listarDiasPorMedico: " + e.getMessage());
        }
        return dias;
    }

    private Horario mapear(ResultSet rs) throws SQLException {
        Horario h = new Horario();
        h.setId(rs.getInt("id"));
        h.setIdMedico(rs.getInt("id_medico"));
        h.setDiaSemana(rs.getInt("dia_semana"));
        h.setHoraInicio(rs.getTime("hora_inicio"));
        h.setHoraFin(rs.getTime("hora_fin"));
        h.setMaxCitas(rs.getInt("max_citas"));
        return h;
    }

    private Horario mapearConJoin(ResultSet rs) throws SQLException {
        Horario h = mapear(rs);
        h.setNombreMedico(rs.getString("nom_medico"));
        return h;
    }
}
