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

<fmt:setLocale value="${currentLang}" scope="session"/>
<fmt:setBundle basename="messages"/>
<% request.setAttribute("currentPage", "citas"); %>

<!DOCTYPE html>
<html lang="${currentLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${modo == 'editar'}"><fmt:message key="cita.editar.titulo"/></c:when>
            <c:otherwise><fmt:message key="cita.nueva.titulo"/></c:otherwise>
        </c:choose>
        · SaludBoyacá
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lato:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        <%@ include file="/WEB-INF/views/componentes/sidebar-styles.css" %>

        .form-select:disabled, .form-control:disabled {
            background-color: #f5e1ce !important; opacity: 0.7; cursor: not-allowed;
        }
        .dias-badge {
            display: inline-block; background: var(--wine-mid); color: #fff;
            border-radius: 20px; font-size: 0.75rem; padding: 2px 10px; margin: 2px 2px 0;
        }
        #diasInfo { margin-top: 5px; min-height: 22px; }
        .foto-paciente-box {
            margin-top: 10px; display: none; align-items: center; gap: 14px;
            background: var(--cream); border-radius: 10px;
            padding: 10px 16px; border: 1px solid var(--border-light);
        }
        .foto-paciente-box img {
            width: 60px; height: 60px; object-fit: cover; border-radius: 50%;
            border: 3px solid var(--wine-mid); flex-shrink: 0;
        }
        .foto-paciente-sin-foto { margin-top: 8px; display: none; font-size: 0.8rem; color: var(--text-muted); }
        .alert-wine {
            background: rgba(86,28,36,0.08); border: 1px solid rgba(86,28,36,0.2);
            border-radius: 12px; padding: 14px 18px; color: var(--wine-deep);
            font-size: 0.9rem; display: flex; align-items: center; gap: 10px;
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/views/componentes/sidebar.jsp" %>

    <div class="main-wrapper" id="mainWrapper">
        <div class="topbar">
            <div>
                <div class="topbar-title">
                    <i class="fas fa-calendar-plus me-2" style="color:var(--wine-mid);"></i>
                    <c:choose>
                        <c:when test="${modo == 'editar'}"><fmt:message key="cita.editar.titulo"/></c:when>
                        <c:otherwise><fmt:message key="cita.nueva.titulo"/></c:otherwise>
                    </c:choose>
                </div>
                <div class="topbar-breadcrumb">
                    SaludBoyacá &rsaquo; <fmt:message key="nav.citas"/> &rsaquo;
                    <c:choose>
                        <c:when test="${modo == 'editar'}"><fmt:message key="cita.editar.titulo"/></c:when>
                        <c:otherwise><fmt:message key="cita.nueva.titulo"/></c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}/citas/listar" class="btn-outline-wine" style="padding:6px 14px; font-size:0.82rem;">
                    <i class="fas fa-arrow-left me-1"></i><fmt:message key="btn.volver"/>
                </a>
            </div>
        </div>

        <div class="page-content">
            <div class="row justify-content-center">
                <div class="col-lg-9">
                    <div class="card-salud">
                        <div class="card-header-salud">
                            <i class="fas fa-calendar-plus me-2"></i>
                            <c:choose>
                                <c:when test="${modo == 'editar'}"><fmt:message key="cita.editar.titulo"/></c:when>
                                <c:otherwise><fmt:message key="cita.nueva.titulo"/></c:otherwise>
                            </c:choose>
                        </div>
                        <div style="padding: 24px;">

                            <c:if test="${not empty error}">
                                <div class="alert-wine mb-3">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span>${error}</span>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/citas/${modo == 'editar' ? 'actualizar' : 'guardar'}"
                                  method="post" id="formCita">

                                <c:if test="${modo == 'editar'}">
                                    <input type="hidden" name="id" value="${cita.id}">
                                </c:if>

                                <!-- Paciente + Especialidad -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-user me-1"></i><fmt:message key="cita.paciente"/>
                                        </label>
                                        <select name="idPaciente" class="form-select" required
                                                id="selectPaciente" onchange="mostrarFotoPaciente(this)">
                                            <option value=""><fmt:message key="cita.select.paciente"/></option>
                                            <c:forEach var="paciente" items="${pacientes}">
                                                <option value="${paciente.id}"
                                                    data-foto="${not empty paciente.fotoUrl ? pageContext.request.contextPath.concat(paciente.fotoUrl) : ''}"
                                                    ${cita.idPaciente == paciente.id ? 'selected' : ''}>
                                                    ${paciente.nombres} ${paciente.apellidos} - ${paciente.documento}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <div id="fotoPacienteBox" class="foto-paciente-box">
                                            <img id="fotoPacienteImg" src="#" alt="<fmt:message key='cita.foto.paciente'/>">
                                            <div>
                                                <div style="font-size:0.78rem; color:var(--text-muted); font-weight:600;">
                                                    <i class="fas fa-user-circle me-1"></i><fmt:message key="cita.foto.paciente"/>
                                                </div>
                                                <div id="fotoPacienteNombre" style="font-size:0.9rem; color:var(--wine-deep); font-weight:700;"></div>
                                            </div>
                                        </div>
                                        <div id="fotoPacienteSinFoto" class="foto-paciente-sin-foto">
                                            <i class="fas fa-user-slash me-1"></i><fmt:message key="cita.sin.foto"/>
                                        </div>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-stethoscope me-1"></i><fmt:message key="cita.especialidad"/>
                                        </label>
                                        <select name="idEspecialidad" class="form-select" id="especialidad"
                                                required onchange="cargarMedicos()">
                                            <option value=""><fmt:message key="cita.select.especialidad"/></option>
                                            <c:forEach var="esp" items="${especialidades}">
                                                <option value="${esp.id}" ${cita.idEspecialidad == esp.id ? 'selected' : ''}>${esp.nombre}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <!-- Médico + Fecha -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-user-md me-1"></i><fmt:message key="cita.medico"/>
                                        </label>
                                        <select name="idMedico" class="form-select" id="medico"
                                                required disabled onchange="cargarDias()">
                                            <option value=""><fmt:message key="cita.select.medico.espera"/></option>
                                        </select>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-calendar me-1"></i><fmt:message key="cita.fecha"/>
                                        </label>
                                        <input type="date" name="fechaCita" class="form-control"
                                               id="fechaCita" required disabled>
                                        <div id="diasInfo"></div>
                                    </div>
                                </div>

                                <!-- Hora + Motivo -->
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-clock me-1"></i><fmt:message key="cita.hora"/>
                                        </label>
                                        <select name="horaCita" class="form-select" id="horaCita" required disabled>
                                            <option value=""><fmt:message key="cita.select.hora.espera"/></option>
                                        </select>
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">
                                            <i class="fas fa-comment-medical me-1"></i><fmt:message key="cita.motivo"/>
                                        </label>
                                        <input type="text" name="motivo" class="form-control"
                                               value="${cita.motivo}"
                                               placeholder="<fmt:message key='cita.motivo.placeholder'/>">
                                    </div>
                                </div>

                                <!-- Botones -->
                                <div class="d-flex gap-3 mt-3">
                                    <button type="submit" class="btn-wine" id="btnGuardar">
                                        <i class="fas fa-save me-2"></i>
                                        <c:choose>
                                            <c:when test="${modo == 'editar'}"><fmt:message key="cita.actualizar"/></c:when>
                                            <c:otherwise><fmt:message key="cita.guardar"/></c:otherwise>
                                        </c:choose>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/citas/listar" class="btn-outline-wine">
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
        var CTX = '${pageContext.request.contextPath}';
        var diasPermitidos = [];
        var lang = '${currentLang}';

        var NOMBRES_DIA = {
            1: lang === 'en' ? 'Monday'    : lang === 'it' ? 'Lunedì'    : 'Lunes',
            2: lang === 'en' ? 'Tuesday'   : lang === 'it' ? 'Martedì'   : 'Martes',
            3: lang === 'en' ? 'Wednesday' : lang === 'it' ? 'Mercoledì' : 'Miércoles',
            4: lang === 'en' ? 'Thursday'  : lang === 'it' ? 'Giovedì'   : 'Jueves',
            5: lang === 'en' ? 'Friday'    : lang === 'it' ? 'Venerdì'   : 'Viernes',
            6: lang === 'en' ? 'Saturday'  : lang === 'it' ? 'Sabato'    : 'Sábado',
            7: lang === 'en' ? 'Sunday'    : lang === 'it' ? 'Domenica'  : 'Domingo'
        };

        var MSG = {
            seleccionaMedico:   lang === 'en' ? 'Select a doctor'              : lang === 'it' ? 'Seleziona un medico'                : 'Seleccione un médico',
            sinMedicos:         lang === 'en' ? 'No doctors in this specialty': lang === 'it' ? 'Nessun medico in questa specialità' : 'No hay médicos en esta especialidad',
            seleccionaFecha:    lang === 'en' ? 'Select date first'            : lang === 'it' ? 'Seleziona prima la data'              : 'Seleccione fecha primero',
            consultandoHorario: lang === 'en' ? 'Checking schedules...'        : lang === 'it' ? 'Consultando orari...'               : 'Consultando horarios...',
            sinHoras:           lang === 'en' ? 'No available times that day'  : lang === 'it' ? 'Nessun orario disponibile'            : 'Sin horas disponibles ese día',
            seleccionaHora:     lang === 'en' ? 'Select a time'                : lang === 'it' ? 'Seleziona un orario'                  : 'Seleccione una hora',
            guardando:          lang === 'en' ? 'Saving...'                    : lang === 'it' ? 'Salvando...'                          : 'Guardando...',
            atiende:            lang === 'en' ? 'Available on: '               : lang === 'it' ? 'Disponibile: '                        : 'Atiende: ',
            errorHorario:       lang === 'en' ? 'This doctor has no schedule'  : lang === 'it' ? 'Questo medico non ha un orario'       : 'Este médico no tiene horario configurado.',
            diaNoDisponible:    lang === 'en' ? 'The doctor does not attend that day.\nAvailable days: ' : lang === 'it' ? 'Il medico non riceve quel giorno.\nGiorni disponibili: ' : 'El médico no atiende ese día.\nDías disponibles: ',
            seleccionaHoraAntesDeGuardar: lang === 'en' ? 'Select an available time before saving.' : lang === 'it' ? 'Seleziona un orario disponibile prima di salvare.' : 'Seleccione una hora disponible antes de programar la cita.'
        };

        function mostrarFotoPaciente(sel) {
            var opt = sel.options[sel.selectedIndex];
            var fotoUrl = opt ? opt.dataset.foto : '';
            var box = document.getElementById('fotoPacienteBox');
            var img = document.getElementById('fotoPacienteImg');
            var nombre = document.getElementById('fotoPacienteNombre');
            var sinFoto = document.getElementById('fotoPacienteSinFoto');
            box.style.display = 'none';
            sinFoto.style.display = 'none';
            if (!opt || !opt.value) return;
            if (fotoUrl) {
                img.src = fotoUrl;
                nombre.textContent = opt.textContent.split(' - ')[0];
                box.style.display = 'flex';
            } else {
                sinFoto.style.display = 'block';
            }
        }

        function cargarMedicos() {
            var idEsp = document.getElementById('especialidad').value;
            var medSel = document.getElementById('medico');
            var fechaInp = document.getElementById('fechaCita');
            var horaSel = document.getElementById('horaCita');

            resetCampo(medSel, MSG.seleccionaMedico, true);
            resetCampo(horaSel, MSG.seleccionaFecha, true);
            fechaInp.value = ''; fechaInp.disabled = true;
            document.getElementById('diasInfo').innerHTML = '';
            diasPermitidos = [];

            if (!idEsp) return;

            fetch(CTX + '/citas/ajax/medicos?idEspecialidad=' + idEsp)
                .then(r => r.json())
                .then(medicos => {
                    if (!medicos.length) { resetCampo(medSel, MSG.sinMedicos, true); return; }
                    medSel.innerHTML = '<option value="">' + MSG.seleccionaMedico + '</option>';
                    medicos.forEach(m => medSel.innerHTML += '<option value="' + m.id + '">' + m.nombre + '</option>');
                    medSel.disabled = false;
                })
                .catch(() => resetCampo(medSel, MSG.sinMedicos, true));
        }

        function cargarDias() {
            var idMedico = document.getElementById('medico').value;
            var fechaInp = document.getElementById('fechaCita');
            var horaSel = document.getElementById('horaCita');
            var diasInfo = document.getElementById('diasInfo');

            resetCampo(horaSel, MSG.seleccionaFecha, true);
            fechaInp.value = ''; fechaInp.disabled = true;
            diasInfo.innerHTML = '';
            diasPermitidos = [];

            if (!idMedico) return;
            diasInfo.innerHTML = '<small class="text-muted">' + MSG.consultandoHorario + '</small>';

            fetch(CTX + '/citas/ajax/dias?idMedico=' + idMedico)
                .then(r => r.json())
                .then(dias => {
                    diasPermitidos = dias;
                    if (!dias.length) { diasInfo.innerHTML = '<small class="text-danger">' + MSG.errorHorario + '</small>'; return; }
                    var badges = dias.map(d => '<span class="dias-badge">' + NOMBRES_DIA[d] + '</span>').join('');
                    diasInfo.innerHTML = '<small>' + MSG.atiende + '</small>' + badges;
                    var hoy = new Date();
                    fechaInp.min = hoy.toISOString().split('T')[0];
                    fechaInp.disabled = false;
                    fechaInp.onchange = function() { validarDiaYCargarHoras(this.value); };
                })
                .catch(() => { diasInfo.innerHTML = '<small class="text-danger">' + MSG.errorHorario + '</small>'; });
        }

        function validarDiaYCargarHoras(fechaStr) {
            var horaSel = document.getElementById('horaCita');
            resetCampo(horaSel, MSG.seleccionaFecha, true);
            if (!fechaStr) return;
            var jsDay = new Date(fechaStr + 'T12:00:00').getDay();
            var isoDay = jsDay === 0 ? 7 : jsDay;
            if (diasPermitidos.indexOf(isoDay) === -1) {
                var nombres = diasPermitidos.map(d => NOMBRES_DIA[d]).join(', ');
                alert(MSG.diaNoDisponible + nombres);
                document.getElementById('fechaCita').value = '';
                return;
            }
            cargarHoras(fechaStr);
        }

        function cargarHoras(fechaStr) {
            var idMedico = document.getElementById('medico').value;
            var horaSel = document.getElementById('horaCita');
            if (!idMedico || !fechaStr) return;
            horaSel.innerHTML = '<option value="">' + MSG.consultandoHorario + '</option>';
            horaSel.disabled = true;
            fetch(CTX + '/citas/ajax/horas?idMedico=' + idMedico + '&fecha=' + fechaStr)
                .then(r => r.json())
                .then(horas => {
                    if (!horas.length) { resetCampo(horaSel, MSG.sinHoras, true); return; }
                    horaSel.innerHTML = '<option value="">' + MSG.seleccionaHora + '</option>';
                    horas.forEach(h => horaSel.innerHTML += '<option value="' + h + '">' + h + '</option>');
                    horaSel.disabled = false;
                })
                .catch(() => resetCampo(horaSel, MSG.sinHoras, true));
        }

        function resetCampo(select, texto, deshabilitar) {
            select.innerHTML = '<option value="">' + texto + '</option>';
            select.disabled = deshabilitar;
        }

        document.getElementById('formCita').addEventListener('submit', function(e) {
            if (!document.getElementById('horaCita').value) {
                e.preventDefault();
                alert(MSG.seleccionaHoraAntesDeGuardar);
                return;
            }
            var btn = document.getElementById('btnGuardar');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>' + MSG.guardando;
        });

        document.getElementById('sidebarToggle').addEventListener('click', () => {
            document.getElementById('sidebar').classList.toggle('collapsed');
            document.getElementById('mainWrapper').classList.toggle('expanded');
        });

        <c:if test="${modo == 'editar' && not empty cita}">
        (function() {
            var idEsp    = '${cita.idEspecialidad}';
            var idMedico = '${cita.idMedico}';
            var fechaCita = '${cita.fechaCita}';
            var horaCita  = '${cita.horaCita != null ? cita.horaCita.toString().substring(0,5) : ""}';
            if (!idEsp || !idMedico) return;
            var medSel = document.getElementById('medico');
            var fechaInp = document.getElementById('fechaCita');
            var horaSel = document.getElementById('horaCita');
            fetch(CTX + '/citas/ajax/medicos?idEspecialidad=' + idEsp)
                .then(r => r.json())
                .then(medicos => {
                    medSel.innerHTML = '<option value="">' + MSG.seleccionaMedico + '</option>';
                    medicos.forEach(m => {
                        medSel.innerHTML += '<option value="' + m.id + '"' + (m.id == idMedico ? ' selected' : '') + '>' + m.nombre + '</option>';
                    });
                    medSel.disabled = false;
                    return fetch(CTX + '/citas/ajax/dias?idMedico=' + idMedico);
                })
                .then(r => r.json())
                .then(dias => {
                    diasPermitidos = dias;
                    var badges = dias.map(d => '<span class="dias-badge">' + NOMBRES_DIA[d] + '</span>').join('');
                    document.getElementById('diasInfo').innerHTML = '<small>' + MSG.atiende + '</small>' + badges;
                    fechaInp.min = new Date().toISOString().split('T')[0];
                    fechaInp.value = fechaCita;
                    fechaInp.disabled = false;
                    fechaInp.onchange = function() { validarDiaYCargarHoras(this.value); };
                    return fetch(CTX + '/citas/ajax/horas?idMedico=' + idMedico + '&fecha=' + fechaCita);
                })
                .then(r => r.json())
                .then(horas => {
                    horaSel.innerHTML = '<option value="">' + MSG.seleccionaHora + '</option>';
                    var withCurrent = horas.indexOf(horaCita) === -1 ? [horaCita, ...horas] : horas;
                    withCurrent.forEach(h => {
                        horaSel.innerHTML += '<option value="' + h + '"' + (h === horaCita ? ' selected' : '') + '>' + h + '</option>';
                    });
                    horaSel.disabled = false;
                })
                .catch(err => console.error('Error precargando edición:', err));
        })();
        </c:if>

        (function() {
            var sel = document.getElementById('selectPaciente');
            if (sel && sel.value) mostrarFotoPaciente(sel);
        })();
    </script>
    <%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
</body>
</html>