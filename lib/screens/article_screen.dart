// ignore_for_file: must_be_immutable
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/article_model.dart';
import 'package:hansa_lab/blocs/article_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.333333333333333),
                                  topRight: Radius.circular(5.333333333333333)),
                              color: Color(0xFFffffff)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data!.article.title,
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18),
                                ),
                              ),
                              Html(
                                data: snapshot.data!.article.body,
                                onLinkTap: (url, context, attributes, element) {
                                  _launchInBrowser(Uri.parse(url.toString()));
                                },
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
        });
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
