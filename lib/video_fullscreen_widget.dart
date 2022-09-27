import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFullscreenWidget extends StatelessWidget {
  final VideoPlayerController? controller;
  const VideoFullscreenWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return (controller != null && controller!.value.isInitialized)
        ? Container(
            alignment: Alignment.topCenter,
            child: buildVideo(),
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget buildVideo() {
    return Stack(
      children: [
        buildVideoPlayer(),
      ],
    );
  }

  Widget buildVideoPlayer() {
    return buildFullScreen(
      child: AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: Chewie(
          controller: ChewieController(
            allowFullScreen: true,
            looping: true,
            videoPlayerController: controller!,
          ),
        ),
      ),
    );
  }

  Widget buildFullScreen({required Widget child}) {
    final size = controller!.value.size;
    final width = size.width;
    final height = size.height;
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
