import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/treningi_video_model.dart';
import 'package:hansa_lab/api_services/treningi_video_api.dart';

import 'package:hansa_lab/providers/treningi_videos_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CustomTreningiVideoPlay extends StatefulWidget {
  final ChewieController chewieController;
  const CustomTreningiVideoPlay({Key? key, required this.chewieController})
      : super(key: key);

  @override
  State<CustomTreningiVideoPlay> createState() =>
      _CustomTreningiVideoPlayState();
}

class _CustomTreningiVideoPlayState extends State<CustomTreningiVideoPlay> {
  @override
  void dispose() {
    widget.chewieController.dispose();
    widget.chewieController.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final treningiVideos = Provider.of<TreningiVideosProvider>(context);
    final token = Provider.of<String>(context);
    ChewieController ch = widget.chewieController;

    setState(() {});
    return Padding(
      padding: const EdgeInsets.only(bottom: 11, left: 25, right: 25),
      child: SizedBox(
        width: double.infinity,
        child: FutureBuilder<TreningiVideoModel>(
          future:
              TreningiVideoApi.getTreningiVideo(treningiVideos.getUrl, token),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ch = ChewieController(
                autoPlay: true,
                allowedScreenSleep: false,
                aspectRatio: 16 / 9,
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
                useRootNavigator: true,
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
                videoPlayerController: VideoPlayerController.network(
                  snapshot.data!.data.data.data[0].videoLink,
                ),
              );
              return Stack(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: Chewie(
                            controller: ch,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 90,
                          width: double.infinity,
                          color: const Color(0xffffffff),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, bottom: 8),
                                child: SizedBox(
                                  width: isTablet ? 550 : 150,
                                  child: Text(
                                    snapshot.data!.data.data.data[0].title,
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(64),
                                    child: Container(
                                      height: 25,
                                      width: 95,
                                      color:
                                          const Color.fromARGB(255, 213, 0, 50),
                                      child: Center(
                                        child: Text(
                                          "Скачать",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 10,
                                            color: const Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 500,
                    right: 110,
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: const BoxDecoration(
                        color: Color(0xfff1f1f1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 213, 0, 50),
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox(
                child: Center(
                  child: Lottie.asset(
                    'assets/pre.json',
                    height: 70,
                    width: 70,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
