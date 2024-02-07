import 'dart:typed_data';

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/models/m_extra_cost.dart';
import 'package:tamirci/core/models/m_service.dart';

import '../../core/models/m_piece.dart';

class PdfServicePage extends StatefulWidget {
  const PdfServicePage({super.key, required this.service});

  final MService service;

  @override
  State<PdfServicePage> createState() => _PdfServicePageState();
}

class _PdfServicePageState extends State<PdfServicePage> {
  MService get _service => widget.service;

  List<MapEntry<String, String>> _getPrices() {
    List<MapEntry<String, String>> list = [];

    List<MPiece> usedPieces = _service.usedPieces ?? [];

    if (usedPieces.length > 1) {
      list.add(const MapEntry("Açıklama", "Fiyat (TL)"));

      list.addAll(usedPieces.map((e) =>
          MapEntry("${e.quantity} Adet - ${e.piece}", e.price.toString())));
    } else if (usedPieces.length == 1) {
      final element = usedPieces.first;
      final piece = element.piece ?? "";
      List<String> pieces = piece.split("-");

      if (pieces.length == 1) {
        list.add(const MapEntry("Açıklama", "Fiyat (TL)"));
        list.add(MapEntry(piece, element.price.toString()));
      } else {
        list.add(const MapEntry("Parçalar", "Fiyat (TL)"));
        list.addAll(pieces.map((e) => MapEntry(e.trim(), "-")));
        list.add(
            MapEntry("Yukarıdaki Parçalar Toplamı", element.price.toString()));
      }
    }

    list.add(MapEntry("İşçilik", _service.workCost.toString()));

    for (MExtraCost element in _service.extraCosts ?? []) {
      list.add(MapEntry(
          element.explanation ?? "Ekstra ücret", element.price.toString()));
    }

    return list;
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final doc = pw.Document();

    final image = await imageFromAssetBundle('assets/eksiler.jpeg');

    final regular = await PdfGoogleFonts.robotoRegular();
    final bold = await PdfGoogleFonts.robotoBold();
    final italic = await PdfGoogleFonts.robotoItalic();

    final prices = _getPrices();

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: regular,
            bold: bold,
            italic: italic,
          ),
        ),
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.Image(image, height: 100, width: 100),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  child: pw.FittedBox(
                    child: pw.Text(
                      "EKŞİLER OTO",
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "Araç sahibi: ${_service.customer?.getFullName}",
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "Araç plaka:  ${_service.plate?.withSpaces.toUpperCase()}",
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "Tarih:             ${_service.createdAt!.toStringFromDate}",
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 20),
            ...List.generate(
              prices.length,
              (index) {
                final p = prices[index];
                return pw.Container(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(width: 2),
                      left: pw.BorderSide(width: 2),
                      right: pw.BorderSide(width: 2),
                    ),
                  ),
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          p.key,
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Text(
                        p.value,
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
            pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 2),
                  left: pw.BorderSide(width: 2),
                  right: pw.BorderSide(width: 2),
                  top: pw.BorderSide(width: 2),
                ),
              ),
              padding: const pw.EdgeInsets.all(5),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Toplam Fiyat",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.red,
                    ),
                  ),
                  pw.Text(
                    _service.totalPrice.toString(),
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.red,
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    ); // Page

    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (format) => _buildPdf(format),
      canChangePageFormat: false,
      canChangeOrientation: false,
      allowPrinting: false,
      canDebug: false,
    );
  }
}
