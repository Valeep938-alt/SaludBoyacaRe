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
import co.sena.cimm.adso.saludboyaca.util.OTPService;

@WebServlet(name = "OTPServlet", urlPatterns = {"/otp"})
public class OTPServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otpCodigo") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String email = (String) session.getAttribute("otpEmail");
        request.setAttribute("emailMasked", enmascararEmail(email));
        // CORREGIDO: Ruta correcta según tu estructura
        request.getRequestDispatcher("/WEB-INF/views/otp_verificacion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String codigoIngresado = request.getParameter("otpCodigo");
        String codigoSesion = (String) session.getAttribute("otpCodigo");
        long timestamp = (Long) session.getAttribute("otpTimestamp");
        Integer usuarioId = (Integer) session.getAttribute("usuarioId");
        
        String lang = (String) session.getAttribute("lang");
        if (lang == null) lang = "es";
        ResourceBundle rb = ResourceBundle.getBundle("messages", new Locale(lang));
        
        // Validar OTP
        if (OTPService.esValido(codigoIngresado, codigoSesion, timestamp)) {
            
            // Marcar como usado en BD
            OTPTokenDAO otpDAO = new OTPTokenDAO();
            otpDAO.marcarUsadoPorCodigo(codigoSesion, usuarioId);
            
            // Marcar sesión como verificada
            session.setAttribute("otpVerificado", true);
            session.removeAttribute("otpCodigo");
            session.removeAttribute("otpTimestamp");
            
            response.sendRedirect(request.getContextPath() + "/dashboard");
            
        } else {
            request.setAttribute("error", rb.getString("otp.error"));
            String email = (String) session.getAttribute("otpEmail");
            request.setAttribute("emailMasked", enmascararEmail(email));
            // CORREGIDO: Ruta correcta
            request.getRequestDispatcher("/WEB-INF/views/otp_verificacion.jsp").forward(request, response);
        }
    }
    
    private String enmascararEmail(String email) {
        if (email == null || !email.contains("@")) return "***";
        String[] partes = email.split("@");
        String local = partes[0];
        String dominio = partes[1];
        if (local.length() <= 3) return local + "***@" + dominio;
        return local.substring(0, 3) + "***@" + dominio;
    }
}