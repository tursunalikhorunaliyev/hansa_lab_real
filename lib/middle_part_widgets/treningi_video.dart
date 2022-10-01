import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/treningi_photos_model.dart';
import 'package:hansa_lab/api_models.dart/treningi_video_model.dart';
import 'package:hansa_lab/api_services/treningi_photos_api.dart';
import 'package:hansa_lab/api_services/treningi_video_api.dart';
import 'package:hansa_lab/blocs/bloc_detect_tap.dart';
import 'package:hansa_lab/blocs/download_progress_bloc.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/classes/send_analise_download.dart';
import 'package:hansa_lab/extra/chewie_fffi.dart';
import 'package:hansa_lab/extra/custom_clip_item.dart';
import 'package:hansa_lab/extra/custom_tablet_stati_item.dart';
import 'package:hansa_lab/extra/custom_title.dart';
import 'package:hansa_lab/providers/is_video_provider.dart';
import 'package:hansa_lab/providers/treningi_photos_provider.dart';
import 'package:hansa_lab/providers/treningi_videos_provider.dart';
import 'package:hansa_lab/training_video_section/custom_tablet_photos.dart';
import 'package:hansa_lab/training_video_section/custom_treningi_photos.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoStream {
  final controller = StreamController<ChewieController>.broadcast();
  Stream<ChewieController> get stream => controller.stream;
  StreamSink<ChewieController> get streamSink => controller.sink;
}

class GetR {
  final String url;
  final String token;
  const GetR({required this.url, required this.token});
}

class GetRStream {
  final controller = StreamController<GetR>();
  StreamSink<GetR> get sink => controller.sink;
  Stream<GetR> get stream => controller.stream;
}

class TreningiVideo extends StatefulWidget {
  const TreningiVideo({Key? key}) : super(key: key);

  @override
  State<TreningiVideo> createState() => _TreningiVideoState();
}

class _TreningiVideoState extends State<TreningiVideo> {
  final scroll = ScrollController();
  final videoStream = VideoStream();
  final getRStream = GetRStream();

