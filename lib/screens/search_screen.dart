import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/article_model.dart';
import 'package:hansa_lab/api_models.dart/search_model.dart';
import 'package:hansa_lab/api_services/search_api.dart';
import 'package:hansa_lab/blocs/article_bloc.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/classes/send_link.dart';
import 'package:hansa_lab/extra/top_video_vidget.dart';
import 'package:hansa_lab/video/model_video.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Map<String, dynamic>? globalData;
  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final token = Provider.of<String>(context);
    SearchApi searchApi = SearchApi();
    final articleBLoC = Provider.of<ArticleBLoC>(context);
    final menuProvider = Provider.of<MenuEventsBloC>(context);
    final providerSendLink = Provider.of<SendLink>(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 40, bottom: 10, left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.grey[500],
                      size: isTablet ? 33  : null,
                    ),
                  ),
                ),
                SizedBox(
                  width: isTablet ?   .90.sw : .85.sw,
                  child: TextField(
                    controller: search,
                    autofocus: true,
                    onChanged: (value) {
                      if (value.length > 2) {
                        value = search.text;
                      } else {
                        value = "   ";
                      }
                      setState(() {});
                    },
                    cursorColor: const Color(0xFF272624),
                    cursorHeight: isTablet ? 20 : 14,
                    style: TextStyle(fontSize: isTablet ? 18 : 12),
                    decoration: InputDecoration(
                      isDense: true,
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF272624),
                        ),
                      ),
                      hintText: "Поиск",
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF272624),
                        ),
                      ),
                      suffixIconConstraints:
                          const BoxConstraints(maxHeight: 20),
                      suffixIcon: InkWell(
                        onTap: () async {
                          if (search.text.length > 2) {
                            log("Search button clicked...");
                            setState(() {});
                          }
                        },
                        child: Icon(
                          Icons.search,
                          size: isTablet ? 25 : 20,
                          color: const Color(0xFF272624),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<SearchModel>(
              future: searchApi.getSearchData(token, search.text),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.data.data;
                  log("Length of data ${data.length}");
                  return (search.text.length > 2)
                      ? Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: List.generate(data.length, (index) {
                                return InkWell(
                                  onTap: () async {
                                    if (data[index].type == 1) {
                                      Navigator.pop(context);
                                      menuProvider.eventSink
                                          .add(MenuActions.article);
                                      ArticleModel statiModel =
                                          await articleBLoC.getArticle(
                                              token, data[index].link);
                                      articleBLoC.sink.add(statiModel);
                                    } else if (data[index].type == 3) {
                                      Navigator.pop(context);
                                      providerSendLink
                                          .setLink(data[index].link);
                                      menuProvider.eventSink
                                          .add(MenuActions.chitatStati);
                                    } else if (data[index].type == 4) {
                                      final video = VideoDetails(
                                          title: data[index].title,
                                          pictureLink: data[index].picturelink,
                                          videoLink: data[index].link);
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Scaffold(
                                            backgroundColor: Colors.transparent,
                                            body: MultiProvider(
                                              providers: [
                                                Provider(
                                                  create: (context) => index,
                                                ),
                                                Provider(
                                                  create: (context) => token,
                                                ),
                                              ],
                                              child: TopVideoVidget(
                                                url: video.videoLink,
                                                title: video.title,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
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
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: data[index]
                                                            .picturelink,
                                                        height: isTablet
                                                            ? 110
                                                            : 66.66666666666667,
                                                        width: isTablet
                                                            ? 200
                                                            : 101.6666666666667,
                                                      ),
                                                    ),
                                                    (data[index].type == 4)
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 40,
                                                                    top: 21),
                                                            child: Opacity(
                                                              opacity: .5,
                                                              child: Icon(
                                                                CupertinoIcons
                                                                    .play_circle_fill,
                                                                size: isTablet
                                                                    ? 45
                                                                    : 25,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            isTablet
                                                ? const SizedBox(
                                                    width: 20,
                                                  )
                                                : const SizedBox(),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data[index].title,
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
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height:
                                                            isTablet ? 22 : 21,
                                                        width:
                                                            isTablet ? 74 : 63,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .transparent),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.5),
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                213,
                                                                0,
                                                                50)),
                                                        child: Text(
                                                          "Показать",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
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
                                );
                              }),
                            ),
                          ),
                        )
                      : const Center();
                } else {
                  return const Center();
                }
              }),
        ],
      ),
    );
  }
}
