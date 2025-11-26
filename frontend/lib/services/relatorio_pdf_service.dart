import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioPdfService {
  static Future<Uint8List> gerarPdf(
    List<Map<String, String>> itens, {
    String? autorNome,
  }) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'MobSafety - Relatório de Inspeção',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          if (autorNome != null && autorNome.isNotEmpty)
            pw.Text(
              'Gerado por: $autorNome',
              style: const pw.TextStyle(fontSize: 10),
            ),
          pw.Text(
            'Gerado em: ${DateTime.now()}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: const ['Código', 'Seção', 'Subseção', 'Pergunta', 'Resposta'],
            data: itens
                .map((i) => [
                      i['codigo'] ?? '-',
                      i['secao'] ?? '-',
                      (i['subsecao']?.isEmpty ?? true) ? '-' : i['subsecao'],
                      i['pergunta'] ?? '-',
                      i['resposta'] ?? '-',
                    ])
                .toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              0: const pw.FixedColumnWidth(50),
              1: const pw.FixedColumnWidth(110),
              2: const pw.FixedColumnWidth(120),
              3: const pw.FlexColumnWidth(),
              4: const pw.FixedColumnWidth(120),
            },
          ),
        ],
      ),
    );

    return doc.save();
  }
}