package co.sena.cimm.adso.saludboyaca.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.sena.cimm.adso.saludboyaca.dao.CitaDAO;
import co.sena.cimm.adso.saludboyaca.dao.EspecialidadDAO;
import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.util.CaptchaGenerator;

@WebServlet(name = "IndexServlet", urlPatterns = {"", "/", "/index"})
public class IndexServlet extends HttpServlet {

    private PacienteDAO pacienteDAO;
    private CitaDAO     citaDAO;
    private EspecialidadDAO especialidadDAO;

    @Override
    public void init() throws ServletException {
        pacienteDAO     = new PacienteDAO();
        citaDAO         = new CitaDAO();
        especialidadDAO = new EspecialidadDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

        // ── Stats desde la BD ─────────────────────────────────────
        int totalPacientes    = pacienteDAO.contar();
        int totalCitas        = citaDAO.contarPorEstado("ATENDIDA");
        int totalEspecialidades = especialidadDAO.listarTodos().size();

        // Cobertura: porcentaje de citas atendidas vs total (excl. canceladas)
        int totalNoCanc = totalCitas
                        + citaDAO.contarPorEstado("PROGRAMADA")
                        + citaDAO.contarPorEstado("CONFIRMADA");
        int cobertura = totalNoCanc > 0 ? (int) Math.round(totalCitas * 100.0 / totalNoCanc) : 0;

        request.setAttribute("totalPacientes",     totalPacientes);
        request.setAttribute("totalCitas",         totalCitas);
        request.setAttribute("totalEspecialidades",totalEspecialidades);
        request.setAttribute("cobertura",          cobertura);

        // ── CAPTCHA para el módulo de consulta pública ────────────
        String captchaText = CaptchaGenerator.generarTextoCaptcha();
        request.getSession().setAttribute("captchaText", captchaText);
        request.setAttribute("captchaText", captchaText);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // El cambio de idioma llega por POST desde el selector
        request.setCharacterEncoding("UTF-8");
        String lang = request.getParameter("lang");
        if (lang != null && (lang.equals("es") || lang.equals("en") || lang.equals("it"))) {
            request.getSession().setAttribute("lang", lang);
        }
        response.sendRedirect(request.getContextPath() + "/index");
    }
}