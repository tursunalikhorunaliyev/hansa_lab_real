import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/nastroyka_model.dart';
import 'package:hansa_lab/blocs/bloc_for_nastroyka.dart';
import 'package:hansa_lab/drawer_widgets/text_icon.dart';
import 'package:hansa_lab/drawer_widgets/toggle_switcher_one.dart';
import 'package:hansa_lab/drawer_widgets/toggle_switcher_three.dart';
import 'package:hansa_lab/providers/provider_otpravit_rassilku.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class NastroykaWidget extends StatefulWidget {
  const NastroykaWidget({Key? key}) : super(key: key);

  @override
  State<NastroykaWidget> createState() => _NastroykaWidgetState();
}

class _NastroykaWidgetState extends State<NastroykaWidget> {
  Future<NastroykaModel> getData(token) async {
    http.Response response = await http.get(
      Uri.parse("https://hansa-lab.ru/api/site/unsubscribe"),
      headers: {"token": token},
    );

    return NastroykaModel.fromMap(jsonDecode(response.body));
  }

  int firstTime = 0;
  @override
  void initState() {
    firstTime = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerToken = Provider.of<String>(context);
    final blocForNastroyka = BlocForNastroyka(providerToken);
    final providerOtpravitRassilku =
        Provider.of<ProviderOtpravitRassilku>(context);

    blocForNastroyka.eventSink.add(Nastroyka.nastroyka);
    if (firstTime == 1) {
      getData(providerToken).then((value) {
        providerOtpravitRassilku.setAlignment(value.data.subscribe == 1
            ? Alignment.centerLeft
            : Alignment.centerRight);
      });
      firstTime = 2;
    }
    return Wrap(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 26),
          child: TextIcon(
            text: "Настройки",
            iconUrl: "assets/icon.png",
            colorIcon: Color(0xFFaaaaaa),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Divider(
          color: Color(0xFF444444),
          thickness: 2,
          indent: 26,
          endIndent: 26,
        ),
        const SizedBox(
          height: 43,
        ),
        StreamBuilder<NastroykaModel>(
            stream: blocForNastroyka.dataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                log("${snapshot.data!.data.subscribe} in builder");
                return Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 37, right: 23),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Включить пуш уведомления",
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: const Color(0xFFffffff),
                                  fontWeight: FontWeight.w500)),
                          const ToggleSwitcherOne(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 37, right: 23),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Подписка на рассылку",
                                style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: const Color(0xFFffffff),
                                    fontWeight: FontWeight.w500)),
                            MultiProvider(
                              providers: [
                                Provider(
                                  create: (context) => String,
                                ),
                                Provider(
                                  create: (context) => TextEditingController(),
                                )
                              ],
                              child: Center(
                                  child: SizedBox(
                                height: 21,
                                width: 40,
                                child: GestureDetector(
                                    onTap: () {
                                      providerOtpravitRassilku.setAlignment(
                                          providerOtpravitRassilku
                                                      .getAlignment ==
                                                  Alignment.centerRight
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight);
                                      Timer(
                                        const Duration(seconds: 3),
                                        () {
                                          blocForNastroyka
                                              .postData(providerToken)
                                              .then((value) => blocForNastroyka
                                                  .eventSink
                                                  .add(Nastroyka.nastroyka));
                                        },
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 12,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFdddddd),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        Consumer<ProviderOtpravitRassilku>(
                                          builder: (context, value, child) {
                                            return AnimatedAlign(
                                              alignment: value.getAlignment,
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              child: Container(
                                                width: 21,
                                                decoration: BoxDecoration(
                                                    color: value.getAlignment ==
                                                            Alignment
                                                                .centerRight
                                                        ? const Color(
                                                            0xFF25b049)
                                                        : Colors.grey[350],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.r)),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    )),
                              )),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 37, right: 23),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Оставаться в трее ",
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: const Color(0xFFffffff),
                                  fontWeight: FontWeight.w500)),
                          MultiProvider(providers: [
                            Provider(
                              create: (context) => String,
                            ),
                            Provider(
                              create: (context) => TextEditingController(),
                            )
                          ], child: const ToggleSwitcherThree()),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const SpinKitPulse(
                  color: Colors.white,
                );
              }
            }),
        const SizedBox(
          height: 186,
        ),
        const Divider(
          color: Color(0xFF444444),
          thickness: 2,
          indent: 26,
          endIndent: 26,
        ),
      ],
    );
  }
}
