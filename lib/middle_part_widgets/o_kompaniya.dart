import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/api_models.dart/model_o_kompaniya.dart';
import 'package:hansa_lab/blocs/bloc_o_kompaniya.dart';
import 'package:hansa_lab/enums/enum_action_view.dart';
import 'package:hansa_lab/extra/sobshit_o_problem.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sticky_headers/sticky_headers.dart';

class Okompaniya extends StatelessWidget {
  const Okompaniya({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final providerToken = Provider.of<String>(context);
    final blocOKompaniya = BlocOKompaniya(providerToken);
    blocOKompaniya.eventSink.add(EnumActionView.view);
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StickyHeader(
          header: Container(
            height: isTablet ? 95 : 67,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(color: Color(0xffeaeaea), offset: Offset(0, -3))
            ], color: Color(0xFFf1f1f1)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: isTablet ? 22 : 16,
                      left: isTablet ? 30 : 14,
                      right: isTablet ? 15 : 13,
                      bottom: isTablet ? 25 : 16),
                  height: isTablet ? 63 : 42,
                  width: isTablet ? 120 : 70,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 213, 0, 50),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(64),
                          bottomRight: Radius.circular(64))),
                  child: Image.asset(
                    "assets/Lab.png",
                  ),
                ),
                const SizedBox(
                  width: 9,
                ),
                Text(
                  "#",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 213, 0, 50),
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 20 : 16),
                ),
                Text(
                  "О проекте",
                  textScaleFactor: 1.0,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 25 : 20),
                )
              ],
            ),
          ),
          content: Stack(
            children: [
              isTablet
                  ? const SizedBox()
                  : Container(
                      height: 217,
                      width: 375,
                      decoration: const BoxDecoration(color: Color(0xFFf8f8f8)),
                    ),
              isTablet
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            "assets/1649660637Аракелян Ася.png",
                            fit: BoxFit.fitWidth,
                            height: 445,
                            width: 330.w,
                          ),
                        ),
                      ],
                    )
                  : Image.asset("assets/1649660637Аракелян Ася.png"),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: isTablet ? 391 : 174),
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(
                      height: isTablet ? 633 : 360,
                      width: isTablet ? 770 : 323,
                      decoration: BoxDecoration(
                          color: const Color(0xFFffffff),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: isTablet ? 405 : 184,
                  ),
                  child: Container(
                    height: isTablet ? 621 : 360,
                    width: isTablet ? 800 : 342,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 213, 0, 50),
                        borderRadius: BorderRadius.circular(16)),
                    child: StreamBuilder<ModelOKompaniyaMain>(
                        stream: blocOKompaniya.dataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70),
                                    child: Text(
                                      snapshot.data!.data.title,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.fade,
                                      style: GoogleFonts.montserrat(
                                        fontSize: isTablet ? 26 : 16,
                                        color: const Color(0xFFffffff),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: isTablet ? 20 : 10,
                                      top: 20,
                                      right: isTablet ? 20 : 10),
                                  child: Text(
                                    snapshot.data!.data.list[0],
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontSize: isTablet ? 21 : 11,
                                      color: const Color(0xFFffffff),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: isTablet ? 20 : 10,
                                      top: 20,
                                      right: isTablet ? 20 : 10),
                                  child: Text(
                                    snapshot.data!.data.list[1],
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontSize: isTablet ? 21 : 11,
                                      color: const Color(0xFFffffff),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: isTablet ? 20 : 10,
                                      top: 20,
                                      right: isTablet ? 20 : 10),
                                  child: Text(
                                    snapshot.data!.data.list[2],
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      fontSize: isTablet ? 21 : 11,
                                      color: const Color(0xFFffffff),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: isTablet ? 100 : 30,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          useRootNavigator: false,
                                          builder: (context) =>
                                              Provider<String>.value(
                                                  value:
                                                      providerToken.toString(),
                                                  child:
                                                      const SobshitOProblem()),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: isTablet ? 65 : 31,
                                        width: isTablet ? 540 : 213,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF25b049),
                                          borderRadius:
                                              BorderRadius.circular(70),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 213, 0, 50)
                                                  .withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          "Написать разработчику",
                                          style: GoogleFonts.montserrat(
                                              fontSize: isTablet ? 19 : 10,
                                              color: const Color(0xFFffffff)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SpinKitPulse(
                              color: Color.fromARGB(255, 213, 0, 50),
                            );
                          }
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
