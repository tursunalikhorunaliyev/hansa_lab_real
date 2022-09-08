import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/article_model.dart';
import 'package:hansa_lab/api_models.dart/izbrannoe_model.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:hansa_lab/blocs/article_bloc.dart';
import 'package:hansa_lab/blocs/bloc_obucheniya.dart';
import 'package:hansa_lab/blocs/favourite_bloc.dart';
import 'package:hansa_lab/blocs/izbrannoe_bloc.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Izbrannoe extends StatefulWidget {
  const Izbrannoe({Key? key}) : super(key: key);

  @override
  State<Izbrannoe> createState() => _IzbrannoeState();
}

class _IzbrannoeState extends State<Izbrannoe> {
  double radius = 0;
  @override
  Widget build(BuildContext context) {
    final scafforlKeyProvider = Provider.of<GlobalKey<ScaffoldState>>(context);
    final isTablet = Provider.of<bool>(context);
    final token = Provider.of<String>(context);
    final articleBLoC = Provider.of<ArticleBLoC>(context);
    final menuProvider = Provider.of<MenuEventsBloC>(context);
    final izbrannoeBLoC = IzbrannoeBLoC();
    final providerWelcomeApi = Provider.of<WelcomeApi>(context);
    final bloc = Provider.of<BlocObucheniya>(context);

    Future<void>? launched;

    final isFavouriteBLoC = FavouriteBLoC();
    return Center(
      child: Container(
        height: isTablet ? 650 : 470,
        width: isTablet ? 500 : 323.6666666666667,
        color: const Color(0xFFffffff),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 17.66666666666667),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 213, 0, 50),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(21),
                            bottomRight: Radius.circular(21))),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 35.33333333333333,
                          right: 13.33333333333333,
                          top: 12.66666666666667,
                          bottom: 12.66666666666667),
                      child: Icon(
                        Icons.favorite,
                        size: 21.66666666666667,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("#",
                      style: GoogleFonts.montserrat(
                          color: const Color.fromARGB(255, 213, 0, 50),
                          fontSize: isTablet ? 18 : 13.66666666666667)),
                  Text("Избранное",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF272624),
                          fontSize: isTablet ? 24 : 19.66666666666667)),
                  //#Избранное
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<IzbrannoeModel>(
                  future: izbrannoeBLoC.getData(token),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            snapshot.data!.data.list.length,
                            (index) => Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                  color: const Color.fromARGB(255, 213, 0, 50)),
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                color: const Color.fromARGB(255, 213, 0, 50),
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              key: UniqueKey(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  if (snapshot.data!.data.list[index].type ==
                                      2) {
                                    isFavouriteBLoC.sink.add(false);
                                    isFavouriteBLoC.getFavourite(token,
                                        snapshot.data!.data.list[index].unlink);
                                    bloc.eventSink
                                        .add(ObucheniyaEnum.obucheniya);
                                  } else {
                                    isFavouriteBLoC.sink.add(false);
                                    providerWelcomeApi.setList(
                                        true,
                                        snapshot.data!.data.list[index].link,
                                        snapshot
                                            .data!.data.list[index].pictureLink,
                                        snapshot.data!.data.list[index].title);
                                    isFavouriteBLoC.getFavourite(token,
                                        snapshot.data!.data.list[index].unlink);
                                    providerWelcomeApi.eventSink
                                        .add([WelcomeApiAction.update, true]);
                                  }

                                  return true;
                                } else {
                                  return false;
                                }
                              },
                              child: InkWell(
                                onTap: () async {
                                  if (snapshot.data!.data.list[index].type ==
                                      1) {
                                    scafforlKeyProvider.currentState!
                                        .closeDrawer();
                                    menuProvider.eventSink
                                        .add(MenuActions.article);

                                    ArticleModel statiModel =
                                        await articleBLoC.getArticle(
                                            token,
                                            snapshot
                                                .data!.data.list[index].link);
                                    articleBLoC.sink.add(statiModel);
                                  } else {
                                    setState(() {
                                      launched = launchInBrowser(Uri.parse(
                                          "http://${snapshot.data!.data.list[index].pdfUrl}"));
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 20),
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: SizedBox(
                                                height: 65,
                                                width: 120,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: snapshot.data!.data
                                                      .list[index].pictureLink,
                                                  height: isTablet
                                                      ? 110
                                                      : 66.66666666666667,
                                                  width: isTablet
                                                      ? 150
                                                      : 101.6666666666667,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 11,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: isTablet ? 240 : 140,
                                                  child: Text(
                                                    snapshot.data!.data
                                                        .list[index].title,
                                                    softWrap: true,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.montserrat(
                                                        color: const Color(
                                                            0xFF272624),
                                                        fontSize: isTablet
                                                            ? 14
                                                            : 9.666666666666667,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          isTablet ? 200 : 90,
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height:
                                                          isTablet ? 22 : 21,
                                                      width: isTablet ? 74 : 63,
                                                      decoration: BoxDecoration(
                                                        border: snapshot
                                                                    .data!
                                                                    .data
                                                                    .list[index]
                                                                    .type ==
                                                                2
                                                            ? Border.all(
                                                                width: 2,
                                                                color: const Color(
                                                                    0xFF313131))
                                                            : Border.all(
                                                                color: Colors
                                                                    .transparent),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.5),
                                                        color: snapshot
                                                                    .data!
                                                                    .data
                                                                    .list[index]
                                                                    .type ==
                                                                2
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF313131),
                                                      ),
                                                      child: Text(
                                                        snapshot
                                                                    .data!
                                                                    .data
                                                                    .list[index]
                                                                    .type ==
                                                                2
                                                            ? "Скачать"
                                                            : "Смотреть",
                                                        style: GoogleFonts.montserrat(
                                                            color: snapshot
                                                                        .data!
                                                                        .data
                                                                        .list[
                                                                            index]
                                                                        .type ==
                                                                    1
                                                                ? const Color(
                                                                    0xFFFFFFFF)
                                                                : const Color(
                                                                    0xFF313131),
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          color: Color(0xFF8c8c8b),
                                          thickness: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          const Spacer(),
                          Lottie.asset(
                            'assets/pre.json',
                            height: 70,
                            width: 70,
                          ),
                          const Spacer()
                        ],
                      );
                    }
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}
