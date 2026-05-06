package co.sena.cimm.adso.saludboyaca.model;

import java.util.Date;

public class Paciente {

    private int id;
    private String nombres;
    private String apellidos;
    private String documento;
    private java.sql.Date fechaNacimiento;
    private String telefono;
    private String email;
    private String eps;
    private String veredaBarrio;
    private Date createdAt;
    private String fotoUrl;

    public Paciente() {
    }

    public Paciente(int id, String nombres, String apellidos, String documento,
            java.sql.Date fechaNacimiento, String telefono, String email,
            String eps, String veredaBarrio, Date createdAt, String fotoUrl) {
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.documento = documento;
        this.fechaNacimiento = fechaNacimiento;
        this.telefono = telefono;
        this.email = email;
        this.eps = eps;
        this.veredaBarrio = veredaBarrio;
        this.createdAt = createdAt;
        this.fotoUrl = fotoUrl;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public java.sql.Date getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(java.sql.Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEps() {
        return eps;
    }

    public void setEps(String eps) {
        this.eps = eps;
    }

    public String getVeredaBarrio() {
        return veredaBarrio;
    }

    public void setVeredaBarrio(String veredaBarrio) {
        this.veredaBarrio = veredaBarrio;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getFotoUrl() {
        return fotoUrl;
    }

    public void setFotoUrl(String fotoUrl) {
        this.fotoUrl = fotoUrl;
    }

    @Override
    public String toString() {
        return nombres + " " + apellidos + " (" + documento + ")";
    }
}
