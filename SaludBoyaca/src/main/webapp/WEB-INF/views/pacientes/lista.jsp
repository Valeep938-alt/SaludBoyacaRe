<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:requestEncoding value="UTF-8"/>

<c:choose>
    <c:when test="${not empty param.lang}">
        <c:set var="currentLang" value="${param.lang}" scope="session"/>
    </c:when>
    <c:when test="${not empty sessionScope.lang}">
        <c:set var="currentLang" value="${sessionScope.lang}" scope="session"/>
    </c:when>
    <c:otherwise>
        <c:set var="currentLang" value="es" scope="session"/>
    </c:otherwise>
</c:choose>

<fmt:setLocale value="${currentLang}" scope="session"/>
<fmt:setBundle basename="messages"/>
<% request.setAttribute("currentPage", "pacientes"); %>

<!DOCTYPE html>
<html lang="${currentLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="paciente.titulo"/> · SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lato:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        .search-box { position: relative; flex: 1; max-width: 400px; }
        .search-box i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 0.9rem; }
        .search-box input { width: 100%; padding: 10px 14px 10px 38px; border: 2px solid var(--border-light); border-radius: 10px; font-size: 0.9rem; color: var(--text-dark); background: var(--white); transition: all 0.2s; }
        .search-box input:focus { outline: none; border-color: var(--wine-mid); box-shadow: 0 0 0 3px rgba(86,28,36,0.1); }
        .search-box input::placeholder { color: var(--text-muted); }
        .filtro-btn { padding: 6px 14px; border-radius: 20px; border: 2px solid var(--border-light); background: var(--white); color: var(--text-muted); font-size: 0.8rem; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .filtro-btn:hover { border-color: var(--wine-mid); color: var(--wine-mid); }
        .filtro-activo { background: var(--wine-deep) !important; color: white !important; border-color: var(--wine-deep) !important; }
        .sin-resultados { text-align: center; padding: 40px 20px; color: var(--text-muted); }
        .sin-resultados i { font-size: 3rem; color: var(--warm-gray); margin-bottom: 12px; }
        .badge-eps { background: var(--cream); color: var(--wine-deep); padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; border: 1px solid var(--border-light); }
        .foto-avatar { width: 42px; height: 42px; object-fit: cover; border-radius: 50%; border: 2px solid var(--wine-mid); }
        .foto-avatar-placeholder { display: inline-flex; align-items: center; justify-content: center; width: 42px; height: 42px; border-radius: 50%; background: var(--cream); border: 2px solid var(--border-light); color: var(--wine-mid); font-size: 1rem; }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/views/componentes/sidebar.jsp" %>

    <div class="main-wrapper" id="mainWrapper">
        <div class="topbar">
            <div>
                <div class="topbar-title">
                    <i class="fas fa-users me-2" style="color:var(--wine-mid);"></i>
                    <fmt:message key="paciente.titulo"/>
                </div>
                <div class="topbar-breadcrumb">SaludBoyacá &rsaquo; <fmt:message key="nav.pacientes"/></div>
            </div>
            <div class="topbar-actions">
                <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                    <a href="${pageContext.request.contextPath}/pacientes/nuevo" class="btn-wine">
                        <i class="fas fa-plus"></i> <fmt:message key="paciente.nuevo"/>
                    </a>
                </c:if>
            </div>
        </div>

        <div class="page-content">

            <div class="card-salud mb-4" style="border:none; background:var(--white);">
                <div style="padding:14px 20px; display:flex; gap:12px; flex-wrap:wrap; align-items:center; justify-content:space-between;">
                    <div style="display:flex; gap:8px; flex-wrap:wrap; align-items:center; flex:1;">
                        <span style="font-size:0.82rem; color:var(--text-muted); font-weight:600;">
                            <i class="fas fa-filter me-1"></i><fmt:message key="paciente.filtrar"/>
                        </span>
                        <button class="filtro-btn filtro-activo" data-filtro="todos"><fmt:message key="cita.filtro.todos"/></button>
                        <button class="filtro-btn" data-filtro="A">A-M</button>
                        <button class="filtro-btn" data-filtro="N">N-Z</button>
                    </div>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="buscarPaciente"
                               placeholder="<fmt:message key='paciente.buscar.placeholder'/>">
                    </div>
                </div>
            </div>

            <div class="card-salud">
                <div class="card-header-salud">
                    <span>
                        <i class="fas fa-list me-2"></i><fmt:message key="paciente.listado"/>
                    </span>
                    <span id="contadorPacientes" style="font-size:0.8rem; opacity:0.8;"></span>
                </div>
                <div class="table-responsive">
                    <table class="table table-salud" id="tablaPacientes">
                        <thead>
                            <tr>
                                <th style="width:60px;"><fmt:message key="paciente.col.foto"/></th>
                                <th><fmt:message key="paciente.col.documento"/></th>
                                <th><fmt:message key="paciente.col.nombres"/></th>
                                <th><fmt:message key="paciente.col.apellidos"/></th>
                                <th><fmt:message key="paciente.col.nacimiento"/></th>
                                <th><fmt:message key="paciente.col.telefono"/></th>
                                <th><fmt:message key="paciente.col.eps"/></th>
                                <th><fmt:message key="paciente.col.acciones"/></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="paciente" items="${pacientes}">
                                <tr data-nombre="${paciente.nombres} ${paciente.apellidos}"
                                    data-documento="${paciente.documento}"
                                    data-eps="${paciente.eps}">

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty paciente.fotoUrl}">
                                                <img src="${pageContext.request.contextPath}${paciente.fotoUrl}"
                                                     alt="<fmt:message key='paciente.col.foto'/>" class="foto-avatar">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="foto-avatar-placeholder">
                                                    <i class="fas fa-user"></i>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <span style="font-family:'Playfair Display',serif; color:var(--wine-mid); font-weight:700;">
                                            ${paciente.documento}
                                        </span>
                                    </td>
                                    <td>${paciente.nombres}</td>
                                    <td>${paciente.apellidos}</td>
                                    <td>
                                        <i class="far fa-calendar me-1" style="color:var(--warm-gray);"></i>
                                        ${paciente.fechaNacimiento}
                                    </td>
                                    <td>
                                        <i class="fas fa-phone me-1" style="color:var(--warm-gray);"></i>
                                        ${not empty paciente.telefono ? paciente.telefono : '-'}
                                    </td>
                                    <td><span class="badge-eps">${paciente.eps}</span></td>
                                    <td>
                                        <div class="d-flex gap-1 flex-wrap">
                                            <c:if test="${sessionScope.usuarioRol != 'ENFERMERO'}">
                                                <a href="${pageContext.request.contextPath}/pacientes/editar?id=${paciente.id}"
                                                   class="btn-action btn-act-view"
                                                   title="<fmt:message key='paciente.editar'/>">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                                                <a href="${pageContext.request.contextPath}/pacientes/eliminar?id=${paciente.id}"
                                                   class="btn-action btn-act-cancel"
                                                   title="<fmt:message key='paciente.eliminar'/>"
                                                   onclick="return confirm('<fmt:message key="paciente.confirmar"/>')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div id="sinResultados" class="sin-resultados" style="display:none;">
                        <i class="fas fa-search"></i><br>
                        <fmt:message key="paciente.sin.resultados"/>
                    </div>
                </div>
            </div>
        </div>

        <footer class="footer-salud"><fmt:message key="app.footer"/></footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('sidebarToggle').addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('collapsed');
            document.getElementById('mainWrapper').classList.toggle('expanded');
        });

        const tabla         = document.getElementById('tablaPacientes');
        const filas         = tabla.querySelectorAll('tbody tr');
        const contador      = document.getElementById('contadorPacientes');
        const sinResultados = document.getElementById('sinResultados');
        const inputBuscar   = document.getElementById('buscarPaciente');
        const botonesFiltro = document.querySelectorAll('.filtro-btn');

        let filtroLetra   = 'todos';
        let textoBusqueda = '';

        function actualizarContador() {
            const visibles = tabla.querySelectorAll('tbody tr:not([style*="none"])').length;
            contador.textContent = visibles + ' pacientes';
            sinResultados.style.display = visibles === 0 ? 'block' : 'none';
            tabla.style.display         = visibles === 0 ? 'none'  : 'table';
        }

        function filtrar() {
            const termino = textoBusqueda.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
            filas.forEach(fila => {
                const nombre    = (fila.dataset.nombre    || '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
                const documento = (fila.dataset.documento || '').toLowerCase();
                const eps       = (fila.dataset.eps       || '').toLowerCase();
                const primera   = nombre.charAt(0);
                let pasaLetra = true;
                if (filtroLetra === 'A') pasaLetra = primera >= 'a' && primera <= 'm';
                else if (filtroLetra === 'N') pasaLetra = primera >= 'n' && primera <= 'z';
                const pasaTexto = !termino || nombre.includes(termino) || documento.includes(termino) || eps.includes(termino);
                fila.style.display = (pasaLetra && pasaTexto) ? '' : 'none';
            });
            actualizarContador();
        }

        botonesFiltro.forEach(btn => {
            btn.addEventListener('click', () => {
                botonesFiltro.forEach(b => b.classList.remove('filtro-activo'));
                btn.classList.add('filtro-activo');
                filtroLetra = btn.dataset.filtro;
                filtrar();
            });
        });

        inputBuscar.addEventListener('input', e => { textoBusqueda = e.target.value; filtrar(); });
        actualizarContador();
    </script>
    <%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
</body>
</html>