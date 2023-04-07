import 'dart:async';

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hansa_lab/blocs/login_clicked_bloc.dart';
import 'package:hansa_lab/extra/voyti_ili_sozdat_accaunt.dart';
import 'package:hansa_lab/providers/provider_for_flipping/flip_login_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/login_clicked_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

bool _initialUriIsHandled = false;

class HansaEntry extends StatefulWidget {
  const HansaEntry({Key? key}) : super(key: key);

  @override
  State<HansaEntry> createState() => _HansaEntryState();
}

class _HansaEntryState extends State<HansaEntry> {
  late final Map<String, FlipCardController> _providerFlip;
  late final FlipLoginProvider _flipLoginProvider;
  late final LoginClickedProvider _loginActionProvider;
  StreamSubscription? _sub;
  double pos = 420;

  @override
  void initState() {
    _providerFlip = Provider.of<Map<String, FlipCardController>>(context, listen: false);
    _flipLoginProvider = Provider.of<FlipLoginProvider>(context, listen: false);
    _loginActionProvider = Provider.of<LoginClickedProvider>(context, listen: false);

    timerWidget();
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  /// Handle incoming links - the ones that the app will receive from the OS
  /// while already started.
  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen(_handleAppLink, onError: (err) => print(err));
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        _handleAppLink(uri);
      } catch (err) {
        print(err);
      }
    }
  }

  void _handleAppLink(Uri? uri) {
    if (uri == null) return;
    final path = uri.path;
    switch (path) {
      case '/auth/login':
        _flipLoginForm();
        break;
      default:
    }
  }

  void _flipLoginForm() {
    _loginActionProvider.changeLoginAction(LoginAction.login);
    _flipLoginProvider.changeIsClosed(true);
    _providerFlip['login']!.toggleCard();
  }

  timerWidget() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (timer.tick == 1) {
        setState(() {
          pos = 200;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: isTablet ? 445.h : 438.6666666666667.h,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 80.h, left: isTablet ? 70.w : 40.w, right: isTablet ? 70.w : 40.w),
                    child: Image.asset("assets/logoHansa.png")),
                Padding(
                  padding: EdgeInsets.only(top: isTablet ? 20.h : 27.66666666666667.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "#Увидимся",
                        textScaleFactor: 1.0,
                        style: GoogleFonts.montserrat(
                            color: const Color.fromARGB(255, 59, 59, 59),
                            fontSize: isTablet ? 16.sp : 25.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "на",
                        textScaleFactor: 1.0,
                        style: GoogleFonts.montserrat(
                            color: const Color.fromARGB(255, 59, 59, 59),
                            fontSize: isTablet ? 16.sp : 25.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "кухне",
                        textScaleFactor: 1.0,
                        style: GoogleFonts.montserrat(
                            color: const Color.fromARGB(255, 59, 59, 59),
                            fontSize: isTablet ? 16.sp : 25.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pos == 420
              ? Positioned(
                  top: 240.h,
                  left: 27.w,
                  right: 27.w,
                  child: Lottie.asset("assets/pre.json", width: 120, height: 120),
                )
              : const SizedBox(),
          Positioned(
            top: isTablet ? -90 : -58,
            child: isTablet
                ? Image.asset("assets/tabletTumLogo.png")
                : Image.asset(
                    "assets/Logo.png",
                    height: 133,
                    width: 133,
                  ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: pos.h,
            bottom: isTablet ? 25.h : 20.h,
            child: const VoytiIliSozdatAccaunt(),
          ),
        ],
      ),
    );
  }
}
