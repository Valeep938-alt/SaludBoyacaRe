<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>
<% request.setAttribute("currentPage", "horarios"); %>

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="nav.horarios"/> · SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lato:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        <%@ include file="/WEB-INF/views/componentes/sidebar-styles.css" %>

        .filter-bar { display:flex; gap:12px; flex-wrap:wrap; align-items:center; justify-content:space-between; }
        .filter-group { display:flex; gap:8px; flex-wrap:wrap; align-items:center; }
        .filter-select { padding:10px 14px; border:2px solid var(--border-light); border-radius:10px; font-size:0.9rem; color:var(--text-dark); background:var(--white); min-width:220px; cursor:pointer; transition:all 0.2s; }
        .filter-select:focus { outline:none; border-color:var(--wine-mid); box-shadow:0 0 0 3px rgba(86,28,36,0.1); }
        .search-box { position:relative; flex:1; max-width:300px; }
        .search-box i { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--text-muted); font-size:0.9rem; }
        .search-box input { width:100%; padding:10px 14px 10px 38px; border:2px solid var(--border-light); border-radius:10px; font-size:0.9rem; color:var(--text-dark); background:var(--white); transition:all 0.2s; }
        .search-box input:focus { outline:none; border-color:var(--wine-mid); box-shadow:0 0 0 3px rgba(86,28,36,0.1); }
        .search-box input::placeholder { color:var(--text-muted); }
        .dia-filtros { display:flex; gap:6px; flex-wrap:wrap; }
        .dia-btn { padding:6px 14px; border-radius:20px; font-size:0.8rem; font-weight:600; border:1px solid var(--border-light); background:var(--cream-light); color:var(--text-muted); cursor:pointer; transition:all 0.2s; }
        .dia-btn:hover { background:var(--cream); color:var(--wine-mid); }
        .dia-btn.active { background:var(--wine-deep); color:white; border-color:var(--wine-deep); }
        .badge-citas { background:var(--cream); color:var(--wine-deep); padding:4px 12px; border-radius:20px; font-size:0.85rem; font-weight:700; border:1px solid var(--border-light); }
        .disponibilidad-bar { width:100%; height:6px; background:var(--cream-light); border-radius:3px; overflow:hidden; margin-top:4px; }
        .disponibilidad-fill { height:100%; border-radius:3px; transition:width 0.4s ease; }
        .disponibilidad-fill.alta  { background:linear-gradient(90deg,var(--success),#3d8b5f); }
        .disponibilidad-fill.media { background:linear-gradient(90deg,var(--warning),#c47d1a); }
        .disponibilidad-fill.baja  { background:linear-gradient(90deg,var(--danger),#8b1515); }
        .sin-resultados { text-align:center; padding:40px 20px; color:var(--text-muted); }
        .sin-resultados i { font-size:3rem; color:var(--warm-gray); margin-bottom:12px; }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/views/componentes/sidebar.jsp" %>

    <div class="main-wrapper" id="mainWrapper">
        <div class="topbar">
            <div>
                <div class="topbar-title">
                    <i class="fas fa-clock me-2" style="color:var(--wine-mid);"></i>
                    <fmt:message key="nav.horarios"/>
                </div>
                <div class="topbar-breadcrumb">
                    SaludBoyacá &rsaquo;
                    <c:choose>
                        <c:when test="${sessionScope.lang == 'en'}">Schedules</c:when>
                        <c:when test="${sessionScope.lang == 'it'}">Orari di Attenzione</c:when>
                        <c:otherwise>Horarios de Atención</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="page-content">
            <!-- Barra de filtros -->
            <div class="card-salud mb-4" style="border:none; background:var(--white);">
                <div style="padding:14px 20px;">
                    <div class="filter-bar">
                        <div class="filter-group">
                            <span style="font-size:0.82rem; color:var(--text-muted); font-weight:600;">
                                <i class="fas fa-user-md me-1"></i>
                                <fmt:message key="cita.medico"/>:
                            </span>
                            <select id="filtroMedico" class="filter-select">
                                <option value="">
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">All doctors</c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">Tutti i medici</c:when>
                                        <c:otherwise>Todos los médicos</c:otherwise>
                                    </c:choose>
                                </option>
                                <c:forEach var="medico" items="${medicos}">
                                    <option value="${medico.nombres} ${medico.apellidos}">
                                        ${medico.nombres} ${medico.apellidos}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-group">
                            <span style="font-size:0.82rem; color:var(--text-muted); font-weight:600;">
                                <i class="fas fa-calendar-day me-1"></i>
                                <c:choose>
                                    <c:when test="${sessionScope.lang == 'en'}">Day:</c:when>
                                    <c:when test="${sessionScope.lang == 'it'}">Giorno:</c:when>
                                    <c:otherwise>Día:</c:otherwise>
                                </c:choose>
                            </span>
                            <div class="dia-filtros">
                                <button class="dia-btn active" data-dia="todos">
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">All</c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">Tutti</c:when>
                                        <c:otherwise>Todos</c:otherwise>
                                    </c:choose>
                                </button>
                                <button class="dia-btn" data-dia="Lunes">
                                    <c:choose><c:when test="${sessionScope.lang=='en'}">Mo</c:when><c:when test="${sessionScope.lang=='it'}">Lu</c:when><c:otherwise>Lu</c:otherwise></c:choose>
                                </button>
                                <button class="dia-btn" data-dia="Martes">
                                    <c:choose><c:when test="${sessionScope.lang=='en'}">Tu</c:when><c:when test="${sessionScope.lang=='it'}">Ma</c:when><c:otherwise>Ma</c:otherwise></c:choose>
                                </button>
                                <button class="dia-btn" data-dia="Miercoles">
                                    <c:choose><c:when test="${sessionScope.lang=='en'}">We</c:when><c:when test="${sessionScope.lang=='it'}">Me</c:when><c:otherwise>Mi</c:otherwise></c:choose>
                                </button>
                                <button class="dia-btn" data-dia="Jueves">
                                    <c:choose><c:when test="${sessionScope.lang=='en'}">Th</c:when><c:when test="${sessionScope.lang=='it'}">Gi</c:when><c:otherwise>Ju</c:otherwise></c:choose>
                                </button>
                                <button class="dia-btn" data-dia="Viernes">
                                    <c:choose><c:when test="${sessionScope.lang=='en'}">Fr</c:when><c:when test="${sessionScope.lang=='it'}">Ve</c:when><c:otherwise>Vi</c:otherwise></c:choose>
                                </button>
                            </div>
                        </div>

                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="buscarHorario"
                                   placeholder="<c:choose><c:when test='${sessionScope.lang==\"en\"}'> Search doctor...</c:when><c:when test='${sessionScope.lang==\"it\"}'> Cerca medico...</c:when><c:otherwise> Buscar médico...</c:otherwise></c:choose>">
                        </div>
                    </div>
                </div>
            </div>

            <div class="card-salud">
                <div class="card-header-salud">
                    <span>
                        <i class="fas fa-list me-2"></i>
                        <c:choose>
                            <c:when test="${sessionScope.lang == 'en'}">Attendance Schedules</c:when>
                            <c:when test="${sessionScope.lang == 'it'}">Orari di Attenzione</c:when>
                            <c:otherwise>Horarios de Atención</c:otherwise>
                        </c:choose>
                    </span>
                    <span id="contadorHorarios" style="font-size:0.8rem; opacity:0.8;"></span>
                </div>
                <div class="table-responsive">
                    <table class="table table-salud" id="tablaHorarios">
                        <thead>
                            <tr>
                                <th><fmt:message key="cita.medico"/></th>
                                <th>
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">Day</c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">Giorno</c:when>
                                        <c:otherwise>Día</c:otherwise>
                                    </c:choose>
                                </th>
                                <th>
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">Start Time</c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">Ora Inizio</c:when>
                                        <c:otherwise>Hora Inicio</c:otherwise>
                                    </c:choose>
                                </th>
                                <th>
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">End Time</c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">Ora Fine</c:when>
                                        <c:otherwise>Hora Fin</c:otherwise>
                                    </c:choose>
                                </th>
                                <th>
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">Max. Appointments</c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">Max. Appuntamenti</c:when>
                                        <c:otherwise>Máx. Citas</c:otherwise>
                                    </c:choose>
                                </th>
                                <th>
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">Availability</c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">Disponibilità</c:when>
                                        <c:otherwise>Disponibilidad</c:otherwise>
                                    </c:choose>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="horario" items="${horarios}">
                                <tr data-medico="${horario.nombreMedico}"
                                    data-dia="${horario.nombreDia}"
                                    data-max="${horario.maxCitas}">
                                    <td>
                                        <div style="display:flex; align-items:center; gap:10px;">
                                            <div style="width:32px; height:32px; border-radius:50%; background:var(--cream); display:flex; align-items:center; justify-content:center; color:var(--wine-mid); font-size:0.85rem;">
                                                <i class="fas fa-user-md"></i>
                                            </div>
                                            <span style="font-weight:600; color:var(--text-dark);">${horario.nombreMedico}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span style="background:var(--cream-light); color:var(--wine-mid); padding:4px 12px; border-radius:20px; font-size:0.8rem; font-weight:600; border:1px solid var(--border-light);">
                                            ${horario.nombreDia}
                                        </span>
                                    </td>
                                    <td><i class="far fa-clock me-1" style="color:var(--warm-gray);"></i>${horario.horaInicio}</td>
                                    <td><i class="far fa-clock me-1" style="color:var(--warm-gray);"></i>${horario.horaFin}</td>
                                    <td>
                                        <span class="badge-citas">
                                            ${horario.maxCitas}
                                            <c:choose>
                                                <c:when test="${sessionScope.lang == 'en'}"> appts</c:when>
                                                <c:when test="${sessionScope.lang == 'it'}"> app.</c:when>
                                                <c:otherwise> citas</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td style="min-width:140px;">
                                        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">
                                            <span style="font-size:0.75rem; color:var(--text-muted); font-weight:600;">
                                                <c:choose>
                                                    <c:when test="${sessionScope.lang == 'en'}">Capacity</c:when>
                                                    <c:when test="${sessionScope.lang == 'it'}">Capacità</c:when>
                                                    <c:otherwise>Capacidad</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span style="font-size:0.75rem; color:var(--wine-deep); font-weight:700;">${horario.maxCitas}</span>
                                        </div>
                                        <div class="disponibilidad-bar">
                                            <div class="disponibilidad-fill ${horario.maxCitas >= 15 ? 'alta' : horario.maxCitas >= 8 ? 'media' : 'baja'}"
                                                 style="width:${horario.maxCitas * 100 / 20}%"></div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div id="sinResultados" class="sin-resultados" style="display:none;">
                        <i class="fas fa-search"></i><br>
                        <c:choose>
                            <c:when test="${sessionScope.lang == 'en'}">No schedules found with those filters</c:when>
                            <c:when test="${sessionScope.lang == 'it'}">Nessun orario trovato con questi filtri</c:when>
                            <c:otherwise>No se encontraron horarios con esos filtros</c:otherwise>
                        </c:choose>
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

        const tabla        = document.getElementById('tablaHorarios');
        const filas        = tabla.querySelectorAll('tbody tr');
        const contador     = document.getElementById('contadorHorarios');
        const sinResultados = document.getElementById('sinResultados');
        const inputBuscar  = document.getElementById('buscarHorario');
        const selectMedico = document.getElementById('filtroMedico');
        const botonesDia   = document.querySelectorAll('.dia-btn');
        const lang         = '${sessionScope.lang != null ? sessionScope.lang : "es"}';
        const labelHorario = lang === 'en' ? 'schedule(s)' : lang === 'it' ? 'orario/i' : 'horario(s)';

        let filtroMedico = '', filtroDia = 'todos', textoBusqueda = '';

        function actualizarContador() {
            const visibles = tabla.querySelectorAll('tbody tr:not([style*="none"])').length;
            contador.textContent = visibles + ' ' + labelHorario;
            sinResultados.style.display = visibles === 0 ? 'block' : 'none';
            tabla.style.display         = visibles === 0 ? 'none'  : 'table';
        }

        function filtrar() {
            const termino = textoBusqueda.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
            filas.forEach(fila => {
                const medico = (fila.dataset.medico || '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
                const dia    = fila.dataset.dia || '';
                const pasaMedico = !filtroMedico || medico.includes(filtroMedico.toLowerCase());
                const pasaDia    = filtroDia === 'todos' || dia === filtroDia;
                const pasaTexto  = !termino || medico.includes(termino);
                fila.style.display = (pasaMedico && pasaDia && pasaTexto) ? '' : 'none';
            });
            actualizarContador();
        }

        selectMedico.addEventListener('change', e => { filtroMedico = e.target.value; filtrar(); });
        botonesDia.forEach(btn => {
            btn.addEventListener('click', () => {
                botonesDia.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                filtroDia = btn.dataset.dia;
                filtrar();
            });
        });
        inputBuscar.addEventListener('input', e => { textoBusqueda = e.target.value; filtrar(); });
        actualizarContador();
    </script>
    <%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
</body>
</html>
