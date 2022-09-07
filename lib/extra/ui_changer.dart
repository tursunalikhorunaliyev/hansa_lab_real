import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hansa_lab/blocs/bloc_play_video.dart';
import 'package:hansa_lab/blocs/bloc_video_controll.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/middle_part_widgets/prezent_otkrit.dart';
import 'package:hansa_lab/middle_part_widgets/welcome_widget.dart';
import 'package:hansa_lab/middle_part_widgets/katalogi.dart';
import 'package:hansa_lab/middle_part_widgets/o_kompanii.dart';
import 'package:hansa_lab/middle_part_widgets/o_kompaniya.dart';
import 'package:hansa_lab/middle_part_widgets/obucheniya_widget.dart';
import 'package:hansa_lab/middle_part_widgets/present_and_achive.dart';
import 'package:hansa_lab/middle_part_widgets/stati.dart';
import 'package:hansa_lab/middle_part_widgets/treningi.dart';
import 'package:hansa_lab/middle_part_widgets/treningi_video.dart';
import 'package:hansa_lab/middle_part_widgets/video.dart';
import 'package:hansa_lab/screens/article_screen.dart';
import 'package:hansa_lab/screens/article_screen_tab.dart';
import 'package:hansa_lab/screens/read_stati.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class UIChanger extends StatefulWidget {
  const UIChanger({Key? key}) : super(key: key);

  @override
  State<UIChanger> createState() => _UIChangerState();
}

class _UIChangerState extends State<UIChanger> {
  bool? netCheck;

  Future<bool> checkNet() async {
    try {
      final response = await InternetAddress.lookup('www.example.com');

      if (response.isNotEmpty) {
        setState(() {
          netCheck = true;
        });
      }
    } catch (xatoyuuu) {
      setState(() {
        netCheck = false;
      });
      if (kDebugMode) {
        print(xatoyuuu);
      }
    }
    return netCheck!;
  }

  @override
  void initState() {
    checkNet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuEventsBloC>(context);
    final videoControlProvider = Provider.of<BlocVideoControll>(context);
    final playProvider = Provider.of<BlocPlayVideo>(context);
    final isTablet = Provider.of<bool>(context);

    return StreamBuilder<bool>(
      initialData: false,
      stream: checkNet().asStream(),
      builder: (context, snapshot) {
        if (snapshot.data!) {
          return StreamBuilder<MenuActions>(
            stream: provider.eventStream,
            initialData: MenuActions.welcome,
            builder: (context, snapshot) {
              if (snapshot.data != MenuActions.video) {
                videoControlProvider.sink.add(false);
                playProvider.sink.add([false, "", ""]);
              }
              if (snapshot.data == MenuActions.article) {
                return isTablet
                    ? const ArticleScreenTab()
                    : const ArticleScreen();
              } else if (snapshot.data == MenuActions.welcome) {
                return const WelcomeWidget();
              } else if (snapshot.data == MenuActions.obuchayushieMaterial) {
                return const ObucheniyaWidget();
              } else if (snapshot.data == MenuActions.prezintatsiya) {
                return const PrezentOtkrit();
              } else if (snapshot.data == MenuActions.trening) {
                return const Treningi();
              } else if (snapshot.data == MenuActions.stati) {
                return const Stati();
              } else if (snapshot.data == MenuActions.katalog) {
                return const Katalogi();
              } else if (snapshot.data == MenuActions.video) {
                return const Video();
              } else if (snapshot.data == MenuActions.oProyekt) {
                return const Okompaniya();
              } else if (snapshot.data == MenuActions.presentAndArchive) {
                return const PresentArchive();
              } else if (snapshot.data == MenuActions.chitatStati) {
                return const ReadStati();
              } else if (snapshot.data == MenuActions.trainingVideo) {
                return const TreningiVideo();
              } else if (snapshot.data == MenuActions.oKompanii) {
                return const OKompanii();
              } else if (snapshot.data == MenuActions.prezentFav) {
                return const PresentArchive();
              } else {
                return const SizedBox();
              }
            },
          );
        } else {
          return Center(
              child: Lottie.asset(
            'assets/71559-no-internet.json',
            height: 450,
          ));
        }
      },
    );
  }
}
