<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>
<% request.setAttribute("currentPage", "citas"); %>

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${sessionScope.lang == 'en'}">Appointment Detail #${cita.id}</c:when>
            <c:when test="${sessionScope.lang == 'it'}">Dettaglio Appuntamento #${cita.id}</c:when>
            <c:otherwise>Detalle Cita #${cita.id}</c:otherwise>
        </c:choose>
        · SaludBoyacá
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lato:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        <%@ include file="/WEB-INF/views/componentes/sidebar-styles.css" %>
        .detalle-row {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .detalle-label {
            color: var(--wine-mid); font-weight: 600; font-size: 0.85rem;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .detalle-value { color: var(--text-dark); font-size: 1rem; font-weight: 500; }
        .detalle-block { padding: 1rem 1.5rem; border-bottom: 1px solid var(--border-light); }
        .detalle-block .detalle-label { display: block; margin-bottom: 6px; }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/views/componentes/sidebar.jsp" %>

    <div class="main-wrapper" id="mainWrapper">
        <div class="topbar">
            <div>
                <div class="topbar-title">
                    <i class="fas fa-file-medical me-2" style="color:var(--wine-mid);"></i>
                    <c:choose>
                        <c:when test="${sessionScope.lang == 'en'}">Appointment Detail</c:when>
                        <c:when test="${sessionScope.lang == 'it'}">Dettaglio Appuntamento</c:when>
                        <c:otherwise>Detalle de Cita</c:otherwise>
                    </c:choose>
                </div>
                <div class="topbar-breadcrumb">SaludBoyacá &rsaquo; <fmt:message key="nav.citas"/> &rsaquo; #${cita.id}</div>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/citas/listar" class="btn-outline-wine" style="padding:6px 14px; font-size:0.82rem;">
                    <i class="fas fa-arrow-left me-1"></i>
                    <c:choose>
                        <c:when test="${sessionScope.lang == 'en'}">Back</c:when>
                        <c:when test="${sessionScope.lang == 'it'}">Indietro</c:when>
                        <c:otherwise>Volver</c:otherwise>
                    </c:choose>
                </a>
            </div>
        </div>

        <div class="page-content">
            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <div class="card-salud">

                        <!-- Encabezado con foto -->
                        <div class="card-header-salud"
                             style="flex-direction:column; align-items:center; text-align:center; padding:28px 24px;">
                            <c:choose>
                                <c:when test="${not empty pacienteDetalle && not empty pacienteDetalle.fotoUrl}">
                                    <img src="${pageContext.request.contextPath}${pacienteDetalle.fotoUrl}"
                                         alt="Foto paciente"
                                         style="width:90px; height:90px; object-fit:cover; border-radius:50%;
                                                border:4px solid rgba(255,255,255,0.5); margin-bottom:14px;">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:90px; height:90px; border-radius:50%;
                                                background:rgba(255,255,255,0.15);
                                                border:4px solid rgba(255,255,255,0.4);
                                                display:flex; align-items:center; justify-content:center;
                                                margin-bottom:14px;">
                                        <i class="fas fa-user-injured fa-2x" style="color:rgba(255,255,255,0.8);"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <h4 style="margin:0; font-family:'Playfair Display',serif;">
                                <c:choose>
                                    <c:when test="${sessionScope.lang == 'en'}">Medical Appointment Detail</c:when>
                                    <c:when test="${sessionScope.lang == 'it'}">Dettaglio Appuntamento Medico</c:when>
                                    <c:otherwise>Detalle de Cita Médica</c:otherwise>
                                </c:choose>
                            </h4>
                            <p style="margin:4px 0 0; opacity:0.75; font-size:0.9rem;">N. ${cita.id}</p>
                        </div>

                        <!-- Cuerpo -->
                        <div style="padding:0;">

                            <div class="detalle-row">
                                <span class="detalle-label"><fmt:message key="cita.paciente"/></span>
                                <span class="detalle-value">${cita.nombrePaciente}</span>
                            </div>

                            <div class="detalle-row">
                                <span class="detalle-label"><fmt:message key="cita.medico"/></span>
                                <span class="detalle-value">${cita.nombreMedico}</span>
                            </div>

                            <div class="detalle-row">
                                <span class="detalle-label"><fmt:message key="cita.especialidad"/></span>
                                <span class="detalle-value">${cita.nombreEspecialidad}</span>
                            </div>

                            <div class="detalle-row">
                                <span class="detalle-label"><fmt:message key="cita.fecha"/></span>
                                <span class="detalle-value">
                                    <i class="far fa-calendar me-1" style="color:var(--warm-gray);"></i>
                                    ${cita.fechaCita}
                                </span>
                            </div>

                            <div class="detalle-row">
                                <span class="detalle-label"><fmt:message key="cita.hora"/></span>
                                <span class="detalle-value">
                                    <i class="far fa-clock me-1" style="color:var(--warm-gray);"></i>
                                    ${cita.horaCita}
                                </span>
                            </div>

                            <div class="detalle-row">
                                <span class="detalle-label"><fmt:message key="cita.estado"/></span>
                                <span>
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
                                </span>
                            </div>

                            <div class="detalle-block">
                                <span class="detalle-label"><fmt:message key="cita.motivo"/></span>
                                <p style="margin:0; color:var(--text-dark);">
                                    <c:choose>
                                        <c:when test="${not empty cita.motivo}">${cita.motivo}</c:when>
                                        <c:otherwise>
                                            <em style="color:var(--text-muted);">
                                                <c:choose>
                                                    <c:when test="${sessionScope.lang == 'en'}">Not specified</c:when>
                                                    <c:when test="${sessionScope.lang == 'it'}">Non specificato</c:when>
                                                    <c:otherwise>No especificado</c:otherwise>
                                                </c:choose>
                                            </em>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <c:if test="${not empty cita.observaciones}">
                                <div class="detalle-block">
                                    <span class="detalle-label"><fmt:message key="cita.observaciones"/></span>
                                    <div style="background:var(--cream-light); border-radius:12px; padding:1rem; border:1px solid var(--border-light);">
                                        ${cita.observaciones}
                                    </div>
                                </div>
                            </c:if>

                            <!-- Botones de acción -->
                            <div style="padding:1.5rem; display:flex; gap:12px; justify-content:center;
                                        border-top:1px solid var(--border-light); flex-wrap:wrap;">

                                <!-- Editar: solo RECEPCIONISTA y PROGRAMADA -->
                                <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA' && cita.estado == 'PROGRAMADA'}">
                                    <a href="${pageContext.request.contextPath}/citas/editar?id=${cita.id}" class="btn-wine">
                                        <i class="fas fa-edit me-2"></i>
                                        <c:choose>
                                            <c:when test="${sessionScope.lang == 'en'}">Edit Appointment</c:when>
                                            <c:when test="${sessionScope.lang == 'it'}">Modifica Appuntamento</c:when>
                                            <c:otherwise>Editar Cita</c:otherwise>
                                        </c:choose>
                                    </a>
                                </c:if>

                                <!-- Confirmar: solo MEDICO y PROGRAMADA -->
                                <c:if test="${sessionScope.usuarioRol == 'MEDICO' && cita.estado == 'PROGRAMADA'}">
                                    <a href="${pageContext.request.contextPath}/citas/confirmar?id=${cita.id}" class="btn-wine">
                                        <i class="fas fa-check me-2"></i>
                                        <c:choose>
                                            <c:when test="${sessionScope.lang == 'en'}">Confirm</c:when>
                                            <c:when test="${sessionScope.lang == 'it'}">Conferma</c:when>
                                            <c:otherwise>Confirmar</c:otherwise>
                                        </c:choose>
                                    </a>
                                </c:if>

                                <!-- Atender: solo MEDICO y CONFIRMADA -->
                                <c:if test="${sessionScope.usuarioRol == 'MEDICO' && cita.estado == 'CONFIRMADA'}">
                                    <a href="${pageContext.request.contextPath}/citas/atender?id=${cita.id}" class="btn-wine">
                                        <i class="fas fa-stethoscope me-2"></i>
                                        <c:choose>
                                            <c:when test="${sessionScope.lang == 'en'}">Attend</c:when>
                                            <c:when test="${sessionScope.lang == 'it'}">Visita</c:when>
                                            <c:otherwise>Atender</c:otherwise>
                                        </c:choose>
                                    </a>
                                </c:if>

                                <!-- Cancelar: solo MEDICO y estado no final -->
                                <<!-- Cancelar: solo MEDICO y estado no final -->
                                <c:if test="${sessionScope.usuarioRol == 'MEDICO' && cita.estado != 'CANCELADA' && cita.estado != 'ATENDIDA'}">
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">
                                            <c:set var="msgConfirm" value="Are you sure you want to cancel this appointment?"/>
                                        </c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">
                                            <c:set var="msgConfirm" value="Sei sicuro di voler cancellare questo appuntamento?"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="msgConfirm" value="¿Está seguro de cancelar esta cita?"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/citas/cancelar?id=${cita.id}"
                                    class="btn-outline-wine"
                                    onclick="return confirm('${msgConfirm}')">
                                    <i class="fas fa-times me-2"></i>
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">Cancel</c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">Cancella</c:when>
                                        <c:otherwise>Cancelar</c:otherwise>
                                    </c:choose>
                                    </a>
                                </c:if>

                                <!-- PDF: todos -->
                                <a href="${pageContext.request.contextPath}/citas/pdf?id=${cita.id}" class="btn-outline-wine">
                                    <i class="fas fa-file-pdf me-2"></i><fmt:message key="cita.descargar"/>
                                </a>

                                <!-- Volver -->
                                <a href="${pageContext.request.contextPath}/citas/listar" class="btn-outline-wine">
                                    <i class="fas fa-arrow-left me-2"></i>
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en'}">Back</c:when>
                                        <c:when test="${sessionScope.lang == 'it'}">Indietro</c:when>
                                        <c:otherwise>Volver</c:otherwise>
                                    </c:choose>
                                </a>
                            </div>

                        </div>
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
    </script>
</body>
</html>
