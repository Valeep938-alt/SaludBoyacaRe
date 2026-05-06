package co.sena.cimm.adso.saludboyaca.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.model.Paciente;
import co.sena.cimm.adso.saludboyaca.model.Usuario;

@WebServlet(name = "PacienteServlet", urlPatterns = {"/pacientes/*"})
@MultipartConfig(maxFileSize = 2 * 1024 * 1024) // 2MB max
public class PacienteServlet extends HttpServlet {
    
    private PacienteDAO pacienteDAO;
    
    @Override
    public void init() throws ServletException {
        pacienteDAO = new PacienteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        
        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (!verificarAcceso(usuario, session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getPathInfo();
        if (action == null) action = "/listar";
        
        switch (action) {
            case "/listar":
                listar(request, response);
                break;
            case "/nuevo":
                if (!usuario.isEnfermero()) {
                    // CORREGIDO: Ruta correcta
                    request.getRequestDispatcher("/WEB-INF/views/pacientes/formulario.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/pacientes/listar");
                }
                break;
            case "/editar":
                if (!usuario.isEnfermero()) {
                    editar(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/pacientes/listar");
                }
                break;
            case "/eliminar":
                if (usuario.isRecepcionista()) {
                    eliminar(request, response);
                } else {
                    listar(request, response);
                }
                break;
            default:
                listar(request, response);
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
        if (action == null) action = "/guardar";
        
        switch (action) {
            case "/guardar":
                if (!usuario.isEnfermero()) {
                    guardar(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/pacientes/listar");
                }
                break;
            case "/actualizar":
                if (!usuario.isEnfermero()) {
                    actualizar(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/pacientes/listar");
                }
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/pacientes/listar");
        }
    }
    
    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Paciente> pacientes = pacienteDAO.listarTodos();
        request.setAttribute("pacientes", pacientes);
        // CORREGIDO: Ruta correcta
        request.getRequestDispatcher("/WEB-INF/views/pacientes/lista.jsp").forward(request, response);
    }
    
    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Paciente paciente = pacienteDAO.buscarPorId(id);
        request.setAttribute("paciente", paciente);
        request.setAttribute("modo", "editar");
        // CORREGIDO: Ruta correcta
        request.getRequestDispatcher("/WEB-INF/views/pacientes/formulario.jsp").forward(request, response);
    }
    
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        pacienteDAO.eliminar(id);
        // CORREGIDO: Redirigir al servlet, no al JSP
        response.sendRedirect(request.getContextPath() + "/pacientes/listar");
    }
    
    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Paciente p = new Paciente();
        p.setNombres(request.getParameter("nombres"));
        p.setApellidos(request.getParameter("apellidos"));
        p.setDocumento(request.getParameter("documento"));
        p.setFechaNacimiento(Date.valueOf(request.getParameter("fechaNacimiento")));
        p.setTelefono(request.getParameter("telefono"));
        p.setEmail(request.getParameter("email"));
        p.setEps(request.getParameter("eps"));
        p.setVeredaBarrio(request.getParameter("veredaBarrio"));
        
        boolean insertado = pacienteDAO.insertar(p);
        
        // Guardar foto si se subió
        if (insertado && p.getId() > 0) {
            procesarFoto(request, response, p.getId());
        }
        
        response.sendRedirect(request.getContextPath() + "/pacientes/listar");
    }
    
    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Paciente p = new Paciente();
        p.setId(Integer.parseInt(request.getParameter("id")));
        p.setNombres(request.getParameter("nombres"));
        p.setApellidos(request.getParameter("apellidos"));
        p.setDocumento(request.getParameter("documento"));
        p.setFechaNacimiento(Date.valueOf(request.getParameter("fechaNacimiento")));
        p.setTelefono(request.getParameter("telefono"));
        p.setEmail(request.getParameter("email"));
        p.setEps(request.getParameter("eps"));
        p.setVeredaBarrio(request.getParameter("veredaBarrio"));
        
        pacienteDAO.actualizar(p);
        
        // Actualizar foto si se subió una nueva
        procesarFoto(request, response, p.getId());
        
        response.sendRedirect(request.getContextPath() + "/pacientes/listar");
    }
    
    private void procesarFoto(HttpServletRequest request, HttpServletResponse response, int idPaciente)
            throws ServletException, IOException {
        try {
            Part filePart = request.getPart("foto");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = "paciente_" + idPaciente + "_" + System.currentTimeMillis() + ".jpg";
                String uploadPath = getServletContext().getRealPath("/resources/img/pacientes/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + fileName);
                String fotoUrl = request.getContextPath() + "/resources/img/pacientes/" + fileName;
                pacienteDAO.actualizarFoto(idPaciente, fotoUrl);
            }
        } catch (Exception e) {
            System.err.println("Error al procesar foto paciente: " + e.getMessage());
        }
    }
    
    private boolean verificarAcceso(Usuario usuario, HttpSession session) {
        return usuario != null 
            && Boolean.TRUE.equals(session.getAttribute("otpVerificado"))
            && (usuario.isMedico() || usuario.isRecepcionista() || usuario.isEnfermero());
    }
}