package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.model.Cita;
import co.sena.cimm.adso.saludboyaca.util.Conexion;

public class CitaDAO {

    public boolean insertar(Cita c) {
        String sql = "INSERT INTO citas (id_paciente, id_medico, id_especialidad, fecha_cita, "
                + "hora_cita, motivo, estado, observaciones, id_registrado_por) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, c.getIdPaciente());
            ps.setInt(2, c.getIdMedico());
            ps.setInt(3, c.getIdEspecialidad());
            ps.setDate(4, c.getFechaCita());
            ps.setTime(5, c.getHoraCita());
            ps.setString(6, c.getMotivo());
            ps.setString(7, c.getEstado() != null ? c.getEstado() : "PROGRAMADA");
            ps.setString(8, c.getObservaciones());
            ps.setObject(9, c.getIdRegistradoPor(), Types.INTEGER);

            int filas = ps.executeUpdate();
            if (filas > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    c.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error insertar cita: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizar(Cita c) {
        String sql = "UPDATE citas SET id_paciente=?, id_medico=?, id_especialidad=?, fecha_cita=?, "
                + "hora_cita=?, motivo=?, estado=?, observaciones=?, id_registrado_por=? WHERE id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, c.getIdPaciente());
            ps.setInt(2, c.getIdMedico());
            ps.setInt(3, c.getIdEspecialidad());
            ps.setDate(4, c.getFechaCita());
            ps.setTime(5, c.getHoraCita());
            ps.setString(6, c.getMotivo());
            ps.setString(7, c.getEstado());
            ps.setString(8, c.getObservaciones());
            ps.setObject(9, c.getIdRegistradoPor(), Types.INTEGER);
            ps.setInt(10, c.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error actualizar cita: " + e.getMessage());
        }
        return false;
    }

    public boolean cambiarEstado(int id, String nuevoEstado, String observaciones) {
        String sql = "UPDATE citas SET estado=?, observaciones=COALESCE(observaciones,'') || ' | ' || ? WHERE id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setString(2, observaciones);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error cambiar estado: " + e.getMessage());
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM citas WHERE id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error eliminar cita: " + e.getMessage());
        }
        return false;
    }

    public Cita buscarPorId(int id) {
        String sql = "SELECT c.*, p.nombres || ' ' || p.apellidos as nom_paciente, "
                + "u.nombres || ' ' || u.apellidos as nom_medico, e.nombre as nom_especialidad "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearConJoins(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error buscar cita: " + e.getMessage());
        }
        return null;
    }

