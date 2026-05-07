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
    private CitaDAO citaDAO;
    private EspecialidadDAO especialidadDAO;

    @Override
    public void init() throws ServletException {
        pacienteDAO = new PacienteDAO();
        citaDAO = new CitaDAO();
        especialidadDAO = new EspecialidadDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // ── Stats desde la BD (con protección) ─────────────────────────────────────
        int totalPacientes = 0;
        int totalCitas = 0;
        int totalEspecialidades = 0;
        int cobertura = 0;

        try {
            totalPacientes = pacienteDAO.contar();
            totalCitas = citaDAO.contarPorEstado("ATENDIDA");
            totalEspecialidades = especialidadDAO.listarTodos().size();

            int totalNoCanc = totalCitas
                    + citaDAO.contarPorEstado("PROGRAMADA")
                    + citaDAO.contarPorEstado("CONFIRMADA");
            cobertura = totalNoCanc > 0 ? (int) Math.round(totalCitas * 100.0 / totalNoCanc) : 0;

        } catch (Exception e) {
            System.err.println("Error cargando stats del dashboard: " + e.getMessage());
            // La página carga igual, solo con valores en 0
        }

        request.setAttribute("totalPacientes", totalPacientes);
        request.setAttribute("totalCitas", totalCitas);
        request.setAttribute("totalEspecialidades", totalEspecialidades);
        request.setAttribute("cobertura", cobertura);

        // ── CAPTCHA ────────────────────────────────────────────────────────────────
        String captchaText = CaptchaGenerator.generarTextoCaptcha();
        request.getSession().setAttribute("captchaText", captchaText);
        request.setAttribute("captchaText", captchaText);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
