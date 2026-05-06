package co.sena.cimm.adso.saludboyaca.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;

// ✅ Acepta ambas rutas: /foto/* y /resources/img/pacientes/*
@WebServlet(name = "FotoServlet", urlPatterns = {"/foto/*", "/resources/img/pacientes/*"})
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class FotoServlet extends HttpServlet {

    private PacienteDAO pacienteDAO;

    @Override
    public void init() throws ServletException {
        pacienteDAO = new PacienteDAO();
    }

    // ── GET: SERVIR IMAGEN ───────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        String fileName;
        
        // Extraer nombre del archivo según la ruta usada
        if (path.startsWith("/foto/")) {
            fileName = path.substring("/foto/".length());
        } else if (path.startsWith("/resources/img/pacientes/")) {
            fileName = path.substring("/resources/img/pacientes/".length());
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Ruta no válida");
            return;
        }
        
        // Sanitizar: evitar path traversal
        if (fileName.contains("..") || fileName.contains("\\") || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Nombre de archivo inválido");
            return;
        }
        
        // Ruta física
        String uploadPath = getServletContext().getRealPath("/resources/img/pacientes/");
        File file = new File(uploadPath, fileName);
        
        // Verificar que esté dentro del directorio permitido
        String canonicalPath = file.getCanonicalPath();
        String canonicalBase = new File(uploadPath).getCanonicalPath();
        if (!canonicalPath.startsWith(canonicalBase)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado");
            return;
        }
        
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Imagen no encontrada: " + fileName);
            return;
        }
        
        // Content-Type
        String lowerName = fileName.toLowerCase();
        String contentType;
        if (lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg")) {
            contentType = "image/jpeg";
        } else if (lowerName.endsWith(".png")) {
            contentType = "image/png";
        } else if (lowerName.endsWith(".gif")) {
            contentType = "image/gif";
        } else {
            contentType = "application/octet-stream";
        }
        
        response.setContentType(contentType);
        response.setContentLength((int) file.length());
        response.setHeader("Cache-Control", "public, max-age=86400");
        
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }

    // ── POST: SUBIR IMAGEN ───────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
        Part filePart = request.getPart("foto");

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = "paciente_" + idPaciente + "_" + System.currentTimeMillis() + ".jpg";
            
            String uploadPath = getServletContext().getRealPath("/resources/img/pacientes/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            filePart.write(uploadPath + File.separator + fileName);
            
            // ✅ Guardar con la nueva ruta /foto/ (para futuras fotos)
            String fotoUrl = "/foto/" + fileName;
            pacienteDAO.actualizarFoto(idPaciente, fotoUrl);
            
            System.out.println("Foto guardada en: " + uploadPath + File.separator + fileName);
            System.out.println("URL guardada en BD: " + fotoUrl);
        }

        response.sendRedirect(request.getContextPath() + "/pacientes/listar");
    }
}