import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hansa_lab/blocs/qr_code_bloc.dart';
import 'package:hansa_lab/screens/pdf_viewer.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodePage extends StatefulWidget {
  final String? token;

  const QrCodePage({Key? key, this.token}) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QrCodeBloc qrCodeBloc = QrCodeBloc();
  Future<void>? launched;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 20,
              borderWidth: 5,
            ),
            key: qrKey,
            onQRViewCreated: (QRViewController controller) {
              this.controller = controller;
              controller.scannedDataStream.listen(
                (scanData) {
                  result = scanData;
                  qrCodeBloc
                      .getQrCodeResponse(widget.token, result!.code)
                      .then((value) {
                    if (value.data!.url!.contains(".pdf") &&
                        value.data!.url!.contains("google")) {
                      String pdfInAppUrl =
                          value.data!.url!.split("url=")[1].split("&")[0];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PDFViewer(pdfUrlForPDFViewer: pdfInAppUrl),
                          ));
                    } else if (value.data!.url!.endsWith(".pdf")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PDFViewer(pdfUrlForPDFViewer: value.data!.url!),
                          ));
                    } else {
                      String fullUrl = value.data!.url!.startsWith("http")
                          ? value.data!.url!
                          : "http://${value.data!.url!}";
                      launched = _launchInBrowser(Uri.parse(fullUrl));
                    }
                  });
                  controller.stopCamera();
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 68.0,
              horizontal: 18,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
     )) {
      throw 'Could not launch $url';
    }
  }
}
