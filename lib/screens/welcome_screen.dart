import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:hansa_lab/blocs/bloc_obucheniya.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/classes/notification_token.dart';
import 'package:hansa_lab/classes/send_check_switcher.dart';
import 'package:hansa_lab/classes/tap_favorite.dart';
import 'package:hansa_lab/extra/exit_dialog.dart';
import 'package:hansa_lab/extra/glavniy_menyu.dart';
import 'package:hansa_lab/extra/hamburger.dart';
import 'package:hansa_lab/extra/ui_changer.dart';
import 'package:hansa_lab/page_routes/bottom_slide_page_route.dart';
import 'package:hansa_lab/providers/provider_personal_textFields.dart';
import 'package:hansa_lab/screens/search_screen.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final providerScaffoldKey = Provider.of<GlobalKey<ScaffoldState>>(context);
    final menuProvider = Provider.of<MenuEventsBloC>(context);
    final providerTapFavorite = Provider.of<TapFavorite>(context);
    final token = Provider.of<String>(context);
    final providerSendCheckSwitcher = Provider.of<SendCheckSwitcher>(context);
    final welcomeApi = WelcomeApi(token);
    final bloc = BlocObucheniya(token);
    final not = Provider.of<bool>(context);
    final providerNotificationToken = Provider.of<NotificationToken>(context);
    providerNotificationToken.getToken().then((value) => log("$value KLLLK"));

    return WillPopScope(
      onWillPop: () async {
        providerSendCheckSwitcher.getBool == true
            ? backPressedTrue(menuProvider)
            : backPressed(menuProvider);
        return false;
      },
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        resizeToAvoidBottomInset: false,
        drawer: MultiProvider(providers: [
          Provider(create: (context) => ProviderPersonalTextFields()),
          Provider(create: (context) => providerScaffoldKey),
          Provider<WelcomeApi>(
            create: (context) => welcomeApi,
          ),
          Provider<BlocObucheniya>(
            create: (context) => bloc,
          )
        ], child: const GlavniyMenyu()),
        key: providerScaffoldKey,
        bottomNavigationBar: StreamBuilder<MenuActions>(
            initialData: (not) ? MenuActions.stati : MenuActions.welcome,
            stream: menuProvider.eventStream,
            builder: (context, snapshot) {
              return SizedBox(
                height: 58.h,
                child: Container(
                  color: const Color(0xffffffff),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          backPressed(menuProvider);
                        },
                        child: Icon(
                          CupertinoIcons.chevron_left_circle,
                          size: isTablet ? 20.sp : 25.sp,
                          color: const Color(0xffa5a5ae),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          menuProvider.eventSink.add(MenuActions.welcome);
                        },
                        child: Icon(
                          CupertinoIcons.home,
                          size: isTablet ? 20.sp : 25.sp,
                          color: const Color(0xffa5a5ae),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          providerTapFavorite.setInt(1);
                          log("${providerTapFavorite.getInt} Welcome screen get bool");
                          providerScaffoldKey.currentState!.openDrawer();
                        },
                        child: Icon(
                          CupertinoIcons.heart,
                          size: isTablet ? 20.sp : 25.sp,
                          color: const Color(0xffa5a5ae),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          providerTapFavorite.setInt(2);
                          providerScaffoldKey.currentState!.openDrawer();
                        },
                        child: Icon(
                          CupertinoIcons.person,
                          size: isTablet ? 20.sp : 25.sp,
                          color: const Color(0xffa5a5ae),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        backgroundColor: const Color(0xffeaeaea),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: const Color(0xffffffff),
                  width: double.infinity,
                  height: 100.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 25.h, left: 20, right: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                       crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              providerTapFavorite.setInt(0);
                              providerScaffoldKey.currentState!.openDrawer();
                            },
                            icon: const HamburgerIcon()),
                        InkWell(
                          onTap: () {
                            menuProvider.eventSink.add(MenuActions.welcome);
                          },
                          child: Image.asset(
                            'assets/tepaLogo.png',
                            height: isTablet ? 30.h : 25.h,
                            width: isTablet ? 230.w : null,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            log("${providerSendCheckSwitcher.getBool} SEARCH");
                            Navigator.of(context).push(SlideTransitionBottom(
                              Provider.value(
                                value: token,
                                child: const SearchScreen(),
                              ),
                            ));
                          },
                          child: Icon(
                            CupertinoIcons.search,
                            size: isTablet ? 19.sp : 21.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                MultiProvider(
                  providers: [
                    Provider<BlocObucheniya>(
                      create: (context) => bloc,
                    ),
                    Provider(
                      create: (context) => providerScaffoldKey,
                    ),
                    Provider(
                      create: (context) => welcomeApi,
                    )
                  ],
                  child: const UIChanger(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  backPressed(MenuEventsBloC menuProvider) {
    if (menuProvider.list.length > 1) {
      menuProvider.eventSink
          .add(menuProvider.list.elementAt(menuProvider.list.length - 2));
      menuProvider.list
          .remove(menuProvider.list.elementAt(menuProvider.list.length - 1));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const ExitDialog();
        },
      );
    }
  }

  backPressedTrue(MenuEventsBloC menuProvider) {
    if (menuProvider.list.length > 1) {
      menuProvider.eventSink
          .add(menuProvider.list.elementAt(menuProvider.list.length - 2));
      menuProvider.list
          .remove(menuProvider.list.elementAt(menuProvider.list.length - 1));
    } else {
      MoveToBackground.moveTaskToBack();
    }
  }
}
