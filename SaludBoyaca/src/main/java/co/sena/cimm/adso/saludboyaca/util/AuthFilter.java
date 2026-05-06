package co.sena.cimm.adso.saludboyaca.util;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import co.sena.cimm.adso.saludboyaca.model.Usuario;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/dashboard/*", "/pacientes/*", "/citas/*", "/horarios/*", "/usuarios/*"})
public class AuthFilter implements Filter {

    // Rutas excluidas del filtro (públicas o que no requieren OTP verificado aún)
    private static final List<String> RUTAS_EXCLUIDAS = Arrays.asList(
        "/login", "/otp", "/consulta-cita", "/logout",
        "/resources/", "/css/", "/js/", "/images/", "/foto/", 
        "/citas/pdf"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String ruta = uri.substring(contextPath.length());

        // Verificar si la ruta está excluida
        for (String excluida : RUTAS_EXCLUIDAS) {
            if (ruta.startsWith(excluida)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // Verificar que haya sesión
        if (session == null || session.getAttribute("usuario") == null) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Verificar OTP verificado
        Boolean otpVerificado = (Boolean) session.getAttribute("otpVerificado");
        if (!Boolean.TRUE.equals(otpVerificado)) {
            res.sendRedirect(contextPath + "/otp");
            return;
        }

        // Verificar rol para rutas específicas (opcional - ya se valida en cada Servlet)
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String rol = usuario.getRol();

        // Rutas específicas por rol (protección adicional)
        if (ruta.startsWith("/usuarios/") && !"RECEPCIONISTA".equals(rol)) {
            res.sendRedirect(contextPath + "/dashboard");
            return;
        }

        // Todo OK, continuar
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
