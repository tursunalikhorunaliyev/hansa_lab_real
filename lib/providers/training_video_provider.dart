import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hansa_lab/api_models.dart/treningi_video_model.dart';
import 'package:hansa_lab/api_services/treningi_video_api.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class TrainingVideoProvider extends ChangeNotifier {
  TreningiVideoModel? treningiVideoModel;
  TreningiVideoModel get getTreningiVideoModel => treningiVideoModel!;
  Widget chewieWidget = const SizedBox();
  Widget get getChewieWidget => chewieWidget;

  ChewieController videoInitialize(String link) {
    return ChewieController(
      autoPlay: true,
      allowedScreenSleep: false,
      autoInitialize: true,
      allowMuting: false,
      optionsBuilder: (context, chewieOptions) {
        return Future.value();
      },
      systemOverlaysAfterFullScreen: [SystemUiOverlay.top],
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
  }

  getVideoDetails(String url, String token, bool isTablet) async {
    await TreningiVideoApi.getTreningiVideo(url, token)
        .then((value) => treningiVideoModel = value);
    final chVideo =
        videoInitialize(treningiVideoModel!.data.data.data.first.videoLink);
    if (chVideo.videoPlayerController.value.size.aspectRatio > 0.0) {
      chewieWidget = SizedBox(
        width: isTablet ? 800 : 355,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(
            controller: chVideo,
          ),
        ),
      );
    } else {
      chewieWidget = Lottie.asset(
        'assets/pre.json',
        height: 70,
        width: 70,
      );
    }
    notifyListeners();
  }
}
