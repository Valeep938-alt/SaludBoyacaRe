<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. Encoding primero para que el parámetro ?lang=xx se lea bien --%>
<fmt:requestEncoding value="UTF-8"/>

<%-- 2. Determinar idioma: parámetro > sesión > default 'es' --%>
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

<%-- 3. Establecer locale en sesión para que persista --%>
<fmt:setLocale value="${currentLang}" scope="session"/>
<fmt:setBundle basename="messages"/>

<!DOCTYPE html>
<html lang="${currentLang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key='login.titulo'/> · SaludBoyacá</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --wine-deep:    #561C24;
            --wine-mid:     #6D2932;
            --warm-gray:    #C7B7A3;
            --cream:        #E8D8C4;
            --cream-light:  #F5EDE4;
            --white:        #FFFFFF;
            --text-dark:    #2C1810;
            --text-muted:   #8B7355;
            --border-light: rgba(199,183,163,0.4);
            --shadow:       rgba(86,28,36,0.15);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            background: var(--cream-light);
            overflow-x: hidden;
        }

        /* ── PANEL IZQUIERDO (decorativo / imagen) ── */
        .side-panel {
            display: none;
            width: 50%;
            flex-shrink: 0;
            background: linear-gradient(160deg, var(--wine-deep) 0%, var(--wine-mid) 50%, #3a1520 100%);
            position: relative;
            overflow: hidden;
            padding: 3rem;
            flex-direction: column;
            justify-content: space-between;
        }
        @media (min-width: 992px) { .side-panel { display: flex; } }

        .side-panel::before {
            content: '';
            position: absolute;
            inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.03'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }
        .side-panel::after {
            content: '';
            position: absolute;
            right: -10%; top: -10%;
            width: 500px; height: 500px;
            background: radial-gradient(ellipse, rgba(199,183,163,0.12) 0%, transparent 60%);
            pointer-events: none;
        }

        .side-brand {
            position: relative; z-index: 1;
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .side-brand-icon {
            width: 52px; height: 52px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            color: var(--cream);
            font-size: 1.4rem;
            flex-shrink: 0;
        }
        .side-brand-name {
            font-family: 'Syne', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--white);
            line-height: 1.1;
        }
        .side-brand-sub {
            font-size: .72rem;
            letter-spacing: .18em;
            text-transform: uppercase;
            color: rgba(232,216,196,.6);
            margin-top: .2rem;
            font-weight: 500;
        }

        .side-visual {
            position: relative; z-index: 1;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        .side-visual-card {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 24px;
            padding: 2.5rem;
            backdrop-filter: blur(10px);
            max-width: 380px;
            width: 100%;
        }
        .side-visual-card h3 {
            font-family: 'Syne', sans-serif;
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--white);
            margin-bottom: 1rem;
            line-height: 1.3;
        }
        .side-visual-card p {
            font-size: 0.9rem;
            color: rgba(232,216,196,0.8);
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }
        .side-feature {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }
        .side-feature:last-child { border-bottom: none; }
        .side-feature-ico {
            width: 36px; height: 36px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: var(--cream);
            font-size: 0.9rem;
            flex-shrink: 0;
        }
        .side-feature-text {
            font-size: 0.82rem;
            color: rgba(232,216,196,0.85);
            font-weight: 500;
        }

        .side-tagline {
            position: relative; z-index: 1;
        }
        .side-tagline blockquote {
            font-family: 'Syne', sans-serif;
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--cream);
            line-height: 1.5;
            border-left: 3px solid rgba(199,183,163,.4);
            padding-left: 1.2rem;
            margin: 0;
        }
        .side-tagline cite {
            display: block;
            font-family: 'DM Sans', sans-serif;
            font-style: normal;
            font-size: .72rem;
            letter-spacing: .14em;
            text-transform: uppercase;
            color: rgba(199,183,163,.55);
            margin-top: .8rem;
            padding-left: 1.2rem;
        }

        .side-stats {
            position: relative; z-index: 1;
            display: flex;
            gap: 2.5rem;
        }
        .stat-num {
            font-family: 'Syne', sans-serif;
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--white);
            line-height: 1;
        }
        .stat-label {
            font-size: .68rem;
            letter-spacing: .12em;
            text-transform: uppercase;
            color: rgba(199,183,163,.6);
            margin-top: .2rem;
            font-weight: 500;
        }

        /* ── PANEL DERECHO (formulario) ── */
        .form-panel {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1.5rem;
            position: relative;
        }
        .form-panel::before {
            content: '';
            position: absolute;
            top: -100px; right: -100px;
            width: 300px; height: 300px;
            background: radial-gradient(ellipse, rgba(86,28,36,0.06) 0%, transparent 70%);
            pointer-events: none;
        }

        .login-box {
            width: 100%;
            max-width: 440px;
            animation: fadeUp .65s ease both;
            position: relative;
            z-index: 1;
        }

        /* Brand visible solo en móvil */
        .mobile-brand {
            text-align: center;
            margin-bottom: 2rem;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }
        .mobile-brand-icon {
            width: 56px; height: 56px;
            background: var(--wine-deep);
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            color: var(--cream);
            font-size: 1.5rem;
            box-shadow: 0 8px 24px rgba(86,28,36,0.3);
        }
        .mobile-brand-name {
            font-family: 'Syne', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--wine-deep);
        }
        .mobile-brand-sub {
            font-size: .72rem;
            letter-spacing: .16em;
            text-transform: uppercase;
            color: var(--text-muted);
            font-weight: 500;
        }
        @media (min-width: 992px) { .mobile-brand { display: none; } }

        /* Card */
        .login-card {
            background: var(--white);
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 24px 72px rgba(86,28,36,.14), 0 2px 8px rgba(86,28,36,.06);
            border: 1px solid var(--border-light);
        }

        .card-header-bar {
            background: linear-gradient(135deg, var(--wine-deep), var(--wine-mid));
            padding: 1.8rem 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            position: relative;
            overflow: hidden;
        }
        .card-header-bar::after {
            content: '';
            position: absolute;
            right: -40px; top: -40px;
            width: 140px; height: 140px;
            border-radius: 50%;
            background: rgba(255,255,255,.06);
        }
        .header-icon-box {
            width: 48px; height: 48px;
            background: rgba(255,255,255,.15);
            border: 1px solid rgba(255,255,255,.25);
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem;
            color: var(--cream);
            flex-shrink: 0;
            position: relative;
            z-index: 1;
        }
        .header-text { position: relative; z-index: 1; }
        .header-text h2 {
            font-family: 'Syne', sans-serif;
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--white);
            margin: 0;
        }
        .header-text p {
            font-size: .78rem;
            color: rgba(232,216,196,.75);
            margin: .2rem 0 0;
        }

        .card-body-pad { padding: 2.2rem 2rem 2.4rem; }

        /* Campo */
        .field-wrap { margin-bottom: 1.4rem; }
        .field-label {
            font-size: .72rem;
            font-weight: 700;
            letter-spacing: .1em;
            text-transform: uppercase;
            color: var(--wine-mid);
            margin-bottom: .5rem;
            display: flex; align-items: center; gap: .4rem;
        }
        .input-row {
            display: flex;
            border: 2px solid var(--cream);
            border-radius: 14px;
            overflow: hidden;
            transition: border-color .25s, box-shadow .25s;
            background: var(--cream-light);
        }
        .input-row:focus-within {
            border-color: var(--wine-deep);
            box-shadow: 0 0 0 4px rgba(86,28,36,.1);
            background: var(--white);
        }
        .input-icon {
            width: 48px;
            background: transparent;
            display: flex; align-items: center; justify-content: center;
            color: var(--text-muted);
            font-size: .95rem;
            flex-shrink: 0;
            transition: color .2s;
        }
        .input-row:focus-within .input-icon { color: var(--wine-deep); }
        .field-input {
            flex: 1;
            border: none;
            outline: none;
            padding: .9rem 1rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .95rem;
            color: var(--text-dark);
            background: transparent;
        }
        .field-input::placeholder { color: var(--text-muted); }

        /* Toggle password */
        .toggle-pass {
            background: none;
            border: none;
            width: 48px;
            color: var(--text-muted);
            cursor: pointer;
            font-size: .95rem;
            transition: color .2s;
            padding: 0;
        }
        .toggle-pass:hover { color: var(--wine-deep); }

        /* Submit */
        .btn-login {
            width: 100%;
            background: linear-gradient(135deg, var(--wine-deep), var(--wine-mid));
            color: var(--cream);
            border: none;
            border-radius: 14px;
            padding: 1rem;
            font-family: 'DM Sans', sans-serif;
            font-size: 1rem;
            font-weight: 600;
            letter-spacing: .02em;
            cursor: pointer;
            transition: all .25s;
            display: flex; align-items: center; justify-content: center; gap: .6rem;
            margin-top: 1.8rem;
            box-shadow: 0 8px 28px rgba(86,28,36,.3);
        }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 12px 36px rgba(86,28,36,.4); }
        .btn-login:active { transform: translateY(0); }

        /* Error */
        .alert-custom {
            background: rgba(86,28,36,.07);
            border: 1.5px solid rgba(86,28,36,.2);
            border-radius: 12px;
            color: var(--wine-deep);
            padding: .9rem 1.1rem;
            font-size: .88rem;
            margin-bottom: 1.4rem;
            display: flex;
            align-items: center;
            gap: .6rem;
            font-weight: 500;
        }

        /* Divider */
        .divider {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin: 1.6rem 0;
            color: var(--text-muted);
            font-size: .75rem;
            font-weight: 500;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border-light);
        }

        /* Lang pills */
        .lang-bar {
            display: flex;
            justify-content: center;
            gap: .5rem;
            margin-top: 1.4rem;
        }
        .lang-pill {
            background: none;
            border: 1.5px solid var(--border-light);
            border-radius: 10px;
            padding: .35rem .9rem;
            font-size: .75rem;
            font-weight: 600;
            color: var(--text-muted);
            text-decoration: none;
            letter-spacing: .04em;
            transition: all .2s;
            display: flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
        }
        .lang-pill:hover {
            border-color: var(--wine-deep);
            color: var(--wine-deep);
            background: rgba(86,28,36,0.04);
        }
        .lang-pill.active {
            background: var(--wine-deep);
            border-color: var(--wine-deep);
            color: var(--white);
            box-shadow: 0 4px 12px rgba(86,28,36,0.25);
        }

        /* Footer link */
        .footer-link {
            text-align: center;
            margin-top: 1.2rem;
            font-size: .8rem;
            color: var(--text-muted);
        }
        .footer-link a { 
            color: var(--wine-deep); 
            text-decoration: none; 
            font-weight: 600; 
            transition: color .2s;
        }
        .footer-link a:hover { color: var(--wine-mid); }

        @keyframes fadeUp { 
            from { opacity:0; transform:translateY(24px); } 
            to { opacity:1; transform:translateY(0); } 
        }
    </style>
