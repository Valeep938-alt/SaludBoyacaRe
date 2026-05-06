package co.sena.cimm.adso.saludboyaca.model;

import java.util.Date;

public class OTPToken {
    private int id;
    private int idUsuario;
    private String codigo;
    private Date fechaGen;
    private Date expiraEn;
    private boolean usado;

    public OTPToken() {}

    public OTPToken(int id, int idUsuario, String codigo, Date fechaGen, 
                    Date expiraEn, boolean usado) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.codigo = codigo;
        this.fechaGen = fechaGen;
        this.expiraEn = expiraEn;
        this.usado = usado;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public Date getFechaGen() { return fechaGen; }
    public void setFechaGen(Date fechaGen) { this.fechaGen = fechaGen; }

    public Date getExpiraEn() { return expiraEn; }
    public void setExpiraEn(Date expiraEn) { this.expiraEn = expiraEn; }

    public boolean isUsado() { return usado; }
    public void setUsado(boolean usado) { this.usado = usado; }

    public boolean isExpirado() {
        return new Date().after(expiraEn);
    }

    public boolean isValido() {
        return !usado && !isExpirado();
    }

    @Override
    public String toString() {
        return "OTP " + codigo + " - Usado: " + usado;
    }
}
