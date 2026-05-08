<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:requestEncoding value="UTF-8"/>

<c:choose>
    <c:when test="${not empty param.lang}">
        <c:set var="currentLang" value="${param.lang}" scope="session"/>
    </c:when>
    <c:when test="${not empty sessionScope.lang}">
        <c:set var="currentLang" value="${sessionScope.lang}" scope="page"/>
    </c:when>
    <c:otherwise>
        <c:set var="currentLang" value="es" scope="session"/>
    </c:otherwise>
</c:choose>

<c:set var="lang" value="${currentLang}" scope="session"/>
<fmt:setLocale value="${currentLang}" scope="session"/>
<fmt:setBundle basename="messages"/>
<% request.setAttribute("currentPage", "citas"); %>

<!DOCTYPE html>
<html lang="${currentLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="cita.titulo"/> · SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lato:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        <%@ include file="/WEB-INF/views/componentes/sidebar-styles.css" %>

        .search-box { position: relative; flex: 1; max-width: 400px; }
        .search-box i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); font-size: 0.9rem; }
        .search-box input { width: 100%; padding: 10px 14px 10px 38px; border: 2px solid var(--border-light); border-radius: 10px; font-size: 0.9rem; color: var(--text-dark); background: var(--white); transition: all 0.2s; }
        .search-box input:focus { outline: none; border-color: var(--wine-mid); box-shadow: 0 0 0 3px rgba(86,28,36,0.1); }
        .search-box input::placeholder { color: var(--text-muted); }
        .filtro-activo { background: var(--wine-deep) !important; color: white !important; border-color: var(--wine-deep) !important; }
        .sin-resultados { text-align: center; padding: 40px 20px; color: var(--text-muted); }
        .sin-resultados i { font-size: 3rem; color: var(--warm-gray); margin-bottom: 12px; }
        .badge-programada { background: rgba(212,137,26,0.12); color: #b07200; border: 1px solid rgba(212,137,26,0.3); padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }
        .badge-confirmada { background: rgba(46,125,80,0.12); color: #1e6640; border: 1px solid rgba(46,125,80,0.3); padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }
        .badge-atendida   { background: rgba(26,109,158,0.12); color: #0f5073; border: 1px solid rgba(26,109,158,0.3); padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }
        .badge-cancelada  { background: rgba(180,30,30,0.1); color: #8B0000; border: 1px solid rgba(180,30,30,0.25); padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/views/componentes/sidebar.jsp" %>

    <div class="main-wrapper" id="mainWrapper">
        <div class="topbar">
            <div>
                <div class="topbar-title">
                    <i class="fas fa-calendar-check me-2" style="color:var(--wine-mid);"></i>
                    <fmt:message key="cita.titulo"/>
                </div>
                <div class="topbar-breadcrumb">SaludBoyacá &rsaquo; <fmt:message key="nav.citas"/></div>
            </div>
            <div class="topbar-actions">
                <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
                    <a href="${pageContext.request.contextPath}/citas/nueva" class="btn-wine">
                        <i class="fas fa-plus"></i> <fmt:message key="cita.nueva"/>
                    </a>
                </c:if>
            </div>
        </div>

        <div class="page-content">

            <!-- Barra de filtros y búsqueda -->
            <div class="card-salud mb-4" style="border:none; background:var(--white);">
                <div style="padding:14px 20px; display:flex; gap:12px; flex-wrap:wrap; align-items:center; justify-content:space-between;">
                    <div style="display:flex; gap:8px; flex-wrap:wrap; align-items:center; flex:1;">
                        <span style="font-size:0.82rem; color:var(--text-muted); font-weight:600;">
                            <i class="fas fa-filter me-1"></i><fmt:message key="cita.filtrar"/>
                        </span>
                        <button class="filtro-btn filtro-activo" data-filtro="todos"><fmt:message key="cita.filtro.todos"/></button>
                        <button class="filtro-btn" data-filtro="hoy"><fmt:message key="dashboard.citas.hoy"/></button>
                        <button class="filtro-btn" data-filtro="semana"><fmt:message key="dashboard.citas.semana"/></button>
                    </div>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="buscarCita"
                               placeholder="<fmt:message key='paciente.buscar.placeholder'/>">
                    </div>
                </div>
            </div>

            <div class="card-salud">
                <div class="card-header-salud">
                    <span>
                        <i class="fas fa-list me-2"></i><fmt:message key="cita.listado"/>
                    </span>
                    <span id="contadorCitas" style="font-size:0.8rem; opacity:0.8;"></span>
                </div>
                <div class="table-responsive">
                    <table class="table table-salud" id="tablaCitas">
                        <thead>
                            <tr>
                                <th><fmt:message key="cita.numero"/></th>
                                <th><fmt:message key="cita.col.fecha"/></th>
                                <th><fmt:message key="cita.col.hora"/></th>
                                <th><fmt:message key="cita.col.paciente"/></th>
                                <th><fmt:message key="cita.col.medico"/></th>
                                <th><fmt:message key="cita.col.especialidad"/></th>
                                <th><fmt:message key="cita.col.estado"/></th>
                                <th><fmt:message key="cita.col.acciones"/></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cita" items="${citas}">
                                <tr data-paciente="${cita.nombrePaciente}"
                                    data-medico="${cita.nombreMedico}"
                                    data-especialidad="${cita.nombreEspecialidad}"
                                    data-fecha="${cita.fechaCita}"
                                    data-estado="${cita.estado}">

                                    <td>
                                        <span style="font-family:'Playfair Display',serif; color:var(--wine-mid); font-weight:700;">
                                            #${cita.id}
                                        </span>
                                    </td>
                                    <td>
                                        <i class="far fa-calendar me-1" style="color:var(--warm-gray);"></i>
                                        ${cita.fechaCita}
                                    </td>
                                    <td>
                                        <i class="far fa-clock me-1" style="color:var(--warm-gray);"></i>
                                        ${cita.horaCita}
                                    </td>
                                    <td>${cita.nombrePaciente}</td>
                                    <td>${cita.nombreMedico}</td>
                                    <td><span class="badge-eps">${cita.nombreEspecialidad}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${cita.estado == 'PROGRAMADA'}">
                                                <span class="badge-programada"><fmt:message key="cita.estado.programada"/></span>
                                            </c:when>
                                            <c:when test="${cita.estado == 'CONFIRMADA'}">
                                                <span class="badge-confirmada"><fmt:message key="cita.estado.confirmada"/></span>
                                            </c:when>
                                            <c:when test="${cita.estado == 'ATENDIDA'}">
                                                <span class="badge-atendida"><fmt:message key="cita.estado.atendida"/></span>
                                            </c:when>
                                            <c:when test="${cita.estado == 'CANCELADA'}">
                                                <span class="badge-cancelada"><fmt:message key="cita.estado.cancelada"/></span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex gap-1 flex-wrap">
                                            <a href="${pageContext.request.contextPath}/citas/detalle?id=${cita.id}"
                                               class="btn-action btn-act-view"
                                               title="<fmt:message key='cita.accion.ver'/>">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA' && cita.estado == 'PROGRAMADA'}">
                                                <a href="${pageContext.request.contextPath}/citas/editar?id=${cita.id}"
                                                   class="btn-action btn-act-view"
                                                   title="<fmt:message key='cita.accion.editar'/>">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${(sessionScope.usuarioRol == 'MEDICO' || sessionScope.usuarioRol == 'RECEPCIONISTA') && cita.estado == 'PROGRAMADA'}">
                                                <a href="${pageContext.request.contextPath}/citas/confirmar?id=${cita.id}"
                                                    class="btn-action btn-act-confirm"
                                                    title="<fmt:message key='cita.accion.confirmar'/>">
                                                    <i class="fas fa-check"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${sessionScope.usuarioRol == 'MEDICO' && cita.estado == 'CONFIRMADA'}">
                                                <a href="${pageContext.request.contextPath}/citas/atender?id=${cita.id}"
                                                   class="btn-action btn-act-attend"
                                                   title="<fmt:message key='cita.accion.atender'/>">
                                                    <i class="fas fa-stethoscope"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${(sessionScope.usuarioRol == 'MEDICO' || sessionScope.usuarioRol == 'RECEPCIONISTA') && cita.estado != 'CANCELADA' && cita.estado != 'ATENDIDA'}">
                                                <a href="${pageContext.request.contextPath}/citas/cancelar?id=${cita.id}"
                                                   class="btn-action btn-act-cancel"
                                                   title="<fmt:message key='cita.accion.cancelar'/>"
                                                   onclick="return confirm('<fmt:message key="cita.confirmar.cancelar"/>')">
                                                    <i class="fas fa-times"></i>
                                                </a>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/citas/pdf?id=${cita.id}"
                                               class="btn-action btn-act-pdf"
                                               title="<fmt:message key='cita.accion.pdf'/>">
                                                <i class="fas fa-file-pdf"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div id="sinResultados" class="sin-resultados" style="display:none;">
                        <i class="fas fa-search"></i><br>
                        <fmt:message key="cita.sin.registros"/>
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

        const tabla         = document.getElementById('tablaCitas');
        const filas         = tabla.querySelectorAll('tbody tr');
        const contador      = document.getElementById('contadorCitas');
        const sinResultados = document.getElementById('sinResultados');
        const inputBuscar   = document.getElementById('buscarCita');
        const botonesFiltro = document.querySelectorAll('.filtro-btn');

        let filtroPeriodo = 'todos';
        let textoBusqueda = '';

        function actualizarContador() {
            const visibles = tabla.querySelectorAll('tbody tr:not([style*="none"])').length;
            contador.textContent = visibles + ' <fmt:message key="dashboard.citas.label"/>';
            sinResultados.style.display = visibles === 0 ? 'block' : 'none';
            tabla.style.display         = visibles === 0 ? 'none'  : 'table';
        }

        function filtrar() {
            const hoy = new Date().toISOString().split('T')[0];
            const termino = textoBusqueda.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
            
            filas.forEach(fila => {
                const paciente     = (fila.dataset.paciente     || '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
                const medico       = (fila.dataset.medico       || '').toLowerCase();
                const especialidad = (fila.dataset.especialidad || '').toLowerCase();
                const fecha        = fila.dataset.fecha || '';
                const estado       = fila.dataset.estado || '';
                
                let pasaPeriodo = true;
                if (filtroPeriodo === 'hoy') pasaPeriodo = fecha === hoy;
                else if (filtroPeriodo === 'semana') {
                    const d = new Date(fecha);
                    const hoyDate = new Date();
                    const diff = Math.ceil((d - hoyDate) / (1000 * 60 * 60 * 24));
                    pasaPeriodo = diff >= 0 && diff <= 7;
                }
                
                let pasaTexto = !termino || paciente.includes(termino) || medico.includes(termino) || especialidad.includes(termino);
                fila.style.display = (pasaPeriodo && pasaTexto) ? '' : 'none';
            });
            actualizarContador();
        }

        botonesFiltro.forEach(btn => {
            btn.addEventListener('click', () => {
                botonesFiltro.forEach(b => b.classList.remove('filtro-activo'));
                btn.classList.add('filtro-activo');
                filtroPeriodo = btn.dataset.filtro;
                filtrar();
            });
        });

        inputBuscar.addEventListener('input', e => { textoBusqueda = e.target.value; filtrar(); });
        actualizarContador();
    </script>
    <%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
</body>
</html>