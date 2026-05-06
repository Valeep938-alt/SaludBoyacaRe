<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, java.sql.Date, co.sena.cimm.adso.saludboyaca.dao.CitaDAO, co.sena.cimm.adso.saludboyaca.model.Cita" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%!
    private int getInt(Object obj, int def) {
        if (obj == null) return def;
        if (obj instanceof Integer) return ((Integer) obj).intValue();
        if (obj instanceof Number)  return ((Number)  obj).intValue();
        try { return Integer.parseInt(obj.toString()); } catch (Exception e) { return def; }
    }
%>

<%
    String lang = (String) request.getAttribute("lang");
    if (lang == null) lang = (String) session.getAttribute("lang");
    if (lang == null) lang = request.getParameter("lang");
    if (lang == null || !(lang.equals("es") || lang.equals("en") || lang.equals("it"))) lang = "es";
    session.setAttribute("lang", lang);

    int totalCitas       = getInt(request.getAttribute("totalCitas"),       0);
    int citasProgramadas = getInt(request.getAttribute("citasProgramadas"), 0);
    int citasConfirmadas = getInt(request.getAttribute("citasConfirmadas"), 0);
    int citasAtendidas   = getInt(request.getAttribute("citasAtendidas"),   0);
    int citasCanceladas  = getInt(request.getAttribute("citasCanceladas"),  0);
    int totalPacientes   = getInt(request.getAttribute("totalPacientes"),   0);
    int totalMedicos     = getInt(request.getAttribute("totalMedicos"),     0);
    int citasHoyCount    = getInt(request.getAttribute("citasHoyCount"),    0);
    int citasMes         = getInt(request.getAttribute("citasMes"),         0);

    int calYear        = getInt(request.getAttribute("calYear"),         Calendar.getInstance().get(Calendar.YEAR));
    int calMonth       = getInt(request.getAttribute("calMonth"),        Calendar.getInstance().get(Calendar.MONTH) + 1);
    int firstDayOfWeek = getInt(request.getAttribute("firstDayOfWeek"), 1);
    int daysInMonth    = getInt(request.getAttribute("daysInMonth"),     30);
    boolean esMesActual = Boolean.TRUE.equals(request.getAttribute("esMesActual"));
    int hoyDia         = getInt(request.getAttribute("hoyDia"), 1);

    Map  citasPorDia      = (Map)  request.getAttribute("citasPorDia");      if (citasPorDia      == null) citasPorDia      = new HashMap();
    List citasHoy         = (List) request.getAttribute("citasHoy");         if (citasHoy         == null) citasHoy         = new ArrayList();
    List citasRecientes   = (List) request.getAttribute("citasRecientes");   if (citasRecientes   == null) citasRecientes   = new ArrayList();
    List especialidadesTop= (List) request.getAttribute("especialidadesTop");if (especialidadesTop== null) especialidadesTop= new ArrayList();

    int maxBarVal = Math.max(totalCitas, 1);
    int pctProg = (int)((citasProgramadas * 100.0) / maxBarVal);
    int pctConf = (int)((citasConfirmadas * 100.0) / maxBarVal);
    int pctAten = (int)((citasAtendidas   * 100.0) / maxBarVal);
    int pctCanc = (int)((citasCanceladas  * 100.0) / maxBarVal);
    int pctMes  = (int)(Math.min(citasMes, 100));

    String[] dayNames;
    String[] monthNames;
    if ("en".equals(lang)) {
        dayNames   = new String[]{"Su","Mo","Tu","We","Th","Fr","Sa"};
        monthNames = new String[]{"January","February","March","April","May","June","July","August","September","October","November","December"};
    } else if ("it".equals(lang)) {
        dayNames   = new String[]{"Do","Lu","Ma","Me","Gi","Ve","Sa"};
        monthNames = new String[]{"Gennaio","Febbraio","Marzo","Aprile","Maggio","Giugno","Luglio","Agosto","Settembre","Ottobre","Novembre","Dicembre"};
    } else {
        dayNames   = new String[]{"Do","Lu","Ma","Mi","Ju","Vi","Sa"};
        monthNames = new String[]{"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"};
    }

    Locale locale = "en".equals(lang) ? new Locale("en","US") : "it".equals(lang) ? new Locale("it","IT") : new Locale("es","ES");
    SimpleDateFormat sdfFecha  = new SimpleDateFormat("dd MMMM yyyy, EEEE", locale);
    SimpleDateFormat sdfDiaMes = new SimpleDateFormat("dd MMM", locale);

    String nombreUsuario = (String) session.getAttribute("usuarioNombre");
    if (nombreUsuario == null) nombreUsuario = "Usuario";
    String rolUsuario = (String) session.getAttribute("usuarioRol");
    if (rolUsuario == null) rolUsuario = "ROL";

    request.setAttribute("currentPage", "dashboard");
