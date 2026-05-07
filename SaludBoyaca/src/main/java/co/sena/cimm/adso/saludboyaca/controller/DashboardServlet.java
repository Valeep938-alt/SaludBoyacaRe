package co.sena.cimm.adso.saludboyaca.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.dao.CitaDAO;
import co.sena.cimm.adso.saludboyaca.dao.HorarioDAO;
import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.model.Cita;
import co.sena.cimm.adso.saludboyaca.model.Horario;
import co.sena.cimm.adso.saludboyaca.model.Usuario;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private PacienteDAO pacienteDAO;
    private UsuarioDAO usuarioDAO;
    private HorarioDAO horarioDAO;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        pacienteDAO = new PacienteDAO();
        usuarioDAO = new UsuarioDAO();
        horarioDAO = new HorarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // ===== VERIFICAR AUTENTICACIÓN =====
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ===== DETERMINAR ROL Y FILTRO =====
        String rol = usuario.getRol();
        boolean esMedico = "MEDICO".equals(rol);
        boolean esRecepcionista = "RECEPCIONISTA".equals(rol);
        int idMedico = esMedico ? usuario.getId() : 0;

        // ===== CONFIGURAR IDIOMA =====
        String lang = request.getParameter("lang");
        if (lang != null && (lang.equals("es") || lang.equals("en") || lang.equals("it"))) {
            session.setAttribute("lang", lang);
        } else if (session.getAttribute("lang") == null) {
            session.setAttribute("lang", "es");
        }
        lang = (String) session.getAttribute("lang");

        // ===== INICIALIZAR VARIABLES CON VALORES POR DEFECTO =====
        int totalCitas = 0;
        int citasProgramadas = 0;
        int citasConfirmadas = 0;
        int citasAtendidas = 0;
        int citasCanceladas = 0;
        int totalPacientes = 0;
        int totalMedicos = 0;
        int citasMes = 0;
        List<Cita> citasHoy = new ArrayList<>();
        List<Cita> citasRecientes = new ArrayList<>();
        List<CitaDAO.EspecialidadTop> especialidadesTop = new ArrayList<>();
        Map<String, List<Cita>> citasPorDia = new HashMap<>();

        Calendar cal = Calendar.getInstance();
        int calYear = cal.get(Calendar.YEAR);
        int calMonth = cal.get(Calendar.MONTH) + 1;
        int firstDayOfWeek = 1;
        int daysInMonth = 30;
        boolean esMesActual = true;
        int hoyDia = 1;

        try {
            // ===== OBTENER ESTADÍSTICAS (FILTRADAS POR ROL) =====
            Date hoy = new Date(System.currentTimeMillis());
            int mesActual = cal.get(Calendar.MONTH) + 1;
            int anioActual = cal.get(Calendar.YEAR);

            if (esMedico) {
                // === MÉDICO: solo sus citas ===
                try {
                    List<Cita> todas = citaDAO.listarPorMedico(idMedico);
                    totalCitas = todas != null ? todas.size() : 0;
                } catch (Exception e) {
                    System.err.println("Error listarPorMedico: " + e.getMessage());
                }
                try {
                    citasProgramadas = citaDAO.contarPorEstadoYMedico("PROGRAMADA", idMedico);
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    citasConfirmadas = citaDAO.contarPorEstadoYMedico("CONFIRMADA", idMedico);
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    citasAtendidas = citaDAO.contarPorEstadoYMedico("ATENDIDA", idMedico);
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    citasCanceladas = citaDAO.contarPorEstadoYMedico("CANCELADA", idMedico);
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    citasMes = citaDAO.contarPorMedicoYMes(idMedico, mesActual, anioActual);
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    List<Cita> temp = citaDAO.listarPorFechaYMedico(hoy, idMedico);
                    if (temp != null) {
                        citasHoy = temp;
                    }
                } catch (Exception e) {
                    System.err.println("Error citasHoy medico: " + e.getMessage());
                }
                try {
                    List<CitaDAO.EspecialidadTop> temp = citaDAO.listarEspecialidadesTopPorMedico(5, idMedico);
                    if (temp != null) {
                        especialidadesTop = temp;
                    }
                } catch (Exception e) {
                    System.err.println("Error especialidadesTop medico: " + e.getMessage());
                }
                try {
                    List<Cita> temp = citaDAO.listarPorMedico(idMedico);
                    if (temp != null) {
                        citasRecientes = temp;
                        if (citasRecientes.size() > 10) {
                            citasRecientes = citasRecientes.subList(0, 10);
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error citasRecientes medico: " + e.getMessage());
                }
                // Médico no ve total de pacientes ni total de médicos
                totalPacientes = 0;
                totalMedicos = 0;

            } else {
                // === RECEPCIONISTA / ADMIN: todas las citas ===
                try {
                    List<Cita> todas = citaDAO.listarTodas();
                    totalCitas = todas != null ? todas.size() : 0;
                } catch (Exception e) {
                    System.err.println("Error listarTodas: " + e.getMessage());
                }
                try {
                    citasProgramadas = citaDAO.contarPorEstado("PROGRAMADA");
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    citasConfirmadas = citaDAO.contarPorEstado("CONFIRMADA");
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    citasAtendidas = citaDAO.contarPorEstado("ATENDIDA");
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    citasCanceladas = citaDAO.contarPorEstado("CANCELADA");
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    totalPacientes = pacienteDAO.contar();
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    List<Usuario> medicos = usuarioDAO.listarMedicos();
                    totalMedicos = medicos != null ? medicos.size() : 0;
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    List<Cita> temp = citaDAO.listarPorFecha(hoy);
                    if (temp != null) {
                        citasHoy = temp;
                    }
                } catch (Exception e) {
                    System.err.println("Error citasHoy: " + e.getMessage());
                }
                try {
                    citasMes = citaDAO.contarPorMes(mesActual, anioActual);
                } catch (Exception e) {
                    /* ignore */ }
                try {
                    List<CitaDAO.EspecialidadTop> temp = citaDAO.listarEspecialidadesTop(5);
                    if (temp != null) {
                        especialidadesTop = temp;
                    }
                } catch (Exception e) {
                    System.err.println("Error especialidadesTop: " + e.getMessage());
                }
                try {
                    List<Cita> temp = citaDAO.listarTodas();
                    if (temp != null) {
                        citasRecientes = temp;
                        if (citasRecientes.size() > 10) {
                            citasRecientes = citasRecientes.subList(0, 10);
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error citasRecientes: " + e.getMessage());
                }
            }

            // ===== PREPARAR CALENDARIO =====
            String yearParam = request.getParameter("calYear");
            String monthParam = request.getParameter("calMonth");

            if (yearParam != null && monthParam != null) {
                try {
                    calYear = Integer.parseInt(yearParam);
                    calMonth = Integer.parseInt(monthParam);
                } catch (NumberFormatException e) {
                    // usar valores por defecto
                }
            }

            // Ajustar meses fuera de rango
            if (calMonth < 1) {
                calMonth = 12;
                calYear--;
            }
            if (calMonth > 12) {
                calMonth = 1;
                calYear++;
            }

            Calendar calView = Calendar.getInstance();
            calView.set(calYear, calMonth - 1, 1);
            firstDayOfWeek = calView.get(Calendar.DAY_OF_WEEK);
            daysInMonth = calView.getActualMaximum(Calendar.DAY_OF_MONTH);

            // Obtener citas para cada día del mes (filtradas por rol)
            try {
                List<Cita> citasMesCompleto;
                if (esMedico) {
                    citasMesCompleto = citaDAO.listarPorMesPorMedico(calMonth, calYear, idMedico);
                } else {
                    citasMesCompleto = citaDAO.listarPorMes(calMonth, calYear);
                }
                if (citasMesCompleto != null) {
                    for (Cita cita : citasMesCompleto) {
                        if (cita.getFechaCita() != null) {
                            String fechaKey = cita.getFechaCita().toString(); // formato "yyyy-MM-dd"
                            if (!citasPorDia.containsKey(fechaKey)) {
                                citasPorDia.put(fechaKey, new ArrayList<>());
                            }
                            citasPorDia.get(fechaKey).add(cita);
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("Error calendario mes: " + e.getMessage());
            }

            // Determinar día actual
            Calendar hoyCal = Calendar.getInstance();
            esMesActual = (hoyCal.get(Calendar.MONTH) + 1 == calMonth && hoyCal.get(Calendar.YEAR) == calYear);
            hoyDia = hoyCal.get(Calendar.DAY_OF_MONTH);

        } catch (Exception e) {
            System.err.println("Error general en DashboardServlet: " + e.getMessage());
            e.printStackTrace();
        }

        // Horarios del médico logueado
        List<Horario> horariosMedico = null;
        if ("MEDICO".equals(usuario.getRol())) {
            try {
                horariosMedico = horarioDAO.listarPorMedico(usuario.getId());
            } catch (Exception e) {
                /* ignore */ }
        }

        // ===== SETEAR ATRIBUTOS =====
        request.setAttribute("currentPage", "dashboard");
        request.setAttribute("lang", lang);
        request.setAttribute("totalCitas", totalCitas);
        request.setAttribute("citasProgramadas", citasProgramadas);
        request.setAttribute("citasConfirmadas", citasConfirmadas);
        request.setAttribute("citasAtendidas", citasAtendidas);
        request.setAttribute("citasCanceladas", citasCanceladas);
        request.setAttribute("totalPacientes", totalPacientes);
        request.setAttribute("totalMedicos", totalMedicos);
        request.setAttribute("citasHoy", citasHoy);
        request.setAttribute("citasHoyCount", citasHoy.size());
        request.setAttribute("citasMes", citasMes);
        request.setAttribute("especialidadesTop", especialidadesTop);
        request.setAttribute("citasRecientes", citasRecientes);
        request.setAttribute("calYear", calYear);
        request.setAttribute("calMonth", calMonth);
        request.setAttribute("firstDayOfWeek", firstDayOfWeek);
        request.setAttribute("daysInMonth", daysInMonth);
        request.setAttribute("citasPorDia", citasPorDia);
        request.setAttribute("esMesActual", esMesActual);
        request.setAttribute("hoyDia", hoyDia);
        request.setAttribute("horariosMedico", horariosMedico);

        // Nombres según idioma
        String[] dayNames;
        String[] monthNames;
        if ("en".equals(lang)) {
            dayNames = new String[]{"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
            monthNames = new String[]{"January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"};
        } else if ("it".equals(lang)) {
            dayNames = new String[]{"Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab"};
            monthNames = new String[]{"Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
                "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"};
        } else {
            dayNames = new String[]{"Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"};
            monthNames = new String[]{"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
                "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
        }
        request.setAttribute("dayNames", dayNames);
        request.setAttribute("monthNames", monthNames);

        // Forward al JSP
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
