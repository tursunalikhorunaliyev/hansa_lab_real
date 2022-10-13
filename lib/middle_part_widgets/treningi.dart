import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/training_model.dart';
import 'package:hansa_lab/api_services/training_api_bloc.dart';
import 'package:hansa_lab/api_services/treningi_video_api.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/drawer_widgets/izbrannoe.dart';
import 'package:hansa_lab/extra/custom_tablet_item.dart';
import 'package:hansa_lab/extra/custom_treningi_ipad_container.dart';
import 'package:hansa_lab/extra/my_behavior%20.dart';
import 'package:hansa_lab/extra/top_video_vidg.dart';
import 'package:hansa_lab/providers/event_title_provider.dart';
import 'package:hansa_lab/providers/is_video_provider.dart';
import 'package:hansa_lab/providers/treningi_photos_provider.dart';
import 'package:hansa_lab/providers/treningi_videos_provider.dart';
import 'package:hansa_lab/providers/video_ind_provider.dart';
import 'package:hansa_lab/providers/video_tit_provider.dart';
import 'package:hansa_lab/training_section/custom_calendar.dart';
import 'package:hansa_lab/extra/custom_clip_item.dart';
import 'package:hansa_lab/extra/custom_title.dart';
import 'package:hansa_lab/video/model_video.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

class Treningi extends StatefulWidget {
  const Treningi({Key? key}) : super(key: key);

  @override
  State<Treningi> createState() => _TreningiState();
}

class _TreningiState extends State<Treningi> {
  int i = 0;
  @override
  void dispose() {
    super.dispose();
    i = 0;
  }

