import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/article_model.dart';
import 'package:hansa_lab/api_models.dart/welcome_model.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:hansa_lab/blocs/article_bloc.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/extra/event_cards.dart';
import 'package:hansa_lab/extra/my_behavior%20.dart';
import 'package:hansa_lab/stacked_stack.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  ChewieController chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(""),
      aspectRatio: 13.6 / 7.2,
      autoPlay: false)
    ..setVolume(0);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    chewieController.dispose();
    chewieController.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int snapshotCount = 0;
    final scroll = ScrollController();
    final isTablet = Provider.of<bool>(context);
    final token = Provider.of<String>(context);
    final providerWelcomeApi = Provider.of<WelcomeApi>(context);
    providerWelcomeApi.eventSink.add(WelcomeApiAction.fetch);
    final articleBLoC = Provider.of<ArticleBLoC>(context);
    final menuProvider = Provider.of<MenuEventsBloC>(context);

    return Expanded(
      child: StreamBuilder<List<WelcomeModelData>>(
          stream: providerWelcomeApi.dataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.requireData;
              final videoLink = providerWelcomeApi.getVideoLink;
              if (snapshotCount == 0 && isTablet) {
                chewieController = ChewieController(
                    videoPlayerController:
                        VideoPlayerController.network(videoLink),
                    aspectRatio: 13.6 / 7.2,
                    autoPlay: true)
                  ..setVolume(0);
                snapshotCount = 1;
              }

              return isTablet
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: SizedBox(
                                    height: 450,
                                    child: Chewie(controller: chewieController),
                                  ),
                                ),
                              ),
                              GridView(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisExtent: 375,
                                ),
                                children: List.generate(
                                    data.length,
                                    (index) => StackedStack(
                                          imageOnTap: () async {
                                            menuProvider.eventSink
                                                .add(MenuActions.article);
                                            ArticleModel statiModel =
                                                await articleBLoC.getArticle(
                                                    token,
                                                    snapshot.data![index].link);
                                            articleBLoC.sink.add(statiModel);
                                          },
                                          isFavouriteURL: snapshot
                                              .data![index].favoriteLink,
                                          onTap: () async {
                                            menuProvider.eventSink
                                                .add(MenuActions.article);
                                            ArticleModel statiModel =
                                                await articleBLoC.getArticle(
                                                    token,
                                                    snapshot.data![index].link);
                                            articleBLoC.sink.add(statiModel);
                                          },
                                          buttonColor: const Color.fromARGB(
                                              255, 213, 0, 50),
                                          buttonText: 'Смотреть',
                                          isDate: true,
                                          month: toDateString(snapshot
                                              .data![index].date
                                              .substring(5, 7)),
                                          day: snapshot.data![index].date
                                              .substring(8, 10),
                                          title: data[index].title,
                                          url: data[index].pictureLink,
                                          isFavourite: data[index].isFavorite,
                                        )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    providerWelcomeApi.eventSink
                                        .add(WelcomeApiAction.fetch);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: isTablet ? 100 : 120,
                                    height: isTablet ? 28 : 30,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Text(
                                      "показать ещё",
                                      style: GoogleFonts.montserrat(
                                          fontSize: isTablet ? 12 : 10,
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      controller: scroll,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Column(
                            children: List.generate(data.length, (index) {
                              return EventCards(
                                index: index,
                                imageOnTap: () async {
                                  menuProvider.eventSink
                                      .add(MenuActions.article);
                                  ArticleModel statiModel =
                                      await articleBLoC.getArticle(
                                          token, snapshot.data![index].link);
                                  articleBLoC.sink.add(statiModel);
                                },
                                isFavouriteURL:
                                    snapshot.data![index].favoriteLink,
                                onTap: () async {
                                  menuProvider.eventSink
                                      .add(MenuActions.article);
                                  ArticleModel statiModel =
                                      await articleBLoC.getArticle(
                                          token, snapshot.data![index].link);
                                  articleBLoC.sink.add(statiModel);
                                },
                                buttonColor:
                                    const Color.fromARGB(255, 213, 0, 50),
                                buttonText: 'Смотреть',
                                isDate: true,
                                month: toDateString(
                                    snapshot.data![index].date.substring(5, 7)),
                                day:
                                    snapshot.data![index].date.substring(8, 10),
                                title: data[index].title,
                                url: data[index].pictureLink,
                                isFavourite: data[index].isFavorite,
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                providerWelcomeApi.eventSink
                                    .add(WelcomeApiAction.fetch);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: isTablet ? 100 : 120,
                                height: isTablet ? 28 : 30,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(13)),
                                child: Text(
                                  "показать ещё",
                                  style: GoogleFonts.montserrat(
                                      fontSize: isTablet ? 12 : 10,
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            } else {
              providerWelcomeApi.eventSink.add(WelcomeApiAction.fetch);
              return Center(
                  child: Lottie.asset(
                'assets/pre.json',
                height: 70,
                width: 70,
              ));
            }
          }),
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
}