  ChewieController chewieController = ChewieController(
    aspectRatio: 16 / 9,
    videoPlayerController: VideoPlayerController.network('',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false)),
  );

  Future<ChewieController> videoInitialize(String link) async {
    chewieController.dispose();
    chewieController.videoPlayerController.dispose();
    chewieController = ChewieController(
      autoPlay: true,
      allowedScreenSleep: false,
      autoInitialize: true,
      allowMuting: false,
      optionsBuilder: (context, chewieOptions) {
        return Future.value();
      },
      useRootNavigator: true,
      cupertinoProgressColors: ChewieProgressColors(
        backgroundColor: const Color(0xff090909),
        bufferedColor: const Color(0xff090909),
        playedColor: const Color.fromARGB(255, 213, 0, 50),
        handleColor: const Color.fromARGB(255, 213, 0, 50),
      ),
      allowFullScreen: true,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ],
      materialProgressColors: ChewieProgressColors(
        backgroundColor: const Color(0xff090909),
        bufferedColor: const Color(0xff090909),
        playedColor: const Color.fromARGB(255, 213, 0, 50),
        handleColor: const Color.fromARGB(255, 213, 0, 50),
      ),
      videoPlayerController: VideoPlayerController.network(
        link,
      ),
    );
    return chewieController;
  }

  @override
  void initState() {
    super.initState();
    getRStream.stream.listen((event) {
      log('${event.token} - ${event.url}');
      TreningiVideoApi.getTreningiVideo(event.url, event.token).then((value) {
        videoTitle = value.data.data.data.first.title;
        videoInitialize(value.data.data.data.first.videoLink).then((value) {
          value.videoPlayerController.addListener(() {
            if (value.videoPlayerController.value.isInitialized) {
              videoStream.streamSink.add(value);
            }
          });
        });
      });
    });
  }

  @override
  void dispose() {
    chewieController.dispose();
    chewieController.videoPlayerController.dispose();
    super.dispose();
  }

  bool downloading = false;
  double progress = 0;
  bool isDownloaded = false;

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

  Future<bool> downloadFile(String url, String fileName,
      DownloadProgressFileBloc downloadProgressFileBloc) async {
    progress = 0;

    String savePath = await getFilePath(fileName);

    if (await File(savePath).exists()) {
      return false;
    } else {
      Dio dio = Dio();
      dio.download(
        url,
        savePath,
        onReceiveProgress: (recieved, total) {
          progress =
              double.parse(((recieved / total) * 100).toStringAsFixed(0));
          downloadProgressFileBloc.streamSink.add(progress);
          if (progress == 100) {
            log("Download success");
          } else {
            log("$progress %%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          }
        },
        deleteOnError: true,
      );

      return true;
    }
  }

  final blocProgress = DownloadProgressFileBloc();
  final blocDetectTap = BlocDetectTap();
  String videoTitle = '';
  String videoLink = "";
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final token = Provider.of<String>(context);
    final treningiPhotos = Provider.of<TreningiPhotosProvider>(context);
    final treningiVideos = Provider.of<TreningiVideosProvider>(context);
    final isVideo = Provider.of<IsVideoprovider>(context);
    final menuBloCProvider = Provider.of<MenuEventsBloC>(context);
    final providerSendAnaliseDownload =
        Provider.of<SendAnaliseDownload>(context);
    getRStream.sink.add(GetR(url: treningiVideos.getUrl, token: token));
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: SingleChildScrollView(
          controller: scroll,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              StickyHeader(
                header: const CustomTitle(
                  imagePath: "assets/treningi_title.png",
                  title: "Тренинги",
                ),
                content: SizedBox(
                  width: double.infinity,
                  child: StreamBuilder<ChewieController>(
                      stream: videoStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final chVideo = snapshot.data!;
                          return Column(
                            children: [
                              Row(),
                              !isVideo.getIsVideo
                                  ? isTablet
                                      ? const TabletPhotosItem()
                                      : const CustomTreningiPhotos()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 11, left: 25, right: 25),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: AspectRatio(
                                              aspectRatio: chVideo
                                                          .videoPlayerController
                                                          .value
                                                          .size
                                                          .aspectRatio !=
                                                      0.0
                                                  ? chVideo
                                                      .videoPlayerController
                                                      .value
                                                      .size
                                                      .aspectRatio
                                                  : 16 / 9,
                                              child: Chewie(
                                                controller: chVideo,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 11,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              height: 75,
                                              width: double.infinity,
                                              color: const Color(0xffffffff),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            top: 10,
                                                            bottom: 8),
                                                    child: SizedBox(
                                                      width:
                                                          isTablet ? 550 : 150,
                                                      child: Text(
                                                        videoTitle,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15),
                                                    child: StreamBuilder<
                                                            double>(
                                                        stream:
                                                            blocProgress.stream,
                                                        builder: (context,
                                                            snapshotProgress) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              blocDetectTap
                                                                  .dataSink
                                                                  .add(true);
                                                              if (snapshotProgress
                                                                          .data ==
                                                                      null ||
                                                                  snapshotProgress
                                                                          .data ==
                                                                      0) {
                                                                downloadFile(
                                                                        videoLink,
                                                                        videoTitle,
                                                                        blocProgress)
                                                                    .then(
                                                                        (value) {
                                                                  providerSendAnaliseDownload
                                                                      .setAnalise(
                                                                          value);
                                                                });
                                                              } else {}
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          64),
                                                              child: Container(
                                                                height: 25,
                                                                width: 95,
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    213,
                                                                    0,
                                                                    50),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Скачать",
                                                                    style: GoogleFonts
                                                                        .montserrat(
                                                                      fontSize:
                                                                          10,
                                                                      color:
                                                                          const Color(
                                                                        0xffffffff,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<bool>(
                                              stream: blocDetectTap.dataStream,
                                              builder:
                                                  (context, snapshotDetectTap) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: AnimatedContainer(
                                                    curve: snapshotDetectTap
                                                                .data ==
                                                            true
                                                        ? Curves.bounceOut
                                                        : Curves.bounceOut,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    width: 355,
                                                    height: snapshotDetectTap
                                                                .data ==
                                                            true
                                                        ? 18
                                                        : 0,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Color(
                                                                0xffffffff),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            )),
                                                    child: AnimatedOpacity(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      opacity: snapshotDetectTap
                                                                  .data ==
                                                              true
                                                          ? 1
                                                          : 0,
                                                      child: providerSendAnaliseDownload
                                                                  .getAnalise ==
                                                              true
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right:
                                                                          15),
                                                              child: StreamBuilder<
                                                                      double>(
                                                                  initialData:
                                                                      0,
                                                                  stream:
                                                                      blocProgress
                                                                          .stream,
                                                                  builder: (context,
                                                                      snapshotDouble) {
                                                                    if (snapshotDouble
                                                                            .data ==
                                                                        100) {
                                                                      blocProgress
                                                                          .streamSink
                                                                          .add(
                                                                              0);
                                                                      blocDetectTap
                                                                          .dataSink
                                                                          .add(
                                                                              false);
                                                                    }
                                                                    return LinearPercentIndicator(
                                                                      alignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              0),
                                                                      barRadius:
                                                                          const Radius.circular(
                                                                              5),
                                                                      lineHeight:
                                                                          6,
                                                                      percent:
                                                                          snapshotDouble.data! /
                                                                              100,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      progressColor:
                                                                          Colors
                                                                              .green,
                                                                    );
                                                                  }),
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "Этот файл уже скачан",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      )),
                            ],
                          );
                        } else {
                          return Lottie.asset(
                            'assets/pre.json',
                            height: 70,
                            width: 70,
                          );
                        }
                      }),
                ),
              ),
              !isVideo.getIsVideo
                  ? StickyHeader(
                      header: const CustomTitle(
                        imagePath: "assets/kak_title.png",
                        title: "Похожие мероприятия",
                      ),
                      content: FutureBuilder<TreningiPhotosModel>(
                        future: TreningiPhotosApi.getdata(
                            treningiPhotos.getUrl, token),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return isTablet
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 11.w),
                                        child: GridView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 10 / 3),
                                          children: List.generate(
                                            snapshot
                                                .data!.data.similar.list.length,
                                            (index) => CustomStatiTabletItem(
                                                onTap: () {
                                                  treningiPhotos.setUrl(snapshot
                                                      .data!
                                                      .data
                                                      .similar
                                                      .list[index]
                                                      .link);
                                                  isVideo.setIsVideo(false);
                                                  scroll.animateTo(
                                                    0,
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.ease,
                                                  );
                                                  setState(() {});
                                                },
                                                backgroundColor:
                                                    const Color(0xff000004),
                                                buttonColor:
                                                    const Color.fromARGB(
                                                        255, 213, 0, 50),
                                                buttonTextColor:
                                                    const Color(0xffffffff),
                                                titleColor:
                                                    const Color(0xffffffff),
                                                buttonText: "Смотреть",
                                                title: snapshot.data!.data
                                                    .similar.list[index].title),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: List.generate(
                                      snapshot.data!.data.similar.list.length,
                                      (index) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomClipItem(
                                              onTap: () {
                                                treningiPhotos.setUrl(snapshot
                                                    .data!
                                                    .data
                                                    .similar
                                                    .list[index]
                                                    .link);
                                                isVideo.setIsVideo(false);
                                                scroll.animateTo(
                                                  0,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                                setState(() {});
                                              },
                                              backgroundColor:
                                                  const Color(0xff000004),
                                              buttonColor: const Color.fromARGB(
                                                  255, 213, 0, 50),
                                              buttonTextColor:
                                                  const Color(0xffffffff),
                                              titleColor:
                                                  const Color(0xffffffff),
                                              buttonText: "Смотреть",
                                              title: snapshot.data!.data.similar
                                                  .list[index].title),
                                        ],
                                      ),
                                    ),
                                  );
                          } else {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                            );
                          }
                        },
                      ),
                    )
                  : StickyHeader(
                      header: const CustomTitle(
                        imagePath: "assets/kak_title.png",
                        title: "Похожие мероприятия",
                      ),
                      content: FutureBuilder<TreningiVideoModel>(
                        future: TreningiVideoApi.getTreningiVideo(
                            treningiVideos.getUrl, token),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return isTablet
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 11.w),
                                        child: GridView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 10 / 3),
                                          children: List.generate(
                                            snapshot
                                                .data!.data.similar.data.length,
                                            (index) => CustomStatiTabletItem(
                                              onTap: () {
                                                treningiVideos.setUrl(
                                                  snapshot.data!.data.similar
                                                      .data[index].link,
                                                );
                                                isVideo.setIsVideo(true);
                                                scroll.animateTo(
                                                  0,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                                setState(() {});
                                                menuBloCProvider.eventSink.add(
                                                    MenuActions.trainingVideo);
                                              },
                                              backgroundColor:
                                                  const Color(0xff000004),
                                              buttonColor: const Color.fromARGB(
                                                  255, 213, 0, 50),
                                              buttonTextColor:
                                                  const Color(0xffffffff),
                                              titleColor:
                                                  const Color(0xffffffff),
                                              buttonText: "Смотреть",
                                              title: snapshot.data!.data.similar
                                                  .data[index].title,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: List.generate(
                                      snapshot.data!.data.similar.data.length,
                                      (index) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomClipItem(
                                            onTap: () {
                                              treningiVideos.setUrl(
                                                snapshot.data!.data.similar
                                                    .data[index].link,
                                              );
                                              isVideo.setIsVideo(true);

                                              scroll.animateTo(
                                                0,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.ease,
                                              );
                                              setState(() {});
                                              menuBloCProvider.eventSink.add(
                                                  MenuActions.trainingVideo);
                                            },
                                            backgroundColor:
                                                const Color(0xff000004),
                                            buttonColor: const Color.fromARGB(
                                                255, 213, 0, 50),
                                            buttonTextColor:
                                                const Color(0xffffffff),
                                            titleColor: const Color(0xffffffff),
                                            buttonText: "Смотреть",
                                            title: snapshot.data!.data.similar
                                                .data[index].title,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          } else {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                            );
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