%>
<!DOCTYPE html>
<html lang="<%= lang %>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard · SaludBoyacá</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,500;0,700;1,500&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        /* ===== RESET + VARIABLES ===== */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --wine:         #561C24;
            --wine-mid:     #6D2932;
            --wine-light:   #8B3A45;
            --cream:        #E8D8C4;
            --cream-light:  #F5EDE4;
            --cream-pale:   #FBF7F3;
            --warm:         #C7B7A3;
            --white:        #FFFFFF;
            --text:         #2C1810;
            --text-muted:   #8B7355;
            --border:       rgba(199,183,163,0.35);
            --shadow-sm:    0 1px 8px rgba(86,28,36,0.08);
            --shadow-md:    0 4px 20px rgba(86,28,36,0.12);
            --shadow-lg:    0 8px 32px rgba(86,28,36,0.18);
            --success:      #2e7d50;
            --warning:      #c97d15;
            --info:         #1a6d9e;
            --danger:       #b41e1e;
            --radius-sm:    8px;
            --radius-md:    14px;
            --radius-lg:    20px;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--cream-pale);
            color: var(--text);
            min-height: 100vh;
            display: flex;
        }

        /* ===== PAGE LAYOUT ===== */
        .main-wrapper {
            margin-left: var(--sidebar-width, 260px);
            flex: 1;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            transition: margin-left 0.3s ease;
        }
        .sidebar.collapsed ~ .main-wrapper { margin-left: var(--sidebar-collapsed, 72px); }

        /* ===== TOPBAR ===== */
        .topbar {
            background: var(--white);
            border-bottom: 1px solid var(--border);
            padding: 12px 28px;
            display: flex; align-items: center; justify-content: space-between;
            box-shadow: var(--shadow-sm);
            position: sticky; top: 0; z-index: 100;
        }
        .topbar-title { font-family: 'Playfair Display', serif; font-size: 1.2rem; color: var(--wine); font-weight: 700; }
        .topbar-breadcrumb { font-size: 0.75rem; color: var(--text-muted); margin-top: 1px; }
        .live-pill {
            display: inline-flex; align-items: center; gap: 6px;
            background: rgba(46,125,80,0.1); color: var(--success);
            padding: 4px 12px; border-radius: 20px;
            font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .live-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--success); animation: pulse 1.5s infinite; }
        @keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:0.3;} }

        /* ===== PAGE CONTENT ===== */
        .page-content { padding: 22px 24px; flex: 1; }

        /* ===== WELCOME STRIP ===== */
        .welcome-strip {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 20px;
        }
        .welcome-name {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem; color: var(--wine); font-weight: 700;
        }
        .welcome-name em { color: var(--wine-mid); font-style: normal; }
        .welcome-date { font-size: 0.82rem; color: var(--text-muted); display: flex; align-items: center; gap: 6px; }
        .welcome-date i { color: var(--warm); }

        /* ===== MAIN GRID ===== */
        .dash-grid {
            display: grid;
            grid-template-columns: 1fr 290px;
            grid-template-rows: auto;
            gap: 18px;
        }

        /* ===== LEFT COLUMN ===== */
        .left-col { display: flex; flex-direction: column; gap: 18px; }

        /* ===== STATS ROW ===== */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 12px;
        }

        .stat-chip {
            background: var(--white);
            border-radius: var(--radius-md);
            padding: 14px 12px 12px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
            text-align: center;
            cursor: default;
            transition: transform 0.2s, box-shadow 0.2s;
            position: relative;
            overflow: hidden;
        }
        .stat-chip::after {
            content: '';
            position: absolute;
            bottom: 0; left: 0; right: 0;
            height: 3px;
            border-radius: 0 0 var(--radius-md) var(--radius-md);
        }
        .stat-chip:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .stat-chip.c-total   { border-top: 3px solid var(--wine); }        .stat-chip.c-total::after   { background: var(--wine); }
        .stat-chip.c-prog    { border-top: 3px solid var(--warning); }     .stat-chip.c-prog::after    { background: var(--warning); }
        .stat-chip.c-conf    { border-top: 3px solid var(--success); }     .stat-chip.c-conf::after    { background: var(--success); }
        .stat-chip.c-aten    { border-top: 3px solid var(--info); }        .stat-chip.c-aten::after    { background: var(--info); }
        .stat-chip.c-pac     { border-top: 3px solid var(--warm); }        .stat-chip.c-pac::after     { background: var(--warm); }
        .stat-chip.c-med     { border-top: 3px solid var(--danger); }      .stat-chip.c-med::after     { background: var(--danger); }

        .stat-chip-icon {
            width: 34px; height: 34px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 8px; font-size: 0.95rem;
        }
        .c-total .stat-chip-icon { background: rgba(86,28,36,0.1);   color: var(--wine); }
        .c-prog  .stat-chip-icon { background: rgba(201,125,21,0.1); color: var(--warning); }
        .c-conf  .stat-chip-icon { background: rgba(46,125,80,0.1);  color: var(--success); }
        .c-aten  .stat-chip-icon { background: rgba(26,109,158,0.1); color: var(--info); }
        .c-pac   .stat-chip-icon { background: rgba(199,183,163,0.2); color: var(--text-muted); }
        .c-med   .stat-chip-icon { background: rgba(180,30,30,0.1);  color: var(--danger); }

        .stat-chip-num {
            font-family: 'Playfair Display', serif;
            font-size: 1.6rem; font-weight: 700;
            color: var(--wine); line-height: 1; margin-bottom: 2px;
        }
        .stat-chip-lbl {
            font-size: 0.65rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.6px;
            color: var(--text-muted);
        }

        /* ===== MIDDLE ROW: chart + upcoming ===== */
        .mid-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        /* ===== CARD BASE ===== */
        .card-base {
            background: var(--white);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
            overflow: hidden;
        }
        .card-head {
            padding: 13px 18px;
            background: linear-gradient(135deg, var(--wine) 0%, var(--wine-mid) 100%);
            color: var(--cream);
            font-family: 'Playfair Display', serif;
            font-size: 0.88rem; font-weight: 600;
            display: flex; align-items: center; gap: 8px;
        }
        .card-head-link {
            margin-left: auto; font-size: 0.72rem;
            color: var(--cream); opacity: 0.75; text-decoration: none;
            font-family: 'DM Sans', sans-serif; font-weight: 400;
        }
        .card-head-link:hover { opacity: 1; }
        .card-body { padding: 16px 18px; }

        /* ===== BAR CHART ===== */
        .bar-chart-wrap {
            display: flex; align-items: flex-end; justify-content: space-around;
            height: 160px; padding: 0 8px;
        }
        .bar-col {
            display: flex; flex-direction: column;
            align-items: center; gap: 6px; flex: 1;
        }
        .bar-num { font-family: 'Playfair Display', serif; font-size: 1rem; font-weight: 700; color: var(--wine); }
        .bar-track { width: 40px; border-radius: 8px 8px 4px 4px; background: var(--cream-light); position: relative; overflow: hidden; }
        .bar-fill { position: absolute; bottom: 0; left: 0; right: 0; border-radius: 8px 8px 0 0; transition: height 1.2s cubic-bezier(0.34,1.56,0.64,1); }
        .bar-fill.p { background: linear-gradient(180deg,#f0b84a,var(--warning)); }
        .bar-fill.c { background: linear-gradient(180deg,#5bb88a,var(--success)); }
        .bar-fill.a { background: linear-gradient(180deg,#5aade0,var(--info)); }
        .bar-fill.x { background: linear-gradient(180deg,#e57373,var(--danger)); }
        .bar-lbl { font-size: 0.65rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.4px; text-align: center; }

        /* ===== UPCOMING CITAS ===== */
        .upcoming-item {
            display: flex; align-items: center; gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid var(--border);
        }
        .upcoming-item:last-child { border-bottom: none; }
        .upcoming-time-badge {
            background: var(--cream-light);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            padding: 6px 10px;
            text-align: center;
            min-width: 52px;
            flex-shrink: 0;
        }
        .upcoming-time { font-family: 'Playfair Display', serif; font-size: 0.9rem; font-weight: 700; color: var(--wine); line-height: 1; }
        .upcoming-info { flex: 1; }
        .upcoming-paciente { font-size: 0.83rem; font-weight: 600; color: var(--text); }
        .upcoming-esp { font-size: 0.72rem; color: var(--text-muted); }
        .upcoming-badge {
            padding: 3px 9px; border-radius: 20px;
            font-size: 0.65rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.3px;
        }
        .upcoming-badge.programada { background: rgba(201,125,21,0.12); color: var(--warning); }
        .upcoming-badge.confirmada { background: rgba(46,125,80,0.12);  color: var(--success); }
        .upcoming-badge.atendida   { background: rgba(26,109,158,0.12); color: var(--info); }
        .upcoming-badge.cancelada  { background: rgba(180,30,30,0.1);  color: var(--danger); }

        /* ===== ESPECIALIDADES ===== */
        .esp-row {
            display: flex; align-items: center; gap: 10px;
            padding: 8px 0; border-bottom: 1px solid var(--border);
        }
        .esp-row:last-child { border-bottom: none; }
        .esp-rank {
            width: 24px; height: 24px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-family: 'Playfair Display', serif; font-size: 0.75rem; font-weight: 700;
            flex-shrink: 0;
        }
        .esp-rank.g { background: linear-gradient(135deg,#FFD700,#FFA500); color: white; }
        .esp-rank.s { background: linear-gradient(135deg,#C0C0C0,#909090); color: white; }
        .esp-rank.b { background: linear-gradient(135deg,#CD7F32,#A06020); color: white; }
        .esp-rank.n { background: var(--cream-light); color: var(--text-muted); }
        .esp-info { flex: 1; }
        .esp-name { font-size: 0.8rem; font-weight: 600; color: var(--text); }
        .esp-bar { height: 4px; background: var(--cream-light); border-radius: 2px; margin-top: 3px; overflow: hidden; }
        .esp-bar-fill { height: 100%; border-radius: 2px; background: linear-gradient(90deg, var(--wine), var(--wine-mid)); }
        .esp-cnt { font-family: 'Playfair Display', serif; font-size: 0.9rem; font-weight: 700; color: var(--wine); }

        /* ===== RIGHT COLUMN ===== */
        .right-col { display: flex; flex-direction: column; gap: 18px; }

        /* ===== PROFILE CARD ===== */
        .profile-wrap {
            background: linear-gradient(145deg, var(--wine) 0%, var(--wine-mid) 60%, #4a1520 100%);
            border-radius: var(--radius-lg);
            padding: 22px 18px;
            text-align: center;
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
        }
        .profile-wrap::before {
            content: '';
            position: absolute;
            top: -30px; right: -30px;
            width: 120px; height: 120px;
            border-radius: 50%;
            background: rgba(255,255,255,0.05);
        }
        .profile-wrap::after {
            content: '';
            position: absolute;
            bottom: -20px; left: -20px;
            width: 80px; height: 80px;
            border-radius: 50%;
            background: rgba(255,255,255,0.04);
        }
        .profile-avatar-ring {
            width: 68px; height: 68px;
            border-radius: 50%;
            background: rgba(232,216,196,0.15);
            border: 2px solid rgba(232,216,196,0.4);
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 12px;
            font-size: 1.6rem; color: var(--cream);
            position: relative; z-index: 1;
        }
        .profile-uname {
            font-family: 'Playfair Display', serif;
            font-size: 1rem; font-weight: 700;
            color: var(--cream); margin-bottom: 3px;
            position: relative; z-index: 1;
        }
        .profile-urole {
            font-size: 0.68rem; font-weight: 600;
            color: var(--warm); text-transform: uppercase;
            letter-spacing: 1.5px; margin-bottom: 16px;
            position: relative; z-index: 1;
        }
        .profile-counters {
            display: flex; justify-content: center; gap: 0;
            background: rgba(255,255,255,0.08);
            border-radius: var(--radius-sm);
            position: relative; z-index: 1;
            overflow: hidden;
        }
        .profile-cnt {
            flex: 1; padding: 10px 6px; text-align: center;
            border-right: 1px solid rgba(255,255,255,0.1);
        }
        .profile-cnt:last-child { border-right: none; }
        .profile-cnt-val { font-family: 'Playfair Display', serif; font-size: 1.3rem; font-weight: 700; color: var(--cream); line-height: 1; }
        .profile-cnt-lbl { font-size: 0.6rem; font-weight: 600; color: var(--warm); text-transform: uppercase; letter-spacing: 0.5px; }

        /* ===== CALENDARIO ===== */
        .cal-wrap {
            background: var(--white);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
            overflow: hidden;
        }
        .cal-head {
            background: linear-gradient(135deg, var(--wine), var(--wine-mid));
            padding: 8px 12px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .cal-title { font-family: 'Playfair Display', serif; font-size: 0.75rem; color: var(--cream); font-weight: 600; }
        .cal-nav { display: flex; gap: 4px; align-items: center; }
        .cal-nav-btn {
            width: 20px; height: 20px;
            background: rgba(255,255,255,0.15);
            border: none; border-radius: 5px;
            color: var(--cream); font-size: 0.55rem;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; text-decoration: none; transition: background 0.2s;
        }
        .cal-nav-btn:hover { background: rgba(255,255,255,0.3); color: white; }
        .cal-month-lbl { font-size: 0.65rem; font-weight: 600; color: var(--cream); min-width: 70px; text-align: center; }
        .cal-inner { padding: 8px 6px 4px; }
        .cal-wdays { display: grid; grid-template-columns: repeat(7,1fr); gap: 1px; margin-bottom: 2px; }
        .cal-wd { text-align: center; font-size: 0.5rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; padding: 2px 0; }
        .cal-cells { display: grid; grid-template-columns: repeat(7,1fr); gap: 2px; }
        .cal-cell {
            aspect-ratio: 1;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            border-radius: 5px; font-size: 0.6rem; font-weight: 500;
            cursor: pointer; transition: all 0.12s;
            position: relative; border: 1.5px solid transparent;
        }
        .cal-cell.empty { cursor: default; }
        .cal-cell:hover:not(.empty):not(.today) { background: var(--cream-light); }
        .cal-cell.today { background: var(--wine); color: white; font-weight: 700; box-shadow: 0 2px 8px rgba(86,28,36,0.35); }
        .cal-cell.has-p { background: rgba(201,125,21,0.14); border-color: rgba(201,125,21,0.45); color: #7a5200; font-weight: 600; }
        .cal-cell.has-c { background: rgba(46,125,80,0.14);  border-color: rgba(46,125,80,0.45);  color: #155230; font-weight: 600; }
        .cal-cell.has-a { background: rgba(26,109,158,0.14); border-color: rgba(26,109,158,0.45); color: #073e62; font-weight: 600; }
        .cal-cell.has-x { background: rgba(180,30,30,0.1);   border-color: rgba(180,30,30,0.3);   color: #700000; font-weight: 600; }
        .cal-cell .cdot {
            width: 3px; height: 3px; border-radius: 50%;
            position: absolute; bottom: 2px;
        }
        .cal-cell.has-p .cdot { background: var(--warning); }
        .cal-cell.has-c .cdot { background: var(--success); }
        .cal-cell.has-a .cdot { background: var(--info); }
        .cal-cell.has-x .cdot { background: var(--danger); }
        .cal-tip {
            display: none; position: absolute;
            bottom: calc(100% + 4px); left: 50%;
            transform: translateX(-50%);
            background: var(--wine); color: white;
            padding: 5px 8px; border-radius: 6px;
            font-size: 0.6rem; white-space: nowrap;
            z-index: 200; pointer-events: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            line-height: 1.5;
        }
        .cal-tip::after {
            content:''; position: absolute;
            top:100%; left:50%; transform:translateX(-50%);
            border:4px solid transparent;
            border-top-color: var(--wine);
        }
        .cal-cell:hover .cal-tip { display: block; }
        .cal-legend-row {
            display: flex; justify-content: center; gap: 10px;
            padding: 6px 8px; border-top: 1px solid var(--border);
        }
        .cal-lgd { display: flex; align-items: center; gap: 3px; font-size: 0.55rem; color: var(--text-muted); font-weight: 600; }
        .cal-lgd-dot { width: 7px; height: 7px; border-radius: 50%; }
        .cal-lgd-dot.p { background: var(--warning); }
        .cal-lgd-dot.c { background: var(--success); }
        .cal-lgd-dot.a { background: var(--info); }
        .cal-lgd-dot.x { background: var(--danger); }

        /* ===== PROGRESS DONUT ===== */
        .donut-wrap {
            background: var(--white);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border);
            padding: 16px;
            text-align: center;
        }
        .donut-title {
            font-family: 'Playfair Display', serif;
            font-size: 0.88rem; color: var(--wine); font-weight: 600;
            margin-bottom: 12px;
        }
        .donut-ring { position: relative; width: 110px; height: 110px; margin: 0 auto; }
        .donut-ring svg { transform: rotate(-90deg); }
        .donut-bg   { fill: none; stroke: var(--cream-light); stroke-width: 10; }
        .donut-fill { fill: none; stroke-width: 10; stroke-linecap: round; transition: stroke-dashoffset 1.5s ease; stroke: url(#dg); }
        .donut-center {
            position: absolute; top:50%; left:50%;
            transform: translate(-50%,-50%); text-align: center;
        }
        .donut-pct { font-family: 'Playfair Display', serif; font-size: 1.4rem; font-weight: 700; color: var(--wine); line-height: 1; }
        .donut-sub { font-size: 0.62rem; color: var(--text-muted); font-weight: 600; text-transform: uppercase; }
        .donut-meta { margin-top: 10px; font-size: 0.75rem; color: var(--text-muted); }
        .donut-meta strong { color: var(--wine); font-family: 'Playfair Display', serif; }

        /* ===== FOOTER ===== */
        .footer-salud {
            background: var(--wine);
            color: var(--warm);
            padding: 12px 28px;
            text-align: center;
            font-size: 0.78rem;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1300px) {
            .dash-grid { grid-template-columns: 1fr; }
            .right-col { display: grid; grid-template-columns: repeat(3,1fr); }
        }
        @media (max-width: 1024px) {
            .stats-row { grid-template-columns: repeat(3,1fr); }
            .mid-row { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .stats-row { grid-template-columns: repeat(2,1fr); }
            .right-col { grid-template-columns: 1fr; }
            .page-content { padding: 14px; }
        }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <jsp:include page="/WEB-INF/views/componentes/sidebar.jsp" />

    <div class="main-wrapper" id="mainWrapper">

        <!-- TOPBAR -->
        <div class="topbar">
            <div>
                <div class="topbar-title">
                    <%= "en".equals(lang) ? "Dashboard" : "it".equals(lang) ? "Pannello" : "Panel de Control" %>
                </div>
                <div class="topbar-breadcrumb">
                    SaludBoyacá &rsaquo; <%= "en".equals(lang) ? "Dashboard" : "it".equals(lang) ? "Pannello" : "Dashboard" %>
                </div>
            </div>
            <div>
                <span class="live-pill">
                    <span class="live-dot"></span>
                    <%= "en".equals(lang) ? "Live" : "it".equals(lang) ? "Diretta" : "En vivo" %>
                </span>
            </div>
        </div>

        <div class="page-content">

            <!-- WELCOME -->
            <div class="welcome-strip">
                <div>
                    <div class="welcome-name">
                        <%= "en".equals(lang) ? "Hello, " : "it".equals(lang) ? "Ciao, " : "Hola, " %>
                        <em><%= nombreUsuario %>!</em>
                    </div>
                    <div style="font-size:0.78rem; color:var(--text-muted); margin-top:2px;">
                        <%= rolUsuario %> &mdash; SaludBoyacá
                    </div>
                </div>
                <div class="welcome-date">
                    <i class="far fa-calendar-alt"></i>
                    <%= sdfFecha.format(new java.util.Date()) %>
                </div>
            </div>

            <!-- MAIN GRID -->
            <div class="dash-grid">

                <!-- LEFT COLUMN -->
                <div class="left-col">

                    <!-- STATS ROW -->
                    <div class="stats-row">
                        <div class="stat-chip c-total">
                            <div class="stat-chip-icon"><i class="fas fa-calendar-check"></i></div>
                            <div class="stat-chip-num"><%= totalCitas %></div>
                            <div class="stat-chip-lbl"><%= "en".equals(lang) ? "Total" : "Total" %></div>
                        </div>
                        <div class="stat-chip c-prog">
                            <div class="stat-chip-icon"><i class="fas fa-clock"></i></div>
                            <div class="stat-chip-num"><%= citasProgramadas %></div>
                            <div class="stat-chip-lbl"><%= "en".equals(lang) ? "Scheduled" : "it".equals(lang) ? "Program." : "Program." %></div>
                        </div>
                        <div class="stat-chip c-conf">
                            <div class="stat-chip-icon"><i class="fas fa-check-circle"></i></div>
                            <div class="stat-chip-num"><%= citasConfirmadas %></div>
                            <div class="stat-chip-lbl"><%= "en".equals(lang) ? "Confirmed" : "it".equals(lang) ? "Conferm." : "Confirm." %></div>
                        </div>
                        <div class="stat-chip c-aten">
                            <div class="stat-chip-icon"><i class="fas fa-user-check"></i></div>
                            <div class="stat-chip-num"><%= citasAtendidas %></div>
                            <div class="stat-chip-lbl"><%= "en".equals(lang) ? "Attended" : "it".equals(lang) ? "Servite" : "Atendidas" %></div>
                        </div>
                        <div class="stat-chip c-pac">
                            <div class="stat-chip-icon"><i class="fas fa-users"></i></div>
                            <div class="stat-chip-num"><%= totalPacientes %></div>
                            <div class="stat-chip-lbl"><%= "en".equals(lang) ? "Patients" : "it".equals(lang) ? "Pazienti" : "Pacientes" %></div>
                        </div>
                        <div class="stat-chip c-med">
                            <div class="stat-chip-icon"><i class="fas fa-user-md"></i></div>
                            <div class="stat-chip-num"><%= totalMedicos %></div>
                            <div class="stat-chip-lbl"><%= "en".equals(lang) ? "Doctors" : "it".equals(lang) ? "Medici" : "Médicos" %></div>
                        </div>
                    </div>

                    <!-- MID ROW -->
                    <div class="mid-row">

                        <!-- BAR CHART -->
                        <div class="card-base">
                            <div class="card-head">
                                <i class="fas fa-chart-bar"></i>
                                <%= "en".equals(lang) ? "Appointments by Status" : "it".equals(lang) ? "Per Stato" : "Citas por Estado" %>
                            </div>
                            <div class="card-body" style="padding-bottom:20px;">
                                <div class="bar-chart-wrap">
                                    <div class="bar-col">
                                        <div class="bar-num"><%= citasProgramadas %></div>
                                        <div class="bar-track" style="height:120px;">
                                            <div class="bar-fill p" style="height:<%= pctProg %>%;"></div>
                                        </div>
                                        <div class="bar-lbl"><%= "en".equals(lang) ? "Sched." : "it".equals(lang) ? "Prog." : "Prog." %></div>
                                    </div>
                                    <div class="bar-col">
                                        <div class="bar-num"><%= citasConfirmadas %></div>
                                        <div class="bar-track" style="height:120px;">
                                            <div class="bar-fill c" style="height:<%= pctConf %>%;"></div>
                                        </div>
                                        <div class="bar-lbl"><%= "en".equals(lang) ? "Conf." : "it".equals(lang) ? "Conf." : "Conf." %></div>
                                    </div>
                                    <div class="bar-col">
                                        <div class="bar-num"><%= citasAtendidas %></div>
                                        <div class="bar-track" style="height:120px;">
                                            <div class="bar-fill a" style="height:<%= pctAten %>%;"></div>
                                        </div>
                                        <div class="bar-lbl"><%= "en".equals(lang) ? "Attend." : "it".equals(lang) ? "Serv." : "Aten." %></div>
                                    </div>
                                    <div class="bar-col">
                                        <div class="bar-num"><%= citasCanceladas %></div>
                                        <div class="bar-track" style="height:120px;">
                                            <div class="bar-fill x" style="height:<%= pctCanc %>%;"></div>
                                        </div>
                                        <div class="bar-lbl"><%= "en".equals(lang) ? "Cancld." : "it".equals(lang) ? "Annul." : "Canc." %></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- UPCOMING CITAS -->
                        <div class="card-base">
                            <div class="card-head">
                                <i class="fas fa-list-ul"></i>
                                <%= "en".equals(lang) ? "Today's Appointments" : "it".equals(lang) ? "Oggi" : "Citas de Hoy" %>
                                <a href="${pageContext.request.contextPath}/citas/listar" class="card-head-link">
                                    <%= "en".equals(lang) ? "See all →" : "it".equals(lang) ? "Vedi →" : "Ver todas →" %>
                                </a>
                            </div>
                            <div class="card-body">
                                <% if (!citasHoy.isEmpty()) {
                                    int maxShow = Math.min(citasHoy.size(), 5);
                                    for (int i = 0; i < maxShow; i++) {
                                        Cita c = (Cita) citasHoy.get(i);
                                        String est = c.getEstado() != null ? c.getEstado().toLowerCase() : "programada";
                                        String hora = c.getHoraCita() != null ? c.getHoraCita().toString().substring(0,5) : "--:--";
                                %>
                                    <div class="upcoming-item">
                                        <div class="upcoming-time-badge">
                                            <div class="upcoming-time"><%= hora %></div>
                                        </div>
                                        <div class="upcoming-info">
                                            <div class="upcoming-paciente"><%= c.getNombrePaciente() != null ? c.getNombrePaciente() : "Paciente" %></div>
                                            <div class="upcoming-esp"><%= c.getNombreEspecialidad() != null ? c.getNombreEspecialidad() : "" %></div>
                                        </div>
                                        <span class="upcoming-badge <%= est %>"><%= c.getEstado() %></span>
                                    </div>
                                <% } } else { %>
                                    <div style="text-align:center; padding:30px 0; color:var(--text-muted);">
                                        <i class="fas fa-calendar-day" style="font-size:2rem; opacity:0.3; display:block; margin-bottom:8px;"></i>
                                        <%= "en".equals(lang) ? "No appointments today" : "it".equals(lang) ? "Nessun appuntamento" : "Sin citas hoy" %>
                                    </div>
                                <% } %>
                            </div>
                        </div>

                    </div>

                    <!-- BOTTOM ROW: especialidades + actividad reciente -->
                    <div class="mid-row">

                        <!-- TOP ESPECIALIDADES -->
                        <div class="card-base">
                            <div class="card-head">
                                <i class="fas fa-trophy"></i>
                                <%= "en".equals(lang) ? "Top Specialties" : "it".equals(lang) ? "Top Specialità" : "Top Especialidades" %>
                            </div>
                            <div class="card-body">
                                <% if (!especialidadesTop.isEmpty()) {
                                    CitaDAO.EspecialidadTop ft = (CitaDAO.EspecialidadTop) especialidadesTop.get(0);
                                    int mx = ft.getTotalCitas() > 0 ? ft.getTotalCitas() : 1;
                                    String[] rankCls = {"g","s","b","n","n"};
                                    for (int e = 0; e < especialidadesTop.size() && e < 5; e++) {
                                        CitaDAO.EspecialidadTop et = (CitaDAO.EspecialidadTop) especialidadesTop.get(e);
                                        int pct = (et.getTotalCitas() * 100) / mx;
                                        String rc = e < rankCls.length ? rankCls[e] : "n";
                                %>
                                    <div class="esp-row">
                                        <div class="esp-rank <%= rc %>"><%= e+1 %></div>
                                        <div class="esp-info">
                                            <div class="esp-name"><%= et.getNombre() %></div>
                                            <div class="esp-bar"><div class="esp-bar-fill" style="width:<%= pct %>%"></div></div>
                                        </div>
                                        <div class="esp-cnt"><%= et.getTotalCitas() %></div>
                                    </div>
                                <% } } else { %>
                                    <div style="text-align:center; padding:24px 0; color:var(--text-muted);">
                                        <i class="fas fa-chart-bar" style="font-size:1.8rem; opacity:0.3; display:block; margin-bottom:8px;"></i>
                                        <%= "en".equals(lang) ? "No data" : "Sin datos" %>
                                    </div>
                                <% } %>
                            </div>
                        </div>

                        <!-- ACTIVIDAD RECIENTE -->
                        <div class="card-base">
                            <div class="card-head">
                                <i class="fas fa-history"></i>
                                <%= "en".equals(lang) ? "Recent Activity" : "it".equals(lang) ? "Attività" : "Actividad Reciente" %>
                            </div>
                            <div class="card-body">
                                <% if (!citasRecientes.isEmpty()) {
                                    int cnt = 0;
                                    for (int c = 0; c < citasRecientes.size() && cnt < 5; c++) {
                                        Cita cita = (Cita) citasRecientes.get(c);
                                        String timeAgo = "";
                                        if (cita.getFechaRegistro() != null) {
                                            long diff = new java.util.Date().getTime() - cita.getFechaRegistro().getTime();
                                            long hrs = diff / 3600000; long ds = hrs / 24;
                                            if (ds > 0) timeAgo = ds + ("en".equals(lang) ? "d ago" : "it".equals(lang) ? "g fa" : "d atrás");
                                            else if (hrs > 0) timeAgo = hrs + ("en".equals(lang) ? "h ago" : "it".equals(lang) ? "h fa" : "h atrás");
                                            else timeAgo = "en".equals(lang) ? "Now" : "it".equals(lang) ? "Ora" : "Ahora";
                                        }
                                        String est2 = cita.getEstado() != null ? cita.getEstado().toLowerCase() : "programada";
                                %>
                                    <div class="upcoming-item">
                                        <div class="upcoming-time-badge" style="min-width:44px;">
                                            <div style="font-size:0.7rem; color:var(--text-muted); font-weight:600;"><%= timeAgo %></div>
                                        </div>
                                        <div class="upcoming-info">
                                            <div class="upcoming-paciente"><%= cita.getNombrePaciente() != null ? cita.getNombrePaciente() : "Paciente" %></div>
                                            <div class="upcoming-esp"><%= cita.getNombreEspecialidad() != null ? cita.getNombreEspecialidad() : "" %></div>
                                        </div>
                                        <span class="upcoming-badge <%= est2 %>"><%= cita.getEstado() %></span>
                                    </div>
                                <% cnt++; }
                                } else { %>
                                    <div style="text-align:center; padding:24px 0; color:var(--text-muted);">
                                        <i class="fas fa-bell-slash" style="font-size:1.8rem; opacity:0.3; display:block; margin-bottom:8px;"></i>
                                        <%= "en".equals(lang) ? "No recent activity" : "Sin actividad" %>
                                    </div>
                                <% } %>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- RIGHT COLUMN -->
                <div class="right-col">

                    <!-- PROFILE -->
                    <div class="profile-wrap">
                        <div class="profile-avatar-ring"><i class="fas fa-user-md"></i></div>
                        <div class="profile-uname"><%= nombreUsuario %></div>
                        <div class="profile-urole"><%= rolUsuario %></div>
                        <div class="profile-counters">
                            <div class="profile-cnt">
                                <div class="profile-cnt-val"><%= citasHoyCount %></div>
                                <div class="profile-cnt-lbl"><%= "en".equals(lang) ? "Today" : "Hoy" %></div>
                            </div>
                            <div class="profile-cnt">
                                <div class="profile-cnt-val"><%= citasMes %></div>
                                <div class="profile-cnt-lbl"><%= "en".equals(lang) ? "Month" : "Mes" %></div>
                            </div>
                            <div class="profile-cnt">
                                <div class="profile-cnt-val"><%= totalCitas %></div>
                                <div class="profile-cnt-lbl"><%= "en".equals(lang) ? "Total" : "Total" %></div>
                            </div>
                        </div>
                    </div>

                    <!-- CALENDARIO -->
                    <div class="cal-wrap">
                        <div class="cal-head">
                            <div class="cal-title"><i class="far fa-calendar-alt" style="margin-right:5px;"></i><%= "en".equals(lang) ? "Calendar" : "Calendario" %></div>
                            <div class="cal-nav">
                                <a href="${pageContext.request.contextPath}/dashboard?calYear=<%= calMonth==1?calYear-1:calYear %>&calMonth=<%= calMonth==1?12:calMonth-1 %>&lang=<%= lang %>" class="cal-nav-btn">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                                <span class="cal-month-lbl"><%= monthNames[calMonth-1] %> <%= calYear %></span>
                                <a href="${pageContext.request.contextPath}/dashboard?calYear=<%= calMonth==12?calYear+1:calYear %>&calMonth=<%= calMonth==12?1:calMonth+1 %>&lang=<%= lang %>" class="cal-nav-btn">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </div>
                        </div>
                        <div class="cal-inner">
                            <div class="cal-wdays">
                                <% for (String d : dayNames) { %><div class="cal-wd"><%= d %></div><% } %>
                            </div>
                            <div class="cal-cells">
                                <%
                                    int empty = firstDayOfWeek - Calendar.SUNDAY;
                                    if (empty < 0) empty += 7;
                                    for (int i = 0; i < empty; i++) { %><div class="cal-cell empty"></div><% }
                                    for (int dia = 1; dia <= daysInMonth; dia++) {
                                        String fk = String.format("%04d-%02d-%02d", calYear, calMonth, dia);
                                        List cd = (List) citasPorDia.get(fk);
                                        boolean hasCitas = cd != null && !cd.isEmpty();
                                        boolean isHoy = esMesActual && dia == hoyDia;
                                        String cls = isHoy ? " today" : "";
                                        String tipHtml = "";
                                        if (hasCitas) {
                                            int pp=0,cc=0,aa=0,xx=0;
                                            for (int ci=0; ci<cd.size(); ci++) {
                                                Cita cit=(Cita)cd.get(ci);
                                                String es = cit.getEstado()!=null?cit.getEstado().toUpperCase():"PROGRAMADA";
                                                if("PROGRAMADA".equals(es))pp++;
                                                else if("CONFIRMADA".equals(es))cc++;
                                                else if("ATENDIDA".equals(es))aa++;
                                                else if("CANCELADA".equals(es))xx++;
                                            }
                                            // Clase por estado predominante
                                            if(xx>0) cls+=" has-x";
                                            else if(aa>0) cls+=" has-a";
                                            else if(cc>0) cls+=" has-c";
                                            else cls+=" has-p";
                                            // Tooltip
                                            StringBuilder sb = new StringBuilder();
                                            for(int ci=0;ci<cd.size();ci++){
                                                Cita cit=(Cita)cd.get(ci);
                                                sb.append(cit.getHoraCita()!=null?cit.getHoraCita().toString().substring(0,5):"--:--");
                                                sb.append(" ").append(cit.getNombrePaciente()!=null?cit.getNombrePaciente():"");
                                                if(ci<cd.size()-1) sb.append("<br>");
                                            }
                                            tipHtml = sb.toString();
                                        }
                                %>
                                    <div class="cal-cell<%= cls %>">
                                        <%= dia %>
                                        <% if (hasCitas) { %>
                                            <span class="cdot"></span>
                                            <div class="cal-tip"><%= tipHtml %></div>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                        <div class="cal-legend-row">
                            <div class="cal-lgd"><div class="cal-lgd-dot p"></div><%= "en".equals(lang)?"Sched.":"it".equals(lang)?"Prog.":"Prog." %></div>
                            <div class="cal-lgd"><div class="cal-lgd-dot c"></div><%= "en".equals(lang)?"Conf.":"it".equals(lang)?"Conf.":"Conf." %></div>
                            <div class="cal-lgd"><div class="cal-lgd-dot a"></div><%= "en".equals(lang)?"Attend.":"it".equals(lang)?"Serv.":"Aten." %></div>
                            <div class="cal-lgd"><div class="cal-lgd-dot x"></div><%= "en".equals(lang)?"Cancld.":"it".equals(lang)?"Ann.":"Canc." %></div>
                        </div>
                    </div>

                    <!-- DONUT META MENSUAL -->
                    <div class="donut-wrap">
                        <div class="donut-title">
                            <%= "en".equals(lang) ? "Monthly Goal" : "it".equals(lang) ? "Obiettivo Mensile" : "Meta Mensual" %>
                        </div>
                        <div class="donut-ring">
                            <svg width="110" height="110" viewBox="0 0 110 110">
                                <defs>
                                    <linearGradient id="dg" x1="0%" y1="0%" x2="100%" y2="0%">
                                        <stop offset="0%"   stop-color="#561C24"/>
                                        <stop offset="100%" stop-color="#6D2932"/>
                                    </linearGradient>
                                </defs>
                                <circle class="donut-bg"   cx="55" cy="55" r="47"/>
                                <circle class="donut-fill" cx="55" cy="55" r="47"
                                    stroke-dasharray="295.3"
                                    stroke-dashoffset="<%= 295.3 - (295.3 * pctMes) / 100.0 %>"/>
                            </svg>
                            <div class="donut-center">
                                <div class="donut-pct"><%= pctMes %>%</div>
                                <div class="donut-sub"><%= citasMes %> <%= "en".equals(lang)?"appts":"it".equals(lang)?"appunt.":"citas" %></div>
                            </div>
                        </div>
                        <div class="donut-meta">
                            <%= "en".equals(lang) ? "Target:" : "it".equals(lang) ? "Obiettivo:" : "Meta:" %>
                            <strong>100</strong> / <%= "en".equals(lang)?"month":"it".equals(lang)?"mese":"mes" %>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="footer-salud">
            &copy; 2026 Salud Boyacá &mdash;
            <%= "en".equals(lang) ? "Healthcare Management System" : "it".equals(lang) ? "Sistema di Gestione Sanitaria" : "Sistema de Gestión de Salud" %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function () {

        // Animar stat chips con stagger
        document.querySelectorAll('.stat-chip').forEach(function(el, i) {
            el.style.opacity = '0';
            el.style.transform = 'translateY(16px)';
            setTimeout(function() {
                el.style.transition = 'all 0.4s ease';
                el.style.opacity = '1';
                el.style.transform = 'translateY(0)';
            }, i * 70);
        });

        // Animar barras
        document.querySelectorAll('.bar-fill').forEach(function(bar, i) {
            var h = bar.style.height;
            bar.style.height = '0%';
            setTimeout(function() {
                bar.style.transition = 'height 1.2s cubic-bezier(0.34,1.56,0.64,1)';
                bar.style.height = h;
            }, 400 + i * 100);
        });

        // Animar donut
        var donut = document.querySelector('.donut-fill');
        if (donut) {
            var finalOffset = donut.getAttribute('stroke-dashoffset');
            donut.setAttribute('stroke-dashoffset', '295.3');
            setTimeout(function() {
                donut.style.transition = 'stroke-dashoffset 1.5s ease';
                donut.setAttribute('stroke-dashoffset', finalOffset);
            }, 600);
        }

        // Sidebar toggle
        var btn = document.getElementById('sidebarToggle');
        var sb  = document.getElementById('sidebar');
        if (btn && sb) {
            btn.addEventListener('click', function() {
                sb.classList.toggle('collapsed');
                document.getElementById('mainWrapper').classList.toggle('expanded');
            });
        }
    });
    </script>
    <%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
</body>
</html>
