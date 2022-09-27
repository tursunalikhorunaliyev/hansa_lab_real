import 'package:flutter/material.dart';
import 'package:hansa_lab/video_fullscreen_widget.dart';
import 'package:video_player/video_player.dart';

class VideoFix extends StatefulWidget {
  final String videoLink;
  const VideoFix({super.key, required this.videoLink});

  @override
  State<VideoFix> createState() => _VideoFixState();
}

class _VideoFixState extends State<VideoFix> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.videoLink)
      ..addListener(() {})
      ..setLooping(true)
      ..initialize().then((value) => controller.play());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoFullscreenWidget(controller: controller);
  }
}
