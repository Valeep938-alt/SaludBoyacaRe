<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key='consulta.titulo'/> · SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --wine:      #561C24;
            --rosewood:  #5D2932;
            --sand:      #C7B7A3;
            --cream:     #E8D8C4;
            --ink:       #2a1215;
            --white:     #fdfaf7;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'DM Sans', sans-serif;
            background-color: var(--cream);
            background-image:
                radial-gradient(ellipse at 10% 20%, rgba(86,28,36,.18) 0%, transparent 55%),
                radial-gradient(ellipse at 90% 80%, rgba(93,41,50,.14) 0%, transparent 55%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }

        .page-wrap { width: 100%; max-width: 680px; }

        .brand { text-align: center; margin-bottom: 2rem; animation: fadeDown .6s ease both; }
        .brand-name { font-family: 'Cormorant Garamond', serif; font-size: 2.2rem; font-weight: 700; color: var(--wine); letter-spacing: .04em; }
        .brand-sub { font-size: .78rem; letter-spacing: .18em; text-transform: uppercase; color: var(--sand); margin-top: .1rem; }

        .form-card { background: var(--white); border-radius: 24px; overflow: hidden; box-shadow: 0 32px 80px rgba(86,28,36,.18), 0 2px 8px rgba(86,28,36,.08); animation: fadeUp .7s ease both; }
        .form-card-header { background: linear-gradient(135deg, var(--wine) 0%, var(--rosewood) 100%); padding: 2rem 2.5rem 1.6rem; position: relative; overflow: hidden; }
        .form-card-header::after { content: ''; position: absolute; right: -40px; bottom: -40px; width: 160px; height: 160px; border-radius: 50%; background: rgba(255,255,255,.06); }
        .form-card-header h2 { font-family: 'Cormorant Garamond', serif; font-size: 1.55rem; color: var(--white); font-weight: 600; margin: 0; }
        .form-card-header p { color: var(--cream); font-size: .84rem; margin-top: .3rem; opacity: .85; }
        .header-icon { width: 44px; height: 44px; background: rgba(255,255,255,.15); border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 1rem; font-size: 1.2rem; color: var(--cream); }
        .form-body { padding: 2rem 2.5rem 2.5rem; }

        .field-label { font-size: .72rem; font-weight: 600; letter-spacing: .12em; text-transform: uppercase; color: var(--rosewood); margin-bottom: .5rem; display: flex; align-items: center; gap: .4rem; }
        .field-input { width: 100%; border: 2px solid var(--cream); border-radius: 12px; padding: .85rem 1.1rem; font-family: 'DM Sans', sans-serif; font-size: .95rem; color: var(--ink); background: var(--white); transition: border-color .25s, box-shadow .25s; outline: none; }
        .field-input::placeholder { color: var(--sand); }
        .field-input:focus { border-color: var(--wine); box-shadow: 0 0 0 4px rgba(86,28,36,.1); }

        .captcha-wrapper { background: var(--cream); border-radius: 14px; padding: 1rem 1.2rem; display: flex; align-items: center; justify-content: space-between; margin-bottom: .75rem; }
        .captcha-code { font-family: 'Courier New', monospace; font-size: 1.6rem; font-weight: 800; letter-spacing: 10px; color: var(--wine); background: var(--white); padding: .4rem 1.2rem; border-radius: 8px; user-select: none; }
        .btn-refresh { background: none; border: 2px solid var(--sand); border-radius: 8px; color: var(--rosewood); font-size: .78rem; font-weight: 600; padding: .4rem .9rem; cursor: pointer; transition: all .2s; display: flex; align-items: center; gap: .3rem; }
        .btn-refresh:hover { border-color: var(--wine); color: var(--wine); }

        .btn-consultar { width: 100%; background: linear-gradient(135deg, var(--wine), var(--rosewood)); color: var(--white); border: none; border-radius: 14px; padding: 1rem; font-family: 'DM Sans', sans-serif; font-size: 1rem; font-weight: 600; letter-spacing: .04em; cursor: pointer; transition: all .25s; display: flex; align-items: center; justify-content: center; gap: .6rem; margin-top: 1.8rem; box-shadow: 0 6px 24px rgba(86,28,36,.25); }
        .btn-consultar:hover { transform: translateY(-2px); box-shadow: 0 10px 32px rgba(86,28,36,.35); }

        .lang-bar { display: flex; justify-content: center; gap: .6rem; margin-top: 1.8rem; }
        .lang-pill { background: none; border: 1.5px solid var(--sand); border-radius: 20px; padding: .3rem .85rem; font-size: .75rem; font-weight: 600; color: var(--rosewood); text-decoration: none; letter-spacing: .06em; transition: all .2s; }
        .lang-pill:hover, .lang-pill.active { background: var(--rosewood); border-color: var(--rosewood); color: var(--white); }

        .footer-link { text-align: center; margin-top: 1.2rem; font-size: .8rem; color: var(--sand); }
        .footer-link a { color: var(--rosewood); text-decoration: none; font-weight: 500; }
        .footer-link a:hover { color: var(--wine); }

        .alert-custom { background: rgba(86,28,36,.07); border: 1.5px solid rgba(86,28,36,.25); border-radius: 12px; color: var(--wine); padding: .85rem 1.1rem; font-size: .88rem; margin-bottom: 1.4rem; display: flex; align-items: center; gap: .6rem; }

        /* RESULTS */
        .results-wrap { width: 100%; max-width: 860px; animation: fadeUp .7s ease both; }

        .patient-hero { background: linear-gradient(135deg, var(--wine) 0%, var(--rosewood) 100%); border-radius: 24px 24px 0 0; padding: 2.2rem 2.5rem 1.8rem; display: flex; align-items: center; gap: 1.4rem; position: relative; overflow: hidden; }
        .patient-hero::before { content: ''; position: absolute; right: -60px; top: -60px; width: 220px; height: 220px; border-radius: 50%; background: rgba(255,255,255,.05); }
        .patient-avatar { width: 64px; height: 64px; background: rgba(255,255,255,.15); border-radius: 18px; display: flex; align-items: center; justify-content: center; font-size: 1.8rem; color: var(--cream); flex-shrink: 0; }
        .patient-info { flex: 1; }
        .patient-name { font-family: 'Cormorant Garamond', serif; font-size: 1.7rem; font-weight: 700; color: var(--white); line-height: 1.2; }
        .patient-label { font-size: .72rem; letter-spacing: .14em; text-transform: uppercase; color: rgba(232,216,196,.7); margin-top: .2rem; }
        .btn-new-search { background: rgba(255,255,255,.15); border: 1.5px solid rgba(255,255,255,.3); border-radius: 10px; color: var(--white); padding: .5rem 1.1rem; font-size: .8rem; font-weight: 600; text-decoration: none; transition: all .2s; display: flex; align-items: center; gap: .4rem; flex-shrink: 0; }
        .btn-new-search:hover { background: rgba(255,255,255,.25); color: var(--white); }

        .stats-bar { background: var(--rosewood); padding: .9rem 2.5rem; display: flex; gap: 2rem; flex-wrap: wrap; }
        .stat-item { color: rgba(232,216,196,.85); font-size: .8rem; }
        .stat-item strong { color: var(--cream); font-size: 1.1rem; display: block; }

        .citas-container { background: var(--white); border-radius: 0 0 24px 24px; box-shadow: 0 32px 80px rgba(86,28,36,.18); overflow: hidden; }
        .citas-list { padding: 1.5rem 2rem 2rem; }

        .cita-card { background: var(--white); border: 2px solid var(--cream); border-radius: 16px; padding: 1.4rem 1.6rem 1.4rem 1.8rem; margin-bottom: 1rem; display: grid; grid-template-columns: auto 1fr auto; gap: 1.2rem; align-items: center; transition: border-color .2s, box-shadow .2s; position: relative; overflow: hidden; animation: fadeUp .5s ease both; }
        .cita-card:nth-child(1){animation-delay:.05s}
        .cita-card:nth-child(2){animation-delay:.12s}
        .cita-card:nth-child(3){animation-delay:.19s}
        .cita-card:nth-child(4){animation-delay:.26s}
        .cita-card:nth-child(5){animation-delay:.33s}
        .cita-card::before { content: ''; position: absolute; left: 0; top: 0; bottom: 0; width: 5px; border-radius: 0 4px 4px 0; }
        .cita-card.estado-PROGRAMADA::before { background: #e6a817; }
        .cita-card.estado-CONFIRMADA::before  { background: #27ae60; }
        .cita-card.estado-ATENDIDA::before    { background: var(--rosewood); }
        .cita-card.estado-CANCELADA::before   { background: #c0392b; }
        .cita-card:hover { border-color: var(--sand); box-shadow: 0 8px 32px rgba(86,28,36,.1); }

        .date-block { text-align: center; background: var(--cream); border-radius: 12px; padding: .7rem 1rem; min-width: 90px; }
        .date-full { font-size: .82rem; font-weight: 700; color: var(--wine); line-height: 1.5; }

        .cita-info { min-width: 0; }
        .doctor-name { font-family: 'Cormorant Garamond', serif; font-size: 1.15rem; font-weight: 600; color: var(--ink); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .especialidad { font-size: .78rem; color: var(--sand); margin-top: .15rem; font-weight: 500; }
        .hora-chip { display: inline-flex; align-items: center; gap: .3rem; background: rgba(86,28,36,.07); color: var(--rosewood); border-radius: 20px; padding: .2rem .65rem; font-size: .75rem; font-weight: 600; margin-top: .5rem; }

        .cita-actions { display: flex; flex-direction: column; align-items: flex-end; gap: .6rem; }

        .badge-estado { display: inline-flex; align-items: center; gap: .3rem; border-radius: 20px; padding: .32rem .85rem; font-size: .72rem; font-weight: 700; letter-spacing: .06em; text-transform: uppercase; }
        .badge-PROGRAMADA { background: rgba(230,168,23,.15); color: #b8880e; border: 1.5px solid rgba(230,168,23,.4); }
        .badge-CONFIRMADA  { background: rgba(39,174,96,.13);  color: #1f8a4c; border: 1.5px solid rgba(39,174,96,.35); }
        .badge-ATENDIDA    { background: rgba(93,41,50,.12);   color: var(--rosewood); border: 1.5px solid rgba(93,41,50,.3); }
        .badge-CANCELADA   { background: rgba(192,57,43,.12);  color: #992d1e; border: 1.5px solid rgba(192,57,43,.3); }

        .btn-pdf { background: linear-gradient(135deg, var(--wine), var(--rosewood)); color: var(--white); border: none; border-radius: 10px; padding: .45rem 1rem; font-size: .78rem; font-weight: 600; cursor: pointer; transition: all .2s; display: inline-flex; align-items: center; gap: .4rem; text-decoration: none; box-shadow: 0 4px 14px rgba(86,28,36,.25); }
        .btn-pdf:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(86,28,36,.35); color: var(--white); }

        .no-citas { text-align: center; padding: 3rem 2rem; color: var(--sand); }
        .no-citas i { font-size: 2.5rem; margin-bottom: 1rem; display: block; }

        @keyframes fadeDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeUp   { from { opacity: 0; transform: translateY(24px);  } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 540px) {
            .form-card-header, .form-body { padding-left: 1.4rem; padding-right: 1.4rem; }
            .patient-hero { flex-wrap: wrap; padding: 1.6rem 1.4rem; }
            .stats-bar { padding: .9rem 1.4rem; gap: 1.2rem; }
            .citas-list { padding: 1rem 1rem 1.4rem; }
            .cita-card { grid-template-columns: 1fr; gap: .8rem; padding: 1.1rem 1.1rem 1.1rem 1.4rem; }
            .cita-actions { flex-direction: row; align-items: center; }
        }
    </style>
</head>
<body>

<%-- ══ CALCULAR TOTALES (sin fn:) ══ --%>
<c:if test="${not empty paciente}">
    <c:set var="totalCitas"  value="0"/>
    <c:set var="programadas" value="0"/>
    <c:set var="confirmadas" value="0"/>
    <c:set var="atendidas"   value="0"/>
    <c:set var="canceladas"  value="0"/>
    <c:forEach var="cStat" items="${citas}">
        <c:set var="totalCitas"  value="${totalCitas + 1}"/>
        <c:if test="${cStat.estado == 'PROGRAMADA'}"><c:set var="programadas" value="${programadas + 1}"/></c:if>
        <c:if test="${cStat.estado == 'CONFIRMADA'}"><c:set var="confirmadas" value="${confirmadas + 1}"/></c:if>
        <c:if test="${cStat.estado == 'ATENDIDA'}">  <c:set var="atendidas"   value="${atendidas   + 1}"/></c:if>
        <c:if test="${cStat.estado == 'CANCELADA'}"> <c:set var="canceladas"  value="${canceladas  + 1}"/></c:if>
    </c:forEach>
</c:if>

<!-- ════════ VISTA: RESULTADOS ════════ -->
<c:if test="${not empty paciente}">
    <div class="results-wrap">

        <div class="patient-hero">
            <div class="patient-avatar"><i class="fas fa-user-injured"></i></div>
            <div class="patient-info">
                <div class="patient-label"><fmt:message key='consulta.titulo'/></div>
                <div class="patient-name">${paciente.nombres} ${paciente.apellidos}</div>
            </div>
            <a href="${pageContext.request.contextPath}/consulta-cita" class="btn-new-search">
                <i class="fas fa-search"></i> Nueva consulta
            </a>
        </div>

        <div class="stats-bar">
            <div class="stat-item"><strong>${totalCitas}</strong>Total de citas</div>
            <c:if test="${programadas > 0}"><div class="stat-item"><strong>${programadas}</strong>Programadas</div></c:if>
            <c:if test="${confirmadas > 0}"><div class="stat-item"><strong>${confirmadas}</strong>Confirmadas</div></c:if>
            <c:if test="${atendidas   > 0}"><div class="stat-item"><strong>${atendidas}</strong>Atendidas</div></c:if>
            <c:if test="${canceladas  > 0}"><div class="stat-item"><strong>${canceladas}</strong>Canceladas</div></c:if>
        </div>

        <div class="citas-container">
            <div class="citas-list">
                <c:choose>
                    <c:when test="${not empty citas}">
                        <c:forEach var="cita" items="${citas}">
                            <div class="cita-card estado-${cita.estado}">

                                <div class="date-block">
                                    <div class="date-full">${cita.fechaCita}</div>
                                </div>

                                <div class="cita-info">
                                    <div class="doctor-name">
                                        <i class="fas fa-user-md" style="font-size:.8rem;color:var(--sand);margin-right:.35rem;"></i>${cita.nombreMedico}
                                    </div>
                                    <div class="especialidad">${cita.nombreEspecialidad}</div>
                                    <div class="hora-chip">
                                        <i class="fas fa-clock"></i>${cita.horaCita}
                                    </div>
                                </div>

                                <div class="cita-actions">
                                    <span class="badge-estado badge-${cita.estado}">
                                        <c:choose>
                                            <c:when test="${cita.estado == 'PROGRAMADA'}"><i class="fas fa-calendar-alt"></i></c:when>
                                            <c:when test="${cita.estado == 'CONFIRMADA'}"><i class="fas fa-check-circle"></i></c:when>
                                            <c:when test="${cita.estado == 'ATENDIDA'}"><i class="fas fa-check-double"></i></c:when>
                                            <c:when test="${cita.estado == 'CANCELADA'}"><i class="fas fa-times-circle"></i></c:when>
                                        </c:choose>
                                        ${cita.estado}
                                    </span>
                                    <c:if test="${cita.estado == 'PROGRAMADA' or cita.estado == 'CONFIRMADA' or cita.estado == 'ATENDIDA'}">
                                        <a href="${pageContext.request.contextPath}/citas/pdf?id=${cita.id}"
                                           class="btn-pdf" title="Descargar comprobante PDF">
                                            <i class="fas fa-file-pdf"></i> PDF
                                        </a>
                                    </c:if>
                                </div>

                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-citas">
                            <i class="fas fa-calendar-times"></i>
                            No se encontraron citas para este paciente.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="footer-link" style="margin-top:1.2rem;">
            <fmt:message key='app.footer'/> ·
            <a href="${pageContext.request.contextPath}/login">
                <i class="fas fa-sign-in-alt"></i> Acceso al sistema
            </a>
        </div>
    </div>
</c:if>

<!-- ════════ VISTA: FORMULARIO ════════ -->
<c:if test="${empty paciente}">
    <div class="page-wrap">
        <div class="brand">
            <div class="brand-name">SaludBoyacá</div>
            <div class="brand-sub">Sistema de Gestión Médica · Regional Boyacá</div>
        </div>

        <div class="form-card">
            <div class="form-card-header">
                <div class="header-icon"><i class="fas fa-search-location"></i></div>
                <h2><fmt:message key='consulta.titulo'/></h2>
                <p>Ingrese su documento para consultar sus citas médicas</p>
            </div>

            <div class="form-body">
                <c:if test="${not empty error}">
                    <div class="alert-custom">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/consulta-cita" method="post">
                    <div class="mb-4">
                        <div class="field-label">
                            <i class="fas fa-id-card"></i>
                            <fmt:message key='consulta.documento'/>
                        </div>
                        <input type="text" name="documento" class="field-input"
                               placeholder="Ingrese su número de documento"
                               required autofocus autocomplete="off">
                    </div>

                    <div class="mb-4">
                        <div class="field-label">
                            <i class="fas fa-shield-alt"></i>
                            <fmt:message key='consulta.captcha'/>
                        </div>
                        <div class="captcha-wrapper">
                            <div class="captcha-code">${not empty requestScope.captchaText ? requestScope.captchaText : sessionScope.captchaText}</div>
                            <button type="button" class="btn-refresh" onclick="window.location.href=window.location.pathname">
                                <i class="fas fa-sync-alt"></i> Cambiar
                            </button>
                        </div>
                        <input type="text" name="captcha" class="field-input text-center"
                               placeholder="Ingrese el código" maxlength="6" required autocomplete="off">
                    </div>

                    <button type="submit" class="btn-consultar">
                        <i class="fas fa-search"></i>
                        <fmt:message key='consulta.buscar'/>
                    </button>
                                        <input type="hidden" name="captchaHash" value="${not empty requestScope.captchaHash ? requestScope.captchaHash : sessionScope.captchaHash}">
                    </form>

                <div class="lang-bar">
                    <a href="?lang=es" class="lang-pill ${sessionScope.lang == 'es' || empty sessionScope.lang ? 'active' : ''}">🇨🇴 ES</a>
                    <a href="?lang=en" class="lang-pill ${sessionScope.lang == 'en' ? 'active' : ''}">🇺🇸 EN</a>
                    <a href="?lang=it" class="lang-pill ${sessionScope.lang == 'it' ? 'active' : ''}">🇮🇹 IT</a>
                </div>

                <div class="footer-link">
                    <fmt:message key='app.footer'/> ·
                    <a href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-sign-in-alt"></i> Acceso al sistema
                    </a>
                </div>
            </div>
        </div>
    </div>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
</body>
</html>
