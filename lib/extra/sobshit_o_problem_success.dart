import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SobshitOProblemSuccess extends StatefulWidget {
  const SobshitOProblemSuccess({Key? key}) : super(key: key);

  @override
  State<SobshitOProblemSuccess> createState() => _SobshitOProblemSuccessState();
}

class _SobshitOProblemSuccessState extends State<SobshitOProblemSuccess> {
  @override
  Widget build(BuildContext context) {
        final isTablet = Provider.of<bool>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: SingleChildScrollView(
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
                          height: 170,
                          width: isTablet ? 500 : 350,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child:  Icon(
                                      Icons.close,
                                      size: isTablet ? 30  : 22,
                                      color: const Color(0xff8c8c8b),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                             SizedBox(
                              height: isTablet ? 30   : 45,
                            ),
                             Icon(
                              Icons.check,
                              color: const Color(0xFF25b049),
                              size: isTablet  ? 40  : null ,
                            ),
                            Text(
                              "Спасибо за комментарий",
                              style: GoogleFonts.montserrat(
                                  color: const Color(0xff444444), fontSize: isTablet ?  30 : 24),
                            )
                          ]),
                        ),
                      ),
                    )
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
    );
  }
}
