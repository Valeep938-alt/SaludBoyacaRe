package co.sena.cimm.adso.saludboyaca.model;

import java.util.Date;

public class LogAcceso {
    private int id;
    private Integer idUsuario;
    private String username;
    private String accion;      // LOGIN, OTP_VERIFY, etc.
    private String ip;
    private String resultado;   // EXITO, FALLO
    private Date fecha;

    public LogAcceso() {}

    public LogAcceso(int id, Integer idUsuario, String username, String accion, 
                     String ip, String resultado, Date fecha) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.username = username;
        this.accion = accion;
        this.ip = ip;
        this.resultado = resultado;
        this.fecha = fecha;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getAccion() { return accion; }
    public void setAccion(String accion) { this.accion = accion; }

    public String getIp() { return ip; }
    public void setIp(String ip) { this.ip = ip; }

    public String getResultado() { return resultado; }
    public void setResultado(String resultado) { this.resultado = resultado; }

    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }

    public boolean isExito() {
        return "EXITO".equals(resultado);
    }

    @Override
    public String toString() {
        return username + " - " + accion + " [" + resultado + "] " + fecha;
    }
}
