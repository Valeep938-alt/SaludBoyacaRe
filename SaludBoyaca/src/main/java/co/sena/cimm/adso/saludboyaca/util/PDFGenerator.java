package co.sena.cimm.adso.saludboyaca.util;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import co.sena.cimm.adso.saludboyaca.model.Cita;

public class PDFGenerator {

    private static final Font FUENTE_TITULO = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, new BaseColor(26, 82, 118));
    private static final Font FUENTE_SUBTITULO = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, new BaseColor(57, 169, 0));
    private static final Font FUENTE_NORMAL = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL);
    private static final Font FUENTE_BOLD = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
    private static final Font FUENTE_PEQUEÑA = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL, BaseColor.GRAY);

    public static void generarComprobante(OutputStream out, Cita cita) throws Exception {
        
        // Validaciones de entrada
        if (out == null) {
            throw new IllegalArgumentException("El OutputStream no puede ser null");
        }
        if (cita == null) {
            throw new IllegalArgumentException("La cita no puede ser null");
        }

        Document documento = null;
        
        try {
            documento = new Document(PageSize.A4, 36, 36, 36, 36);
            PdfWriter writer = PdfWriter.getInstance(documento, out);
            documento.open();

            // ══ ENCABEZADO ══
            PdfPTable header = new PdfPTable(2);
            header.setWidthPercentage(100);
            header.setWidths(new float[]{1, 3});
            
            // Celda izquierda - Logo texto
            PdfPCell logoCell = new PdfPCell();
            logoCell.setBorder(Rectangle.NO_BORDER);
            logoCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            Paragraph logo = new Paragraph("SB", 
                new Font(Font.FontFamily.HELVETICA, 28, Font.BOLD, new BaseColor(26, 82, 118)));
            logo.setAlignment(Element.ALIGN_CENTER);
            logoCell.addElement(logo);
            header.addCell(logoCell);
            
            // Celda derecha - Título institución
            PdfPCell titleCell = new PdfPCell();
            titleCell.setBorder(Rectangle.NO_BORDER);
            titleCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            Paragraph titulo = new Paragraph("SaludBoyacá", FUENTE_TITULO);
            titulo.add(new Chunk("\nCentro de Salud Municipal de Paipa, Boyacá", FUENTE_SUBTITULO));
            titleCell.addElement(titulo);
            header.addCell(titleCell);
            
            documento.add(header);
            documento.add(Chunk.NEWLINE);

            // ══ LÍNEA SEPARADORA VERDE ══
            PdfPTable lineaTabla = new PdfPTable(1);
            lineaTabla.setWidthPercentage(100);
            PdfPCell lineaCell = new PdfPCell();
            lineaCell.setBorder(Rectangle.BOTTOM);
            lineaCell.setBorderColor(new BaseColor(57, 169, 0));
            lineaCell.setBorderWidth(2);
            lineaCell.setFixedHeight(5);
            lineaTabla.addCell(lineaCell);
            documento.add(lineaTabla);
            documento.add(Chunk.NEWLINE);

            // ══ TÍTULO COMPROBANTE ══ 
            Paragraph tituloComp = new Paragraph("COMPROBANTE DE CITA MÉDICA", 
                new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.WHITE));
            tituloComp.setAlignment(Element.ALIGN_CENTER);
            
            PdfPTable tituloTabla = new PdfPTable(1);
            tituloTabla.setWidthPercentage(100);
            PdfPCell tituloCell = new PdfPCell(tituloComp);
            tituloCell.setBackgroundColor(new BaseColor(26, 82, 118));
            tituloCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            tituloCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            tituloCell.setPadding(12);
            tituloCell.setBorder(Rectangle.NO_BORDER);
            tituloTabla.addCell(tituloCell);
            documento.add(tituloTabla);
            documento.add(Chunk.NEWLINE);

            // ══ TABLA DE DATOS ══
            PdfPTable tabla = new PdfPTable(2);
            tabla.setWidthPercentage(100);
            tabla.setWidths(new float[]{1, 2});
            tabla.setSpacingBefore(10);
            tabla.setSpacingAfter(10);

            // Datos de la cita con validación de null
            agregarFila(tabla, "Número de Cita:", String.valueOf(cita.getId()));
            agregarFila(tabla, "Paciente:", 
                safeString(cita.getNombrePaciente(), "No disponible"));
            agregarFila(tabla, "Médico:", 
                safeString(cita.getNombreMedico(), "No disponible"));
            agregarFila(tabla, "Especialidad:", 
                safeString(cita.getNombreEspecialidad(), "No disponible"));
            agregarFila(tabla, "Fecha de la Cita:", 
                cita.getFechaCita() != null ? cita.getFechaCita().toString() : "No especificada");
            agregarFila(tabla, "Hora de la Cita:", 
                cita.getHoraCita() != null ? cita.getHoraCita().toString() : "No especificada");
            agregarFila(tabla, "Motivo:", 
                safeString(cita.getMotivo(), "No especificado"));
            agregarFila(tabla, "Estado:", safeString(cita.getEstado(), "No definido"));
            
            documento.add(tabla);

            // ══ OBSERVACIONES ══
            if (cita.getObservaciones() != null && !cita.getObservaciones().isEmpty()) {
                documento.add(Chunk.NEWLINE);
                Paragraph obsTitulo = new Paragraph("Observaciones:", FUENTE_BOLD);
                documento.add(obsTitulo);
                Paragraph obs = new Paragraph(cita.getObservaciones(), FUENTE_NORMAL);
                documento.add(obs);
            }

            // ══ INSTRUCCIONES ══
            documento.add(Chunk.NEWLINE);
            PdfPTable instruccionesTabla = new PdfPTable(1);
            instruccionesTabla.setWidthPercentage(100);
            
            PdfPCell instCell = new PdfPCell();
            instCell.setBackgroundColor(new BaseColor(214, 234, 248));
            instCell.setPadding(10);
            instCell.setBorderColor(new BaseColor(26, 82, 118));
            
            Paragraph instTitulo = new Paragraph("INSTRUCCIONES IMPORTANTES", 
                new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, new BaseColor(26, 82, 118)));
            instCell.addElement(instTitulo);
            instCell.addElement(Chunk.NEWLINE);
            
            String[] instrucciones = {
                "• Llegue 15 minutos antes de su cita programada.",
                "• Traiga su documento de identidad original.",
                "• Si necesita cancelar, hágalo con 24 horas de anticipación.",
                "• Este comprobante es válido únicamente para la fecha y hora indicadas.",
                "• En caso de no poder asistir, comuníquese al (8) 123-4567."
            };
            
            for (String inst : instrucciones) {
                instCell.addElement(new Paragraph(inst, FUENTE_NORMAL));
            }
            
            instruccionesTabla.addCell(instCell);
            documento.add(instruccionesTabla);

            // ══ PIE DE PÁGINA ══
            documento.add(Chunk.NEWLINE);
            
            PdfPTable footerTabla = new PdfPTable(1);
            footerTabla.setWidthPercentage(100);
            
            PdfPCell footerCell = new PdfPCell();
            footerCell.setBorder(Rectangle.TOP);
            footerCell.setBorderColor(BaseColor.LIGHT_GRAY);
            footerCell.setPaddingTop(10);
            
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            Paragraph pie = new Paragraph(
                "Generado el: " + sdf.format(new Date()) + 
                " | SENA · CIMM · Regional Boyacá · 2026", FUENTE_PEQUEÑA);
            pie.setAlignment(Element.ALIGN_CENTER);
            footerCell.addElement(pie);
            
            footerTabla.addCell(footerCell);
            documento.add(footerTabla);

        } catch (Exception e) {
            // Relanzar la excepción para que el servlet la maneje
            throw new Exception("Error al generar el PDF: " + e.getMessage(), e);
        } finally {
            // Cerrar el documento si está abierto
            if (documento != null && documento.isOpen()) {
                documento.close();
            }
            // NO cerrar el OutputStream aquí - el servlet lo cierra
        }
    }

    /**
     * Agrega una fila a la tabla de datos
     */
    private static void agregarFila(PdfPTable tabla, String etiqueta, String valor) {
        PdfPCell cellEtiqueta = new PdfPCell(new Paragraph(etiqueta, FUENTE_BOLD));
        cellEtiqueta.setBackgroundColor(new BaseColor(230, 245, 255));
        cellEtiqueta.setPadding(8);
        cellEtiqueta.setBorderColor(BaseColor.LIGHT_GRAY);
        cellEtiqueta.setVerticalAlignment(Element.ALIGN_MIDDLE);
        
        PdfPCell cellValor = new PdfPCell(new Paragraph(valor, FUENTE_NORMAL));
        cellValor.setPadding(8);
        cellValor.setBorderColor(BaseColor.LIGHT_GRAY);
        cellValor.setVerticalAlignment(Element.ALIGN_MIDDLE);
        
        tabla.addCell(cellEtiqueta);
        tabla.addCell(cellValor);
    }

    /**
     * Retorna el valor si no es null/vacío, sino retorna el valor por defecto
     */
    private static String safeString(String valor, String porDefecto) {
        return (valor != null && !valor.trim().isEmpty()) ? valor : porDefecto;
    }
}