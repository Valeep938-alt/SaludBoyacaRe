package co.sena.cimm.adso.saludboyaca.util;

import java.io.IOException;

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

@WebFilter("/*")
public class LocaleFilter implements Filter {

    private static final String[] IDIOMAS_VALIDOS = {"es", "en", "it"};

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // ── 1. Cambio de idioma ──────────────────────────────────────────────
        String langParam = req.getParameter("lang");

        if (langParam != null && esIdiomaValido(langParam)) {

            HttpSession session = req.getSession(false);
            if (session == null) {
                session = req.getSession();
            }
            session.setAttribute("lang", langParam);

            // Reconstruir la URL sin el parámetro lang
            String uri   = req.getRequestURI();
            String query = req.getQueryString(); // ¡PUEDE SER NULL!

            String destino = uri;

            // ✅ PROTECCIÓN NULL AÑADIDA
            if (query != null && !query.isEmpty()) {
                // Eliminar lang=valor (puede venir al inicio, en medio o al final)
                query = query.replaceAll("(^|&)lang=[^&]*", "");
                // Limpiar & huérfano al inicio
                query = query.replaceAll("^&+", "");

                if (!query.isEmpty()) {
                    destino = uri + "?" + query;
                }
            }

            resp.sendRedirect(destino);
            return;
        }

        // ── 2. Idioma por defecto si no hay ninguno en sesión ────────────────
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("lang") == null) {
            session.setAttribute("lang", "es");
        }

        chain.doFilter(request, response);
    }

    private boolean esIdiomaValido(String lang) {
        for (String v : IDIOMAS_VALIDOS) {
            if (v.equals(lang)) return true;
        }
        return false;
    }

    @Override
    public void destroy() {}
}