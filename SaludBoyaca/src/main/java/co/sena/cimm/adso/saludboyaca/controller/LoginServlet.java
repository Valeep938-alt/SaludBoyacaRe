package co.sena.cimm.adso.saludboyaca.controller;

import java.io.IOException;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.dao.OTPTokenDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.model.Usuario;
import co.sena.cimm.adso.saludboyaca.util.OTPService;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null 
            && Boolean.TRUE.equals(session.getAttribute("otpVerificado"))) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        // CORREGIDO: Ruta correcta según tu estructura
        request.getRequestDispatcher("/WEB-INF/views/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        HttpSession session = request.getSession();
        String lang = (String) session.getAttribute("lang");
        if (lang == null) lang = "es";
        
        ResourceBundle rb = ResourceBundle.getBundle("messages", new Locale(lang));
        
        // Validar credenciales
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.validarLogin(username, password);
        
        if (usuario != null && usuario.isActivo()) {
            // Generar OTP
            String otp = OTPService.generarOTP();
            long timestamp = System.currentTimeMillis();
            
            // Guardar OTP en BD (tabla otp_tokens)
            OTPTokenDAO otpDAO = new OTPTokenDAO();
            java.util.Date expira = new java.util.Date(timestamp + (5 * 60 * 1000)); // 5 min
            co.sena.cimm.adso.saludboyaca.model.OTPToken token = new co.sena.cimm.adso.saludboyaca.model.OTPToken();
            token.setIdUsuario(usuario.getId());
            token.setCodigo(otp);
            token.setExpiraEn(expira);
            token.setUsado(false);
            otpDAO.insertar(token);
            
            // Guardar en sesión
            session.setAttribute("usuario", usuario);
            session.setAttribute("usuarioId", usuario.getId());
            session.setAttribute("usuarioNombre", usuario.getNombreCompleto());
            session.setAttribute("usuarioRol", usuario.getRol());
            session.setAttribute("otpCodigo", otp);
            session.setAttribute("otpTimestamp", timestamp);
            session.setAttribute("otpEmail", usuario.getEmail());
            session.setAttribute("otpVerificado", false);
            
            // Enviar OTP por correo
            try {
                String asunto = rb.getString("otp.email.asunto");
                String cuerpo = java.text.MessageFormat.format(rb.getString("otp.email.cuerpo"), otp);
                OTPService.enviarOTP(usuario.getEmail(), otp, asunto, cuerpo);
            } catch (Exception ex) {
                System.err.println("Error enviando OTP: " + ex.getMessage());
            }
            
            response.sendRedirect(request.getContextPath() + "/otp");
            
        } else {
            request.setAttribute("error", rb.getString("login.error.credenciales"));
            // CORREGIDO: Ruta correcta
            request.getRequestDispatcher("/WEB-INF/views/Login.jsp").forward(request, response);
        }
    }
}