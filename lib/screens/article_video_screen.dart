import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/download_progress_bloc.dart';
import 'package:hansa_lab/extra/custom_okompanii_item.dart';
import 'package:hansa_lab/extra/custom_title.dart';
import 'package:hansa_lab/extra/top_video_vidget.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_index_provider.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_title_provider.dart';
import 'package:hansa_lab/video/bloc_video_api.dart';
import 'package:hansa_lab/video/model_video.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/providers_for_video_title/article_video_Provider.dart';
import '../video/article_video_api.dart';
import '../video/article_video_model.dart';

class ArticleVideoScreen extends StatefulWidget {
  const ArticleVideoScreen({Key? key}) : super(key: key);

  @override
  State<ArticleVideoScreen> createState() => _ArticleVideoScreenState();
}

class _ArticleVideoScreenState extends State<ArticleVideoScreen> {
  final blocDownload = DownloadProgressFileBloc();

  bool downloading = false;
  double progress = 0;
  bool isDownloaded = false;
  String path = "";
  String dir = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final token = Provider.of<String>(context);
    final scroll = ScrollController();
    final blocVideoApi = ArticleVideoApi();
    bool hasVideo = false;
    double progress = 0;

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

    Future<bool> downloadFile(String url, String fileName) async {
      progress = 0;

      String savePath = await getFilePath(fileName);
      if (await File(savePath).exists()) {
        log("exists");
        setState(() {});
        hasVideo = true;
        return false;
      } else {
        progress = 0;
        Dio dio = Dio();
        dio.download(
          url,
          savePath,
          onReceiveProgress: (recieved, total) {
            progress =
                double.parse(((recieved / total) * 100).toStringAsFixed(0));
            blocDownload.streamSink.add(progress);
            if (progress == 100) {
              // log("Download complate");
            } else {
              // log("$progress %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
            }
          },
          deleteOnError: true,
        );
        return true;
      }
    }

    return Consumer<ArticleTitleProvider>(builder: (context, value, child) {
      return FutureBuilder<ArticleVideoModel>(
          future: blocVideoApi.getData(token: token, videoName: value.title),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height / 2) - 135),
                  child: Lottie.asset(
                    'assets/pre.json',
                    height: 70,
                    width: 70,
                  ),
                ),
              );
            }
            return Center(
              child: SizedBox(), // You can use a different widget here
            );
          });
    });
  }
}
