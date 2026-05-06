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

<%
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "";
%>

<style>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lato:wght@300;400;600;700&display=swap');

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
    --sidebar-width: 260px;
    --sidebar-collapsed: 72px;
    --success:      #2e7d50;
    --warning:      #d4891a;
    --info:         #1a6d9e;
    --danger:       #b41e1e;
}

* { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: 'Lato', sans-serif;
    background: var(--cream-light);
    color: var(--text-dark);
    display: flex;
    min-height: 100vh;
}

/* ===== SIDEBAR ===== */
.sidebar {
    width: var(--sidebar-width);
    min-height: 100vh;
    background: linear-gradient(180deg, var(--wine-deep) 0%, var(--wine-mid) 60%, #4a1520 100%);
    display: flex;
    flex-direction: column;
    position: fixed;
    top: 0; left: 0;
    z-index: 1000;
    transition: width 0.3s cubic-bezier(0.4,0,0.2,1);
    box-shadow: 4px 0 24px var(--shadow);
    overflow: hidden;
}

.sidebar.collapsed { width: var(--sidebar-collapsed); }

.sidebar-brand {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 24px 18px 20px;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    position: relative;
}

.sidebar-logo {
    width: 38px; height: 38px;
    background: var(--cream);
    border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    color: var(--wine-deep);
    font-size: 1.2rem;
    flex-shrink: 0;
}

.sidebar-brand-text { flex: 1; overflow: hidden; white-space: nowrap; }
.brand-name  { font-family: 'Playfair Display', serif; color: var(--cream);     font-size: 1.15rem; font-weight: 700; }
.brand-accent{ font-family: 'Playfair Display', serif; color: var(--warm-gray); font-size: 1.15rem; font-weight: 600; }

.sidebar-toggle-btn {
    background: rgba(255,255,255,0.1);
    border: none; color: var(--warm-gray);
    width: 26px; height: 26px;
    border-radius: 6px;
    cursor: pointer;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.75rem;
    transition: all 0.2s;
    flex-shrink: 0;
}
.sidebar-toggle-btn:hover { background: rgba(255,255,255,0.2); color: white; }
.sidebar.collapsed .sidebar-toggle-btn i { transform: rotate(180deg); }

.sidebar-user {
    display: flex; align-items: center; gap: 12px;
    padding: 16px 18px;
    border-bottom: 1px solid rgba(255,255,255,0.08);
}

.user-avatar {
    width: 38px; height: 38px;
    border-radius: 50%;
    background: rgba(199,183,163,0.2);
    border: 2px solid rgba(199,183,163,0.4);
    display: flex; align-items: center; justify-content: center;
    color: var(--warm-gray);
    font-size: 1.3rem;
    flex-shrink: 0;
}

.user-info { overflow: hidden; white-space: nowrap; }
.user-name  { display: block; color: var(--cream);     font-weight: 600; font-size: 0.9rem;  overflow: hidden; text-overflow: ellipsis; }
.user-role  { display: block; color: var(--warm-gray); font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; }

.sidebar-nav {
    flex: 1;
    padding: 16px 12px;
    overflow-y: auto;
    overflow-x: hidden;
}

.nav-section-label {
    color: rgba(199,183,163,0.5);
    font-size: 0.65rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-weight: 700;
    padding: 12px 8px 6px;
    white-space: nowrap;
    overflow: hidden;
}
.sidebar.collapsed .nav-section-label { opacity: 0; height: 0; padding: 0; }

.sidebar-link {
    display: flex; align-items: center; gap: 12px;
    padding: 10px 12px;
    border-radius: 10px;
    color: rgba(232,216,196,0.75);
    text-decoration: none;
    font-size: 0.9rem;
    font-weight: 500;
    transition: all 0.2s;
    white-space: nowrap;
    margin-bottom: 2px;
}
.sidebar-link i { font-size: 1rem; width: 20px; text-align: center; flex-shrink: 0; }
.sidebar-link:hover { background: rgba(255,255,255,0.1); color: white; transform: translateX(3px); }
.sidebar-link.active { background: var(--cream); color: var(--wine-deep); font-weight: 700; box-shadow: 0 4px 12px rgba(0,0,0,0.2); }
.sidebar-link.active i { color: var(--wine-deep); }

.lang-selector { display: flex; gap: 6px; padding: 4px 8px; flex-wrap: wrap; }
.lang-btn { padding: 4px 8px; border-radius: 6px; font-size: 0.75rem; color: rgba(232,216,196,0.7); text-decoration: none; transition: all 0.2s; white-space: nowrap; }
.lang-btn:hover, .lang-btn.lang-active { background: rgba(255,255,255,0.15); color: white; }
.sidebar.collapsed .lang-selector { display: none; }

.sidebar-footer { padding: 16px 12px; border-top: 1px solid rgba(255,255,255,0.08); }
.sidebar-logout {
    display: flex; align-items: center; gap: 12px;
    padding: 10px 12px;
    border-radius: 10px;
    color: rgba(232,216,196,0.6);
    text-decoration: none;
    font-size: 0.9rem;
    transition: all 0.2s;
    white-space: nowrap;
}
.sidebar-logout:hover { background: rgba(231,76,60,0.2); color: #ff8a80; }
.sidebar-logout i { width: 20px; text-align: center; flex-shrink: 0; }

/* ===== MAIN CONTENT ===== */
.main-wrapper {
    margin-left: var(--sidebar-width);
    flex: 1;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    transition: margin-left 0.3s cubic-bezier(0.4,0,0.2,1);
}
.sidebar.collapsed ~ .main-wrapper { margin-left: var(--sidebar-collapsed); }

.topbar {
    background: var(--white);
    border-bottom: 1px solid var(--border-light);
    padding: 14px 28px;
    display: flex; align-items: center; justify-content: space-between;
    box-shadow: 0 2px 8px var(--shadow);
    position: sticky; top: 0; z-index: 100;
}
.topbar-title      { font-family: 'Playfair Display', serif; font-size: 1.25rem; color: var(--wine-deep); font-weight: 600; }
.topbar-breadcrumb { font-size: 0.8rem; color: var(--text-muted); margin-top: 2px; }
.topbar-actions    { display: flex; align-items: center; gap: 12px; }

.page-content { padding: 28px; flex: 1; }

/* ===== CARDS ===== */
.card-salud { background: var(--white); border-radius: 16px; box-shadow: 0 2px 16px var(--shadow); overflow: hidden; border: 1px solid var(--border-light); }
.card-header-salud { background: linear-gradient(135deg, var(--wine-deep), var(--wine-mid)); color: var(--cream); padding: 16px 24px; font-weight: 600; font-size: 0.95rem; display: flex; align-items: center; justify-content: space-between; }

.stat-card { background: var(--white); border-radius: 16px; padding: 22px; box-shadow: 0 2px 16px var(--shadow); border: 1px solid var(--border-light); border-left: 4px solid var(--wine-mid); transition: transform 0.2s, box-shadow 0.2s; }
.stat-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px var(--shadow); }
.stat-card.primary { border-left-color: var(--wine-deep); }
.stat-card.warning { border-left-color: var(--warning); }
.stat-card.success { border-left-color: var(--success); }
.stat-card.info    { border-left-color: var(--info); }
.stat-card.danger  { border-left-color: var(--danger); }
.stat-icon { font-size: 2rem; margin-bottom: 8px; }
.stat-card.primary .stat-icon { color: var(--wine-deep); }
.stat-card.warning .stat-icon { color: var(--warning); }
.stat-card.success .stat-icon { color: var(--success); }
.stat-card.info    .stat-icon { color: var(--info); }
.stat-card.danger  .stat-icon { color: var(--danger); }
.stat-number { font-family: 'Playfair Display', serif; font-size: 2.2rem; font-weight: 700; color: var(--wine-deep); line-height: 1; }
.stat-label  { color: var(--text-muted); font-size: 0.85rem; font-weight: 600; margin-top: 4px; }

/* ===== TABLES ===== */
.table-salud thead th { background: var(--cream); color: var(--wine-mid); font-weight: 700; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px; padding: 14px 16px; border: none; }
.table-salud tbody td { padding: 13px 16px; color: var(--text-dark); border-bottom: 1px solid var(--border-light); vertical-align: middle; font-size: 0.9rem; }
.table-salud tbody tr:hover { background: rgba(232,216,196,0.25); }
.table-salud { margin-bottom: 0; }

/* ===== BADGES ===== */
.badge-programada { background: rgba(212,137,26,0.12); color: #b07200; border: 1px solid rgba(212,137,26,0.3); padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }
.badge-confirmada { background: rgba(46,125,80,0.12);  color: #1e6640; border: 1px solid rgba(46,125,80,0.3);  padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }
.badge-atendida   { background: rgba(26,109,158,0.12); color: #0f5073; border: 1px solid rgba(26,109,158,0.3); padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }
.badge-cancelada  { background: rgba(180,30,30,0.1);   color: #8B0000; border: 1px solid rgba(180,30,30,0.25); padding: 4px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }

/* ===== BUTTONS ===== */
.btn-wine { background: linear-gradient(135deg, var(--wine-deep), var(--wine-mid)); border: none; color: var(--cream); border-radius: 10px; padding: 10px 20px; font-weight: 600; font-size: 0.88rem; transition: all 0.25s; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; }
.btn-wine:hover { transform: translateY(-2px); box-shadow: 0 6px 18px var(--shadow); color: white; }
.btn-outline-wine { background: transparent; border: 2px solid var(--warm-gray); color: var(--wine-mid); border-radius: 10px; padding: 9px 20px; font-weight: 600; font-size: 0.88rem; transition: all 0.25s; display: inline-flex; align-items: center; gap: 8px; text-decoration: none; }
.btn-outline-wine:hover { background: var(--cream); border-color: var(--wine-mid); color: var(--wine-deep); }
.btn-action { padding: 6px 10px; border-radius: 8px; border: none; font-size: 0.8rem; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 4px; text-decoration: none; }
.btn-act-view:hover    { background: var(--wine-deep); color: white; }
.btn-act-confirm:hover { background: #2e7d50; color: white; }
.btn-act-attend:hover  { background: #1a6d9e; color: white; }
.btn-act-cancel:hover  { background: #b41e1e; color: white; }
.btn-act-view    { background: rgba(86,28,36,0.1);  color: var(--wine-deep); }
.btn-act-confirm { background: rgba(46,125,80,0.1);  color: #1e6640; }
.btn-act-attend  { background: rgba(26,109,158,0.1); color: #0f5073; }
.btn-act-cancel  { background: rgba(180,30,30,0.08); color: #8B0000; }
.btn-act-pdf     { background: rgba(199,183,163,0.3);color: var(--text-muted); }
.btn-act-pdf:hover { background: var(--warm-gray); color: var(--text-dark); }

/* ===== FORMS ===== */
.form-label { color: var(--wine-mid); font-weight: 600; font-size: 0.88rem; margin-bottom: 6px; }
.form-control, .form-select { border: 2px solid var(--border-light); border-radius: 10px; padding: 10px 14px; color: var(--text-dark); font-size: 0.9rem; transition: border-color 0.2s, box-shadow 0.2s; background: var(--white); }
.form-control:focus, .form-select:focus { border-color: var(--wine-mid); box-shadow: 0 0 0 3px rgba(86,28,36,0.12); outline: none; }

/* ===== ALERT ===== */
.alert-wine { background: rgba(86,28,36,0.08); border: 1px solid rgba(86,28,36,0.2); border-radius: 12px; padding: 14px 18px; color: var(--wine-deep); font-size: 0.9rem; display: flex; align-items: center; gap: 10px; }

/* ===== FOOTER ===== */
.footer-salud { background: var(--wine-deep); color: var(--warm-gray); padding: 16px 28px; text-align: center; font-size: 0.82rem; }

/* ===== LIVE INDICATOR ===== */
.live-indicator { display: inline-flex; align-items: center; gap: 6px; font-size: 0.7rem; color: var(--success); font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
.live-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--success); animation: blink 1.5s infinite; }
@keyframes blink { 0%, 100% { opacity: 1; } 50% { opacity: 0.3; } }

/* ===== PROGRESS ===== */
.progress-salud { height: 8px; border-radius: 4px; background: var(--cream-light); overflow: hidden; }
.progress-salud-bar { height: 100%; border-radius: 4px; background: linear-gradient(90deg, var(--wine-deep), var(--wine-mid)); transition: width 0.6s ease; }

/* ===== RESPONSIVE ===== */
@media (max-width: 768px) {
    .sidebar { width: var(--sidebar-collapsed); }
    .sidebar .sidebar-brand-text,
    .sidebar .user-info,
    .sidebar .sidebar-link span,
    .sidebar .sidebar-logout span,
    .sidebar .nav-section-label,
    .sidebar .lang-selector { display: none; }
    .main-wrapper { margin-left: var(--sidebar-collapsed); }
}
</style>

<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="sidebar-logo">
            <i class="fas fa-heart-pulse"></i>
        </div>
        <div class="sidebar-brand-text">
            <span class="brand-name">Salud</span><span class="brand-accent">Boyacá</span>
        </div>
        <button class="sidebar-toggle-btn" id="sidebarToggle" title="<fmt:message key='sidebar.tooltip.colapsar'/>">
            <i class="fas fa-chevron-left"></i>
        </button>
    </div>

    <div class="sidebar-user">
        <div class="user-avatar">
            <i class="fas fa-user-circle"></i>
        </div>
        <div class="user-info">
            <span class="user-name">${sessionScope.usuarioNombre}</span>
            <span class="user-role">${sessionScope.usuarioRol}</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section-label"><fmt:message key="nav.principal"/></div>
        <a href="${pageContext.request.contextPath}/dashboard"
           class="sidebar-link <%= "dashboard".equals(currentPage) ? "active" : "" %>">
            <i class="fas fa-chart-pie"></i>
            <span><fmt:message key="nav.dashboard"/></span>
        </a>

        <div class="nav-section-label"><fmt:message key="nav.gestion"/></div>
        <a href="${pageContext.request.contextPath}/pacientes/listar"
           class="sidebar-link <%= "pacientes".equals(currentPage) ? "active" : "" %>">
            <i class="fas fa-users"></i>
            <span><fmt:message key="nav.pacientes"/></span>
        </a>
        <a href="${pageContext.request.contextPath}/citas/listar"
           class="sidebar-link <%= "citas".equals(currentPage) ? "active" : "" %>">
            <i class="fas fa-calendar-check"></i>
            <span><fmt:message key="nav.citas"/></span>
        </a>
        <a href="${pageContext.request.contextPath}/horarios/listar"
           class="sidebar-link <%= "horarios".equals(currentPage) ? "active" : "" %>">
            <i class="fas fa-clock"></i>
            <span><fmt:message key="nav.horarios"/></span>
        </a>

        <div class="nav-section-label"><fmt:message key="nav.idioma"/></div>
        <div class="lang-selector">
            <a href="?lang=es" class="lang-btn ${currentLang == 'es' ? 'lang-active' : ''}">🇨🇴 ES</a>
            <a href="?lang=en" class="lang-btn ${currentLang == 'en' ? 'lang-active' : ''}">🇺🇸 EN</a>
            <a href="?lang=it" class="lang-btn ${currentLang == 'it' ? 'lang-active' : ''}">🇮🇹 IT</a>
        </div>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout">
            <i class="fas fa-sign-out-alt"></i>
            <span><fmt:message key="nav.salir"/></span>
        </a>
    </div>
</aside>