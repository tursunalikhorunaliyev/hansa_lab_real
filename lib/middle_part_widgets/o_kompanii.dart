import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/download_progress_bloc.dart';
import 'package:hansa_lab/extra/custom_okompanii_item.dart';
import 'package:hansa_lab/extra/custom_title.dart';
import 'package:hansa_lab/extra/top_video_vidget.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_index_provider.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_title_provider.dart';
import 'package:hansa_lab/video/bloc_video_api.dart';
import 'package:hansa_lab/video/model_video.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OKompanii extends StatefulWidget {
  const OKompanii({Key? key}) : super(key: key);

  @override
  State<OKompanii> createState() => _OKompaniiState();
}

class _OKompaniiState extends State<OKompanii> {
  final blocDownload = DownloadProgressFileBloc();

  bool downloading = false;
  double progress = 0;
  bool isDownloaded = false;
  String path = "";
  String dir = "";

  // Future<String> getFilePath(uniqueFileName) async {
  //   if (Platform.isIOS) {
  //     Directory directory = await getApplicationSupportDirectory();
  //     dir = directory.path;
  //   } else if (Platform.isAndroid) {
  //     dir = "/storage/emulated/0/Download/";
  //   }
  //   path = "$dir/$uniqueFileName";
  //   return path;
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final token = Provider.of<String>(context);
    final scroll = ScrollController();
    final blocVideoApi = BlocVideoApi();
    bool hasVideo = false;
    double progress = 0;

    Future<String> getFilePath(uniqueFileName) async {
      String path = "";
      String dir = "";
      if (Platform.isIOS) {
        Directory directory = await getApplicationSupportDirectory();
        dir = directory.path;
      } else if (Platform.isAndroid) {
        dir = "/storage/emulated/0/Download/";
      }
      path = "$dir/$uniqueFileName.mp4";
      return path;
    }

    Future<bool> downloadFile(String url, String fileName) async {
      progress = 0;

      String savePath = await getFilePath(fileName);
      if (await File(savePath).exists()) {
        log("exists");
        setState(() {});
        hasVideo = true;
        return false;
      } else {
        progress = 0;
        Dio dio = Dio();
        dio.download(
          url,
          savePath,
          onReceiveProgress: (recieved, total) {
            progress =
                double.parse(((recieved / total) * 100).toStringAsFixed(0));
            blocDownload.streamSink.add(progress);
            if (progress == 100) {
              // log("Download complate");
            } else {
              // log("$progress %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
            }
          },
          deleteOnError: true,
        );
        return true;
      }
    }

    // Future<void> downloadFile(String url, String fileName) async {
    //   await Permission.storage.request();
    //   progress = 0;
    //
    //   String savePath = await getFilePath(fileName);
    //   Dio dio = Dio();
    //   dio.download(
    //     url,
    //     savePath,
    //     onReceiveProgress: (recieved, total) {
    //       progress =
    //           double.parse(((recieved / total) * 100).toStringAsFixed(0));
    //       blocDownload.streamSink.add(progress);
    //       if (progress == 100) {
    //         log("tugadi");
    //       } else {
    //         log("hali tugamadi");
    //       }
    //     },
    //     deleteOnError: true,
    //   ).then((value) async {
    //     if (Platform
    //         .isIOS) {
    //       GallerySaver.saveVideo(widget.url);
    //     } else {
    //       GallerySaver.saveVideo(widget.url);
    //     }
    //     // Navigator.pop(context);
    //     // OpenFile.open(path);
    //   });
    // }