  @override
  Widget build(BuildContext context) {
    final menuBloCProvider = Provider.of<MenuEventsBloC>(context);
    final isTablet = Provider.of<bool>(context);
    final token = Provider.of<String>(context);
    final treningiPhotos = Provider.of<TreningiPhotosProvider>(context);
    final treningiVideos = Provider.of<TreningiVideosProvider>(context);
    final title = Provider.of<VideoTitProvider>(context);
    final index = Provider.of<VideoIndProvider>(context);
    final isVideo = Provider.of<IsVideoprovider>(context);
    final trainingBloc = TrainingAPIBloc();
    final scroll = ScrollController();
    final eventTitleProvider = Provider.of<EventTitleProvider>(context);
    if (i == 0) {
      trainingBloc.getTrainingData(token).then((value) {
        List list = value.data.futureEvents.list;
        for (var i = 0; i < list.length; i++) {
          (value.data.futureEvents.list[i].checked == true)
              ? eventTitleProvider.addTitles("Отписация")
              : eventTitleProvider.addTitles("Записаться");
        }
      });
      i = 1;
    }
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FutureBuilder<TrainingModel>(
            future: trainingBloc.getTrainingData(token),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.data;
                return Column(
                  children: [
                    Visibility(
                      visible: (snapshot.data!.data.webinar.data.isNotEmpty &&
                          snapshot.data!.data.events.events.isNotEmpty),
                      child: StickyHeader(
                        header: const CustomTitle(
                          imagePath: "assets/treningi_title.png",
                          title: "Тренинги",
                        ),
                        content: Column(
                          children: [
                            Row(),
                            (snapshot.data!.data.webinar.data.isNotEmpty)
                                ? Column(
                                    children: List.generate(
                                      snapshot.data!.data.webinar.data.length,
                                      (index) => Container(
                                        margin: EdgeInsets.only(
                                            left: isTablet ? 53 : 25,
                                            right: isTablet ? 53 : 25,
                                            bottom: 13),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/event-default.png'),
                                                fit: BoxFit.cover)),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 13,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          snapshot
                                                              .data!
                                                              .data
                                                              .webinar
                                                              .data[index]
                                                              .date
                                                              .trim()
                                                              .substring(0, 4),
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      20)),
                                                      const Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            launchInBrowser(Uri
                                                                .parse(snapshot
                                                                    .data!
                                                                    .data
                                                                    .webinar
                                                                    .data[index]
                                                                    .link));
                                                          },
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        64),
                                                            child: Container(
                                                              height: isTablet
                                                                  ? 35
                                                                  : 25,
                                                              width: 170,
                                                              color: const Color(
                                                                  0xff25b049),
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          15),
                                                                  child: Text(
                                                                    'Зарегистрироваться',
                                                                    style: GoogleFonts.montserrat(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize: isTablet
                                                                            ? 12
                                                                            : 8,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "${snapshot.data!.data.webinar.data[index].date.trim().substring(8, 10)} - ${toDateString(snapshot.data!.data.webinar.data[index].date.trim().substring(5, 7))}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      snapshot
                                                          .data!
                                                          .data
                                                          .webinar
                                                          .data[index]
                                                          .name
                                                          .trim(),
                                                      softWrap: true,
                                                      overflow: TextOverflow
                                                          .clip,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              fontSize: 24)),
                                                  const SizedBox(
                                                    height: 50,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            (snapshot.data!.data.events.events.isNotEmpty)
                                ? CustomCalendar(
                                    dates: snapshot.data!.data.events.events)
                                : const SizedBox(),
                            (snapshot.data!.data.futureEvents.list.isNotEmpty)
                                ? Consumer<EventTitleProvider>(
                                    builder: (context, value, child) {
                                      return Column(
                                        children: List.generate(
                                            snapshot.data!.data.futureEvents
                                                .list.length, (index) {
                                          return isTablet
                                              ? IpadContainer(
                                                  title: snapshot
                                                      .data!
                                                      .data
                                                      .futureEvents
                                                      .list[index]
                                                      .title,
                                                  buttonColor: (value.getTitles[
                                                              index] ==
                                                          "Записаться")
                                                      ? const Color(0xff25b049)
                                                      : const Color(0xFF232323),
                                                  titleColor:
                                                      const Color(0xffffffff),
                                                  buttonText:
                                                      value.getTitles[index],
                                                  buttonTextColor:
                                                      const Color(0xffffffff),
                                                  onTap: () {
                                                    if (value
                                                            .getTitles[index] ==
                                                        "Записаться") {
                                                      value.changeTitles(
                                                          "Отписация", index);
                                                    } else {
                                                      value.changeTitles(
                                                          "Записаться", index);
                                                    }
                                                    postChecked(
                                                        token,
                                                        snapshot
                                                            .data!
                                                            .data
                                                            .futureEvents
                                                            .list[index]
                                                            .link);
                                                  },
                                                )
                                              : CustomClipItem(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 213, 0, 50),
                                                  buttonColor: (value.getTitles[
                                                              index] ==
                                                          "Записаться")
                                                      ? const Color(0xff25b049)
                                                      : const Color(0xFF232323),
                                                  buttonTextColor:
                                                      const Color(0xffffffff),
                                                  titleColor:
                                                      const Color(0xffffffff),
                                                  buttonText:
                                                      value.getTitles[index],
                                                  title: snapshot
                                                      .data!
                                                      .data
                                                      .futureEvents
                                                      .list[index]
                                                      .title,
                                                  onTap: () {
                                                    if (value
                                                            .getTitles[index] ==
                                                        "Записаться") {
                                                      value.changeTitles(
                                                          "Отписаться", index);
                                                    } else {
                                                      value.changeTitles(
                                                          "Записаться", index);
                                                    }
                                                    postChecked(
                                                        token,
                                                        snapshot
                                                            .data!
                                                            .data
                                                            .futureEvents
                                                            .list[index]
                                                            .link);
                                                  },
                                                );
                                        }),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    StickyHeader(
                      header: const CustomTitle(
                        imagePath: "assets/kak_title.png",
                        title: "Как это было",
                      ),
                      content: Builder(builder: (context) {
                        if (isTablet) {
                          return ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Column(
                                    children: [
                                      GridView(
                                        controller: scroll,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 30,
                                                childAspectRatio: 3.4),
                                        children: List.generate(
                                            snapshot.data!.data.videos.list
                                                .length, (index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: TabletItemTreningi(
                                              backgroundColor:
                                                  const Color(0xff000004),
                                              buttonColor: const Color.fromARGB(
                                                  255, 213, 0, 50),
                                              buttonTextColor:
                                                  const Color(0xffffffff),
                                              titleColor:
                                                  const Color(0xffffffff),
                                              buttonText: "Смотреть",
                                              title:
                                                  data.videos.list[index].title,
                                              onTap: () {
                                                /* treningiVideos.setUrl(snapshot
                                                    .data!
                                                    .data
                                                    .videos
                                                    .list[index]
                                                    .link);
                                                isVideo.setIsVideo(true);
                                                menuBloCProvider.eventSink.add(
                                                    MenuActions.trainingVideo); */
                                                final video = snapshot.data!
                                                    .data.videos.list[index];
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Scaffold(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      body: Provider<
                                                          String>.value(
                                                        value: token,
                                                        child: TopVideoWidg(
                                                          url: video.link,
                                                          title: video.title,
                                                          selectedIndex: index,
                                                          selectedTitle:
                                                              video.title,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        }),
                                      ),
                                      GridView(
                                        controller: scroll,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 30,
                                                childAspectRatio: 3.4),
                                        children: List.generate(
                                            snapshot.data!.data.eventReports
                                                .list.length, (index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: TabletItemTreningi(
                                              backgroundColor:
                                                  const Color(0xff000004),
                                              buttonColor: const Color.fromARGB(
                                                  255, 213, 0, 50),
                                              buttonTextColor:
                                                  const Color(0xffffffff),
                                              titleColor:
                                                  const Color(0xffffffff),
                                              buttonText: "Смотреть",
                                              title: data.eventReports
                                                  .list[index].title,
                                              onTap: () {
                                                treningiPhotos.setUrl(snapshot
                                                    .data!
                                                    .data
                                                    .eventReports
                                                    .list[index]
                                                    .link);
                                                isVideo.setIsVideo(false);
                                                menuBloCProvider.eventSink.add(
                                                    MenuActions.trainingVideo);
                                              },
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  )));
                        } else {
                          return Column(
                            children: [
                              Column(
                                children: List.generate(
                                  data.videos.list.length,
                                  (index) {
                                    return CustomClipItem(
                                      backgroundColor: const Color(0xff000004),
                                      buttonColor:
                                          const Color.fromARGB(255, 213, 0, 50),
                                      buttonTextColor: const Color(0xffffffff),
                                      titleColor: const Color(0xffffffff),
                                      buttonText: "Смотреть",
                                      title: data.videos.list[index].title,
                                      onTap: () async {
                                        /* treningiVideos.setUrl(
                                            data.videos.list[index].link);
                                        isVideo.setIsVideo(true);
                                        menuBloCProvider.eventSink
                                            .add(MenuActions.trainingVideo); */
                                        final video = snapshot
                                            .data!.data.videos.list[index].link;

                                        final data = await TreningiVideoApi
                                            .getTreningiVideo(video, token);

                                        final dat = data.data.data.data.first;

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Scaffold(
                                              backgroundColor:
                                                  Colors.transparent,
                                              body: Provider<String>.value(
                                                value: token,
                                                child: TopVideoWidg(
                                                  url: dat.videoLink,
                                                  title: dat.title,
                                                  selectedIndex: index,
                                                  selectedTitle: dat.title,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Column(
                                children: List.generate(
                                  data.eventReports.list.length,
                                  (index) {
                                    return CustomClipItem(
                                      backgroundColor: const Color(0xff000004),
                                      buttonColor:
                                          const Color.fromARGB(255, 213, 0, 50),
                                      buttonTextColor: const Color(0xffffffff),
                                      titleColor: const Color(0xffffffff),
                                      buttonText: "Смотреть",
                                      title:
                                          data.eventReports.list[index].title,
                                      onTap: () {
                                        treningiPhotos.setUrl(
                                            data.eventReports.list[index].link);
                                        isVideo.setIsVideo(false);
                                        menuBloCProvider.eventSink
                                            .add(MenuActions.trainingVideo);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height / 2) - 135),
                  child: Center(
                    child: Lottie.asset(
                      'assets/pre.json',
                      height: 70,
                      width: 70,
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }

  String toDateString(String m) {
    if (m == "01") {
      return "Январь";
    } else if (m == "02") {
      return "Февраль";
    } else if (m == "03") {
      return "Март";
    } else if (m == "04") {
      return "Апрель";
    } else if (m == "05") {
      return "Май";
    } else if (m == "06") {
      return "Июнь";
    } else if (m == "07") {
      return "Июль";
    } else if (m == "08") {
      return "Август";
    } else if (m == "09") {
      return "Сентябрь";
    } else if (m == "10") {
      return "Октябрь";
    } else if (m == "11") {
      return "Ноябрь";
    } else {
      return "Декабрь";
    }
  }

  postChecked(token, url) async {
    log(token);
    log(url);
    Timer(const Duration(seconds: 3), () async {
      http.Response response = await http.post(
        Uri.parse("https://hansa-lab.ru/$url"),
        headers: {"token": token},
      );
      log(response.body);
    });
  }
}
