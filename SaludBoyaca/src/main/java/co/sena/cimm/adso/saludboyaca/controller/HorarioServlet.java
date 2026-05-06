package co.sena.cimm.adso.saludboyaca.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.dao.HorarioDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.model.Usuario;

@WebServlet(name = "HorarioServlet", urlPatterns = {"/horarios/*"})
public class HorarioServlet extends HttpServlet {
    
    private HorarioDAO horarioDAO;
    private UsuarioDAO usuarioDAO;
    
    @Override
    public void init() throws ServletException {
        horarioDAO = new HorarioDAO();
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null || !Boolean.TRUE.equals(session.getAttribute("otpVerificado"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getPathInfo();
        if (action == null) action = "/listar";
        
        switch (action) {
            case "/listar":
                request.setAttribute("horarios", horarioDAO.listarTodos());
                request.setAttribute("medicos", usuarioDAO.listarMedicos());
                // CORREGIDO: Ruta correcta
                request.getRequestDispatcher("/WEB-INF/views/horarios/lista.jsp").forward(request, response);
                break;
            case "/medico":
                int idMedico = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("horarios", horarioDAO.listarPorMedico(idMedico));
                request.setAttribute("medico", usuarioDAO.buscarPorId(idMedico));
                // CORREGIDO: Ruta correcta
                request.getRequestDispatcher("/WEB-INF/views/horarios/lista.jsp").forward(request, response);
                break;
            default:
                request.setAttribute("horarios", horarioDAO.listarTodos());
                request.setAttribute("medicos", usuarioDAO.listarMedicos());
                // CORREGIDO: Ruta correcta
                request.getRequestDispatcher("/WEB-INF/views/horarios/lista.jsp").forward(request, response);
        }
    }
}