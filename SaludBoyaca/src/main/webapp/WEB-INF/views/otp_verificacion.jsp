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
    <title><fmt:message key='otp.titulo'/> - SaludBoyaca</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lato:wght@300;400;600;700&display=swap" rel="stylesheet">
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
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body {
            font-family: 'Lato', sans-serif;
            background: linear-gradient(135deg, var(--wine-deep) 0%, var(--wine-mid) 50%, #4a1520 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .otp-card {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(86, 28, 36, 0.4);
            border: 1px solid var(--border-light);
            overflow: hidden;
            max-width: 450px;
            width: 100%;
        }
        
        .otp-header {
            background: linear-gradient(135deg, var(--wine-deep), var(--wine-mid));
            padding: 2rem;
            text-align: center;
        }
        
        .otp-header i {
            font-size: 3rem;
            color: var(--cream);
            margin-bottom: 1rem;
        }
        
        .otp-header h4 {
            color: var(--cream);
            margin: 0;
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            font-size: 1.4rem;
        }
        
        .otp-header p {
            color: var(--warm-gray);
            margin: 8px 0 0;
            font-size: 0.85rem;
        }
        
        .otp-body {
            padding: 2rem 2.5rem 2.5rem;
        }
        
        .otp-input {
            font-family: 'Playfair Display', serif;
            font-size: 2.2rem;
            letter-spacing: 12px;
            text-align: center;
            border: 2px solid var(--border-light);
            border-radius: 12px;
            padding: 1rem;
            color: var(--wine-deep);
            font-weight: 700;
            background: var(--cream-light);
            transition: all 0.3s ease;
        }
        
        .otp-input:focus {
            border-color: var(--wine-mid);
            box-shadow: 0 0 0 4px rgba(86, 28, 36, 0.1);
            background: var(--white);
            outline: none;
        }
        
        .otp-input::placeholder {
            color: var(--warm-gray);
            opacity: 0.6;
        }
        
        .btn-verify {
            background: linear-gradient(135deg, var(--wine-deep), var(--wine-mid));
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-weight: 700;
            font-size: 1rem;
            color: var(--cream);
            width: 100%;
            transition: all 0.3s ease;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-verify:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px var(--shadow);
            color: var(--white);
        }
        
        .btn-back {
            background: transparent;
            border: 2px solid var(--warm-gray);
            border-radius: 12px;
            padding: 12px;
            color: var(--wine-mid);
            width: 100%;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 0.75rem;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .btn-back:hover {
            background: var(--cream-light);
            border-color: var(--wine-mid);
            color: var(--wine-deep);
        }
        
        .email-masked {
            background: var(--cream-light);
            border: 1px solid var(--border-light);
            border-radius: 10px;
            padding: 0.8rem 1.2rem;
            color: var(--text-dark);
            font-weight: 600;
            text-align: center;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }
        
        .email-masked i {
            color: var(--wine-mid);
            margin-right: 6px;
        }
        
        .alert-wine {
            background: rgba(86, 28, 36, 0.08);
            border: 1px solid rgba(86, 28, 36, 0.2);
            border-radius: 12px;
            padding: 14px 18px;
            color: var(--wine-deep);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 1rem;
        }
        
        .alert-wine i {
            font-size: 1.1rem;
        }
        
        .otp-timer {
            text-align: center;
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-top: 1rem;
        }
        
        .otp-timer i {
            color: var(--wine-mid);
            margin-right: 4px;
        }
        
        .otp-timer span {
            color: var(--wine-deep);
            font-weight: 700;
        }
        
        /* Animacion de entrada */
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .otp-card {
            animation: slideUp 0.5s ease;
        }
        
        /* Responsive */
        @media (max-width: 480px) {
            .otp-body {
                padding: 1.5rem;
            }
            .otp-input {
                font-size: 1.8rem;
                letter-spacing: 8px;
            }
            .otp-header h4 {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="otp-card">
                    <!-- Header -->
                    <div class="otp-header">
                        <i class="fas fa-shield-halved"></i>
                        <h4><fmt:message key='otp.titulo'/></h4>
                        <p>Verificacion de dos factores</p>
                    </div>
                    
                    <!-- Body -->
                    <div class="otp-body">
                        <c:if test="${not empty error}">
                            <div class="alert-wine">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>${error}</span>
                            </div>
                        </c:if>
                        
                        <p class="text-center mb-3" style="color: var(--text-muted); font-size: 0.9rem;">
                            <fmt:message key='otp.instruccion'>
                                <fmt:param value="${emailMasked}"/>
                            </fmt:message>
                        </p>
                        
                        <div class="email-masked">
                            <i class="fas fa-envelope"></i>${emailMasked}
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/otp" method="post">
                            <div class="mb-4">
                                <input type="text" name="otpCodigo" class="form-control otp-input" 
                                       maxlength="6" pattern="[0-9]{6}" placeholder="000000" 
                                       required autofocus autocomplete="one-time-code">
                            </div>
                            
                            <button type="submit" class="btn-verify">
                                <i class="fas fa-check-circle"></i>
                                <fmt:message key='otp.verificar'/>
                            </button>
                        </form>
                        
                        <div class="otp-timer">
                            <i class="fas fa-clock"></i>
                            El codigo expira en <span id="timer">05:00</span>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/login" class="btn-back">
                            <i class="fas fa-arrow-left"></i>
                            <fmt:message key='otp.reenviar'/>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Cuenta regresiva de 5 minutos
        let tiempoRestante = 300; // 5 minutos en segundos
        const timerElement = document.getElementById('timer');
        
        function actualizarTimer() {
            const minutos = Math.floor(tiempoRestante / 60);
            const segundos = tiempoRestante % 60;
            timerElement.textContent = 
                String(minutos).padStart(2, '0') + ':' + String(segundos).padStart(2, '0');
            
            if (tiempoRestante > 0) {
                tiempoRestante--;
                setTimeout(actualizarTimer, 1000);
            } else {
                timerElement.style.color = '#b41e1e';
                timerElement.textContent = 'EXPIRADO';
            }
        }
        
        actualizarTimer();
        
        // Auto-focus en el input
        document.querySelector('.otp-input').focus();
    </script>
</body>
</html>
