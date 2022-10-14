import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoFullscreenWidget extends StatefulWidget {
  const VideoFullscreenWidget({super.key});

  @override
  State<VideoFullscreenWidget> createState() => _VideoFullscreenWidgetState();
}

class _VideoFullscreenWidgetState extends State<VideoFullscreenWidget> {
  late ChewieController chewieController;

  @override
  void initState() {
    chewieController = ChewieController(
      autoPlay: true,
      allowedScreenSleep: false,
      autoInitialize: true,
      fullScreenByDefault: true,
      startAt: const Duration(seconds: 25),
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ],
      allowMuting: false,
      videoPlayerController: VideoPlayerController.network(
          'https://hansa-lab.ru/storage/upload/videos/RFQx56MX6ugz.mp4'),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(
        controller: chewieController,
      ),
    );
  }
}
