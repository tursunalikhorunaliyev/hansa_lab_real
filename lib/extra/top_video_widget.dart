import 'dart:developer';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/bloc_detect_tap.dart';
import 'package:hansa_lab/blocs/download_progress_bloc.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/classes/send_analise_download.dart';
import 'package:hansa_lab/extra/black_custom_title.dart';
import 'package:hansa_lab/extra/custom_black_appbar.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_index_provider.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_title_provider.dart';
import 'package:hansa_lab/training_section/custom_treningi_video.dart';
import 'package:hansa_lab/video/bloc_video_api.dart';
import 'package:hansa_lab/video/model_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class TopVideoWidget extends StatefulWidget {
  final String url;
  final String title;
  final int selectedIndex;
  final String selectedTitle;

  const TopVideoWidget(
      {Key? key,
      required this.url,
      required this.title,
      required this.selectedIndex,
      required this.selectedTitle})
      : super(key: key);

  @override
  State<TopVideoWidget> createState() => _TopVideoWidgetState();
}

class _TopVideoWidgetState extends State<TopVideoWidget> {
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

  final blocDetectTap = BlocDetectTap();
  final blocVideoApi = BlocVideoApi();

  bool downloading = false;
  double progress = 0;
  bool isDownloaded = false;

  Future<String> getFilePath(uniqueFileName) async {
    String path = "";
    String dir = "";
    if (Platform.isIOS) {
      Directory directory = await getApplicationSupportDirectory();
      dir = directory.path;
      log("${dir}kkkkkkkkkkkkk");
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
            log("Download complate");
          } else {
            log("$progress %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
          }
        },
        deleteOnError: true,
      );

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final menuEventsBloCProvider = Provider.of<MenuEventsBloC>(context);
    final title = Provider.of<VideoTitleProvider>(context);
    final index = Provider.of<VideoIndexProvider>(context);
    final providerBlocProgress = Provider.of<DownloadProgressFileBloc>(context);
    final token = Provider.of<String>(context);
    final providerSendAnaliseDownload =
        Provider.of<SendAnaliseDownload>(context);
    return SafeArea(
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
              reset();
              Navigator.pop(context);
            },
          ),
          Column(
            children: [
              Column(
                children: [
                  Provider<ChewieController>.value(
                      value: chewieController,
                      child: const CustomBlackAppBar()),
                  Row(
                    children: const [
                      BlackCustomTitle(
                        imagePath: "assets/video_title.png",
                        title: "Видео",
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: isTablet ? 800 : 355,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PhysicalModel(
                              shadowColor: Colors.grey.withOpacity(.5),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(64),
                              elevation: 5,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  reset();
                                  menuEventsBloCProvider.eventSink
                                      .add(MenuActions.oKompanii);
                                  title.changeTitle(widget.selectedTitle);
                                  index.changeIndex(widget.selectedIndex);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(64),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    constraints: BoxConstraints(
                                      minWidth: isTablet ? 150 : 90,
                                    ),
                                    color:
                                        const Color.fromARGB(255, 213, 0, 50),
                                    child: Center(
                                      child: Text(
                                        "Открыть раздел",
                                        style: GoogleFonts.montserrat(
                                          color: const Color(0xffffffff),
                                          fontSize: isTablet ? 14 : 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 13,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Consumer<VideoIndexProvider>(
                      builder: (context, value, child) {
                        return FutureBuilder<VideoMainOne>(
                          future: blocVideoApi.getData(token: token),
                          builder: (context, snapshot) {
                            return Provider(
                              create: (context) => blocDetectTap,
                              child: StreamBuilder<double>(
                                  stream: providerBlocProgress.stream,
                                  builder: (context, snapshotProgress) {
                                    return CustomTreningiVideo(
                                      onTap: () {
                                        blocDetectTap.dataSink.add(true);
                                        if (snapshotProgress.data == null ||
                                            snapshotProgress.data == 0) {
                                          downloadFile(
                                            snapshot
                                                .data!
                                                .videoListData
                                                .list[value.getIndex]
                                                .data
                                                .list[widget.selectedIndex]
                                                .videoLink,
                                            snapshot
                                                .data!
                                                .videoListData
                                                .list[value.getIndex]
                                                .data
                                                .list[widget.selectedIndex]
                                                .title,
                                            providerBlocProgress,
                                          ).then((v) {
                                            log("Not download");
                                            if (Platform.isIOS) {
                                              GallerySaver.saveVideo(snapshot
                                                  .data!
                                                  .videoListData
                                                  .list[value.getIndex]
                                                  .data
                                                  .list[widget.selectedIndex]
                                                  .videoLink);
                                            }
                                          });
                                        } else {
                                          log("asdffffffffffff=----------------------------------------");
                                        }
                                      },
                                      title: widget.title,
                                    );
                                  }),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  reset() {
    chewieController.videoPlayerController
      ..seekTo(const Duration(seconds: 0))
      ..pause();
    setState(() {});
  }
}
