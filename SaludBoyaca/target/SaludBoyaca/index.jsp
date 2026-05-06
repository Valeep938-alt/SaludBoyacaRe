<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>
<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="app.nombre"/></title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

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
            --shadow:       rgba(86,28,36,0.12);
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'DM Sans', system-ui, sans-serif;
            background: var(--cream-light);
            color: var(--text-dark);
            overflow-x: hidden;
        }

        /* ─── NAVBAR ─── */
        .navbar {
            background: var(--white);
            padding: 0 3rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 80px;
            position: sticky;
            top: 0;
            z-index: 200;
            box-shadow: 0 1px 20px rgba(0,0,0,0.06);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }
        .brand-icon {
            width: 44px; height: 44px;
            background: var(--wine-deep);
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 16px rgba(86,28,36,0.3);
            flex-shrink: 0;
        }
        .brand-text { line-height: 1.2; }
        .brand-name { 
            color: var(--wine-deep); 
            font-family: 'Syne', sans-serif; 
            font-size: 1.2rem; 
            font-weight: 800; 
            letter-spacing: -0.01em; 
        }
        .brand-sub  { 
            color: var(--wine-mid); 
            font-size: 0.65rem; 
            letter-spacing: 0.08em; 
            text-transform: uppercase; 
            font-weight: 600;
        }

        .nav-center { display: flex; align-items: center; gap: 32px; }
        .nav-link {
            color: var(--text-muted);
            font-size: 0.9rem;
            font-weight: 500;
            text-decoration: none;
            transition: color 0.2s;
            position: relative;
        }
        .nav-link:hover { color: var(--wine-deep); }
        .nav-link::after {
            content: '';
            position: absolute;
            bottom: -4px; left: 0;
            width: 0; height: 2px;
            background: var(--wine-deep);
            transition: width 0.3s;
            border-radius: 2px;
        }
        .nav-link:hover::after { width: 100%; }

        .nav-right { display: flex; align-items: center; gap: 16px; }

        /* Language switcher */
        .lang-pills {
            display: flex;
            gap: 4px;
            background: var(--cream-light);
            border: 1px solid var(--border-light);
            border-radius: 10px;
            padding: 4px;
        }
        .lang-pill {
            display: flex; align-items: center; gap: 6px;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            cursor: pointer;
            border: none;
            background: transparent;
            transition: all 0.2s;
            letter-spacing: 0.03em;
        }
        .lang-pill:hover { color: var(--wine-deep); background: rgba(86,28,36,0.06); }
        .lang-pill.active { background: var(--wine-deep); color: var(--white); }
        .lang-flag { font-size: 0.9rem; line-height: 1; }

        .btn-nav-login {
            background: var(--wine-deep);
            color: var(--white);
            border: none;
            padding: 12px 28px;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.25s;
            box-shadow: 0 4px 16px rgba(86,28,36,0.3);
            display: flex; align-items: center; gap: 8px;
        }
        .btn-nav-login:hover { 
            background: var(--wine-mid); 
            transform: translateY(-1px); 
            box-shadow: 0 6px 20px rgba(109,41,50,0.4); 
            color: var(--white); 
        }

        /* ─── HERO ─── */
        .hero-wrapper {
            padding: 1.5rem 3rem 0;
        }
        .hero {
            position: relative;
            min-height: 78vh;
            display: flex;
            align-items: flex-end;
            overflow: hidden;
            border-radius: 32px;
            background: linear-gradient(135deg, var(--wine-deep) 0%, var(--wine-mid) 40%, #8B3A44 100%);
            padding: 4rem;
        }
        .hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.03'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            opacity: 0.4;
        }
        .hero::after {
            content: '';
            position: absolute;
            right: -10%; top: -20%;
            width: 600px; height: 600px;
            background: radial-gradient(ellipse, rgba(199,183,163,0.15) 0%, transparent 60%);
            pointer-events: none;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 580px;
        }

        .hero h1 {
            font-family: 'Syne', sans-serif;
            font-size: clamp(2.8rem, 5vw, 4.2rem);
            font-weight: 800;
            color: var(--white);
            line-height: 1.05;
            letter-spacing: -0.03em;
            margin-bottom: 1.2rem;
        }
        .hero h1 .accent { color: var(--cream); }

        .hero-desc {
            font-size: 1.1rem;
            color: rgba(232,216,196,0.85);
            line-height: 1.7;
            margin-bottom: 2.2rem;
            max-width: 460px;
        }

        .hero-actions { display: flex; gap: 16px; flex-wrap: wrap; align-items: center; }

        .btn-primary {
            background: var(--cream);
            color: var(--wine-deep);
            padding: 16px 36px;
            border-radius: 14px;
            font-size: 0.95rem;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.25s;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            display: flex; align-items: center; gap: 10px;
            border: 2px solid transparent;
        }
        .btn-primary:hover { 
            background: var(--white); 
            transform: translateY(-2px); 
            box-shadow: 0 12px 32px rgba(0,0,0,0.25); 
        }

        .btn-outline {
            background: transparent;
            color: var(--cream);
            padding: 16px 36px;
            border-radius: 14px;
            font-size: 0.95rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.25s;
            border: 2px solid rgba(232,216,196,0.5);
            display: flex; align-items: center; gap: 10px;
        }
        .btn-outline:hover { 
            background: rgba(232,216,196,0.1); 
            border-color: var(--cream); 
            color: var(--white); 
            transform: translateY(-2px); 
        }

        /* ─── WHY CHOOSE US ─── */
        .why-section {
            padding: 5rem 3rem;
            max-width: 1200px;
            margin: 0 auto;
        }
        .why-grid {
            display: grid;
            grid-template-columns: 1.1fr 1fr;
            gap: 5rem;
            align-items: start;
        }
        .why-left { padding-top: 1rem; }
        .why-left h2 {
            font-family: 'Syne', sans-serif;
            font-size: clamp(1.8rem, 3vw, 2.6rem);
            font-weight: 800;
            color: var(--wine-deep);
            line-height: 1.15;
            margin-bottom: 1.2rem;
            letter-spacing: -0.02em;
        }
        .why-left p {
            font-size: 0.95rem;
            color: var(--text-muted);
            line-height: 1.7;
            margin-bottom: 1.5rem;
            max-width: 420px;
        }
        .why-socials {
            display: flex;
            gap: 16px;
            margin-bottom: 2rem;
        }
        .why-socials a {
            width: 40px; height: 40px;
            border-radius: 50%;
            border: 1.5px solid var(--border-light);
            display: flex; align-items: center; justify-content: center;
            color: var(--wine-deep);
            font-size: 1rem;
            transition: all 0.2s;
            text-decoration: none;
        }
        .why-socials a:hover {
            background: var(--wine-deep);
            color: var(--cream);
            border-color: var(--wine-deep);
            transform: translateY(-2px);
        }

        .why-stats-row {
            display: flex;
            gap: 2.5rem;
        }
        .why-stat {
            text-align: center;
        }
        .why-stat-ico {
            width: 52px; height: 52px;
            background: var(--cream-light);
            border: 1.5px solid var(--border-light);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 10px;
            color: var(--wine-deep);
            font-size: 1.1rem;
        }
        .why-stat-num {
            font-family: 'Syne', sans-serif;
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--wine-deep);
            line-height: 1;
        }
        .why-stat-lbl {
            font-size: 0.72rem;
            color: var(--text-muted);
            margin-top: 4px;
            font-weight: 500;
        }

        .why-right {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        .why-card {
            background: var(--white);
            border: 1px solid var(--border-light);
            border-radius: 18px;
            padding: 1.6rem 1.8rem;
            display: flex;
            align-items: flex-start;
            gap: 1.2rem;
            transition: all 0.3s;
            box-shadow: 0 2px 12px rgba(86,28,36,0.04);
        }
        .why-card:hover {
            transform: translateX(6px);
            box-shadow: 0 8px 24px rgba(86,28,36,0.1);
            border-color: rgba(86,28,36,0.2);
        }
        .why-card-ico {
            width: 48px; height: 48px;
            background: rgba(86,28,36,0.08);
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            color: var(--wine-deep);
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        .why-card-text h4 {
            font-family: 'Syne', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            color: var(--wine-deep);
            margin-bottom: 4px;
        }
        .why-card-text p {
            font-size: 0.82rem;
            color: var(--text-muted);
            line-height: 1.5;
        }

        /* ─── STATS BAND ─── */
        .stats-section {
            background: var(--white);
            padding: 3rem 3rem;
            border-top: 1px solid var(--border-light);
            border-bottom: 1px solid var(--border-light);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 2rem;
            max-width: 900px;
            margin: 0 auto;
        }
        .stat-item {
            text-align: center;
        }
        .stat-ico {
            width: 56px; height: 56px;
            background: var(--cream-light);
            border: 1.5px solid var(--border-light);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 12px;
            color: var(--wine-deep);
            font-size: 1.2rem;
        }
        .stat-num {
            font-family: 'Syne', sans-serif;
            font-size: 2rem;
            font-weight: 800;
            color: var(--wine-deep);
            line-height: 1;
            margin-bottom: 6px;
        }
        .stat-lbl {
            font-size: 0.78rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            font-weight: 500;
        }

        /* ─── SERVICES / DESTINATIONS ─── */
        .services-section {
            padding: 5rem 3rem;
            max-width: 1200px;
            margin: 0 auto;
        }
        .services-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 2.5rem;
        }
        .services-header-left h2 {
            font-family: 'Syne', sans-serif;
            font-size: clamp(1.6rem, 3vw, 2.2rem);
            font-weight: 800;
            color: var(--wine-deep);
            margin-bottom: 0.6rem;
            letter-spacing: -0.02em;
        }
        .services-header-left p {
            font-size: 0.9rem;
            color: var(--text-muted);
            max-width: 360px;
            line-height: 1.6;
        }
        .services-nav {
            display: flex;
            gap: 10px;
        }
        .services-nav-btn {
            width: 40px; height: 40px;
            border-radius: 50%;
            border: 1.5px solid var(--border-light);
            background: var(--white);
            color: var(--wine-deep);
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.85rem;
        }
        .services-nav-btn:hover {
            background: var(--wine-deep);
            color: var(--cream);
            border-color: var(--wine-deep);
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.2rem;
        }
        .srv-card {
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            aspect-ratio: 3/4;
            background: linear-gradient(180deg, rgba(86,28,36,0.1) 0%, rgba(86,28,36,0.7) 100%);
            cursor: pointer;
            transition: transform 0.3s;
        }
        .srv-card:hover {
            transform: translateY(-6px);
        }
        .srv-card-bg {
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, var(--wine-deep) 0%, var(--wine-mid) 100%);
            opacity: 0.9;
        }
        .srv-card-content {
            position: absolute;
            bottom: 0; left: 0; right: 0;
            padding: 1.5rem;
            z-index: 2;
        }
        .srv-card-badge {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            color: var(--cream);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
            margin-bottom: 0.8rem;
            border: 1px solid rgba(255,255,255,0.2);
        }
        .srv-card h4 {
            font-family: 'Syne', sans-serif;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--white);
            margin-bottom: 6px;
        }
        .srv-card-meta {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.78rem;
            color: rgba(232,216,196,0.85);
        }
        .srv-card-meta i { font-size: 0.7rem; color: #FFD700; }

        .btn-view-more {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: var(--wine-deep);
            color: var(--cream);
            padding: 12px 28px;
            border-radius: 12px;
            font-size: 0.88rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.25s;
            border: none;
            cursor: pointer;
            margin-top: 2rem;
            box-shadow: 0 4px 16px rgba(86,28,36,0.3);
        }
        .btn-view-more:hover {
            background: var(--wine-mid);
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(109,41,50,0.4);
        }

        /* ─── CONSULTA PÚBLICA ─── */
        .consulta-section {
            background: var(--white);
            padding: 5rem 3rem;
            border-top: 1px solid var(--border-light);
        }
        .consulta-wrapper {
            max-width: 520px;
            margin: 0 auto;
        }
        .consulta-card {
            background: var(--cream-light);
            border: 1px solid var(--border-light);
            border-radius: 28px;
            overflow: hidden;
            box-shadow: 0 12px 40px rgba(86,28,36,0.08);
        }
        .consulta-head {
            background: linear-gradient(135deg, var(--wine-deep), var(--wine-mid));
            padding: 2rem 2.2rem;
            display: flex; align-items: center; gap: 16px;
        }
        .consulta-head-ico {
            width: 50px; height: 50px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.25);
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            color: var(--cream);
            font-size: 1.2rem;
            flex-shrink: 0;
        }
        .consulta-head h3 {
            font-family: 'Syne', sans-serif;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--white);
        }
        .consulta-head p {
            font-size: 0.8rem;
            color: rgba(232,216,196,0.8);
        }
        .consulta-body { padding: 2.2rem; }

        .field-group { margin-bottom: 1.4rem; }
        .field-label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
            letter-spacing: 0.02em;
        }
        .field-input {
            width: 100%;
            background: var(--white);
            border: 1.5px solid var(--border-light);
            border-radius: 12px;
            padding: 13px 18px;
            font-size: 0.95rem;
            color: var(--wine-deep);
            font-family: 'DM Sans', sans-serif;
            outline: none;
            transition: all 0.2s;
        }
        .field-input::placeholder { color: var(--text-muted); }
        .field-input:focus {
            border-color: var(--wine-deep);
            box-shadow: 0 0 0 4px rgba(86,28,36,0.08);
        }

        .captcha-row { display: flex; gap: 12px; align-items: flex-end; }
        .captcha-row .field-group { flex: 1; margin-bottom: 0; }
        .captcha-display {
            background: var(--white);
            border: 1.5px solid var(--border-light);
            border-radius: 12px;
            padding: 12px 24px;
            font-family: 'Courier New', monospace;
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--wine-deep);
            letter-spacing: 10px;
            flex-shrink: 0;
            user-select: none;
        }

        .btn-consultar {
            width: 100%;
            background: var(--wine-deep);
            color: var(--cream);
            border: none;
            padding: 15px;
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 0.5rem;
            transition: all 0.25s;
            font-family: 'DM Sans', sans-serif;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            box-shadow: 0 6px 20px rgba(86,28,36,0.3);
        }
        .btn-consultar:hover { 
            background: var(--wine-mid); 
            transform: translateY(-2px); 
            box-shadow: 0 10px 28px rgba(109,41,50,0.4); 
        }

        .consulta-tip {
            display: flex; align-items: flex-start; gap: 12px;
            background: rgba(199,183,163,0.15);
            border: 1px solid rgba(199,183,163,0.3);
            border-radius: 12px;
            padding: 14px 16px;
            margin-top: 1.4rem;
            font-size: 0.82rem;
            color: var(--wine-mid);
            line-height: 1.55;
        }

        /* ─── HOW IT WORKS ─── */
        .steps-section {
            padding: 5rem 3rem;
            max-width: 1000px;
            margin: 0 auto;
        }
        .steps-header {
            text-align: center;
            margin-bottom: 3.5rem;
        }
        .steps-header h2 {
            font-family: 'Syne', sans-serif;
            font-size: clamp(1.6rem, 3vw, 2.2rem);
            font-weight: 800;
            color: var(--wine-deep);
            margin-bottom: 0.6rem;
        }
        .steps-header p {
            font-size: 0.9rem;
            color: var(--text-muted);
        }

        .steps-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 3rem;
            position: relative;
        }
        .steps-row::before {
            content: '';
            position: absolute;
            top: 28px; left: 20%;
            width: 60%;
            height: 2px;
            background: linear-gradient(90deg, var(--wine-deep), var(--warm-gray));
            z-index: 0;
        }
        .step {
            text-align: center;
            position: relative;
            z-index: 1;
        }
        .step-num {
            width: 56px; height: 56px;
            background: var(--wine-deep);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 1.2rem;
            font-family: 'Syne', sans-serif;
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--cream);
            border: 4px solid var(--cream-light);
            box-shadow: 0 0 0 3px rgba(86,28,36,0.15);
            position: relative;
            z-index: 1;
        }
        .step h5 {
            font-family: 'Syne', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            color: var(--wine-deep);
            margin-bottom: 0.5rem;
        }
        .step p {
            font-size: 0.85rem;
            color: var(--text-muted);
            line-height: 1.5;
        }

        /* ─── FOOTER ─── */
        .footer {
            background: var(--wine-deep);
            border-top: 1px solid rgba(232,216,196,0.1);
            padding: 4rem 3rem 2rem;
        }
        .footer-grid {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr 1fr;
            gap: 3rem;
            margin-bottom: 3rem;
            max-width: 1100px;
            margin-left: auto;
            margin-right: auto;
        }
        .footer-brand-col .brand { margin-bottom: 1rem; }
        .footer-brand-col p {
            font-size: 0.84rem;
            color: rgba(232,216,196,0.7);
            line-height: 1.6;
            margin-bottom: 1.2rem;
        }
        .footer-col h5 {
            font-family: 'Syne', sans-serif;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--cream);
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-bottom: 1.4rem;
        }
        .footer-links-list { list-style: none; }
        .footer-links-list li + li { margin-top: 0.7rem; }
        .footer-links-list a {
            font-size: 0.85rem;
            color: rgba(232,216,196,0.65);
            text-decoration: none;
            transition: color 0.2s;
            display: flex; align-items: center;
            gap: 8px;
        }
        .footer-links-list a::before {
            content: '';
            width: 4px; height: 4px;
            border-radius: 50%;
            background: var(--warm-gray);
            flex-shrink: 0;
        }
        .footer-links-list a:hover { color: var(--cream); }
        .footer-contact-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            font-size: 0.82rem;
            color: rgba(232,216,196,0.65);
            margin-bottom: 0.8rem;
        }
        .footer-contact-item i { color: var(--warm-gray); margin-top: 2px; }
        .footer-bottom {
            border-top: 1px solid rgba(232,216,196,0.1);
            padding-top: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            max-width: 1100px;
            margin: 0 auto;
        }
        .footer-bottom p { font-size: 0.75rem; color: rgba(232,216,196,0.4); }

        /* ─── ALERT ─── */
        .alert-error {
            background: rgba(86,28,36,0.08);
            border: 1px solid rgba(86,28,36,0.25);
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 1.2rem;
            font-size: 0.85rem;
            color: var(--wine-deep);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* ─── RESPONSIVE ─── */
        @media (max-width: 992px) {
            .why-grid      { grid-template-columns: 1fr; gap: 3rem; }
            .services-grid { grid-template-columns: repeat(2, 1fr); }
            .stats-grid    { grid-template-columns: repeat(2, 1fr); gap: 2rem; }
            .steps-row     { grid-template-columns: 1fr; gap: 2.5rem; }
            .steps-row::before { display: none; }
            .footer-grid   { grid-template-columns: 1fr 1fr; }
            .hero          { padding: 3rem 2rem; min-height: 60vh; }
        }
        @media (max-width: 768px) {
            .navbar        { padding: 0 1.2rem; }
            .nav-center .nav-link { display: none; }
            .hero-wrapper  { padding: 1rem 1rem 0; }
            .hero          { padding: 2.5rem 1.5rem; border-radius: 20px; }
            .why-section,
            .services-section,
            .consulta-section,
            .steps-section { padding: 3rem 1.2rem; }
            .services-grid { grid-template-columns: 1fr; }
            .services-header { flex-direction: column; align-items: flex-start; gap: 1rem; }
            .stats-grid    { grid-template-columns: 1fr 1fr; }
            .why-stats-row { gap: 1.5rem; }
            .footer-grid   { grid-template-columns: 1fr; gap: 2rem; }
            .footer        { padding: 3rem 1.5rem 1.5rem; }
        }

        /* ─── SCROLL ANIMATIONS ─── */
        .fade-up {
            opacity: 0;
            transform: translateY(30px);
            transition: opacity 0.7s ease, transform 0.7s ease;
        }
        .fade-up.visible {
            opacity: 1;
            transform: none;
        }
    </style>
</head>
<body>

<%-- SVG reutilizable --%>
<svg style="display:none" aria-hidden="true">
    <symbol id="ico-shield" viewBox="0 0 100 100">
        <path d="M50 8L88 24L88 52C88 72 70 88 50 95C30 88 12 72 12 52L12 24Z"
              fill="none" stroke="currentColor" stroke-width="7" stroke-linejoin="round"/>
        <line x1="30" y1="72" x2="70" y2="32" stroke="currentColor" stroke-width="6" stroke-linecap="round"/>
        <rect x="42" y="28" width="22" height="12" rx="3" transform="rotate(45 53 34)" fill="currentColor"/>
        <line x1="65" y1="22" x2="75" y2="12" stroke="currentColor" stroke-width="5" stroke-linecap="round"/>
        <line x1="28" y1="74" x2="22" y2="80" stroke="currentColor" stroke-width="4" stroke-linecap="round"/>
    </symbol>
</svg>

<%-- NAVBAR --%>
<nav class="navbar">
    <a class="brand" href="${pageContext.request.contextPath}/">
        <div class="brand-icon">
            <svg width="22" height="22" viewBox="0 0 100 100" style="color:#E8D8C4">
                <use href="#ico-shield"/>
            </svg>
        </div>
        <div class="brand-text">
            <div class="brand-name"><fmt:message key="app.nombre"/></div>
            <div class="brand-sub"><fmt:message key="app.institucion.short"/></div>
        </div>
    </a>

    <div class="nav-center">
        <a class="nav-link" href="${pageContext.request.contextPath}/"><fmt:message key="nav.inicio"/></a>
        <a class="nav-link" href="#consulta"><fmt:message key="nav.consulta"/></a>
        <a class="nav-link" href="#servicios"><fmt:message key="nav.servicios"/></a>
        <a class="nav-link" href="#como-funciona"><fmt:message key="nav.como"/></a>
    </div>

    <div class="nav-right">
        <div class="lang-pills">
            <button type="button"
                    class="lang-pill ${sessionScope.lang == null || sessionScope.lang == 'es' ? 'active' : ''}"
                    onclick="cambiarIdioma('es')">
                <span class="lang-flag">🇨🇴</span> ES
            </button>
            <button type="button"
                    class="lang-pill ${sessionScope.lang == 'en' ? 'active' : ''}"
                    onclick="cambiarIdioma('en')">
                <span class="lang-flag">🇺🇸</span> EN
            </button>
            <button type="button"
                    class="lang-pill ${sessionScope.lang == 'it' ? 'active' : ''}"
                    onclick="cambiarIdioma('it')">
                <span class="lang-flag">🇮🇹</span> IT
            </button>
        </div>
        <a class="btn-nav-login" href="${pageContext.request.contextPath}/login">
            <i class="fas fa-sign-in-alt"></i>
            <fmt:message key="login.ingresar"/>
        </a>
    </div>
</nav>

<%-- HERO --%>
<div class="hero-wrapper">
    <section class="hero">
        <div class="hero-content">
            <h1>
                <fmt:message key="hero.titulo.linea1"/><br>
                <span class="accent"><fmt:message key="hero.titulo.linea2"/></span><br>
                <fmt:message key="hero.titulo.linea3"/>
            </h1>

            <p class="hero-desc"><fmt:message key="hero.descripcion"/></p>

            <div class="hero-actions">
                <a class="btn-primary" href="#consulta">
                    <i class="fas fa-search"></i>
                    <fmt:message key="hero.btn.consultar"/>
                </a>
                <a class="btn-outline" href="${pageContext.request.contextPath}/login">
                    <i class="fas fa-user-md"></i>
                    <fmt:message key="hero.btn.acceder"/>
                </a>
            </div>
        </div>
    </section>
</div>

<%-- WHY CHOOSE US --%>
<section class="why-section" id="nosotros">
    <div class="why-grid fade-up">
        <div class="why-left">
            <h2>
                <fmt:message key="about.titulo.linea1"/><br>
                <fmt:message key="about.titulo.linea2"/>
            </h2>
            <p><fmt:message key="about.descripcion"/></p>

            <div class="why-socials">
                <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
            </div>

            <div class="why-stats-row">
                <div class="why-stat">
                    <div class="why-stat-ico"><i class="fas fa-smile"></i></div>
                    <div class="why-stat-num">12k</div>
                    <div class="why-stat-lbl"><fmt:message key="why.stat1"/></div>
                </div>
                <div class="why-stat">
                    <div class="why-stat-ico"><i class="fas fa-award"></i></div>
                    <div class="why-stat-num">10+</div>
                    <div class="why-stat-lbl"><fmt:message key="why.stat2"/></div>
                </div>
                <div class="why-stat">
                    <div class="why-stat-ico"><i class="fas fa-hospital"></i></div>
                    <div class="why-stat-num">5</div>
                    <div class="why-stat-lbl"><fmt:message key="why.stat3"/></div>
                </div>
            </div>
        </div>

        <div class="why-right">
            <div class="why-card">
                <div class="why-card-ico"><i class="fas fa-stethoscope"></i></div>
                <div class="why-card-text">
                    <h4><fmt:message key="why.card1.titulo"/></h4>
                    <p><fmt:message key="why.card1.desc"/></p>
                </div>
            </div>
            <div class="why-card">
                <div class="why-card-ico"><i class="fas fa-headset"></i></div>
                <div class="why-card-text">
                    <h4><fmt:message key="why.card2.titulo"/></h4>
                    <p><fmt:message key="why.card2.desc"/></p>
                </div>
            </div>
            <div class="why-card">
                <div class="why-card-ico"><i class="fas fa-shield-alt"></i></div>
                <div class="why-card-text">
                    <h4><fmt:message key="why.card3.titulo"/></h4>
                    <p><fmt:message key="why.card3.desc"/></p>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- STATS BAND --%>
<div class="stats-section">
    <div class="stats-grid fade-up">
        <div class="stat-item">
            <div class="stat-ico"><i class="fas fa-users"></i></div>
            <div class="stat-num">${totalPacientes != null ? totalPacientes : '12.4K'}</div>
            <div class="stat-lbl"><fmt:message key="stats.pacientes"/></div>
        </div>
        <div class="stat-item">
            <div class="stat-ico"><i class="fas fa-calendar-check"></i></div>
            <div class="stat-num">${totalCitas != null ? totalCitas : '48.3K'}</div>
            <div class="stat-lbl"><fmt:message key="stats.citas"/></div>
        </div>
        <div class="stat-item">
            <div class="stat-ico"><i class="fas fa-percentage"></i></div>
            <div class="stat-num">${cobertura != null ? cobertura : '94'}%</div>
            <div class="stat-lbl"><fmt:message key="stats.cobertura"/></div>
        </div>
        <div class="stat-item">
            <div class="stat-ico"><i class="fas fa-user-md"></i></div>
            <div class="stat-num">5</div>
            <div class="stat-lbl"><fmt:message key="stats.especialidades"/></div>
        </div>
    </div>
</div>

<%-- SERVICIOS / TOP DESTINATIONS STYLE --%>
<section class="services-section" id="servicios">
    <div class="services-header fade-up">
        <div class="services-header-left">
            <h2><fmt:message key="servicios.titulo"/></h2>
            <p><fmt:message key="servicios.subtitulo"/></p>
        </div>
        <div class="services-nav">
            <button class="services-nav-btn" aria-label="Anterior"><i class="fas fa-chevron-left"></i></button>
            <button class="services-nav-btn" aria-label="Siguiente"><i class="fas fa-chevron-right"></i></button>
        </div>
    </div>

    <div class="services-grid fade-up">
        <div class="srv-card">
            <div class="srv-card-bg"></div>
            <div class="srv-card-content">
                <span class="srv-card-badge"><fmt:message key="srv.badge.popular"/></span>
                <h4><fmt:message key="servicio.medicina.general"/></h4>
                <div class="srv-card-meta">
                    <i class="fas fa-star"></i> 4.8 <span>|</span> <fmt:message key="srv.disponible"/>
                </div>
            </div>
        </div>
        <div class="srv-card">
            <div class="srv-card-bg"></div>
            <div class="srv-card-content">
                <span class="srv-card-badge"><fmt:message key="srv.badge.familia"/></span>
                <h4><fmt:message key="servicio.pediatria"/></h4>
                <div class="srv-card-meta">
                    <i class="fas fa-star"></i> 4.9 <span>|</span> <fmt:message key="srv.disponible"/>
                </div>
            </div>
        </div>
        <div class="srv-card">
            <div class="srv-card-bg"></div>
            <div class="srv-card-content">
                <span class="srv-card-badge"><fmt:message key="srv.badge.mujer"/></span>
                <h4><fmt:message key="servicio.ginecologia"/></h4>
                <div class="srv-card-meta">
                    <i class="fas fa-star"></i> 4.7 <span>|</span> <fmt:message key="srv.disponible"/>
                </div>
            </div>
        </div>
        <div class="srv-card">
            <div class="srv-card-bg"></div>
            <div class="srv-card-content">
                <span class="srv-card-badge"><fmt:message key="srv.badge.dental"/></span>
                <h4><fmt:message key="servicio.odontologia"/></h4>
                <div class="srv-card-meta">
                    <i class="fas fa-star"></i> 4.6 <span>|</span> <fmt:message key="srv.disponible"/>
                </div>
            </div>
        </div>
    </div>

    <div style="text-align:center; margin-top:1rem;">
        <a href="#" class="btn-view-more">
            <fmt:message key="srv.ver.todos"/> <i class="fas fa-arrow-right"></i>
        </a>
    </div>
</section>

<%-- CONSULTA PÚBLICA --%>
<section class="consulta-section" id="consulta">
    <div class="consulta-wrapper fade-up">
        <div class="consulta-card">
            <div class="consulta-head">
                <div class="consulta-head-ico">
                    <i class="fas fa-search"></i>
                </div>
                <div>
                    <h3><fmt:message key="consulta.titulo"/></h3>
                    <p><fmt:message key="consulta.subtitulo"/></p>
                </div>
            </div>

            <div class="consulta-body">
                <c:if test="${not empty error}">
                    <div class="alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/consulta-cita" method="post">
                    <div class="field-group">
                        <label class="field-label" for="documento">
                            <fmt:message key="consulta.documento"/>
                        </label>
                        <input class="field-input" type="text" id="documento" name="documento"
                               placeholder="Ej: 1053600001"
                               value="${param.documento}" required>
                    </div>

                    <div class="field-group">
                        <label class="field-label"><fmt:message key="consulta.captcha"/></label>
                        <div class="captcha-row">
                            <div class="captcha-display">${captchaText}</div>
                            <div class="field-group">
                                <input class="field-input" type="text" name="captcha"
                                       placeholder="<fmt:message key='consulta.captcha.placeholder'/>"
                                       required autocomplete="off">
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-consultar">
                        <i class="fas fa-search"></i>
                        <fmt:message key="consulta.buscar"/>
                    </button>
                </form>

                <div class="consulta-tip">
                    <i class="fas fa-info-circle" style="margin-top:2px;flex-shrink:0"></i>
                    <span><fmt:message key="consulta.tip.login"/></span>
                </div>
            </div>
        </div>
    </div>
</section>

<%-- CÓMO FUNCIONA --%>
<section class="steps-section" id="como-funciona">
    <div class="steps-header fade-up">
        <h2><fmt:message key="como.titulo"/></h2>
        <p><fmt:message key="como.subtitulo"/></p>
    </div>

    <div class="steps-row fade-up">
        <div class="step">
            <div class="step-num">1</div>
            <h5><fmt:message key="como.paso1.titulo"/></h5>
            <p><fmt:message key="como.paso1.desc"/></p>
        </div>
        <div class="step">
            <div class="step-num">2</div>
            <h5><fmt:message key="como.paso2.titulo"/></h5>
            <p><fmt:message key="como.paso2.desc"/></p>
        </div>
        <div class="step">
            <div class="step-num">3</div>
            <h5><fmt:message key="como.paso3.titulo"/></h5>
            <p><fmt:message key="como.paso3.desc"/></p>
        </div>
    </div>
</section>

<%-- FOOTER --%>
<footer class="footer">
    <div class="footer-grid">
        <div class="footer-brand-col">
            <a class="brand" href="${pageContext.request.contextPath}/" style="margin-bottom:0.8rem;display:inline-flex">
                <div class="brand-icon" style="width:36px;height:36px">
                    <svg width="18" height="18" viewBox="0 0 100 100" style="color:#E8D8C4"><use href="#ico-shield"/></svg>
                </div>
                <div class="brand-text" style="margin-left:10px">
                    <div class="brand-name" style="font-size:0.9rem;color:#E8D8C4"><fmt:message key="app.nombre"/></div>
                </div>
            </a>
            <p><fmt:message key="footer.descripcion"/></p>
        </div>

        <div class="footer-col">
            <h5><fmt:message key="footer.empresa"/></h5>
            <ul class="footer-links-list">
                <li><a href="${pageContext.request.contextPath}/"><fmt:message key="nav.inicio"/></a></li>
                <li><a href="#consulta"><fmt:message key="nav.consulta"/></a></li>
                <li><a href="#servicios"><fmt:message key="nav.servicios"/></a></li>
                <li><a href="#como-funciona"><fmt:message key="nav.como"/></a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h5><fmt:message key="footer.servicios"/></h5>
            <ul class="footer-links-list">
                <li><a href="#"><fmt:message key="servicio.medicina.general"/></a></li>
                <li><a href="#"><fmt:message key="servicio.pediatria"/></a></li>
                <li><a href="#"><fmt:message key="servicio.odontologia"/></a></li>
                <li><a href="#"><fmt:message key="servicio.optometria"/></a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h5><fmt:message key="footer.contacto"/></h5>
            <div class="footer-contact-item">
                <i class="fas fa-map-marker-alt"></i>
                <span><fmt:message key="app.address"/></span>
            </div>
            <div class="footer-contact-item">
                <i class="fas fa-phone"></i>
                <span><fmt:message key="app.phone"/></span>
            </div>
            <div class="footer-contact-item">
                <i class="fas fa-envelope"></i>
                <span><fmt:message key="app.email"/></span>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <p><fmt:message key="app.footer"/></p>
        <p><fmt:message key="footer.rights"/></p>
    </div>
</footer>

<script>
    /* Language switcher */
    function cambiarIdioma(lang) {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = window.location.pathname;
        form.style.display = 'none';
        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'lang';
        input.value = lang;
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }

    if (window.location.search.includes('lang=')) {
        history.replaceState({}, document.title, window.location.pathname + window.location.hash);
    }

    /* Scroll reveal */
    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry, i) => {
            if (entry.isIntersecting) {
                setTimeout(() => entry.target.classList.add('visible'), i * 100);
            }
        });
    }, { threshold: 0.12 });

    document.querySelectorAll('.fade-up').forEach(el => observer.observe(el));
</script>
<%@ include file="/WEB-INF/views/componentes/kira.jsp" %>
</body>
</html>