
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/custom_paint_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/download_progress_bloc.dart';

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

  final blocDownload = DownloadProgressFileBloc();

  bool downloading = false;
  double progress = 0.0;
  bool isDownloaded = false;

  Future<void> downloadFile(String url, String fileName) async {
    await Permission.storage.request();
    progress = 0;

    String savePath = await getFilePath(fileName);
    Dio dio = Dio();
    dio.download(
      url,
      savePath,
      onReceiveProgress: (recieved, total) {
        progress = double.parse(((recieved / total) * 100).toStringAsFixed(0));
        blocDownload.streamSink.add(progress);
        if (progress == 100) {
          log("tugadi");
          OpenFilex.open(path);
        } else {
          log("hali tugamadi");
        }
      },
      deleteOnError: true,
    );
  }

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
                          onTap: () async {
                            await downloadFile(
                              widget.linkPDF,
                              basename(widget.linkPDF),
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
