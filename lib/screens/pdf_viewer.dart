import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({super.key});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SfPdfViewer.network("https://hansa-lab.ru/storage/upload/guide/m1.pdf"),
      ),
    );
  }
}