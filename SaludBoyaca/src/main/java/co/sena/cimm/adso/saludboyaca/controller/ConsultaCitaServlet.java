package co.sena.cimm.adso.saludboyaca.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.dao.CitaDAO;
import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.model.Cita;
import co.sena.cimm.adso.saludboyaca.model.Paciente;
import co.sena.cimm.adso.saludboyaca.util.CaptchaGenerator;

@WebServlet(name = "ConsultaCitaServlet", urlPatterns = {"/consulta-cita"})
public class ConsultaCitaServlet extends HttpServlet {

    // Salt fijo del servidor — nunca viaja al cliente, el hash no es falsificable
    private static final String CAPTCHA_SALT = "SaludBoyaca_SENA_2026_Paipa";

    private CitaDAO citaDAO;
    private PacienteDAO pacienteDAO;

    @Override
    public void init() throws ServletException {
        citaDAO = new CitaDAO();
        pacienteDAO = new PacienteDAO();
    }

    // ── GET: mostrar formulario con captcha fresco ───────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String captchaText = CaptchaGenerator.generarTextoCaptcha();

        // Guardar en sesion como respaldo
        request.getSession().setAttribute("captchaText", captchaText);
        if ("json".equals(request.getParameter("formato"))) {
            response.setContentType("application/json; charset=UTF-8");
            // Solo permite llamadas desde la misma app (no CORS externo)
            response.setHeader("Cache-Control", "no-store");

            String documento = request.getParameter("documento");

            // Validar documento básico
            if (documento == null || !documento.matches("\\d{5,15}")) {
                response.getWriter().write("{\"error\":\"documento_invalido\"}");
                return;
            }

            try {
                List<Cita> citas = (List<Cita>) citaDAO.buscarPorDocumento(documento);

                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < citas.size(); i++) {
                    Cita c = citas.get(i);
                    if (i > 0) {
                        json.append(",");
                    }

                    // Formatear hora como HH:mm
                    String hora = "";
                    if (c.getHoraCita() != null) {
                        hora = c.getHoraCita().toString().substring(0, 5); // "HH:mm"
                    }

                    json.append("{")
                            .append("\"nombrePaciente\":\"")
                            .append(escapeJson(c.getNombrePaciente())).append("\",")
                            .append("\"nombreMedico\":\"")
                            .append(escapeJson(c.getNombreMedico())).append("\",")
                            .append("\"nombreEspecialidad\":\"")
                            .append(escapeJson(c.getNombreEspecialidad())).append("\",")
                            .append("\"fechaCita\":\"")
                            .append(c.getFechaCita() != null ? c.getFechaCita().toString() : "").append("\",")
                            .append("\"horaCita\":\"").append(hora).append("\",")
                            .append("\"estado\":\"").append(escapeJson(c.getEstado())).append("\"")
                            .append("}");
                }
                json.append("]");

                response.getWriter().write(json.toString());

            } catch (Exception e) {
                response.setStatus(500);
                response.getWriter().write("{\"error\":\"server_error\"}");
            }
            return; // MUY IMPORTANTE: detiene el flujo normal del servlet
        }

        // Pasar texto y hash al JSP (mecanismo principal, independiente de sesion)
        request.setAttribute("captchaText", captchaText);
        request.setAttribute("captchaHash", hashCaptcha(captchaText));

        request.getRequestDispatcher("/WEB-INF/views/consulta/consulta_cita.jsp")
                .forward(request, response);
    }

    // ── POST: validar captcha y buscar paciente ──────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String documento = request.getParameter("documento");
        String captchaIngresado = request.getParameter("captcha");
        String captchaHashForm = request.getParameter("captchaHash"); // campo hidden

        String lang = "es";
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("lang") != null) {
            lang = (String) session.getAttribute("lang");
        }
        java.util.ResourceBundle rb
                = java.util.ResourceBundle.getBundle("messages", new java.util.Locale(lang));

        // ── Validar captcha ──────────────────────────────────────────────────
        boolean captchaValido = false;

        // Metodo 1 (principal): verificar hash del campo hidden — no depende de sesion
        if (captchaIngresado != null && captchaHashForm != null && !captchaHashForm.isEmpty()) {
            captchaValido = captchaHashForm.equals(hashCaptcha(captchaIngresado.trim()));
        }

        // Metodo 2 (respaldo): sesion si las cookies funcionaron
        if (!captchaValido && session != null) {
            String captchaSesion = (String) session.getAttribute("captchaText");
            if (captchaSesion != null && captchaIngresado != null) {
                captchaValido = captchaIngresado.trim().equalsIgnoreCase(captchaSesion.trim());
            }
        }

        if (!captchaValido) {
            request.setAttribute("error", rb.getString("consulta.captcha.error"));
            prepararNuevoCaptcha(request);
            request.getRequestDispatcher("/WEB-INF/views/consulta/consulta_cita.jsp")
                    .forward(request, response);
            return;
        }

        // Captcha correcto: invalidar en sesion para evitar replay
        if (session != null) {
            session.removeAttribute("captchaText");
        }

        // ── Buscar paciente ──────────────────────────────────────────────────
        Paciente paciente = pacienteDAO.buscarPorDocumento(documento);

        if (paciente != null) {
            List<Cita> citas = citaDAO.listarPorPaciente(paciente.getId());
            request.setAttribute("paciente", paciente);
            request.setAttribute("citas", citas);
        } else {
            request.setAttribute("error", rb.getString("consulta.no.encontrado"));
        }

        // Captcha nuevo para siguiente consulta
        prepararNuevoCaptcha(request);

        request.getRequestDispatcher("/WEB-INF/views/consulta/consulta_cita.jsp")
                .forward(request, response);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────
    private void prepararNuevoCaptcha(HttpServletRequest request) {
        String texto = CaptchaGenerator.generarTextoCaptcha();
        request.getSession().setAttribute("captchaText", texto);
        request.setAttribute("captchaText", texto);
        request.setAttribute("captchaHash", hashCaptcha(texto));
    }

    private String escapeJson(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    /**
     * SHA-256(texto.toUpperCase() + SALT) en hex. toUpperCase() hace la
     * comparacion case-insensitive sin if adicionales.
     */
    static String hashCaptcha(String texto) {
        try {
            String entrada = texto.trim().toUpperCase() + CAPTCHA_SALT;
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(entrada.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }
}
