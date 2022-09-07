import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/custom_paint_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class TabletKatalogBottomItem extends StatefulWidget {
  const TabletKatalogBottomItem(
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
  State<TabletKatalogBottomItem> createState() =>
      _TabletKatalogBottomItemState();
}

class _TabletKatalogBottomItemState extends State<TabletKatalogBottomItem> {
  @override
  Widget build(BuildContext context) {
    Future<void>? launched;
    return Padding(
      padding: EdgeInsets.only(
        bottom: 11.h,
      ),
      child: SizedBox(
        width: 200.w,
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: ClipPath(
                    clipper: CustomPaintClipper(),
                    child: Container(
                      width: 150.w,
                      height: 65.h,
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
                    padding: EdgeInsets.only(left: 10.w),
                    child: Container(
                      alignment: Alignment.center,
                      width: 100.w,
                      height: 60.h,
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.montserrat(
                          color: widget.titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 7.sp,
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
                              width: 50.w,
                              height: 20.h,
                              color: widget.buttonColor,
                              child: Center(
                                child: Text(
                                  widget.stbuttonText,
                                  style: GoogleFonts.montserrat(
                                    color: widget.buttonTextColor,
                                    fontSize: 6.sp,
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
                            setState(() {
                              launched =
                                  _launchInBrowser(Uri.parse(widget.linkPDF));
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(64),
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              width: 50.w,
                              height: 20.h,
                              color: widget.buttonColor,
                              child: Center(
                                child: Text(
                                  widget.ndbuttonText,
                                  style: GoogleFonts.montserrat(
                                    color: widget.buttonTextColor,
                                    fontSize: 6.sp,
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
