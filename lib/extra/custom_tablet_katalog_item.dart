import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/extra/custom_bottom_tablet_item.dart';
import 'package:hansa_lab/screens/pdf_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class TabletKatalogItem extends StatefulWidget {
  const TabletKatalogItem(
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
  State<TabletKatalogItem> createState() => _TabletKatalogItemState();
}

class _TabletKatalogItemState extends State<TabletKatalogItem> {
  @override
  Widget build(BuildContext context) {
    Future<void>? launched;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (widget.linkPDF
                                                            .contains(".pdf") &&
                                                        widget.linkPDF
                                                            .contains(
                                                                "google")) {
                                                      String pdfInAppUrl =
                                                          widget.linkPDF
                                                              .split("url=")[1]
                                                              .split("&")[0];
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PDFViewer(
                                                                    pdfUrlForPDFViewer:
                                                                        pdfInAppUrl),
                                                          ));
                                                    } 
                                                    else if (widget.linkPDF
                                              .endsWith(".pdf")) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFViewer(
                                                          pdfUrlForPDFViewer:
                                                              widget.linkPDF),
                                                ));
                                          }
                                                    else {
                                                      String fullUrl = widget.linkPDF.startsWith("http")
                                                          ? widget.linkPDF
                                                          : "http://${widget.linkPDF}";

                                                      setState(() {
                                                        launched =
                                                            _launchInBrowser(
                                                                Uri.parse(
                                                                    fullUrl));
                                                      });
                                                    }
                      
                      
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              width: 200.w,
              height: 150.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        TabletKatalogBottomItem(
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
