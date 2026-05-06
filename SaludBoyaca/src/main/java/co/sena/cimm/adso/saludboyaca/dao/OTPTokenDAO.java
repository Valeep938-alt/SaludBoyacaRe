package co.sena.cimm.adso.saludboyaca.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import co.sena.cimm.adso.saludboyaca.model.OTPToken;
import co.sena.cimm.adso.saludboyaca.util.Conexion;

public class OTPTokenDAO {

    public boolean insertar(OTPToken otp) {
        String sql = "INSERT INTO otp_tokens (id_usuario, codigo, fecha_gen, expira_en, usado) VALUES (?,?,NOW(),?,?)";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, otp.getIdUsuario());
            ps.setString(2, otp.getCodigo());
            ps.setTimestamp(3, new Timestamp(otp.getExpiraEn().getTime()));
            ps.setBoolean(4, otp.isUsado());
            if (ps.executeUpdate() > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    otp.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error insertar OTP: " + e.getMessage());
        }
        return false;
    }

    public boolean marcarUsado(int id) {
        String sql = "UPDATE otp_tokens SET usado=1 WHERE id=?";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error marcar usado: " + e.getMessage());
        }
        return false;
    }

    public boolean marcarUsadoPorCodigo(String codigo, Integer idUsuario) {
        String sql = "UPDATE otp_tokens SET usado = 1 WHERE codigo = ? AND id_usuario = ? AND usado = 0";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, codigo);
            ps.setInt(2, idUsuario);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error marcar OTP como usado por código: " + e.getMessage());
        }
        return false;
    }

    public OTPToken buscarValido(int idUsuario, String codigo) {
        String sql = "SELECT * FROM otp_tokens WHERE id_usuario=? AND codigo=? AND usado=false AND expira_en > NOW()";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, codigo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapear(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error buscar OTP válido: " + e.getMessage());
        }
        return null;
    }

    public List<OTPToken> listarPorUsuario(int idUsuario) {
        List<OTPToken> lista = new ArrayList<>();
        String sql = "SELECT * FROM otp_tokens WHERE id_usuario=? ORDER BY fecha_gen DESC";
        try (Connection conn = Conexion.getConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error listar OTPs: " + e.getMessage());
        }
        return lista;
    }

    private OTPToken mapear(ResultSet rs) throws SQLException {
        OTPToken otp = new OTPToken();
        otp.setId(rs.getInt("id"));
        otp.setIdUsuario(rs.getInt("id_usuario"));
        otp.setCodigo(rs.getString("codigo"));
        otp.setFechaGen(rs.getTimestamp("fecha_gen"));
        otp.setExpiraEn(rs.getTimestamp("expira_en"));
        otp.setUsado(rs.getBoolean("usado"));
        return otp;
    }
}
