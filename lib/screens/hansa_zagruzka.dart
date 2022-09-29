import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/blocs/login_anim_bloc.dart';
import 'package:hansa_lab/blocs/login_clicked_bloc.dart';
import 'package:hansa_lab/extra/full_registr.dart';
import 'package:hansa_lab/extra/hansa_entry_widget.dart';
import 'package:hansa_lab/extra/login_card.dart';
import 'package:hansa_lab/extra/regis_widget.dart';
import 'package:hansa_lab/providers/provider_for_flipping/flip_login_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/login_clicked_provider.dart';
import 'package:hansa_lab/providers/providers_for_login/password_visibility_provider.dart';
import 'package:provider/provider.dart';

class HansaZagruzka extends StatelessWidget {
  const HansaZagruzka({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final loginAnimBloc = LoginAnimBloc();
    final flipCardController =
        Provider.of<Map<String, FlipCardController>>(context);
    final providerClicked = Provider.of<LoginClickedBloc>(context);
    final flipLoginProvider = Provider.of<FlipLoginProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: MultiProvider(
        providers: [
          Provider<LoginAnimBloc>(
            create: (context) => loginAnimBloc,
          ),
        ],
        child: Scaffold(
            backgroundColor: const Color(0xff31363c),
            body: Stack(children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    isTablet
                        ? "assets/tabletRasm.png"
                        : "assets/Layer 1701.png",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    height: 2,
                    color: const Color(0xff31363c),
                  ),
                ],
              ),
              Consumer<FlipLoginProvider>(builder: (context, value, child) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: value.getIsClosed ? 1 : 0,
                  curve: Curves.fastOutSlowIn,
                  child: Padding(
                    padding: EdgeInsets.only(top: 300.h),
                    child: Image.asset(
                      isTablet ? "assets/tabletBgRasm.png" : 'assets/bg.png',
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
              Provider.value(
                value: providerClicked,
                child: FlipCard(
                  controller: flipCardController['login'],
                  flipOnTouch: false,
                  front: Align(
                    alignment: Alignment.bottomCenter,
                    child: Provider.value(
                      value: flipLoginProvider,
                      child: const HansaEntry(),
                    ),
                  ),
                  back: Consumer<LoginClickedProvider>(
                    builder: (context, value, child) {
                      return Center(
                        child: value.getAction == LoginAction.login
                            ? SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 200),
                                  child: MultiProvider(providers: [
                                    ChangeNotifierProvider(
                                      create: (context) =>
                                          PasswordVisibilityProvider(),
                                    ),
                                  ], child: const LoginCard()),
                                ),
                              )
                            : FlipCard(
                                controller: flipCardController['signin'],
                                flipOnTouch: false,
                                back:  FlipCard(
                                  flipOnTouch: false,
                                  controller: flipCardController['toLogin'],
                                  front: const CompleteRegistr(),
                                  back: MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                      create: (context) =>
                                          PasswordVisibilityProvider(),
                                    ),
                                    ],
                                    
                                    child: const LoginCard()),
                                  ),
                                front: Provider.value(
                                  value: flipLoginProvider,
                                  child: const FullRegistr(),
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}