</head>
<body>

    <!-- Panel izquierdo decorativo -->
    <div class="side-panel">
        <div class="side-brand">
            <div class="side-brand-icon">
                <i class="fas fa-shield-heart"></i>
            </div>
            <div>
                <div class="side-brand-name">SaludBoyacá</div>
                <div class="side-brand-sub"><fmt:message key='app.institucion.short'/></div>
            </div>
        </div>

        <div class="side-visual">
            <div class="side-visual-card">
                <h3><fmt:message key='login.side.titulo'/></h3>
                <p><fmt:message key='login.side.desc'/></p>
                <div class="side-feature">
                    <div class="side-feature-ico"><i class="fas fa-calendar-check"></i></div>
                    <div class="side-feature-text"><fmt:message key='login.side.feat1'/></div>
                </div>
                <div class="side-feature">
                    <div class="side-feature-ico"><i class="fas fa-user-md"></i></div>
                    <div class="side-feature-text"><fmt:message key='login.side.feat2'/></div>
                </div>
                <div class="side-feature">
                    <div class="side-feature-ico"><i class="fas fa-shield-alt"></i></div>
                    <div class="side-feature-text"><fmt:message key='login.side.feat3'/></div>
                </div>
            </div>
        </div>

        <div class="side-tagline">
            <blockquote>
                <fmt:message key='login.cita'/>
                <cite>— Arthur Schopenhauer</cite>
            </blockquote>
        </div>

        <div class="side-stats">
            <div class="stat">
                <div class="stat-num">SENA</div>
                <div class="stat-label"><fmt:message key='login.stat1'/></div>
            </div>
            <div class="stat">
                <div class="stat-num">2026</div>
                <div class="stat-label"><fmt:message key='login.stat2'/></div>
            </div>
        </div>
    </div>

    <!-- Panel derecho con formulario -->
    <div class="form-panel">
        <div class="login-box">

            <!-- Brand móvil -->
            <div class="mobile-brand">
                <div class="mobile-brand-icon">
                    <i class="fas fa-shield-heart"></i>
                </div>
                <div class="mobile-brand-name">SaludBoyacá</div>
                <div class="mobile-brand-sub"><fmt:message key='app.institucion.short'/></div>
            </div>

            <div class="login-card">
                <div class="card-header-bar">
                    <div class="header-icon-box"><i class="fas fa-heart-pulse"></i></div>
                    <div class="header-text">
                        <h2><fmt:message key='login.bienvenido'/></h2>
                        <p><fmt:message key='login.titulo'/></p>
                    </div>
                </div>

                <div class="card-body-pad">

                    <c:if test="${not empty error}">
                        <div class="alert-custom">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">

                        <!-- Usuario -->
                        <div class="field-wrap">
                            <div class="field-label">
                                <i class="fas fa-user" style="font-size:0.7rem"></i>
                                <fmt:message key='login.usuario'/>
                            </div>
                            <div class="input-row">
                                <div class="input-icon"><i class="fas fa-user"></i></div>
                                <input type="text" name="username" class="field-input"
                                       placeholder="<fmt:message key='login.usuario.placeholder'/>" required autofocus autocomplete="username">
                            </div>
                        </div>

                        <!-- Contraseña -->
                        <div class="field-wrap">
                            <div class="field-label">
                                <i class="fas fa-lock" style="font-size:0.7rem"></i>
                                <fmt:message key='login.contrasena'/>
                            </div>
                            <div class="input-row">
                                <div class="input-icon"><i class="fas fa-lock"></i></div>
                                <input type="password" name="password" id="passwordField" class="field-input"
                                       placeholder="<fmt:message key='login.contrasena.placeholder'/>" required autocomplete="current-password">
                                <button type="button" class="toggle-pass" onclick="togglePass()" title="<fmt:message key='login.toggle.title'/>">
                                    <i class="fas fa-eye" id="eyeIcon"></i>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="btn-login">
                            <i class="fas fa-sign-in-alt"></i>
                            <fmt:message key='login.ingresar'/>
                        </button>
                    </form>

                    <div class="divider"><fmt:message key='login.idioma'/></div>

                    <!-- Idiomas -->
                    <div class="lang-bar">
                        <c:url var="urlEs" value="">
                            <c:param name="lang" value="es"/>
                        </c:url>
                        <c:url var="urlEn" value="">
                            <c:param name="lang" value="en"/>
                        </c:url>
                        <c:url var="urlIt" value="">
                            <c:param name="lang" value="it"/>
                        </c:url>

                        <a href="${urlEs}" class="lang-pill ${currentLang == 'es' ? 'active' : ''}">
                            <span>🇨🇴</span> ES
                        </a>
                        <a href="${urlEn}" class="lang-pill ${currentLang == 'en' ? 'active' : ''}">
                            <span>🇺🇸</span> EN
                        </a>
                        <a href="${urlIt}" class="lang-pill ${currentLang == 'it' ? 'active' : ''}">
                            <span>🇮🇹</span> IT
                        </a>
                    </div>

                    <div class="footer-link">
                        <fmt:message key='app.footer'/> ·
                        <a href="${pageContext.request.contextPath}/consulta-cita">
                            <i class="fas fa-search"></i> <fmt:message key='nav.consulta'/>
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script>
        function togglePass() {
            const field = document.getElementById('passwordField');
            const icon  = document.getElementById('eyeIcon');
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }
    </script>
    <%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
</body>
</html>