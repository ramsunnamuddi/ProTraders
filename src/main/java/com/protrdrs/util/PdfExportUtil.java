package com.protrdrs.util;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import org.springframework.stereotype.Component;

import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

@Component
public class PdfExportUtil {

    public byte[] buildWithdrawalReport(List<Map<String, Object>> records, String paragraphName) {

        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

            Document doc = new Document(PageSize.A4.rotate(), 36, 36, 36, 36);
            PdfWriter.getInstance(doc, baos);

            doc.open();

            Font titleF  = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
            Font headF   = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10);
            Font cellF   = FontFactory.getFont(FontFactory.HELVETICA, 10);

            // Title
            Paragraph title = new Paragraph(paragraphName, titleF);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            doc.add(title);

            if (records.isEmpty()) {
                doc.add(new Paragraph("No data available."));
                doc.close();
                return baos.toByteArray();
            }

            // Table (dynamic columns based on first row)
            Map<String, Object> firstRow = records.get(0);
            PdfPTable table = new PdfPTable(firstRow.size());
            table.setWidthPercentage(100);

            // Headers
            for (String key : firstRow.keySet()) {
                PdfPCell cell = new PdfPCell(new Phrase(key.toUpperCase(), headF));
                cell.setBackgroundColor(new Color(230, 230, 230));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(5);
                table.addCell(cell);
            }

            // Rows
            for (Map<String, Object> row : records) {
                for (Object val : row.values()) {
                    PdfPCell cell = new PdfPCell(new Phrase(
                            val != null ? val.toString() : "", cellF));
                    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    cell.setPadding(4);
                    table.addCell(cell);
                }
            }

            doc.add(table);
            doc.close();
            return baos.toByteArray();

        } catch (Exception e) {
            throw new RuntimeException("Failed to generate PDF", e);
        }
    }
}
