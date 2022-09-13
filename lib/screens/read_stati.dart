import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/read_stati_model.dart';
import 'package:hansa_lab/api_services/read_stati_send_comment_service.dart';
import 'package:hansa_lab/classes/send_link.dart';
import 'package:hansa_lab/extra/custom_title.dart';
import 'package:hansa_lab/read_statie_section/stati_comment.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class ReadStati extends StatefulWidget {
  const ReadStati({Key? key}) : super(key: key);

  @override
  State<ReadStati> createState() => _ReadStatiState();
}

class _ReadStatiState extends State<ReadStati> {
  double positionDouble = 300.6666666666667;
  final ScrollController listViewController =
      ScrollController(keepScrollOffset: true);

  final Image iconImage = Image.asset(
    "assets/iconStati.png",
    width: 30.33333333333333,
    height: 30.33333333333333,
  );
  TextEditingController textFieldController = TextEditingController();

  Future<ReadStatiModel> getData(String token, url) async {
    var headers = {'token': token};
    http.Response response =
        await http.get(Uri.parse("http://hansa-lab.ru/$url"), headers: headers);
    log("${response.statusCode} KELDI");
    log("${response.body} Body");
    log(url + " QALESAN");
    return ReadStatiModel.fromMap(jsonDecode(response.body));
  }

  Future<Map<String, dynamic>> changeRating(
      String token, id, String rating) async {
    var headers = {'token': token};
    http.Response response =
        await http.post(Uri.parse("http://hansa-lab.ru/api/site/add-rating"),
            body: {
              "useful_skill_id": id,
              "rating": rating,
            },
            headers: headers);
    log(response.statusCode.toString() + " change rating");

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    log("--------------------------------------------------------");
    final isTablet = Provider.of<bool>(context);
    final providerToken = Provider.of<String>(context);

    final statieSendLinkProvider = Provider.of<SendLink>(context);
    positionDouble = isTablet ? 600 : 300;
    return FutureBuilder<ReadStatiModel>(
        future: getData(providerToken, statieSendLinkProvider.getLInk),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            log(statieSendLinkProvider.getLInk + " nmedi");
            log(statieSendLinkProvider.getLInk
                    .substring(statieSendLinkProvider.getLInk.length - 2) +
                " osha joy");
            log(snapshot.data!.data.article.messagesLink + " LKKLLKKLLKKL");
            return Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const CustomTitle(
                          imagePath: "assets/iconStati.png", title: "Статьи"),
                      ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.333333333333333),
                              topRight: Radius.circular(5.333333333333333)),
                          child: CachedNetworkImage(
                              imageUrl:
                                  snapshot.data!.data.article.pictureLink)),
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
                          child: Wrap(children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: RatingBar.builder(
                                  unratedColor: Colors.grey[300],
                                  initialRating: snapshot
                                      .data!.data.article.rating
                                      .toDouble(),
                                  itemCount: 5,
                                  itemSize: 24,
                                  itemBuilder: (context, index) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    );
                                  },
                                  onRatingUpdate: (value) {
                                    log(value.toString());
                                    Timer(
                                      const Duration(seconds: 3),
                                      () {
                                        changeRating(
                                            providerToken,
                                            statieSendLinkProvider.getLInk
                                                .substring(
                                                    statieSendLinkProvider
                                                            .getLInk.length -
                                                        2),
                                            value.toString()).then((value) {
                                              setState(() {
                                                
                                              });
                                            });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Html(
                              data: snapshot.data!.data.article.body,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Flex(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 54.66666666666667,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFffffff),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.3),
                                                blurRadius: 30,
                                                offset: const Offset(3, 7))
                                          ]),
                                      child: Row(
                                        mainAxisAlignment: isTablet
                                            ? MainAxisAlignment.spaceEvenly
                                            : MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: isTablet ? 20 : 0,
                                          ),
                                          Container(
                                            height: 32.22333333333333,
                                            width: 82.40333333333333,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        11.66666666666667),
                                                color: const Color.fromARGB(
                                                    255, 213, 0, 50)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!.data.article.rating
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: isTablet ? 15 : 0,
                                          ),
                                          Text(
                                            "Коментариев ${snapshot.data!.data.article.listMessageComment.list.length}",
                                            style: GoogleFonts.montserrat(
                                              color: const Color(0xFF777777),
                                              fontSize: 13.81,
                                            ),
                                          ),
                                          isTablet
                                              ? const Spacer()
                                              : const SizedBox(),
                                          SizedBox(
                                            height: 46.03666666666667,
                                            width: 46.03666666666667,
                                            child: Image.asset(
                                              "assets/imageLAB.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            width: isTablet ? 20 : 0,
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 19.33333333333333,
                                    ),
                                    Column(
                                      children: List.generate(
                                          snapshot
                                              .data!
                                              .data
                                              .article
                                              .listMessageComment
                                              .list
                                              .length, (index) {
                                        int length = snapshot.data!.data.article
                                            .listMessageComment.list.length;
                                        return StatiComment(
                                          comment: snapshot
                                              .data!
                                              .data
                                              .article
                                              .listMessageComment
                                              .list[length - index - 1]
                                              .body,
                                          imageURl: snapshot
                                              .data!
                                              .data
                                              .article
                                              .listMessageComment
                                              .list[length - index - 1]
                                              .pictureLink,
                                          name: snapshot
                                              .data!
                                              .data
                                              .article
                                              .listMessageComment
                                              .list[length - index - 1]
                                              .fullname,
                                          initialRating: snapshot
                                              .data!
                                              .data
                                              .article
                                              .listMessageComment
                                              .list[length - index - 1]
                                              .rang
                                              .toDouble(),
                                        );
                                      }),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "#",
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 213, 0, 50),
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "Написать комментарий",
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                log("FGFGGFGGFGFGG");
                                                if (textFieldController
                                                    .text.isNotEmpty) {
                                                  ReadStatiSendCommentService
                                                      .getData(
                                                          providerToken,
                                                          snapshot
                                                              .data!
                                                              .data
                                                              .article
                                                              .messagesLink,
                                                          {
                                                        "body":
                                                            textFieldController
                                                                .text,
                                                        "id": snapshot.data!
                                                            .data.article.id
                                                            .toString()
                                                      }).then((value) {
                                                    if (value["status"] ==
                                                        true) {
                                                      textFieldController
                                                          .clear();
                                                      setState(() {});
                                                    }
                                                    log(value["status"]
                                                        .toString());
                                                    getData(
                                                        providerToken,
                                                        statieSendLinkProvider
                                                            .getLInk);
                                                  });
                                                }
                                              },
                                              icon: const Icon(Icons.send)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.66666666666667,
                                    ),
                                    Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFffffff),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.3),
                                                blurRadius: 7,
                                                offset: const Offset(0, 8))
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: TextField(
                                          controller: textFieldController,
                                          maxLines: 7,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "Интересно а почему именн...",
                                              hintStyle: GoogleFonts.montserrat(
                                                  fontSize: 12.66666666666667,
                                                  color:
                                                      const Color(0xFF919191))),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 300,
                                    ),
                                  ]),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            log("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
            return Expanded(
              child: Column(
                children: [
                  const Spacer(),
                  Lottie.asset(
                    'assets/pre.json',
                    height: 70,
                    width: 70,
                  ),
                  const Spacer()
                ],
              ),
            );
          }
        });
  }
}
