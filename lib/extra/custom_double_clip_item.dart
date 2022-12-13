import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/extra/custom_paint_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/download_progress_bloc.dart';
import '../screens/pdf_viewer.dart';

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
                          onTap: () async {
                            print(widget.linkPDF);
                            if (widget.linkPDF
                                .contains(".pdf") &&
                                widget.linkPDF
                                    .contains(
                                    "google")) {
                              String pdfInAppUrl =
                              widget.linkPDF
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
                                    const EdgeInsets
                                        .only(
                                        bottom: 20,
                                        right: 20),
                                    alignment: Alignment
                                        .center,
                                    content:
                                    StreamBuilder<
                                        double>(
                                      stream:
                                      blocDownload
                                          .stream,
                                      initialData: 0,
                                      builder: (context,
                                          snapshotDouble) {
                                        return SizedBox(
                                          height: 50,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                              const SizedBox(
                                                height:
                                                10,
                                              ),
                                              LinearPercentIndicator(
                                                alignment:
                                                MainAxisAlignment.center,
                                                padding:
                                                const EdgeInsets.all(0),
                                                barRadius:
                                                const Radius.circular(5),
                                                lineHeight:
                                                15,
                                                percent:
                                                snapshotDouble.data! /
                                                    100,
                                                center:
                                                Text(
                                                  "${snapshotDouble.data}%",
                                                  style:
                                                  GoogleFonts.montserrat(
                                                    fontSize:
                                                    10,
                                                    color:
                                                    Colors.black,
                                                  ),
                                                ),
                                                backgroundColor:
                                                Colors.transparent,
                                                progressColor:
                                                Colors.green,
                                              ),
                                              const SizedBox(
                                                height:
                                                10,
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
                            } else if (widget.linkPDF.endsWith(".pdf")) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewer(
                                        pdfUrlForPDFViewer: widget.linkPDF),
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