    public Cita buscarPorDocumento(String documento) {
        String sql = "SELECT c.*, p.nombres || ' ' || p.apellidos as nom_paciente, "
                + "u.nombres || ' ' || u.apellidos as nom_medico, e.nombre as nom_especialidad "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE p.documento=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, documento);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearConJoins(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error buscar cita: " + e.getMessage());
        }
        return null;
    }

    public List<Cita> listarTodas() {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres || ' ' || p.apellidos as nom_paciente, "
                + "u.nombres || ' ' || u.apellidos as nom_medico, e.nombre as nom_especialidad "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "ORDER BY c.fecha_cita DESC, c.hora_cita";
        try (Connection conn = Conexion.getConexion(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                lista.add(mapearConJoins(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar citas: " + e.getMessage());
        }
        return lista;
    }

    public List<Cita> listarPorEstado(String estado) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres || ' ' || p.apellidos as nom_paciente, "
                + "u.nombres || ' ' || u.apellidos as nom_medico, e.nombre as nom_especialidad "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.estado=? ORDER BY c.fecha_cita, c.hora_cita";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearConJoins(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar por estado: " + e.getMessage());
        }
        return lista;
    }

    public List<Cita> listarPorMedico(int idMedico) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres || ' ' || p.apellidos as nom_paciente, "
                + "u.nombres || ' ' || u.apellidos as nom_medico, e.nombre as nom_especialidad "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.id_medico=? ORDER BY c.fecha_cita DESC";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearConJoins(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar por medico: " + e.getMessage());
        }
        return lista;
    }

    public List<Cita> listarPorPaciente(int idPaciente) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres || ' ' || p.apellidos as nom_paciente, "
                + "u.nombres || ' ' || u.apellidos as nom_medico, e.nombre as nom_especialidad "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.id_paciente=? ORDER BY c.fecha_cita DESC";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPaciente);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearConJoins(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar por paciente: " + e.getMessage());
        }
        return lista;
    }

    public List<Cita> listarPorFecha(Date fecha) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, p.nombres || ' ' || p.apellidos as nom_paciente, "
                + "u.nombres || ' ' || u.apellidos as nom_medico, e.nombre as nom_especialidad "
                + "FROM citas c "
                + "JOIN pacientes p ON c.id_paciente = p.id "
                + "JOIN usuarios u ON c.id_medico = u.id "
                + "JOIN especialidades e ON c.id_especialidad = e.id "
                + "WHERE c.fecha_cita=? ORDER BY c.hora_cita";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, fecha);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearConJoins(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar por fecha: " + e.getMessage());
        }
        return lista;
    }

    public int contarPorEstado(String estado) {
        String sql = "SELECT COUNT(*) FROM citas WHERE estado=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error contar citas: " + e.getMessage());
        }
        return 0;
    }

    public int contarPorMedicoFechaHora(int idMedico, Date fecha, Time hora) {
        String sql = "SELECT COUNT(*) FROM citas WHERE id_medico = ? AND fecha_cita = ? AND hora_cita = ? AND estado != 'CANCELADA'";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ps.setDate(2, fecha);
            ps.setTime(3, hora);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error contar citas por medico, fecha y hora: " + e.getMessage());
        }
        return 0;
    }

    public int contarPorMedicoYFecha(int idMedico, Date fecha) {
        String sql = "SELECT COUNT(*) FROM citas WHERE id_medico = ? AND fecha_cita = ? AND estado != 'CANCELADA'";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ps.setDate(2, fecha);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error contar citas medico-fecha: " + e.getMessage());
        }
        return 0;
    }

    public int contarPorMedicoYEstado(int idMedico, String estado) {
        String sql = "SELECT COUNT(*) FROM citas WHERE id_medico = ? AND estado = ?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ps.setString(2, estado);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error contar citas medico-estado: " + e.getMessage());
        }
        return 0;
    }

    public int contarPorMedicoYMes(int idMedico, int mes, int anio) {
        String sql = "SELECT COUNT(*) FROM citas WHERE id_medico = ? AND EXTRACT(MONTH FROM fecha_cita) = ? AND EXTRACT(YEAR FROM fecha_cita) = ?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ps.setInt(2, mes);
            ps.setInt(3, anio);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error contar citas medico-mes: " + e.getMessage());
        }
        return 0;
    }

    public int contarPorFecha(Date fecha) {
        String sql = "SELECT COUNT(*) FROM citas WHERE fecha_cita = ? AND estado != 'CANCELADA'";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, fecha);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error contar citas por fecha: " + e.getMessage());
        }
        return 0;
    }

    public int contarPorMes(int mes, int anio) {
        String sql = "SELECT COUNT(*) FROM citas WHERE EXTRACT(MONTH FROM fecha_cita) = ? AND EXTRACT(YEAR FROM fecha_cita) = ?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mes);
            ps.setInt(2, anio);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error contar por mes: " + e.getMessage());
        }
        return 0;
    }

    public List<String> listarHorasOcupadas(int idMedico, Date fecha) {
        List<String> horas = new ArrayList<>();
        String sql = "SELECT TO_CHAR(hora_cita, 'HH24:MI') as hora "
                + "FROM citas WHERE id_medico=? AND fecha_cita=? AND estado != 'CANCELADA'";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idMedico);
            ps.setDate(2, fecha);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                horas.add(rs.getString("hora"));
            }
        } catch (SQLException e) {
            System.err.println("Error listarHorasOcupadas: " + e.getMessage());
        }
        return horas;
    }

    public List<EspecialidadTop> listarEspecialidadesTop(int limite) {
        List<EspecialidadTop> lista = new ArrayList<>();
        String sql = "SELECT e.id, e.nombre, COUNT(c.id) as total "
                + "FROM especialidades e "
                + "LEFT JOIN citas c ON e.id = c.id_especialidad "
                + "GROUP BY e.id, e.nombre "
                + "ORDER BY total DESC "
                + "LIMIT ?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limite);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EspecialidadTop et = new EspecialidadTop();
                et.setId(rs.getInt("id"));
                et.setNombre(rs.getString("nombre"));
                et.setTotalCitas(rs.getInt("total"));
                lista.add(et);
            }
        } catch (SQLException e) {
            System.err.println("Error especialidades top: " + e.getMessage());
        }
        return lista;
    }

    private Cita mapear(ResultSet rs) throws SQLException {
        Cita c = new Cita();
        c.setId(rs.getInt("id"));
        c.setIdPaciente(rs.getInt("id_paciente"));
        c.setIdMedico(rs.getInt("id_medico"));
        c.setIdEspecialidad(rs.getInt("id_especialidad"));
        c.setFechaCita(rs.getDate("fecha_cita"));
        c.setHoraCita(rs.getTime("hora_cita"));
        c.setMotivo(rs.getString("motivo"));
        c.setEstado(rs.getString("estado"));
        c.setObservaciones(rs.getString("observaciones"));
        c.setFechaRegistro(rs.getTimestamp("fecha_registro"));
        c.setIdRegistradoPor(rs.getObject("id_registrado_por") != null ? rs.getInt("id_registrado_por") : null);
        return c;
    }

    private Cita mapearConJoins(ResultSet rs) throws SQLException {
        Cita c = mapear(rs);
        c.setNombrePaciente(rs.getString("nom_paciente"));
        c.setNombreMedico(rs.getString("nom_medico"));
        c.setNombreEspecialidad(rs.getString("nom_especialidad"));
        return c;
    }

    public static class EspecialidadTop {
        private int id;
        private String nombre;
        private int totalCitas;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getNombre() { return nombre; }
        public void setNombre(String nombre) { this.nombre = nombre; }
        public int getTotalCitas() { return totalCitas; }
        public void setTotalCitas(int totalCitas) { this.totalCitas = totalCitas; }
    }
}