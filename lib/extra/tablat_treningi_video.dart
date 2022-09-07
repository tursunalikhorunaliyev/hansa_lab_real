import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/treningi_video_model.dart';
import 'package:hansa_lab/api_services/treningi_video_api.dart';
import 'package:hansa_lab/providers/treningi_videos_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class TablettreningiVideo extends StatefulWidget {
  const TablettreningiVideo({Key? key}) : super(key: key);

  @override
  State<TablettreningiVideo> createState() => TablettreningiVideoState();
}

class TablettreningiVideoState extends State<TablettreningiVideo> {
  @override
  Widget build(BuildContext context) {
    final token = Provider.of<String>(context);
    final treningiVideos = Provider.of<TreningiVideosProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: SizedBox(
        height: 325,
        width: 345,
        child: FutureBuilder<TreningiVideoModel>(
            future:
                TreningiVideoApi.getTreningiVideo(treningiVideos.getUrl, token),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                              controller: ChewieController(
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
                                cupertinoProgressColors: ChewieProgressColors(
                                  backgroundColor: const Color(0xff090909),
                                  bufferedColor: const Color(0xff090909),
                                  playedColor:
                                      const Color.fromARGB(255, 213, 0, 50),
                                  handleColor:
                                      const Color.fromARGB(255, 213, 0, 50),
                                ),
                                materialProgressColors: ChewieProgressColors(
                                  backgroundColor: const Color(0xff090909),
                                  bufferedColor: const Color(0xff090909),
                                  playedColor:
                                      const Color.fromARGB(255, 213, 0, 50),
                                  handleColor:
                                      const Color.fromARGB(255, 213, 0, 50),
                                ),
                                videoPlayerController:
                                    VideoPlayerController.network(
                                  snapshot.data!.data.data.data.first.videoLink,
                                ),
                              ),
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
                            width: 325,
                            color: const Color(0xffffffff),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    "Иммерсивное шоу\n\"Увидимся на кухне\"г.\nЕкатеринбург:     18.04.2019",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(64),
                                      child: Container(
                                        height: 25,
                                        width: 95,
                                        color: const Color.fromARGB(
                                            255, 213, 0, 50),
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
                      top: 197,
                      right: 40,
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
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}
