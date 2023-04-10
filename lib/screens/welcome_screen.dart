import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/api_models.dart/question_day_model.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:hansa_lab/blocs/article_bloc.dart';
import 'package:hansa_lab/blocs/bloc_obucheniya.dart';
import 'package:hansa_lab/blocs/fcm_article_bloc.dart';
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
  late final String _token;
  late final MenuEventsBloC _menuProvider;
  late final ArticleBLoC _articleBloc;
  late final FcmArticleBloC _fcmArticleBloc;

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
    _token = Provider.of<String>(context, listen: false);
    _menuProvider = Provider.of<MenuEventsBloC>(context, listen: false);
    _articleBloc = Provider.of<ArticleBLoC>(context, listen: false);
    _fcmArticleBloc = Provider.of<FcmArticleBloC>(context, listen: false);
    _fcmArticleBloc.addListener(_fetchNewArticle);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), _fetchNewArticle);
    });
    super.initState();
  }

  void _fetchNewArticle() async {
    if (_fcmArticleBloc.empty) return;
    final link = _fcmArticleBloc.articleLink;
    final articleModel = await _articleBloc.getArticle(_token, link);
    _menuProvider.eventSink.add(MenuActions.article);
    Future.delayed(const Duration(seconds: 2), () {
      _articleBloc.sink.add(articleModel);
      _fcmArticleBloc.articleId = null;
    });
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
    final articleBloc = Provider.of<ArticleBLoC>(context);
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
              drawer: MultiProvider(
                providers: [
                  Provider(create: (context) => ProviderPersonalTextFields()),
                  Provider(create: (context) => providerScaffoldKey),
                  Provider<WelcomeApi>(
                    create: (context) => welcomeApi,
                  ),
                  Provider<BlocObucheniya>(
                    create: (context) => bloc,
                  )
                ],
                child: const GlavniyMenyu(),
              ),
              key: providerScaffoldKey,
              bottomNavigationBar: StreamBuilder<MenuActions>(
                  initialData: (not) ? MenuActions.stati : MenuActions.welcome,
                  stream: menuProvider.eventStream,
                  builder: (context, snapshot) {
                    return SizedBox(
                      height: 70.h,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        color: const Color(0xffffffff),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (menuProvider.list.length > 1)
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
                                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
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
                                              margin: const EdgeInsets.all(16),
                                              padding: const EdgeInsets.all(12),
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
                                              margin: const EdgeInsets.all(16),
                                              // padding: EdgeInsets.all(12),
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
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: isTablet ? 28 : 18, right: isTablet ? 28 : 18, top: 24),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 180.h,
                                                    padding: const EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        image: const DecorationImage(
                                                            fit: BoxFit.fitHeight,
                                                            image: AssetImage('assets/quizz.png'))),
                                                    child: Container(
                                                      height: isTablet ? 200 : 179.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        // gradient: LinearGradient(colors: [Color(0xFF6071C9),Color(0xFF6071C9),])
                                                        image: const DecorationImage(
                                                          fit: BoxFit.fitHeight,
                                                          image: AssetImage('assets/ssss.png'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 178.h,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.circular(12)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(20),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const Text(
                                                            'ВОПРОС ДНЯ ',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.normal),
                                                          ),
                                                          const Text(
                                                            '. . .',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.w500),
                                                          ),
                                                          const SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            snapshot.data!.data
                                                                .question.text,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                          if (isRight == 1) ...[
                                            Container(
                                              width: 48,
                                              height: 48,
                                              margin: const EdgeInsets.only(
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
                                                margin: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        color: Colors.white)),
                                                child: const Icon(
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
                                                margin: const EdgeInsets.all(8),
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
                                          if (isRight == null) ...[
                                            Container(
                                              width: 44,
                                              height: 44,
                                              margin: const EdgeInsets.only(left: 24, bottom: 18, top: 8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFB7D6F9),
                                                borderRadius: BorderRadius.circular(22),
                                              ),
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                margin: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: const Color(0xFFB7D6F9),
                                                    borderRadius: BorderRadius.circular(16),
                                                    border: Border.all(color: Colors.black)),
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
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: testVariant.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (BuildContext context, int index) {
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
                                                Future.delayed(const Duration(
                                                        seconds: 3))
                                                    .then((value) {
                                                  isShowDialog = true;
                                                  setState(() {});
                                                });
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 6, left: isTablet ? 38 : 18, right: isTablet ? 38 : 18),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: isTablet ? 76 : 55,
                                                      padding: EdgeInsets.all(isTablet ? 4 : 2),
                                                      decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill, image: AssetImage('assets/quizz.png'))),
                                                      child: Container(
                                                        height: 55,
                                                        decoration: const BoxDecoration(
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: AssetImage('assets/ssss.png'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.all(isTablet ? 14.0 : 4.0),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(isTablet ? 50 : 30)),
                                                        // gradient: LinearGradient(
                                                        //   begin: Alignment.topCenter,
                                                        //   end: Alignment.bottomCenter,
                                                        //   colors: [
                                                        //     Color(0xFF2C3757),
                                                        //     Color(0xFF1E2336),
                                                        //     // Color(0xFF252b3d),
                                                        //     // Color(0xFF000000).withOpacity(0.8),
                                                        //
                                                        //
                                                        //   ],
                                                        // ),
                                                        color: isRight == null ||
                                                                isNumber != snapshot.data!.data.answers[index].number
                                                            ? Colors.transparent
                                                            : snapshot.data!.data.answers[index].isRight == 1
                                                                ? Colors.green.withOpacity(0.5)
                                                                : Colors.red.withOpacity(0.5),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            alignment: Alignment.center,
                                                            height: isTablet ? 40 : 33,
                                                            width: isTablet ? 40 : 32,
                                                            padding: const EdgeInsets.all(6),
                                                            margin: const EdgeInsets.all(6),
                                                            decoration: BoxDecoration(
                                                                color: const Color(0xFFB7D6F9),
                                                                borderRadius:
                                                                    BorderRadius.circular(isTablet ? 35 : 15)),
                                                            child: Text(
                                                              testVariant[index],
                                                              style: const TextStyle(
                                                                  fontWeight: FontWeight.bold, fontSize: 16),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              snapshot.data!.data.answers[index].text,
                                                              style: const TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 80, right: 20, top: 80),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isShowDialog = true;
                                            });
                                          },
                                          icon: const Icon(
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
