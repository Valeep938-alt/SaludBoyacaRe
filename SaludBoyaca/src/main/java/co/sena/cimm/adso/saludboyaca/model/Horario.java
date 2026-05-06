package co.sena.cimm.adso.saludboyaca.model;

import java.sql.Time;

public class Horario {
    private int id;
    private int idMedico;
    private int diaSemana;      // 1=Lunes, 2=Martes, ..., 5=Viernes
    private Time horaInicio;
    private Time horaFin;
    private int maxCitas;

    // Auxiliar
    private String nombreMedico;

    public Horario() {}

    public Horario(int id, int idMedico, int diaSemana, Time horaInicio, 
                   Time horaFin, int maxCitas) {
        this.id = id;
        this.idMedico = idMedico;
        this.diaSemana = diaSemana;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.maxCitas = maxCitas;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public int getDiaSemana() { return diaSemana; }
    public void setDiaSemana(int diaSemana) { this.diaSemana = diaSemana; }

    public Time getHoraInicio() { return horaInicio; }
    public void setHoraInicio(Time horaInicio) { this.horaInicio = horaInicio; }

    public Time getHoraFin() { return horaFin; }
    public void setHoraFin(Time horaFin) { this.horaFin = horaFin; }

    public int getMaxCitas() { return maxCitas; }
    public void setMaxCitas(int maxCitas) { this.maxCitas = maxCitas; }

    public String getNombreMedico() { return nombreMedico; }
    public void setNombreMedico(String nombreMedico) { this.nombreMedico = nombreMedico; }

    public String getNombreDia() {
        String[] dias = {"", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes"};
        return dias[diaSemana];
    }

    @Override
    public String toString() {
        return getNombreDia() + " " + horaInicio + " - " + horaFin;
    }
}
