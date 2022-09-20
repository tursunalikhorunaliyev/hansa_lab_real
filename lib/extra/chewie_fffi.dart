import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ChewieFFFI extends StatefulWidget {
  final bool isTablet;
  final String videoLink;
  final ChewieController chewieController;
  const ChewieFFFI(
      {super.key,
      required this.isTablet,
      required this.videoLink,
      required this.chewieController});

  @override
  State<ChewieFFFI> createState() => _ChewieFFFIState();
}

class _ChewieFFFIState extends State<ChewieFFFI> {
  late ChewieController chewieController;
  @override
  void initState() {
    chewieController = widget.chewieController;
    chewieController.dispose();
    chewieController.videoPlayerController.dispose();
    chewieController = ChewieController(
      autoPlay: true,
      allowedScreenSleep: false,
      autoInitialize: true,
      allowMuting: false,
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
    chewieController.videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
         ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: widget.isTablet ? 380 : 235,
            child: Chewie(
              controller: chewieController,
            ),
          ),
        );
    
  }
}
