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
    <title>
        <c:choose>
            <c:when test="${modo == 'editar'}"><fmt:message key="paciente.editar.titulo"/></c:when>
            <c:otherwise><fmt:message key="paciente.nuevo.titulo"/></c:otherwise>
        </c:choose>
        · SaludBoyacá
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lato:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        .foto-upload-area {
            border: 2px dashed var(--wine-mid);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: background 0.2s;
            background: var(--white);
        }
        .foto-upload-area:hover { background: #fdf0ea; }
        .foto-circulo {
            width: 110px; height: 110px;
            object-fit: cover; border-radius: 50%;
            border: 3px solid var(--wine-mid);
            margin: 0 auto; display: block;
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/views/componentes/sidebar.jsp" %>

    <div class="main-wrapper" id="mainWrapper">
        <div class="topbar">
            <div>
                <div class="topbar-title">
                    <i class="fas fa-user-plus me-2" style="color:var(--wine-mid);"></i>
                    <c:choose>
                        <c:when test="${modo == 'editar'}"><fmt:message key="paciente.editar.titulo"/></c:when>
                        <c:otherwise><fmt:message key="paciente.nuevo.titulo"/></c:otherwise>
                    </c:choose>
                </div>
                <div class="topbar-breadcrumb">
                    SaludBoyacá &rsaquo; <fmt:message key="nav.pacientes"/> &rsaquo;
                    <c:choose>
                        <c:when test="${modo == 'editar'}"><fmt:message key="paciente.editar.titulo"/></c:when>
                        <c:otherwise><fmt:message key="paciente.nuevo.titulo"/></c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/pacientes/listar" class="btn-outline-wine"
                   style="padding:6px 14px; font-size:0.82rem;">
                    <i class="fas fa-arrow-left me-1"></i><fmt:message key="btn.volver"/>
                </a>
            </div>
        </div>

        <div class="page-content">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card-salud">
                        <div class="card-header-salud">
                            <i class="fas fa-user-plus me-2"></i>
                            <c:choose>
                                <c:when test="${modo == 'editar'}"><fmt:message key="paciente.editar.titulo"/></c:when>
                                <c:otherwise><fmt:message key="paciente.registrar"/></c:otherwise>
                            </c:choose>
                        </div>
                        <div style="padding: 24px;">
                            <form action="${pageContext.request.contextPath}/pacientes/${modo == 'editar' ? 'actualizar' : 'guardar'}"
                                  method="post" enctype="multipart/form-data">

                                <c:if test="${modo == 'editar'}">
                                    <input type="hidden" name="id" value="${paciente.id}">
                                </c:if>

                                <!-- Documento + Fecha -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-id-card me-1"></i><fmt:message key="paciente.documento"/>
                                        </label>
                                        <input type="text" name="documento" class="form-control" required
                                               value="${paciente.documento}"
                                               placeholder="<fmt:message key='paciente.placeholder.documento'/>">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-calendar me-1"></i><fmt:message key="paciente.nacimiento"/>
                                        </label>
                                        <input type="date" name="fechaNacimiento" class="form-control" required
                                               value="${paciente.fechaNacimiento}">
                                    </div>
                                </div>

                                <!-- Nombres + Apellidos -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-user me-1"></i><fmt:message key="paciente.nombres"/>
                                        </label>
                                        <input type="text" name="nombres" class="form-control" required
                                               value="${paciente.nombres}"
                                               placeholder="<fmt:message key='paciente.placeholder.nombres'/>">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-user me-1"></i><fmt:message key="paciente.apellidos"/>
                                        </label>
                                        <input type="text" name="apellidos" class="form-control" required
                                               value="${paciente.apellidos}"
                                               placeholder="<fmt:message key='paciente.placeholder.apellidos'/>">
                                    </div>
                                </div>

                                <!-- Teléfono + Email -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-phone me-1"></i><fmt:message key="paciente.telefono"/>
                                        </label>
                                        <input type="text" name="telefono" class="form-control"
                                               value="${paciente.telefono}"
                                               placeholder="<fmt:message key='paciente.placeholder.telefono'/>">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-envelope me-1"></i>Email
                                        </label>
                                        <input type="email" name="email" class="form-control"
                                               value="${paciente.email}"
                                               placeholder="<fmt:message key='paciente.placeholder.email'/>">
                                    </div>
                                </div>

                                <!-- EPS + Vereda -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-hospital me-1"></i><fmt:message key="paciente.eps"/>
                                        </label>
                                        <input type="text" name="eps" class="form-control" required
                                               value="${paciente.eps}"
                                               placeholder="<fmt:message key='paciente.placeholder.eps'/>">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-map-marker-alt me-1"></i><fmt:message key="paciente.vereda"/>
                                        </label>
                                        <input type="text" name="veredaBarrio" class="form-control"
                                               value="${paciente.veredaBarrio}"
                                               placeholder="<fmt:message key='paciente.placeholder.vereda'/>">
                                    </div>
                                </div>

                                <!-- Foto -->
                                <div class="mb-4">
                                    <label class="form-label">
                                        <i class="fas fa-camera me-1"></i><fmt:message key="paciente.foto"/>
                                        <span class="text-muted" style="font-size:0.8rem;">
                                            <fmt:message key="paciente.foto.opcional"/>
                                        </span>
                                    </label>

                                    <c:if test="${modo == 'editar' && not empty paciente.fotoUrl}">
                                        <div style="text-align:center; margin-bottom:12px;">
                                            <img src="${pageContext.request.contextPath}${paciente.fotoUrl}"
                                                 alt="<fmt:message key='paciente.foto.actual'/>"
                                                 class="foto-circulo" id="fotoActual">
                                            <div style="font-size:0.78rem; color:var(--text-muted); margin-top:6px;">
                                                <i class="fas fa-check-circle me-1" style="color:var(--wine-mid);"></i>
                                                <fmt:message key="paciente.foto.actual"/>
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="foto-upload-area"
                                         onclick="document.getElementById('fotoInputPaciente').click()">
                                        <i class="fas fa-cloud-upload-alt fa-2x" style="color:var(--wine-mid);"></i>
                                        <p class="mb-0 mt-2" style="font-size:0.85rem; color:var(--text-muted);">
                                            <c:choose>
                                                <c:when test="${modo == 'editar'}"><fmt:message key="paciente.foto.cambiar"/></c:when>
                                                <c:otherwise><fmt:message key="paciente.foto.seleccionar"/></c:otherwise>
                                            </c:choose>
                                        </p>
                                        <img id="fotoPreviewPaciente" class="foto-circulo" src="#"
                                             alt="<fmt:message key='paciente.foto'/>"
                                             style="display:none; margin-top:12px;">
                                    </div>
                                    <input type="file" id="fotoInputPaciente" name="foto"
                                           accept="image/jpeg,image/png" class="d-none"
                                           onchange="previsualizarFotoPaciente(this)">
                                    <div id="fotoErrorPaciente" class="text-danger mt-1"
                                         style="font-size:0.82rem; display:none;">
                                        <i class="fas fa-exclamation-circle me-1"></i>
                                        <fmt:message key="paciente.foto.error"/>
                                    </div>
                                </div>

                                <!-- Botones -->
                                <div class="d-flex gap-3 mt-3">
                                    <button type="submit" class="btn-wine">
                                        <i class="fas fa-save me-2"></i>
                                        <c:choose>
                                            <c:when test="${modo == 'editar'}"><fmt:message key="paciente.actualizar"/></c:when>
                                            <c:otherwise><fmt:message key="paciente.guardar"/></c:otherwise>
                                        </c:choose>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/pacientes/listar"
                                       class="btn-outline-wine">
                                        <i class="fas fa-times me-2"></i><fmt:message key="paciente.cancelar"/>
                                    </a>
                                </div>

                            </form>
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

        function previsualizarFotoPaciente(input) {
            const errorDiv = document.getElementById('fotoErrorPaciente');
            const preview  = document.getElementById('fotoPreviewPaciente');
            const actual   = document.getElementById('fotoActual');
            errorDiv.style.display = 'none';
            preview.style.display  = 'none';
            const file = input.files[0];
            if (!file) return;
            if (file.size > 2 * 1024 * 1024) {
                errorDiv.style.display = 'block';
                input.value = '';
                return;
            }
            const reader = new FileReader();
            reader.onload = e => {
                preview.src = e.target.result;
                preview.style.display = 'block';
                if (actual) actual.style.display = 'none';
            };
            reader.readAsDataURL(file);
        }
    </script>
    <%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
</body>
</html>