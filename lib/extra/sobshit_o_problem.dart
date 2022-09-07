import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/model_o_kompaniya_napisat.dart';
import 'package:hansa_lab/blocs/bloc_empty_sobshit.dart';
import 'package:hansa_lab/extra/sobshit_o_problem_success.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SobshitOProblem extends StatefulWidget {
  const SobshitOProblem({Key? key}) : super(key: key);

  @override
  State<SobshitOProblem> createState() => _SobshitOProblemState();
}

class _SobshitOProblemState extends State<SobshitOProblem> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final textFieldController = TextEditingController();
  final blocEmptySobshit = BlocEmptySobshit();

  @override
  Widget build(BuildContext context) {
    final providerToken = Provider.of<String>(context);

    final isTablet = Provider.of<bool>(context);
    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .135),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 57.5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.white,
                          width: isTablet ? 500 : 350,
                          height: isTablet ? 480 : null,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 22,
                                        color: Color(0xff8c8c8b),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Задать вопрос",
                                    style: GoogleFonts.montserrat(
                                        color: const Color(0xff444444),
                                        fontSize: isTablet ? 32 : 24),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  StreamBuilder<bool>(
                                      initialData: false,
                                      stream: blocEmptySobshit.dataStream,
                                      builder: (context, snapshot) {
                                        return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            child: TextField(
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      isTablet ? 20 : null),
                                              cursorHeight:
                                                  isTablet ? 23 : null,
                                              controller: textFieldController,
                                              onChanged: (value) {
                                                blocEmptySobshit.dataSink
                                                    .add(false);
                                              },
                                              maxLines: 5,
                                              cursorColor:
                                                  const Color(0xffa1b7c2),
                                              decoration: InputDecoration(
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 100),
                                                  child: Image.asset(
                                                    "assets/free-icon-maps-and-flags-446099.png",
                                                    scale: isTablet ? 2 : 3,
                                                    color: snapshot.data!
                                                        ? const Color.fromARGB(
                                                            255, 213, 0, 50)
                                                        : const Color(
                                                            0xffa1b7c2),
                                                  ),
                                                ),
                                                hintText:
                                                    "Текст вашего сообщения",
                                                hintStyle:
                                                    GoogleFonts.montserrat(
                                                        fontSize: isTablet
                                                            ? 23
                                                            : null,
                                                        color: snapshot.data!
                                                            ? const Color
                                                                    .fromARGB(
                                                                255, 213, 0, 50)
                                                            : const Color(
                                                                0xffa1b7c2)),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: snapshot.data!
                                                        ? const Color.fromARGB(
                                                            255, 213, 0, 50)
                                                        : const Color(
                                                            0xffa1b7c2),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: snapshot.data!
                                                        ? const Color.fromARGB(
                                                            255, 213, 0, 50)
                                                        : const Color(
                                                            0xffa1b7c2),
                                                  ),
                                                ),
                                              ),
                                            ));
                                      }),
                                  SizedBox(
                                    height: isTablet ? 75 : 45,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(64),
                                        child: StreamBuilder<bool>(
                                            initialData: false,
                                            stream: blocEmptySobshit.dataStream,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (textFieldController
                                                        .text.isNotEmpty) {
                                                      cardKey.currentState!
                                                          .toggleCard();
                                                      getData(
                                                              providerToken,
                                                              textFieldController
                                                                  .text)
                                                          .then((value) {});

                                                      blocEmptySobshit.dataSink
                                                          .add(false);
                                                    } else {
                                                      blocEmptySobshit.dataSink
                                                          .add(true);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 47,
                                                    color:
                                                        const Color(0xff25b049),
                                                    child: Center(
                                                      child: Text(
                                                        "Отправить сообщение",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 13,
                                                          color: const Color(
                                                              0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Text("Ошибка простояta",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 20));
                                              }
                                            })),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/LAB1.png",
                      height: 125,
                      width: 125,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      back: const SobshitOProblemSuccess(),
    );
  }

  Future<ModelOKompaniyaNapisatMain> getData(String token, String text) async {
    http.Response response = await http.post(
        Uri.parse("http://hansa-lab.ru/api/site/add-problem"),
        headers: {"token": token},
        body: {"text": text});

    return ModelOKompaniyaNapisatMain.fromMap(jsonDecode(response.body));
  }
}
