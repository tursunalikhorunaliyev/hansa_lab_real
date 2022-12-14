import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/custom_paint_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/screens/pdf_viewer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDoubleClipItem extends StatefulWidget {
  const CustomDoubleClipItem(
      {Key? key,
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
  State<CustomDoubleClipItem> createState() => _CustomDoubleClipItemState();
}

class _CustomDoubleClipItemState extends State<CustomDoubleClipItem> {
  @override
  Widget build(BuildContext context) {
    Future<void>? launched;
    final isTablet = Provider.of<bool>(context);
    return Padding(
      padding: EdgeInsets.only(top: 6.h, bottom: 5.h),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: ClipPath(
                    clipper: CustomPaintClipper(),
                    child: Container(
                      width: 305.w,
                      height: 75.h,
                      color: widget.backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 18.w),
                    child: SizedBox(
                      width: isTablet ? 400 : 200,
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.montserrat(
                          color: widget.titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 10.sp : 13.sp,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      PhysicalModel(
                        shadowColor: Colors.grey.withOpacity(.5),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(64.r),
                        elevation: 5.sp,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              launched = _launchInBrowser(
                                Uri.parse("https://${widget.linkPDFSkachat}"),
                              );
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(64.r),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              constraints: BoxConstraints(
                                minWidth: 90.w,
                              ),
                              color: widget.buttonColor,
                              child: Center(
                                child: Text(
                                  widget.stbuttonText,
                                  style: GoogleFonts.montserrat(
                                    color: widget.buttonTextColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PhysicalModel(
                        shadowColor: Colors.grey.withOpacity(.5),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(64),
                        elevation: 5,
                        child: GestureDetector(
                          onTap: () {
                            if (widget.linkPDF.contains(".pdf") &&
                                widget.linkPDF.contains("google")) {
                              String pdfInAppUrl =
                                  widget.linkPDF.split("url=")[1].split("&")[0];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewer(
                                        pdfUrlForPDFViewer: pdfInAppUrl),
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
                                launched = _launchInBrowser(Uri.parse(fullUrl));
                              });
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(64),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              constraints: BoxConstraints(
                                minWidth: 90.w,
                              ),
                              color: widget.buttonColor,
                              child: Center(
                                child: Text(
                                  widget.ndbuttonText,
                                  style: GoogleFonts.montserrat(
                                    color: widget.buttonTextColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
