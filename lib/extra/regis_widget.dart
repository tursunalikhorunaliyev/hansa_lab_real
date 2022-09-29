import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/login_clicked_bloc.dart';
import 'package:hansa_lab/providers/provider_for_flipping/flip_login_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/login_clicked_provider.dart';
import 'package:provider/provider.dart';

class CompleteRegistr extends StatelessWidget {
  const CompleteRegistr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerFlip = Provider.of<Map<String, FlipCardController>>(context);
    final isTablet = Provider.of<bool>(context);
    final loginActionProvider = Provider.of<LoginClickedProvider>(context);
    final flipLoginProvider = Provider.of<FlipLoginProvider>(context);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 278,
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isTablet ? 18 : 5)),
                  width: isTablet ? 556 : 346,
                  height: isTablet ? 515 : 432,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8, top: 8),
                            child: InkWell(
                              onTap: () => providerFlip['signin']!.toggleCard(),
                              child: Icon(
                                Icons.close_rounded,
                                size: isTablet ? 30 : 24,
                                color: const Color(0xff8c8c8b),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: isTablet ? 70 : 85),
                        child: Text(
                          '        Спасибо\n за регистрацию',
                          style: GoogleFonts.montserrat(
                              fontSize: isTablet ? 30 : 24,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 17),
                        child: Icon(
                          Icons.done,
                          color: const Color(0xff25b049),
                          size: isTablet ? 28 : 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Text(
                          '       Вам на почту \n отправлено письмо\n  с подтверждением\n      Ваших данных',
                          style: GoogleFonts.montserrat(
                              fontSize: isTablet ? 20 : 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 37),
                        child: GestureDetector(
                          onTap: () {
                            /* loginActionProvider
                                .changeLoginAction(LoginAction.signin);
                            flipLoginProvider.changeIsClosed(false); */
                            providerFlip['toLogin']!.toggleCard();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: isTablet ? 525 : 319,
                            height: isTablet ? 55 : 47,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 7,
                                  blurRadius: 9,
                                  offset: const Offset(
                                      0, 15), // changes position of shadow
                                ),
                              ],
                              color: const Color(0xff25b049),
                              borderRadius:
                                  BorderRadius.circular(isTablet ? 28 : 23),
                            ),
                            child: Text(
                              'Войти в приложение',
                              style: GoogleFonts.montserrat(
                                fontSize: isTablet ? 16 : 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //Tugadi
            Padding(
              padding: EdgeInsets.only(
                  top: isTablet ? 190 : 213, left: isTablet ? 350 : 130),
              child: isTablet
                  ? Image.asset(
                      'assets/tabletTumLogo.png',
                    )
                  : Image.asset(
                      'assets/Logo.png',
                      height: 134,
                      width: 134,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 730, left: 115),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "По всем вопросам пришите на",
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 11, color: Color(0xFF989a9d)),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Support@hansa-lab.ru",
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 11, color: Color(0xFF989a9d)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
