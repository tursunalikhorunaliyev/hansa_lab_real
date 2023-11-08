import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/api_services/country_type_service.dart';
import 'package:hansa_lab/api_services/my_firebase.dart';
import 'package:hansa_lab/blocs/article_bloc.dart';
import 'package:hansa_lab/blocs/bloc_change_profile.dart';
import 'package:hansa_lab/blocs/bloc_change_title.dart';
import 'package:hansa_lab/blocs/bloc_detect_tap.dart';
import 'package:hansa_lab/blocs/bloc_flip_login.dart';
import 'package:hansa_lab/blocs/bloc_number_country.dart';
import 'package:hansa_lab/blocs/bloc_play_video.dart';
import 'package:hansa_lab/blocs/bloc_video_controll.dart';
import 'package:hansa_lab/blocs/download_progress_bloc.dart';
import 'package:hansa_lab/blocs/fcm_article_bloc.dart';
import 'package:hansa_lab/blocs/login_clicked_bloc.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/blocs/read_stati_bloc.dart';
import 'package:hansa_lab/blocs/toggle_switcher_bloc.dart';
import 'package:hansa_lab/blocs/voyti_ili_sozdata_bloc.dart';
import 'package:hansa_lab/classes/notification_functions.dart';
import 'package:hansa_lab/classes/notification_token.dart';
import 'package:hansa_lab/classes/send_analise_download.dart';
import 'package:hansa_lab/classes/send_check_switcher.dart';
import 'package:hansa_lab/classes/send_data_personal_update.dart';
import 'package:hansa_lab/classes/send_link.dart';
import 'package:hansa_lab/classes/sned_url_prezent_otkrit.dart';
import 'package:hansa_lab/classes/tap_favorite.dart';
import 'package:hansa_lab/di.dart';
import 'package:hansa_lab/firebase_options.dart';
import 'package:hansa_lab/providers/check_click.dart';
import 'package:hansa_lab/providers/dialog_video_provider.dart';
import 'package:hansa_lab/providers/event_title_provider.dart';
import 'package:hansa_lab/providers/full_registr_provider.dart';
import 'package:hansa_lab/providers/fullname_provider.dart';
import 'package:hansa_lab/providers/is_video_provider.dart';
import 'package:hansa_lab/providers/new_shop_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/flip_login_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/login_clicked_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/provider_for_flipping.dart';
import 'package:hansa_lab/providers/provider_otpravit_push_uvodamleniya.dart';
import 'package:hansa_lab/providers/providers_for_video_title/article_video_Provider.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_index_provider.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_title_provider.dart';
import 'package:hansa_lab/providers/stati_id_provider.dart';
import 'package:hansa_lab/providers/treningi_photos_provider.dart';
import 'package:hansa_lab/providers/treningi_video_changer_provider.dart';
import 'package:hansa_lab/providers/treningi_videos_provider.dart';
import 'package:hansa_lab/providers/video_ind_provider.dart';
import 'package:hansa_lab/providers/video_tit_provider.dart';
import 'package:hansa_lab/sentry_reporter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final fcmArticleBloc = FcmArticleBloC();
  fcmArticleBloc.getNewsIdFromMsg(message);
  fcmArticleBloc.logs
      .addAll({'_firebaseMessagingBackgroundHandler': '${message.data}'});
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Hive.initFlutter();
  await Hive.openBox("savedUser");
  await Hive.openBox('keyChain');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  requestMessaging();
  final fcmArticleBloc = FcmArticleBloC();
  await initMessaging(fcmArticleBloc);
  await listenForeground(fcmArticleBloc);
  await MyFirebase.ensureInitialized();
  await setup();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SentryReporter.setup(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final sendUrlPrezentOtkrit = SendUrlPrezentOtkrit();
    final tapFavorite = TapFavorite();
    final sendDataPersonalUpdate = SendDataPersonalUpdate();
    final sendAnaliseDownload = SendAnaliseDownload();
    final blocDetectTap = BlocDetectTap();
    final sendCheckSwitcher = SendCheckSwitcher();
    final providerOtpravitPushUvodamleniya = ProviderOtpravitPushUvodamleniya();
    final providerSendListPopupGorod = ProviderOtpravitPushUvodamleniya();
    final providerNumberCountry = BlocNumberCountry();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Size size = WidgetsBinding.instance.window.physicalSize;
    bool isTablet = (size.width / 3) > 500;
    Map<String, FlipCardController> map = {
      "login": FlipCardController(),
      "signin": FlipCardController(),
      "toLogin": FlipCardController(),
    };
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MultiProvider(
        providers: [
          Provider(create: (context) => NotificationToken()),
          Provider(create: (context) => SendCheckSwitcher()),
          Provider(create: (context) => DownloadProgressFileBloc()),
          Provider(create: (context) => FcmArticleBloC()),
          ChangeNotifierProvider(create: (context) => EventTitleProvider()),
          ChangeNotifierProvider(create: (context) => StatiIdProvider()),
          ChangeNotifierProvider(
              create: (context) => TreningiVideoChangerProvider()),
          ChangeNotifierProvider(create: (context) => NewShopProvider()),
          ChangeNotifierProvider(create: (context) => FlipProvider()),
          ChangeNotifierProvider(create: (context) => LoginClickedProvider()),
          ChangeNotifierProvider(create: (context) => FlipLoginProvider()),
          Provider(create: (context) => BlocVideoControll()),
          ChangeNotifierProvider(create: (context) => TreningiVideosProvider()),
          ChangeNotifierProvider(create: (context) => IsVideoprovider()),
          ChangeNotifierProvider(create: (context) => VideoTitleProvider()),
          ChangeNotifierProvider(create: (context) => VideoIndexProvider()),
          ChangeNotifierProvider(create: (context) => ArticleTitleProvider()),
          ChangeNotifierProvider(create: (context) => TreningiPhotosProvider()),
          ChangeNotifierProvider(
              create: (context) => FullRegisterDataProvider()),
          Provider(create: (context) => CountryTypeService().getCountryTypes()),
          Provider(create: (context) => ToggleSwitcherBloc()),
          Provider<bool>(create: (context) => isTablet),
          Provider(create: (context) => BlocChangeTitle()),
          Provider(create: (context) => BlocChangeTitleIndex()),
          Provider(create: (context) => map),
          Provider(create: (context) => VoytiIliSozdatBloC()),
          Provider<BlocNumberCountry>(
              create: (context) => providerNumberCountry),
          Provider(create: (context) => ReadStatiBLoC()),
          Provider(create: (context) => MenuEventsBloC()),
          Provider(create: (context) => ArticleBLoC()),
          Provider(create: (context) => BlocPlayVideo()),
          Provider(create: (context) => BlocChangeProfile()),
          Provider(create: (context) => LoginClickedBloc()),
          Provider(create: (context) => BlocFlipLogin()),
          ChangeNotifierProvider(create: (context) => DialogVideoProvider()),
          Provider(create: (context) => scaffoldKey),
          Provider(create: (context) => FullnameProvider()),
          ChangeNotifierProvider(create: (context) => SendLink()),
          Provider<SendUrlPrezentOtkrit>(
              create: (context) => sendUrlPrezentOtkrit),
          Provider<TapFavorite>(create: (context) => tapFavorite),
          Provider<SendDataPersonalUpdate>(
              create: (context) => sendDataPersonalUpdate),
          ChangeNotifierProvider<SendAnaliseDownload>(
              create: (context) => sendAnaliseDownload),
          Provider<BlocDetectTap>(create: (context) => blocDetectTap),
          Provider<SendCheckSwitcher>(create: (context) => sendCheckSwitcher),
          ChangeNotifierProvider<ProviderOtpravitPushUvodamleniya>(
              create: (context) => providerOtpravitPushUvodamleniya),
          ChangeNotifierProvider(
            create: (context) => CheckClick(),
          ),
          ChangeNotifierProvider<ProviderOtpravitPushUvodamleniya>(
            create: (context) => providerSendListPopupGorod,
          ),
          Provider(
            create: (context) => VideoTitProvider(),
          ),
          Provider(
            create: (context) => VideoIndProvider(),
          ),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            //set as per your  status bar color
            systemNavigationBarColor: Colors.white,
            //set as per your navigation bar color
            statusBarIconBrightness: Brightness.dark,
            //set as per your status bar icons' color
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!);
            },
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [Locale("en"), Locale("ru"), Locale("ar")],
            locale: const Locale("ru"),
            debugShowCheckedModeBanner: false,
            home: home,
          ),
        ),
      ),
    );
  }
}
