import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/article_model.dart';
import 'package:hansa_lab/blocs/article_bloc.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/screens/web_view_video.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../extra/top_video_vidget.dart';
import '../firebase_dynamiclinks.dart';
import '../providers/providers_for_video_title/article_video_Provider.dart';
import '../video/article_video_api.dart';
import '../video/article_video_model.dart';
import 'article_video_screen.dart';
import 'article_video_widget.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = Provider.of<ArticleTitleProvider>(context);
    final blocVideoApi = ArticleVideoApi();
    final munuchangerProvider = Provider.of<MenuEventsBloC>(context);
    final scafforlKeyProvider = Provider.of<GlobalKey<ScaffoldState>>(context);
    final token = Provider.of<String>(context);
    final ScrollController listViewController =
        ScrollController(keepScrollOffset: true);

    double positionDouble = 190.6666666666667;

    final articleBloc = Provider.of<ArticleBLoC>(context);
    return StreamBuilder<ArticleModel>(
      stream: articleBloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.333333333333333),
                            topRight: Radius.circular(5.333333333333333)),
                        child: CachedNetworkImage(
                            imageUrl: snapshot.data!.article.puctureLink)),
                  ],
                ),
                SingleChildScrollView(
                  controller: listViewController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 12.33333333333333,
                    right: 12.33333333333333,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: positionDouble,
                        width: double.infinity,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(3),
                                topRight: Radius.circular(3)),
                            color: const Color(0xFFe9e9e9).withOpacity(.9)),
                        height: 7,
                        width: double.infinity,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.333333333333333),
                                topRight: Radius.circular(5.333333333333333)),
                            color: Color(0xFFffffff)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Align(
                            //   alignment: Alignment.topRight,
                            //   child: GestureDetector(
                            //       onTap: () async {
                            //         final dynamicLink = await DynamicLinkHelper.createDynamicLink('341');
                            //         print('Generated Dynamic Link: $dynamicLink');
                            //         // Now you can share the dynamicLink with users
                            //       },
                            //       child: Image.asset("assets/share.png",height: 25,width: 25,)),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SelectableText(
                                snapshot.data!.article.title,
                                // overflow: TextOverflow.clip,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18),
                              ),
                            ),
                            HtmlWidget(
                              snapshot.data!.article.body,
                              onTapUrl: (url) async {
                                if (url.contains("training")) {
                                  munuchangerProvider.eventSink
                                      .add(MenuActions.trening);
                                  scafforlKeyProvider.currentState!
                                      .closeDrawer();
                                } else if (url.contains("catalog")) {
                                  munuchangerProvider.eventSink
                                      .add(MenuActions.katalog);
                                  scafforlKeyProvider.currentState!
                                      .closeDrawer();
                                } else if (url.contains("video")) {
                                  final uri = Uri.parse(url);
                                  final fragment = uri.fragment;
                                  final filename = fragment.split('#').last;
                                  title.changeTitle(filename);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: Consumer<ArticleTitleProvider>(
                                            builder: (context, value, child) {
                                          return FutureBuilder<
                                                  ArticleVideoModel>(
                                              future: blocVideoApi.getData(
                                                  token: token,
                                                  videoName: filename),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return MultiProvider(
                                                    providers: [
                                                      Provider(
                                                        create: (context) =>
                                                            token,
                                                      ),
                                                    ],
                                                    child: ArticleVideoVidget(
                                                      url: snapshot.data!.data!
                                                          .videoLink!,
                                                      title: snapshot
                                                          .data!.data!.title!,
                                                    ),
                                                  );
                                                }
                                                return Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2) -
                                                            135),
                                                    child: Lottie.asset(
                                                      'assets/pre.json',
                                                      height: 70,
                                                      width: 70,
                                                    ),
                                                  ),
                                                );
                                              });
                                        }),
                                      );
                                    },
                                  );
                                  scafforlKeyProvider.currentState!
                                      .closeDrawer();
                                } else if (await canLaunch(url)) {
                                  await launch(
                                    url,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                                return true;
                              },
                              // onLinkTap: (url, context, attributes, element) {
                              //   _launchInBrowser(
                              //     Uri.parse(
                              //       url.toString(),
                              //     ),
                              //   );
                              // },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Expanded(
            child: Column(
              children: [
                const Spacer(),
                Center(
                    child: Lottie.asset(
                  'assets/pre.json',
                  height: 70,
                  width: 70,
                )),
                const Spacer()
              ],
            ),
          );
        }
      },
    );
  }

  _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
