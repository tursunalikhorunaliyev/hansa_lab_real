import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/api_models.dart/question_day_model.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:hansa_lab/blocs/bloc_obucheniya.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/classes/notification_functions.dart';
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
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:provider/provider.dart';

import '../api_services/get_question_api.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isShowDialog = false;
  int? isRight;
  int? isNumber;
  int? isQuestionId;
  List<String> testVariant = ["A", "B", "C", "D"];

  // NotificationServices notificationServices = NotificationServices();


  @override
  void initState() {
    // notificationServices.requestNotificationPermission();
    // notificationServices.firebaseInit(context);
    // notificationServices.setupInteractMessage(context);
    // //notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value){
    //   print('device token');
    //   print(value);
    // });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    final providerScaffoldKey = Provider.of<GlobalKey<ScaffoldState>>(context);
    final menuProvider = Provider.of<MenuEventsBloC>(context);
    final providerTapFavorite = Provider.of<TapFavorite>(context);
    final token = Provider.of<String>(context);
    final providerSendCheckSwitcher = Provider.of<SendCheckSwitcher>(context);
    final welcomeApi = WelcomeApi(token);
    final getQuestionApi = GetQuestionApi(token);
    final bloc = BlocObucheniya(token);
    final not = Provider.of<bool>(context);
    final providerNotificationToken = Provider.of<NotificationToken>(context);
    providerNotificationToken.getToken().then((value) => log("$value token"));
    getQuestionApi.eventSink.add(GetQuestionEnum.get);
    return WillPopScope(
      onWillPop: () async {
        providerSendCheckSwitcher.getBool == true
            ? backPressedTrue(menuProvider)
            : backPressed(menuProvider);
        return false;
      },
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Stack(
          children: [
            Scaffold(
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.chevron_left_circle,
                                    size: isTablet ? 20.sp : 25.sp,
                                    color: const Color(0xffa5a5ae),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Назад",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                menuProvider.eventSink.add(MenuActions.welcome);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.home,
                                    size: isTablet ? 20.sp : 25.sp,
                                    color: const Color(0xffa5a5ae),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Домой",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                providerTapFavorite.setInt(1);
                                log("${providerTapFavorite.getInt} Welcome screen get bool");
                                providerScaffoldKey.currentState!.openDrawer();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.heart,
                                    size: isTablet ? 20.sp : 25.sp,
                                    color: const Color(0xffa5a5ae),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Избранное",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                providerTapFavorite.setInt(2);
                                providerScaffoldKey.currentState!.openDrawer();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.person,
                                    size: isTablet ? 20.sp : 25.sp,
                                    color: const Color(0xffa5a5ae),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Профиль",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 12),
                                  )
                                ],
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
                          padding:
                              EdgeInsets.only(top: 25.h, left: 20, right: 24),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    providerTapFavorite.setInt(0);
                                    providerScaffoldKey.currentState!
                                        .openDrawer();
                                  },
                                  icon: const HamburgerIcon()),
                              InkWell(
                                onTap: () {
                                  menuProvider.eventSink
                                      .add(MenuActions.welcome);
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
                                  Navigator.of(context)
                                      .push(SlideTransitionBottom(
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
            if (!isShowDialog)
              StreamBuilder<QuestionDay>(
                  stream: getQuestionApi.getQuestionData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.data.show == true
                          ? Scaffold(
                              backgroundColor: Colors.black54,
                              body: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          if (isRight == 1) ...[
                                            Container(
                                              width: double.infinity,
                                              height: 150.h,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(16),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    'ПРАВИЛЬНО!',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'ВАМ БУДЕТ ЗАЧИСЛЕНО 100 БАЛЛОВ',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          if (isRight == 0) ...[
                                            Container(
                                              width: double.infinity,
                                              height: 150.h,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(16),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.9),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    'НЕ ВЕРНО',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'ЗАВТРА БУДЕТ НОВЫЙ ВОПРОС',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'ТЫ ТОЧНО СПРАВИШЬСЯ',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          if (isRight == null) ...[
                                            Container(
                                              width: double.infinity,
                                              height: 170.h,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(16),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFF353A5F).withOpacity(0.7),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'ВОПРОС',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const Text(
                                                    '. . .',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    snapshot.data!.data.question
                                                        .text,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                          if (isRight == 1) ...[
                                            Container(
                                              width: 48,
                                              height: 48,
                                              margin: EdgeInsets.only(
                                                  left: 24, bottom: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                margin: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        color: Colors.white)),
                                                child: Icon(
                                                  Icons.done,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                          if (isRight == 0) ...[
                                            Container(
                                              width: 48,
                                              height: 48,
                                              margin: const EdgeInsets.only(
                                                  left: 24, bottom: 8),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                margin: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.red
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        color: Colors.white)),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                          if(isRight == null)...[
                                            Container(
                                              width: 44,
                                              height: 44,
                                              margin: const EdgeInsets.only(
                                                  left: 24, bottom: 8),
                                              decoration: BoxDecoration(
                                                color:
                                                Color(0xFFB7D6F9),
                                                borderRadius:
                                                BorderRadius.circular(22),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                margin: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFB7D6F9),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        16),
                                                    border: Border.all(
                                                        color: Colors.black)),
                                                child: const Icon(
                                                  Icons.question_mark,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          ]
                                        ],
                                      ),
                                      ListView.builder(
                                          itemCount: testVariant.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                isRight ??= snapshot.data!.data
                                                    .answers[index].isRight;
                                                isNumber ??= snapshot.data!.data
                                                    .answers[index].number;
                                                isQuestionId ??= snapshot
                                                    .data!.data.question.id;
                                                getQuestionApi.setQuestion(
                                                    token,
                                                    isNumber!,
                                                    isQuestionId!);
                                                Future.delayed(
                                                        Duration(seconds: 3))
                                                    .then((value) {
                                                  isShowDialog = true;
                                                  setState(() {});
                                                });
                                                setState(() {});
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(
                                                    left: 12,
                                                    right: 12,
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                  color: isRight == null ||
                                                          isNumber !=
                                                              snapshot
                                                                  .data!
                                                                  .data
                                                                  .answers[
                                                                      index]
                                                                  .number
                                                      ? Color(0xFF252B3D).withOpacity(0.7)
                                                      : snapshot
                                                                  .data!
                                                                  .data
                                                                  .answers[
                                                                      index]
                                                                  .isRight ==
                                                              1
                                                          ? Colors.green
                                                              .withOpacity(0.5)
                                                          : Colors.red
                                                              .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: isTablet
                                                          ? 30.h
                                                          : 30.h,
                                                      width: isTablet
                                                          ? 20.w
                                                          : 30.w,
                                                      padding:
                                                          EdgeInsets.all(6),
                                                      margin: EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                          color: Color(0xFFB7D6F9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      isTablet
                                                                          ? 35
                                                                          : 15)),
                                                      child: Text(
                                                          testVariant[index],style: TextStyle(fontWeight: FontWeight.bold),),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .data
                                                            .answers[index]
                                                            .text,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40, top: 40),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isShowDialog = true;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox();
                    }
                    return const SizedBox();
                  }),
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
