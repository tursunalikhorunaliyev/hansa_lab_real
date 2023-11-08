import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:share_plus/share_plus.dart';

import 'api_models.dart/article_model.dart';
import 'blocs/article_bloc.dart';
import 'blocs/menu_events_bloc.dart';

class DynamicLinkHelper {
 static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks(
    BuildContext context,
    token,
    ArticleBLoC articleBLoC,
    MenuEventsBloC menuEventsBloC,
    WelcomeApi welcomeApi,
  ) async {
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      print(dynamicLinkData.link);
      print(dynamicLinkData.link.path);
      if (dynamicLinkData.link.path == "/site/article/") {
        menuEventsBloC.eventSink.add(MenuActions.article);
        ArticleModel statiModel =
            await articleBLoC.getArticle(token, welcomeApi.list[0].link);
        articleBLoC.sink.add(statiModel);
      }
    }).onError((error) {});
  }

  // Future<void> createDynamicLink(String screenPath) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: 'https://hansalabru.page.link',
  //     link: Uri.parse('https://hansalabru.page.link/$screenPath'),
  //     androidParameters: const AndroidParameters(
  //       packageName: 'com.hansa.hansa_lab',
  //       minimumVersion: 1,
  //     ),
  //     iosParameters: const IOSParameters(
  //       bundleId: 'com.hansa.hansahansalab',
  //       minimumVersion: '1',
  //     ),
  //   );
  //
  //   Uri url;
  //
  //   final ShortDynamicLink shortLink =
  //       await dynamicLinks.buildShortLink(parameters);
  //   url = shortLink.shortUrl;
  //   Share.share(url.toString());
  // }

 static  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://hansalabru.page.link', // Replace with your dynamic link domain
      link: Uri.parse('https://hansa-lab.ru/site/article?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.hansa.hansa_lab', // Replace with your Android app package name
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.hansa.hansahansalab', // Replace with your iOS app bundle ID
        appStoreId: '6444158285', // Replace with your iOS app store ID
      ),
    );
    print(parameters);
    final ShortDynamicLink shortDynamicLink = await dynamicLinks.buildShortLink(parameters);
    return shortDynamicLink.shortUrl;
  }
}
