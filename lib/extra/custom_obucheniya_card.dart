import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/api_models.dart/favourite_model.dart';
import 'package:hansa_lab/blocs/favourite_bloc.dart';
import 'package:hansa_lab/screens/pdf_viewer.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ObucheniyaCard extends StatefulWidget {
  const ObucheniyaCard(
      {Key? key,
      required this.buttonColor,
      required this.bottomButtonText,
      required this.title,
      required this.url,
      required this.isFavourite,
      required this.linkPDF,
      required this.link,
      required this.isFavouriteURL})
      : super(key: key);
  final String url;
  final Color buttonColor;
  final String link;
  final String bottomButtonText;
  final String title;
  final bool isFavourite;
  final String linkPDF;
  final String isFavouriteURL;

  @override
  State<ObucheniyaCard> createState() => _ObucheniyaCardState();
}

class _ObucheniyaCardState extends State<ObucheniyaCard> {
  late dynamic response;
  Future<void>? launched;
  @override
  Widget build(BuildContext context) {
    final isFavouriteBLoC = FavouriteBLoC();
    final token = Provider.of<String>(context);
    final isTablet = Provider.of<bool>(context);
    final favouriteModel = FavouriteModel(status: true, data: true);
    bool fav = widget.isFavourite;
    return Padding(
      padding: EdgeInsets.only(
          top: isTablet ? 0 : 15.h,
          left: isTablet ? 0 : 20,
          right: isTablet ? 0 : 20),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: isTablet ? 180 : 217),
            child: Container(
              width: isTablet ? 390 : double.infinity,
              height: isTablet ? 75.h : 110.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: const Color(0xffffffff)),
              child: Padding(
                padding: EdgeInsets.only(left: 18.w, right: 7.w),
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
                          SizedBox(
                            height:
                                widget.link.isEmpty || widget.linkPDF.isEmpty
                                    ? 0
                                    : 10,
                          ),
                          widget.link.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    if (widget.link.contains(".pdf")) {
                                      String pdfInAppUrl = widget.link
                                          .split("url=")[1]
                                          .split("&")[0];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFViewer(
                                                pdfUrlForPDFViewer:
                                                    pdfInAppUrl),
                                          ));
                                    } else {
                                      String fullUrl =
                                          widget.link.startsWith("http")
                                              ? widget.link
                                              : "http://${widget.link}";

                                      setState(() {
                                        launched = _launchInBrowser(
                                            Uri.parse(fullUrl));
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
                                      "Смотреть",
                                      style: GoogleFonts.montserrat(
                                          fontSize: isTablet ? 12 : 10,
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height:
                                widget.link.isEmpty || widget.linkPDF.isEmpty
                                    ? 0
                                    : 10,
                          ),
                          widget.linkPDF.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    if (widget.link.contains(".pdf")) {
                                      String pdfInAppUrl = widget.link
                                          .split("url=")[1]
                                          .split("&")[0];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFViewer(
                                                pdfUrlForPDFViewer:
                                                    pdfInAppUrl),
                                          ));
                                    } else {
                                      String fullUrl =
                                          widget.link.startsWith("http")
                                              ? widget.link
                                              : "http://${widget.link}";

                                      setState(() {
                                        launched = _launchInBrowser(
                                            Uri.parse(fullUrl));
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
                                )
                              : const SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.link.contains(".pdf") && widget.link.contains("google")) {
                String pdfInAppUrl = widget.link.split("url=")[1].split("&")[0];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PDFViewer(pdfUrlForPDFViewer: pdfInAppUrl),
                    ));
              } else {
                String fullUrl = widget.link.startsWith("http")
                    ? widget.link
                    : "http://${widget.link}";

                setState(() {
                  launched = _launchInBrowser(Uri.parse(fullUrl));
                });
              }
            },
            child: SizedBox(
                width: isTablet ? 388 : double.infinity,
                height: isTablet ? 170 : 206,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: CachedNetworkImage(
                    imageUrl: widget.url,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: isTablet ? 150 : 181,
            ),
            child: Row(
              children: [
                Spacer(
                  flex: isTablet ? 13 : 9,
                ),
                StreamBuilder<bool>(
                    initialData: false,
                    stream: isFavouriteBLoC.stream,
                    builder: (context, snapshot) {
                      return InkWell(
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
                                //  messagePadding: EdgeInsets.symmetric(horizontal: 80),
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
                          height: isTablet ? 45 : 55,
                          width: isTablet ? 45 : 55,
                          decoration: BoxDecoration(
                              color: const Color(0xfff1f1f1),
                              borderRadius: BorderRadius.circular(90.w)),
                          child: fav
                              ? const Icon(
                                  Icons.favorite,
                                  color: Color.fromARGB(255, 213, 0, 50),
                                )
                              : const Icon(
                                  Icons.favorite_border_sharp,
                                  color: Color.fromARGB(255, 213, 0, 50),
                                ),
                        ),
                      );
                    }),
                Spacer(
                  flex: isTablet ? 2 : 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