    return Expanded(
      child: Consumer<VideoIndexProvider>(builder: (context, value, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FutureBuilder<VideoMainOne>(
              future: blocVideoApi.getData(token: token),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Consumer<VideoTitleProvider>(
                          builder: (context, value, child) {
                        return CustomTitle(
                          imagePath: "assets/Lab.png",
                          title: value.getTitle,
                        );
                      }),
                      isTablet
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: GridView(
                                controller: scroll,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisExtent: 240.h),
                                children: List.generate(
                                    snapshot.data!.videoListData.list.length,
                                    (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: CustomOKompaniiItem(
                                      imageUrl: snapshot
                                          .data!
                                          .videoListData
                                          .list[value.getIndex]
                                          .data
                                          .list[index]
                                          .pictureLink,
                                      title: snapshot
                                          .data!
                                          .videoListData
                                          .list[value.getIndex]
                                          .data
                                          .list[index]
                                          .title,
                                      onTap: () {
                                        final VideoDetails video = snapshot
                                            .data!
                                            .videoListData
                                            .list[value.getIndex]
                                            .data
                                            .list[index];
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Scaffold(
                                              backgroundColor:
                                                  Colors.transparent,
                                              body: MultiProvider(
                                                providers: [
                                                  Provider(
                                                    create: (context) => index,
                                                  ),
                                                  Provider(
                                                    create: (context) => token,
                                                  ),
                                                ],
                                                child: TopVideoVidget(
                                                  url: video.videoLink,
                                                  title: video.title,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      onDownload: () {
                                        downloadFile(
                                            snapshot
                                                .data!
                                                .videoListData
                                                .list[value.getIndex]
                                                .data
                                                .list[index]
                                                .videoLink,
                                            snapshot
                                                .data!
                                                .videoListData
                                                .list[value.getIndex]
                                                .data
                                                .list[index]
                                                .title);

                                        showDialog(
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
                                                    builder: (context,
                                                        snapshotDouble) {
                                                      return SizedBox(
                                                        height: 250,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: snapshot
                                                                    .data!
                                                                    .videoListData
                                                                    .list[value
                                                                        .getIndex]
                                                                    .data
                                                                    .list[index]
                                                                    .pictureLink,
                                                                height: 165,
                                                                width: 325,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
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
                                                              barRadius:
                                                                  const Radius
                                                                      .circular(5),
                                                              lineHeight: 15,
                                                              //width: 325,
                                                              percent:
                                                                  snapshotDouble
                                                                          .data! /
                                                                      100,
                                                              center: Text(
                                                                "${snapshotDouble.data}%",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),

                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              progressColor:
                                                                  Colors.green,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                snapshot
                                                                    .data!
                                                                    .videoListData
                                                                    .list[value
                                                                        .getIndex]
                                                                    .data
                                                                    .list[index]
                                                                    .title
                                                                    .toString(),
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              );
                                            });
                                      },
                                      onTapImage: () {},
                                    ),
                                  );
                                }),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                snapshot.data!.videoListData
                                    .list[value.getIndex].data.list.length,
                                (index) => CustomOKompaniiItem(
                                  imageUrl: snapshot
                                      .data!
                                      .videoListData
                                      .list[value.getIndex]
                                      .data
                                      .list[index]
                                      .pictureLink,
                                  title: snapshot
                                      .data!
                                      .videoListData
                                      .list[value.getIndex]
                                      .data
                                      .list[index]
                                      .title,
                                  onDownload: () {
                                    downloadFile(
                                            snapshot
                                                .data!
                                                .videoListData
                                                .list[value.getIndex]
                                                .data
                                                .list[index]
                                                .videoLink,
                                            snapshot
                                                .data!
                                                .videoListData
                                                .list[value.getIndex]
                                                .data
                                                .list[index]
                                                .title)
                                        .then((values) {
                                      if (Platform.isIOS) {
                                        GallerySaver.saveVideo(snapshot
                                            .data!
                                            .videoListData
                                            .list[value.getIndex]
                                            .data
                                            .list[index]
                                            .videoLink);
                                      } else {
                                        GallerySaver.saveVideo(snapshot
                                            .data!
                                            .videoListData
                                            .list[value.getIndex]
                                            .data
                                            .list[index]
                                            .videoLink);
                                      }
                                    });

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actionsPadding: const EdgeInsets.only(
                                              bottom: 20, right: 20),
                                          alignment: Alignment.center,
                                          content: StreamBuilder<double>(
                                            stream: blocDownload.stream,
                                            initialData: 0,
                                            builder: (context, snapshotDouble) {
                                              return SizedBox(
                                                height: 250,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: CachedNetworkImage(
                                                        imageUrl: snapshot
                                                            .data!
                                                            .videoListData
                                                            .list[
                                                                value.getIndex]
                                                            .data
                                                            .list[index]
                                                            .pictureLink,
                                                        height: 165,
                                                        width: 325,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    if (!hasVideo)
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
                                                        //width: 325,
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
                                                      )
                                                    else
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Этот файл уже скачан",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .videoListData
                                                            .list[
                                                                value.getIndex]
                                                            .data
                                                            .list[index]
                                                            .title
                                                            .toString(),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  onTap: () {
                                    final VideoDetails video = snapshot
                                        .data!
                                        .videoListData
                                        .list[value.getIndex]
                                        .data
                                        .list[index];
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return Scaffold(
                                          backgroundColor: Colors.transparent,
                                          body: MultiProvider(
                                            providers: [
                                              Provider(
                                                create: (context) => index,
                                              ),
                                              Provider(
                                                create: (context) => token,
                                              ),
                                            ],
                                            child: TopVideoVidget(
                                              url: video.videoLink,
                                              title: video.title,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  onTapImage: () {
                                    final VideoDetails video = snapshot
                                        .data!
                                        .videoListData
                                        .list[value.getIndex]
                                        .data
                                        .list[index];
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Scaffold(
                                          backgroundColor: Colors.transparent,
                                          body: MultiProvider(
                                            providers: [
                                              Provider(
                                                create: (context) => index,
                                              ),
                                              Provider(
                                                create: (context) => token,
                                              ),
                                            ],
                                            child: TopVideoVidget(
                                              url: video.videoLink,
                                              title: video.title,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                    ],
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.height / 2) - 135),
                      child: Lottie.asset(
                        'assets/pre.json',
                        height: 70,
                        width: 70,
                      ),
                    ),
                  );
                }
              }),
        );
      }),
    );
  }
}
