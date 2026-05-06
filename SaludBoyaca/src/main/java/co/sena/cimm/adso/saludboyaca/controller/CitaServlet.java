package co.sena.cimm.adso.saludboyaca.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.dao.CitaDAO;
import co.sena.cimm.adso.saludboyaca.dao.EspecialidadDAO;
import co.sena.cimm.adso.saludboyaca.dao.HorarioDAO;
import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.model.Cita;
import co.sena.cimm.adso.saludboyaca.model.Horario;
import co.sena.cimm.adso.saludboyaca.model.Paciente;
import co.sena.cimm.adso.saludboyaca.model.Usuario;
import co.sena.cimm.adso.saludboyaca.util.PDFGenerator;

@WebServlet(name = "CitaServlet", urlPatterns = {"/citas/*"})
public class CitaServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private PacienteDAO pacienteDAO;
    private UsuarioDAO usuarioDAO;
    private EspecialidadDAO especialidadDAO;
    private HorarioDAO horarioDAO;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        pacienteDAO = new PacienteDAO();
        usuarioDAO = new UsuarioDAO();
        especialidadDAO = new EspecialidadDAO();
        horarioDAO = new HorarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getPathInfo();
        if (action == null) {
            action = "/listar";
        }

        // ── Ruta pública: PDF sin autenticación ──
        if ("/pdf".equals(action)) {
            generarPDF(request, response);
            return;
        }

        // ── Resto de rutas: requieren sesión autenticada ──
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (!verificarAcceso(usuario, session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // AJAX: médicos por especialidad
        if ("/ajax/medicos".equals(action)) {
            int idEsp = Integer.parseInt(request.getParameter("idEspecialidad"));
            List<Usuario> medicos = usuarioDAO.listarMedicosPorEspecialidad(idEsp);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < medicos.size(); i++) {
                Usuario m = medicos.get(i);
                if (i > 0) json.append(",");
                json.append("{\"id\":").append(m.getId())
                    .append(",\"nombre\":\"").append(m.getNombres()).append(" ").append(m.getApellidos()).append("\"}");
            }
            json.append("]");
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json.toString());
            return;
        }

        // AJAX: días disponibles de un médico
        if ("/ajax/dias".equals(action)) {
            int idMedico = Integer.parseInt(request.getParameter("idMedico"));
            List<Integer> dias = horarioDAO.listarDiasPorMedico(idMedico);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < dias.size(); i++) {
                if (i > 0) json.append(",");
                json.append(dias.get(i));
            }
            json.append("]");
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json.toString());
            return;
        }

        // AJAX: horas disponibles de un médico en una fecha
        if ("/ajax/horas".equals(action)) {
            int idMedico = Integer.parseInt(request.getParameter("idMedico"));
            Date fecha = Date.valueOf(request.getParameter("fecha"));
            java.time.LocalDate ld = fecha.toLocalDate();
            int diaSemana = ld.getDayOfWeek().getValue();

            List<Horario> horarios = horarioDAO.listarPorMedico(idMedico);
            List<String> horasOcupadas = citaDAO.listarHorasOcupadas(idMedico, fecha);

            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Horario h : horarios) {
                if (h.getDiaSemana() == diaSemana) {
                    java.time.LocalTime cursor = h.getHoraInicio().toLocalTime();
                    java.time.LocalTime fin = h.getHoraFin().toLocalTime();
                    while (cursor.isBefore(fin)) {
                        String slot = cursor.toString().substring(0, 5);
                        if (!horasOcupadas.contains(slot)) {
                            if (!first) json.append(",");
                            json.append("\"").append(slot).append("\"");
                            first = false;
                        }
                        cursor = cursor.plusMinutes(30);
                    }
                }
            }
            json.append("]");
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(json.toString());
            return;
        }

        switch (action) {
            case "/listar":
                listar(request, response, usuario);
                break;
                
            case "/nueva":
                // ✅ SOLO RECEPCIONISTA puede crear citas
                if (usuario.isRecepcionista()) {
                    prepararFormulario(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/citas/listar");
                }
                break;
                
            case "/editar":
                // ✅ SOLO RECEPCIONISTA puede editar citas
                if (usuario.isRecepcionista()) {
                    editar(request, response);
                } else {
                    listar(request, response, usuario);
                }
                break;
                
            case "/detalle":
                // ✅ Todos los roles pueden ver detalle
                detalle(request, response);
                break;
                
            case "/cancelar":
                // ✅ SOLO MÉDICO puede cancelar citas
                if (usuario.isMedico()) {
                    cambiarEstado(request, response, "CANCELADA");
                } else {
                    response.sendRedirect(request.getContextPath() + "/citas/listar");
                }
                break;
                
            case "/confirmar":
                // ✅ SOLO MÉDICO puede confirmar citas
                if (usuario.isMedico()) {
                    cambiarEstado(request, response, "CONFIRMADA");
                } else {
                    response.sendRedirect(request.getContextPath() + "/citas/listar");
                }
                break;
                
            case "/atender":
                // ✅ SOLO MÉDICO puede atender citas
                if (usuario.isMedico()) {
                    cambiarEstado(request, response, "ATENDIDA");
                } else {
                    response.sendRedirect(request.getContextPath() + "/citas/listar");
                }
                break;
                
            default:
                listar(request, response, usuario);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (!verificarAcceso(usuario, session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            action = "/guardar";
        }

        switch (action) {
            case "/guardar":
                // ✅ SOLO RECEPCIONISTA puede guardar nuevas citas
                if (usuario.isRecepcionista()) {
                    guardar(request, response, usuario);
                } else {
                    response.sendRedirect(request.getContextPath() + "/citas/listar");
                }
                break;
                
            case "/actualizar":
                // ✅ SOLO RECEPCIONISTA puede actualizar citas
                if (usuario.isRecepcionista()) {
                    actualizar(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/citas/listar");
                }
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/citas/listar");
        }
    }

    // ... (resto de métodos privados sin cambios)
    private void listar(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        List<Cita> citas;
        if (usuario.isMedico()) {
            citas = citaDAO.listarPorMedico(usuario.getId());
        } else {
            citas = citaDAO.listarTodas();
        }
        request.setAttribute("citas", citas);
        request.getRequestDispatcher("/WEB-INF/views/citas/lista.jsp").forward(request, response);
    }

    private void prepararFormulario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pacientes", pacienteDAO.listarTodos());
        request.setAttribute("especialidades", especialidadDAO.listarTodos());
        request.getRequestDispatcher("/WEB-INF/views/citas/formulario.jsp").forward(request, response);
    }

    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Cita cita = citaDAO.buscarPorId(id);
        request.setAttribute("cita", cita);
        request.setAttribute("pacientes", pacienteDAO.listarTodos());
        request.setAttribute("especialidades", especialidadDAO.listarTodos());
        request.setAttribute("medicos", usuarioDAO.listarMedicos());
        request.setAttribute("modo", "editar");
        request.getRequestDispatcher("/WEB-INF/views/citas/formulario.jsp").forward(request, response);
    }

    private void detalle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Cita cita = citaDAO.buscarPorId(id);
        request.setAttribute("cita", cita);
        if (cita != null) {
            Paciente paciente = pacienteDAO.buscarPorId(cita.getIdPaciente());
            request.setAttribute("pacienteDetalle", paciente);
        }
        request.getRequestDispatcher("/WEB-INF/views/citas/detalle.jsp").forward(request, response);
    }

    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response, String estado)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String observaciones = request.getParameter("observaciones");
        if (observaciones == null) {
            observaciones = "Cambio de estado a " + estado;
        }
        citaDAO.cambiarEstado(id, estado, observaciones);
        response.sendRedirect(request.getContextPath() + "/citas/listar");
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        int idMedico = Integer.parseInt(request.getParameter("idMedico"));
        Date fechaCita = Date.valueOf(request.getParameter("fechaCita"));
        Time horaCita = Time.valueOf(request.getParameter("horaCita") + ":00");

        if (!validarDisponibilidad(idMedico, fechaCita, horaCita)) {
            request.setAttribute("error", "El médico no tiene disponibilidad en esa fecha y hora");
            prepararFormulario(request, response);
            return;
        }

        Cita c = new Cita();
        c.setIdPaciente(Integer.parseInt(request.getParameter("idPaciente")));
        c.setIdMedico(idMedico);
        c.setIdEspecialidad(Integer.parseInt(request.getParameter("idEspecialidad")));
        c.setFechaCita(fechaCita);
        c.setHoraCita(horaCita);
        c.setMotivo(request.getParameter("motivo"));
        c.setEstado("PROGRAMADA");
        c.setIdRegistradoPor(usuario.getId());

        citaDAO.insertar(c);
        response.sendRedirect(request.getContextPath() + "/citas/listar");
    }

    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cita c = new Cita();
        c.setId(Integer.parseInt(request.getParameter("id")));
        c.setIdPaciente(Integer.parseInt(request.getParameter("idPaciente")));
        c.setIdMedico(Integer.parseInt(request.getParameter("idMedico")));
        c.setIdEspecialidad(Integer.parseInt(request.getParameter("idEspecialidad")));
        c.setFechaCita(Date.valueOf(request.getParameter("fechaCita")));
        c.setHoraCita(Time.valueOf(request.getParameter("horaCita") + ":00"));
        c.setMotivo(request.getParameter("motivo"));
        c.setEstado(request.getParameter("estado"));

        citaDAO.actualizar(c);
        response.sendRedirect(request.getContextPath() + "/citas/listar");
    }

    private void generarPDF(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OutputStream out = null;
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de cita requerido");
                return;
            }
            int id = Integer.parseInt(idParam);
            Cita cita = citaDAO.buscarPorId(id);
            if (cita == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Cita no encontrada");
                return;
            }
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=comprobante_cita_" + id + ".pdf");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            out = response.getOutputStream();
            PDFGenerator.generarComprobante(out, cita);
            out.flush();
        } catch (Exception e) {
            System.err.println("Error generando PDF: " + e.getMessage());
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Error al generar el PDF: " + e.getMessage());
            }
        } finally {
            if (out != null) {
                try { out.close(); } catch (IOException e) { /* ignore */ }
            }
        }
    }

    private boolean validarDisponibilidad(int idMedico, Date fecha, Time hora) {
        LocalDate localDate = fecha.toLocalDate();
        int diaSemana = localDate.getDayOfWeek().getValue();
        List<Horario> horarios = horarioDAO.listarPorMedico(idMedico);
        for (Horario h : horarios) {
            if (h.getDiaSemana() == diaSemana) {
                if (hora.after(h.getHoraInicio()) && hora.before(h.getHoraFin())) {
                    int citasExistentes = citaDAO.contarPorMedicoFechaHora(idMedico, fecha, hora);
                    if (citasExistentes < h.getMaxCitas()) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    private boolean verificarAcceso(Usuario usuario, HttpSession session) {
        return usuario != null
                && Boolean.TRUE.equals(session.getAttribute("otpVerificado"))
                && (usuario.isMedico() || usuario.isRecepcionista() || usuario.isEnfermero());
    }
}