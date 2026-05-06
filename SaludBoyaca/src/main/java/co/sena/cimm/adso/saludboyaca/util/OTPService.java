package co.sena.cimm.adso.saludboyaca.util;

import java.io.IOException;
import java.security.SecureRandom;
import java.time.Instant;

public class OTPService {

    private static final String SENDGRID_API_KEY = System.getenv("SENDGRID_API_KEY");
    private static final String EMAIL_REMIT      = System.getenv("EMAIL_REMIT");
    private static final long   OTP_EXPIRA_MS    = 5 * 60 * 1000;

    public static String generarOTP() {
        SecureRandom rnd = new SecureRandom();
        return String.valueOf(100000 + rnd.nextInt(900000));
    }

    public static boolean esValido(String ingresado, String guardado, long timestamp) {
        if (ingresado == null || guardado == null) return false;
        long ahora = Instant.now().toEpochMilli();
        return (ahora - timestamp) <= OTP_EXPIRA_MS && ingresado.trim().equals(guardado);
    }

    public static void enviarOTP(String destinatario, String codigoOTP,
                                  String asunto, String cuerpo) throws IOException {

        if (SENDGRID_API_KEY == null || EMAIL_REMIT == null) {
            throw new IllegalStateException(
                "Variables SENDGRID_API_KEY y EMAIL_REMIT no configuradas en el servidor."
            );
        }

        com.sendgrid.helpers.mail.objects.Email from =
            new com.sendgrid.helpers.mail.objects.Email(EMAIL_REMIT, "SaludBoyacá - Citas Médicas");

        com.sendgrid.helpers.mail.objects.Email to =
            new com.sendgrid.helpers.mail.objects.Email(destinatario);

        com.sendgrid.helpers.mail.objects.Content content =
            new com.sendgrid.helpers.mail.objects.Content("text/plain", cuerpo);

        com.sendgrid.helpers.mail.Mail mail =
            new com.sendgrid.helpers.mail.Mail(from, asunto, to, content);

        com.sendgrid.SendGrid sg = new com.sendgrid.SendGrid(SENDGRID_API_KEY);

        com.sendgrid.Request request = new com.sendgrid.Request();
        request.setMethod(com.sendgrid.Method.POST);
        request.setEndpoint("mail/send");
        request.setBody(mail.build());

        com.sendgrid.Response response = sg.api(request);

        System.out.println("SendGrid status: " + response.getStatusCode());

        if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
            throw new IOException("Error enviando email. Status: "
                + response.getStatusCode() + " - " + response.getBody());
        }

        System.out.println("OTP enviado exitosamente a: " + destinatario);
    }
}