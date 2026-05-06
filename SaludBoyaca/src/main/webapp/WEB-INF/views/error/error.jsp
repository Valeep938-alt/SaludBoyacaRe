<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>

<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'es'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error · SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --wine:    #561C24;
            --rosewood:#5D2932;
            --cream:   #E8D8C4;
            --white:   #fdfaf7;
            --sand:    #C7B7A3;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'DM Sans', sans-serif;
            background: linear-gradient(135deg, var(--wine) 0%, var(--rosewood) 50%, #3a1520 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        .error-card {
            background: var(--white);
            border-radius: 24px;
            box-shadow: 0 32px 80px rgba(86,28,36,.45);
            text-align: center;
            padding: 3.5rem 3rem;
            max-width: 500px;
            width: 100%;
            animation: fadeUp .6s ease both;
        }
        .error-icon {
            font-size: 5rem;
            color: var(--wine);
            margin-bottom: 1.5rem;
        }
        .error-title {
            font-family: 'Cormorant Garamond', serif;
            color: var(--wine);
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .error-message {
            color: #6b4c3a;
            margin-bottom: 2rem;
            font-size: 0.95rem;
            line-height: 1.6;
        }
        .btn-home {
            background: linear-gradient(135deg, var(--wine), var(--rosewood));
            border: none;
            color: var(--white);
            border-radius: 13px;
            padding: .9rem 2.2rem;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            transition: all .25s;
            box-shadow: 0 6px 22px rgba(86,28,36,.3);
        }
        .btn-home:hover { transform: translateY(-2px); box-shadow: 0 10px 30px rgba(86,28,36,.4); color: var(--white); }
        .error-footer {
            margin-top: 1.5rem;
            font-size: .78rem;
            color: var(--sand);
        }
        @keyframes fadeUp { from { opacity:0; transform:translateY(24px); } to { opacity:1; transform:translateY(0); } }
    </style>
</head>
<body>
    <div class="error-card">
        <i class="fas fa-exclamation-triangle error-icon"></i>
        <h2 class="error-title">
            <c:choose>
                <c:when test="${sessionScope.lang == 'en'}">Oops! Something went wrong</c:when>
                <c:when test="${sessionScope.lang == 'it'}">Ops! Qualcosa è andato storto</c:when>
                <c:otherwise>¡Ups! Algo salió mal</c:otherwise>
            </c:choose>
        </h2>
        <p class="error-message">
            <c:choose>
                <c:when test="${not empty error}">${error}</c:when>
                <c:otherwise><fmt:message key="error.servidor"/></c:otherwise>
            </c:choose>
        </p>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn-home">
            <i class="fas fa-home"></i>
            <c:choose>
                <c:when test="${sessionScope.lang == 'en'}">Back to Dashboard</c:when>
                <c:when test="${sessionScope.lang == 'it'}">Torna alla Bacheca</c:when>
                <c:otherwise>Volver al inicio</c:otherwise>
            </c:choose>
        </a>
        <div class="error-footer"><fmt:message key="app.footer"/></div>
    </div>
</body>
</html>
