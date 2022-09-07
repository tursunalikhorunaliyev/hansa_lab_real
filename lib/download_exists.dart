import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ExistsCheck extends StatefulWidget {
  const ExistsCheck({Key? key}) : super(key: key);

  @override
  State<ExistsCheck> createState() => _ExistsCheckState();
}

class DownLoad {
  final controller = StreamController<double>();
  Stream<double> get stream => controller.stream;
  StreamSink<double> get sink => controller.sink;
}

class _ExistsCheckState extends State<ExistsCheck> {
  final bloc = DownLoad();
  bool downloading = false;
  double progress = 0;
  bool isDownloaded = false;

  Future<String> getFilePath(uniqueFileName) async {
    String path = "";
    String dir = "";
    if (Platform.isIOS) {
      Directory directory = await getApplicationSupportDirectory();
      dir = directory.path;
    } else if (Platform.isAndroid) {
      dir = "/storage/emulated/0/Download/";
    }
    path = "$dir/$uniqueFileName";
    return path;
  }

  Future<bool> downloadFile(
      String url, String fileName, DownLoad downloadProgressFileBloc) async {
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
          downloadProgressFileBloc.sink.add(progress);
        },
        deleteOnError: true,
      );

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<double>(
            stream: bloc.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                log(snapshot.data.toString());
                return Text(snapshot.data.toString());
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
              onPressed: () {
                downloadFile(
                        "https://hansa-lab.ru/storage/upload/videos/ZnaJMRQsLcXP.mp4",
                        "video",
                        bloc)
                    .then((value) {});
              },
              child: const Text("Download"))
        ],
      ),
    );
  }
}
