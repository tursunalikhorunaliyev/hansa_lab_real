/* import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hansa_lab/middle_part_widgets/treningi_video.dart';
import 'package:hansa_lab/providers/check_click.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ChewieFFFI extends StatefulWidget {
  final bool isTablet;
  final String videoLink;
  const ChewieFFFI(
      {super.key, required this.isTablet, required this.videoLink});

  @override
  State<ChewieFFFI> createState() => _ChewieFFFIState();
}

class _ChewieFFFIState extends State<ChewieFFFI> {
  ChewieController chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(""));
  @override
  void initState() {
    log("inin");
    chewieController.dispose();
    chewieController.videoPlayerController.dispose();
    chewieController = ChewieController(
      autoPlay: true,
      allowedScreenSleep: false,
      autoInitialize: true,
      allowMuting: false,
      optionsBuilder: (context, chewieOptions) {
        print(chewieOptions.length);
        return Future.value();
      },
      systemOverlaysOnEnterFullScreen: [SystemUiOverlay.top],
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
        widget.videoLink,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.dispose();
    chewieController.videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckClick>(
      builder: (context, value, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: widget.isTablet ? 380 : 235,
            child: Chewie(
              controller: chewieController,
            ),
          ),
        );
      },
    );
  }
}
 */