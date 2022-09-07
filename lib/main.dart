import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hansa_lab/api_services/country_type_service.dart';
import 'package:hansa_lab/blocs/article_bloc.dart';
import 'package:hansa_lab/blocs/bloc_change_profile.dart';
import 'package:hansa_lab/blocs/bloc_change_title.dart';
import 'package:hansa_lab/blocs/bloc_detect_tap.dart';
import 'package:hansa_lab/blocs/bloc_flip_login.dart';
import 'package:hansa_lab/blocs/bloc_play_video.dart';
import 'package:hansa_lab/blocs/bloc_video_controll.dart';
import 'package:hansa_lab/blocs/download_progress_bloc.dart';
import 'package:hansa_lab/blocs/login_clicked_bloc.dart';
import 'package:hansa_lab/blocs/menu_events_bloc.dart';
import 'package:hansa_lab/blocs/read_stati_bloc.dart';
import 'package:hansa_lab/blocs/voyti_ili_sozdata_bloc.dart';
import 'package:hansa_lab/classes/notification_functions.dart';
import 'package:hansa_lab/classes/notification_token.dart';
import 'package:hansa_lab/classes/send_analise_download.dart';
import 'package:hansa_lab/classes/send_check_switcher.dart';
import 'package:hansa_lab/classes/send_data_personal_update.dart';
import 'package:hansa_lab/classes/send_link.dart';
import 'package:hansa_lab/classes/sned_url_prezent_otkrit.dart';
import 'package:hansa_lab/classes/tap_favorite.dart';
import 'package:hansa_lab/firebase_options.dart';
import 'package:hansa_lab/middle_part_widgets/permission_handler_screen.dart';
import 'package:hansa_lab/providers/dialog_video_provider.dart';
import 'package:hansa_lab/providers/event_title_provider.dart';
import 'package:hansa_lab/providers/full_registr_provider.dart';
import 'package:hansa_lab/providers/fullname_provider.dart';
import 'package:hansa_lab/providers/is_video_provider.dart';
import 'package:hansa_lab/providers/new_shop_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/flip_login_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/login_clicked_provider.dart';
import 'package:hansa_lab/providers/provider_for_flipping/provider_for_flipping.dart';
import 'package:hansa_lab/blocs/toggle_switcher_bloc.dart';
import 'package:hansa_lab/providers/provider_otpravit_push_uvodamleniya.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_index_provider.dart';
import 'package:hansa_lab/providers/providers_for_video_title/video_title_provider.dart';
import 'package:hansa_lab/providers/stati_id_provider.dart';
import 'package:hansa_lab/providers/treningi_photos_provider.dart';
import 'package:hansa_lab/providers/treningi_video_changer_provider.dart';
import 'package:hansa_lab/providers/treningi_videos_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Hive.initFlutter();
  await Hive.openBox("savedUser");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initMessaging();
  listenForeground(channel);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

    Size size = WidgetsBinding.instance.window.physicalSize;
    bool isTablet = (size.width / 3) > 500;
    Map<String, FlipCardController> map = {
      "login": FlipCardController(),
      "signin": FlipCardController()
    };
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MultiProvider(
        providers: [
          Provider(create: (context) => NotificationToken()),
          Provider(create: (context) => SendCheckSwitcher()),
          Provider(create: (context) => DownloadProgressFileBloc()),
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
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [Locale("en"), Locale("ru"), Locale("ar")],
          locale: Locale("ru"),
          debugShowCheckedModeBanner: false,
          home: PermissionHandlerScreen(),
        ),
      ),
    );
  }
}
