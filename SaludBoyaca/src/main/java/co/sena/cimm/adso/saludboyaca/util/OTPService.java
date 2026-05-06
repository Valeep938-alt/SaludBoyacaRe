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
    private static final String SMTP_PORT = "587"; // String, no int

    private static final String EMAIL_REMIT = System.getenv("EMAIL_REMIT");
    private static final String EMAIL_PASS  = System.getenv("EMAIL_PASS");

    private static final long OTP_EXPIRA_MS = 5 * 60 * 1000;

    public static String generarOTP() {
        SecureRandom rnd = new SecureRandom();
        int numero = 100000 + rnd.nextInt(900000);
        return String.valueOf(numero);
    }

    public static boolean esValido(String ingresado, String guardado, long timestamp) {
        if (ingresado == null || guardado == null) return false;
        long ahora = Instant.now().toEpochMilli();
        return (ahora - timestamp) <= OTP_EXPIRA_MS && ingresado.trim().equals(guardado);
    }

    public static void enviarOTP(String destinatario, String codigoOTP,
                                  String asunto, String cuerpo)
            throws MessagingException, UnsupportedEncodingException {

        // Validar que las variables de entorno estén configuradas
        if (EMAIL_REMIT == null || EMAIL_PASS == null) {
            throw new MessagingException(
                "Variables de entorno EMAIL_REMIT y EMAIL_PASS no configuradas en el servidor."
            );
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);      // ahora es String
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        final String passLimpia = EMAIL_PASS.replace(" ", "");

        Session mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_REMIT, passLimpia);
            }
        });

        // Sin debug en producción — evita exponer credenciales en logs
        // mailSession.setDebug(true);

        Message mensaje = new MimeMessage(mailSession);
        mensaje.setFrom(new InternetAddress(EMAIL_REMIT, "SaludBoyacá - Citas Médicas", "UTF-8"));
        mensaje.setRecipient(Message.RecipientType.TO, new InternetAddress(destinatario));
        mensaje.setSubject(asunto);
        mensaje.setText(cuerpo);

        Transport.send(mensaje);
        System.out.println("OTP enviado exitosamente a: " + destinatario);
    }
}