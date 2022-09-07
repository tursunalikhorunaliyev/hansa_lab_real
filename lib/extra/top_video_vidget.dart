import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hansa_lab/blocs/bloc_detect_tap.dart';
import 'package:hansa_lab/blocs/download_progress_bloc.dart';
import 'package:hansa_lab/classes/send_analise_download.dart';
import 'package:hansa_lab/extra/custom_black_appbar.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_index_provider.dart';
import 'package:hansa_lab/training_section/custom_treningi_video.dart';
import 'package:hansa_lab/video/bloc_video_api.dart';
import 'package:hansa_lab/video/model_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class TopVideoVidget extends StatefulWidget {
  final String url;
  final String title;

  const TopVideoVidget({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<TopVideoVidget> createState() => _TopVideoVidgetState();
}

class _TopVideoVidgetState extends State<TopVideoVidget> {
  ChewieController chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(''));
  initVideo() {
    chewieController = ChewieController(
      aspectRatio: 16 / 9,
      autoPlay: true,
      allowedScreenSleep: false,
      autoInitialize: true,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ],
      allowMuting: false,
      videoPlayerController: VideoPlayerController.network(widget.url),
      cupertinoProgressColors: ChewieProgressColors(
        backgroundColor: const Color(0xff090909),
        bufferedColor: const Color(0xff090909),
        playedColor: const Color.fromARGB(255, 213, 0, 50),
        handleColor: const Color.fromARGB(255, 213, 0, 50),
      ),
      materialProgressColors: ChewieProgressColors(
        backgroundColor: const Color(0xff090909),
        bufferedColor: const Color(0xff090909),
        playedColor: const Color.fromARGB(255, 213, 0, 50),
        handleColor: const Color.fromARGB(255, 213, 0, 50),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  void dispose() {
    chewieController.dispose();
    chewieController.videoPlayerController.dispose();
    super.dispose();
  }

  final blocVideoApi = BlocVideoApi();
  final blocDetectTap = BlocDetectTap();
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
      log("exists");
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
            log("tugadi");
          } else {
            log("$progress download progress");
          }
        },
        deleteOnError: true,
      );
      if (progress == 100) {
        log("yuklab olish 100000000");
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerBlocProgress = Provider.of<DownloadProgressFileBloc>(context);
    final token = Provider.of<String>(context);
    final providerIndex = Provider.of<int>(context);
    final isTablet = Provider.of<bool>(context);
    final providerSendAnaliseDownload =
        Provider.of<SendAnaliseDownload>(context);
    return WillPopScope(
      onWillPop: () async {
        chewieController
          ..seekTo(Duration.zero)
          ..pause();
        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.9),
                    Colors.black.withOpacity(.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                chewieController.videoPlayerController
                  ..seekTo(const Duration(seconds: 0))
                  ..pause();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            Column(
              children: [
                Provider<ChewieController>.value(
                    value: chewieController, child: const CustomBlackAppBar()),
                Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: isTablet ? 800 : 355,
                        height: isTablet ? 450 : 200,
                        child: Center(
                          child: Chewie(
                            controller: chewieController,
                          ),
                        ),
                      ),
                    ),
                    Consumer<VideoIndexProvider>(
                      builder: (context, value, child) {
                        return FutureBuilder<VideoMainOne>(
                          future: blocVideoApi.getData(token: token),
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 13),
                              child: Provider(
                                create: (context) => blocDetectTap,
                                child: StreamBuilder<bool>(
                                    stream: blocDetectTap.dataStream,
                                    builder: (context, snapshotDetectTap) {
                                      return StreamBuilder<double>(
                                          stream: providerBlocProgress.stream,
                                          builder: (context, snapshotProgress) {
                                            return CustomTreningiVideo(
                                              onTap: () {
                                                blocDetectTap.dataSink
                                                    .add(true);

                                                if (snapshotProgress.data ==
                                                        null ||
                                                    snapshotProgress.data ==
                                                        0) {
                                                  downloadFile(
                                                    snapshot
                                                        .data!
                                                        .videoListData
                                                        .list[value.getIndex]
                                                        .data
                                                        .list[providerIndex]
                                                        .videoLink,
                                                    snapshot
                                                        .data!
                                                        .videoListData
                                                        .list[value.getIndex]
                                                        .data
                                                        .list[providerIndex]
                                                        .title,
                                                    providerBlocProgress,
                                                  ).then((value) {
                                                    log("$value download status");
                                                    providerSendAnaliseDownload
                                                        .setAnalise(value);
                                                  });
                                                } else {
                                                  log("asdffffffffffff=----------------------------------------");
                                                }
                                              },
                                              title: widget.title,
                                            );
                                          });
                                    }),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
