package co.sena.cimm.adso.saludboyaca.util;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.security.SecureRandom;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

public class CaptchaGenerator {

    private static final String CARACTERES = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789";
    private static final int ANCHO = 200;
    private static final int ALTO = 60;
    private static final int LONGITUD = 6;

    /**
     * Genera un texto CAPTCHA aleatorio de 6 caracteres.
     */
    public static String generarTextoCaptcha() {
        SecureRandom rnd = new SecureRandom();
        StringBuilder sb = new StringBuilder(LONGITUD);
        for (int i = 0; i < LONGITUD; i++) {
            sb.append(CARACTERES.charAt(rnd.nextInt(CARACTERES.length())));
        }
        return sb.toString();
    }

    /**
     * Genera una imagen CAPTCHA y la escribe directamente al response.
     * @param response HttpServletResponse para escribir la imagen
     * @param texto El texto CAPTCHA a mostrar en la imagen
     */
    public static void generarImagenCaptcha(HttpServletResponse response, String texto) 
            throws IOException {
        
        BufferedImage imagen = new BufferedImage(ANCHO, ALTO, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = imagen.createGraphics();
        
        // Fondo
        g2d.setColor(new Color(240, 248, 255));
        g2d.fillRect(0, 0, ANCHO, ALTO);
        
        // Líneas de ruido
        SecureRandom rnd = new SecureRandom();
        g2d.setColor(new Color(200, 200, 200));
        for (int i = 0; i < 15; i++) {
            int x1 = rnd.nextInt(ANCHO);
            int y1 = rnd.nextInt(ALTO);
            int x2 = rnd.nextInt(ANCHO);
            int y2 = rnd.nextInt(ALTO);
            g2d.drawLine(x1, y1, x2, y2);
        }
        
        // Puntos de ruido
        for (int i = 0; i < 100; i++) {
            int x = rnd.nextInt(ANCHO);
            int y = rnd.nextInt(ALTO);
            g2d.setColor(new Color(rnd.nextInt(255), rnd.nextInt(255), rnd.nextInt(255)));
            g2d.drawRect(x, y, 1, 1);
        }
        
        // Texto principal
        g2d.setFont(new Font("Arial", Font.BOLD, 32));
        g2d.setColor(new Color(26, 82, 118)); // #1A5276
        
        // Dibujar cada carácter con ligera rotación
        int x = 20;
        for (int i = 0; i < texto.length(); i++) {
            String ch = String.valueOf(texto.charAt(i));
            double rotation = (rnd.nextDouble() - 0.5) * 0.3; // ±0.15 radianes
            g2d.rotate(rotation, x + 15, ALTO / 2);
            g2d.drawString(ch, x, ALTO / 2 + 12);
            g2d.rotate(-rotation, x + 15, ALTO / 2);
            x += 30;
        }
        
        g2d.dispose();
        
        // Escribir imagen al response
        response.setContentType("image/png");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        ServletOutputStream out = response.getOutputStream();
        ImageIO.write(imagen, "png", out);
        out.close();
    }
}