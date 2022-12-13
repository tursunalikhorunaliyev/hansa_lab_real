import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/api_models.dart/favourite_model.dart';
import 'package:hansa_lab/blocs/favourite_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/download_progress_bloc.dart';
import '../screens/pdf_viewer.dart';
import 'package:path/path.dart';

class ObucheniyaCard extends StatefulWidget {
  ObucheniyaCard(
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

  final blocDownload = DownloadProgressFileBloc();

  bool downloading = false;
  double progress = 0.0;
  bool isDownloaded = false;
  String path = "";
  String dir = "";

  Future<String> getFilePath(uniqueFileName) async {
    if (Platform.isIOS) {
      Directory directory = await getApplicationSupportDirectory();
      dir = directory.path;
      print(uniqueFileName);
    } else if (Platform.isAndroid) {
      dir = "/storage/emulated/0/Download/";
    }
    path = "$dir/$uniqueFileName";
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final isFavouriteBLoC = FavouriteBLoC();
    final token = Provider.of<String>(context);
    final isTablet = Provider.of<bool>(context);
    bool fav = widget.isFavourite;

    Future<void> downloadFile(String url, String fileName) async {
      await Permission.storage.request();
      progress = 0;

      String savePath = await getFilePath(fileName);
      Dio dio = Dio();
      dio.download(
        url,
        savePath,
        onReceiveProgress: (recieved, total) async {
          progress =
              double.parse(((recieved / total) * 100).toStringAsFixed(0));
          blocDownload.streamSink.add(progress);
          if (progress == 100) {
            log("tugadi");
          } else {
            log("hali tugamadi");
          }
        },
        deleteOnError: true,
      ).then((value) async {
        Navigator.pop(context);
        OpenFile.open(path);
      });
    }

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
                                    if (widget.link.contains(".pdf") &&
                                        widget.link.contains("google")) {
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
                                    } else if (widget.link.endsWith(".pdf")) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFViewer(
                                                pdfUrlForPDFViewer:
                                                    widget.link),
                                          ));
                                    } else {
                                      String fullUrl =
                                          widget.link.startsWith("https")
                                              ? widget.link
                                              : "https://${widget.link}";

                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PDFViewer(
                                                  pdfUrlForPDFViewer: fullUrl),
                                            ));
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
                                  onTap: () async {
                                    if (widget.link.contains(".pdf") &&
                                        widget.link.contains("google")) {
                                      String pdfInAppUrl = widget.link
                                          .split("url=")[1]
                                          .split("&")[0];
                                      await downloadFile(
                                        pdfInAppUrl,
                                        basename(pdfInAppUrl),
                                      );
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actionsPadding:
                                                const EdgeInsets.only(
                                                    bottom: 20, right: 20),
                                            alignment: Alignment.center,
                                            content: StreamBuilder<double>(
                                              stream: blocDownload.stream,
                                              initialData: 0,
                                              builder:
                                                  (context, snapshotDouble) {
                                                return SizedBox(
                                                  height: 50,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      LinearPercentIndicator(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        barRadius: const Radius
                                                            .circular(5),
                                                        lineHeight: 15,
                                                        percent: snapshotDouble
                                                                .data! /
                                                            100,
                                                        center: Text(
                                                          "${snapshotDouble.data}%",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        progressColor:
                                                            Colors.green,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
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
              if (widget.link.contains(".pdf") &&
                  widget.link.contains("google")) {
                String pdfInAppUrl = widget.link.split("url=")[1].split("&")[0];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PDFViewer(pdfUrlForPDFViewer: pdfInAppUrl),
                    ));
              } else if (widget.link.endsWith(".pdf")) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PDFViewer(pdfUrlForPDFViewer: widget.link),
                    ));
              } else {
                String fullUrl = widget.link.startsWith("https")
                    ? widget.link
                    : "https://${widget.link}";

                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PDFViewer(pdfUrlForPDFViewer: fullUrl),
                      ));
                  // launched =
                  //     _launchInBrowser(
                  //         Uri.parse(
                  //             fullUrl));
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
