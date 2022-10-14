import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/favourite_bloc.dart';
import 'package:hansa_lab/screens/pdf_viewer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class StackedStackPrezentatsiyaTab extends StatefulWidget {
  const StackedStackPrezentatsiyaTab(
      {Key? key,
      required this.buttonColor,
      required this.topButtonText,
      required this.skachat,
      required this.bottomButtonText,
      required this.title,
      required this.url,
      required this.isFavourite,
      required this.linkPDF,
      required this.linkPDFSkachat,
      required this.isFavouriteURL,
      required this.buttonLink})
      : super(key: key);

  final String url;
  final Color buttonColor;
  final String topButtonText;
  final String bottomButtonText;
  final String title;
  final Widget? skachat;
  final bool isFavourite;
  final String? linkPDF;
  final String linkPDFSkachat;
  final String isFavouriteURL;
  final Widget? buttonLink;

  @override
  State<StackedStackPrezentatsiyaTab> createState() =>
      _StackedStackPrezentatsiyaTabState();
}

class _StackedStackPrezentatsiyaTabState
    extends State<StackedStackPrezentatsiyaTab> {
  late dynamic response;
  Future<void>? launched;
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final isFavouriteBLoC = FavouriteBLoC();
    final token = Provider.of<String>(context);
    bool fav = widget.isFavourite;
    return Center(
      child: SizedBox(
        height: 360,
        width: 430,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (widget.linkPDF!
                                                            .contains(".pdf") &&
                                                        widget.linkPDF!
                                                            .contains(
                                                                "google")) {
                                                      String pdfInAppUrl =
                                                          widget.linkPDF!
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
                                                    else if (widget.linkPDF!
                                              .endsWith(".pdf")) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFViewer(
                                                          pdfUrlForPDFViewer:
                                                              widget.linkPDF!),
                                                ));
                                          }
                                                    else {
                                                      String fullUrl = widget.linkPDF!.startsWith("http")
                                                          ? widget.linkPDF!
                                                          : "http://${widget.linkPDF}";

                                                      setState(() {
                                                        launched =
                                                            _launchInBrowser(
                                                                Uri.parse(
                                                                    fullUrl));
                                                      });
                                                    }
                      
                      
                    },
                    child: SizedBox(
                        width: 410,
                        height: 230,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: CachedNetworkImage(
                            imageUrl: widget.url,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 410,
                    height: 77.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: const Color(0xffffffff)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.montserrat(
                                  fontSize: isTablet ? 14 : 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 23.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.buttonLink!
                                /*   Padding(
                                  padding: EdgeInsets.only(
                                      top: isTablet ? 22.h : 27.h),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        launched = _launchInBrowser(Uri.parse(
                                            "http://${widget.linkPDFSkachat}"));
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: isTablet ? 100 : 94,
                                      height: isTablet ? 28 : 25,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff31353b),
                                          borderRadius:
                                              BorderRadius.circular(13.r)),
                                      child: Text(
                                        widget.topButtonText,
                                        style: GoogleFonts.montserrat(
                                            fontSize: isTablet ? 12 : 10,
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ), */
                                ,
                                Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.linkPDF!
                                                            .contains(".pdf") &&
                                                        widget.linkPDF!
                                                            .contains(
                                                                "google")) {
                                                      String pdfInAppUrl =
                                                          widget.linkPDF!
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
                                                    else if (widget.linkPDF!
                                              .endsWith(".pdf")) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFViewer(
                                                          pdfUrlForPDFViewer:
                                                              widget.linkPDF!),
                                                ));
                                          }
                                                    else {
                                                      String fullUrl = widget.linkPDF!.startsWith("http")
                                                          ? widget.linkPDF!
                                                          : "http://${widget.linkPDF}";

                                                      setState(() {
                                                        launched =
                                                            _launchInBrowser(
                                                                Uri.parse(
                                                                    fullUrl));
                                                      });
                                                    }
                      
                      
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: isTablet ? 100 : 94,
                                      height: isTablet ? 28 : 25,
                                      decoration: BoxDecoration(
                                          color: widget.buttonColor,
                                          borderRadius:
                                              BorderRadius.circular(13.r)),
                                      child: Text(
                                        widget.bottomButtonText,
                                        style: GoogleFonts.montserrat(
                                            fontSize: isTablet ? 12 : 10,
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<bool>(
                stream: isFavouriteBLoC.stream,
                initialData: false,
                builder: (context, snapshot) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 115, right: 45),
                      child: InkWell(
                        onTap: () {
                          fav = !fav;
                          isFavouriteBLoC.sink.add(fav);
                          isFavouriteBLoC.getFavourite(
                              token, widget.isFavouriteURL);
                          if (fav) {
                            showTopSnackBar(
                              reverseCurve: Curves.elasticOut,
                              animationDuration:
                                  const Duration(milliseconds: 600),
                              displayDuration:
                                  const Duration(milliseconds: 600),
                              context,
                              const CustomSnackBar.success(
                                iconRotationAngle: 0,
                                iconPositionLeft: 30,
                               // messagePadding:
                                  //  EdgeInsets.symmetric(horizontal: 80),
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 213, 0, 50),
                                message: "Сохранено в избранном",
                              ),
                            );
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                              color: const Color(0xfff1f1f1),
                              borderRadius: BorderRadius.circular(90.w)),
                          child: fav
                              ? const Icon(
                                  Icons.favorite,
                                  color: Color.fromARGB(255, 213, 0, 50),
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.favorite_border_sharp,
                                  color: Color.fromARGB(255, 213, 0, 50),
                                  size: 30,
                                ),
                        ),
                      ),
                    ),
                  );
                }),
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
