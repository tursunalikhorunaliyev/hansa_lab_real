import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hansa_lab/extra/custom_double_clip_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/pdf_viewer.dart';

class CustomKatalogItemDouble extends StatefulWidget {
  const CustomKatalogItemDouble(
      {Key? key,
      required this.imageUrl,
      required this.backgroundColor,
      required this.buttonTextColor,
      required this.buttonColor,
      required this.titleColor,
      required this.stbuttonText,
      required this.ndbuttonText,
      required this.title,
      required this.linkPDF,
      required this.linkPDFSkachat})
      : super(key: key);
  final String imageUrl;
  final Color backgroundColor;
  final Color buttonTextColor;
  final Color buttonColor;
  final Color titleColor;
  final String stbuttonText;
  final String ndbuttonText;
  final String title;
  final String linkPDF;
  final String linkPDFSkachat;

  @override
  State<CustomKatalogItemDouble> createState() =>
      _CustomKatalogItemDoubleState();
}

class _CustomKatalogItemDoubleState extends State<CustomKatalogItemDouble> {
  @override
  Widget build(BuildContext context) {
    Future<void>? launched;
    return Padding(
      padding:
          EdgeInsets.only(right: 18.w, left: 18.w, bottom: 10.h, top: 10.h),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (widget.linkPDF.contains(".pdf") &&
                  widget.linkPDF.contains("google")) {
                String pdfInAppUrl = widget.linkPDF
                    .split("url=")[1]
                    .split("&")[0];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewer(
                          pdfUrlForPDFViewer:
                          pdfInAppUrl),
                    ));
              } else if (widget.linkPDF
                  .endsWith(".pdf")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewer(
                          pdfUrlForPDFViewer:
                          widget.linkPDF),
                    ));
              } else {
                String fullUrl =
                widget.linkPDF.startsWith("https")
                    ? widget.linkPDF
                    : "https://${widget.linkPDF}";

                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewer(
                            pdfUrlForPDFViewer: fullUrl),
                      ));
                  // launched =
                  //     _launchInBrowser(
                  //         Uri.parse(
                  //             fullUrl));
                });
              }
              // setState(() {
              //   launched = _launchInBrowser(
              //     Uri.parse(widget.linkPDF),
              //   );
              // });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                width: double.infinity,
                height: 206.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          CustomDoubleClipItem(
            linkPDFSkachat: widget.linkPDFSkachat,
            linkPDF: widget.linkPDF,
            backgroundColor: widget.backgroundColor,
            buttonTextColor: widget.buttonTextColor,
            buttonColor: widget.buttonColor,
            titleColor: widget.titleColor,
            stbuttonText: widget.stbuttonText,
            ndbuttonText: widget.ndbuttonText,
            title: widget.title,
          ),
        ],
      ),
    );
  }

  _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
