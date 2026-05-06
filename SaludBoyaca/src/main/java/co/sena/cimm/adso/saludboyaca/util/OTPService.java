package co.sena.cimm.adso.saludboyaca.util;

import java.io.UnsupportedEncodingException;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class OTPService {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;
    
    // Lee de variables de entorno primero, luego valores por defecto
    private static final String EMAIL_REMIT = 
        System.getenv("EMAIL_REMIT") != null ? System.getenv("EMAIL_REMIT") : "gonzalezvalerie938@gmail.com";
    private static final String EMAIL_PASS = 
        System.getenv("EMAIL_PASS") != null ? System.getenv("EMAIL_PASS") : "exyo fwhp thze pjlz";
    
    private static final int OTP_LONGITUD = 6;
    private static final long OTP_EXPIRA_MS = 5 * 60 * 1000; // 5 minutos

    /**
     * Genera un código OTP numérico de 6 dígitos.
     */
    public static String generarOTP() {
        SecureRandom rnd = new SecureRandom();
        // Siempre genera un número entre 100000 y 999999 → exactamente 6 dígitos, nunca empieza en 0
        int numero = 100000 + rnd.nextInt(900000);
        return String.valueOf(numero);
    }

    public static boolean esValido(String ingresado, String guardado, long timestamp) {
        if (ingresado == null || guardado == null) return false;
        
        long ahora = Instant.now().toEpochMilli();
        boolean noExpirado = (ahora - timestamp) <= OTP_EXPIRA_MS;
        boolean coincide = ingresado.trim().equals(guardado);
        
        return noExpirado && coincide;
    }

    /**
     * Envía el código OTP al correo del usuario.
     * @throws UnsupportedEncodingException 
     */
    public static void enviarOTP(String destinatario, String codigoOTP, 
                                  String asunto, String cuerpo) 
            throws MessagingException, UnsupportedEncodingException {
        
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        Session mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_REMIT, EMAIL_PASS.replace(" ", ""));
            }
        });

        // Debug mode (quitar en producción)
        mailSession.setDebug(true);

        Message mensaje = new MimeMessage(mailSession);
        mensaje.setFrom(new InternetAddress(EMAIL_REMIT, "SaludBoyacá - Citas Médicas", "UTF-8"));
        mensaje.setRecipient(Message.RecipientType.TO, new InternetAddress(destinatario));
        mensaje.setSubject(asunto);
        mensaje.setText(cuerpo);

        Transport.send(mensaje);
        System.out.println("OTP enviado exitosamente a: " + destinatario);
    }
}