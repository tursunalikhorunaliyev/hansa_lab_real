import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:hansa_lab/api_services/welcome_api.dart';
import 'package:hansa_lab/screens/details.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'api_models.dart/article_model.dart';
import 'blocs/article_bloc.dart';
import 'blocs/menu_events_bloc.dart';

class DynamicLinkHelper {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks(
      BuildContext context,
      token,
      ArticleBLoC articleBLoC,
      MenuEventsBloC menuEventsBloC,
      WelcomeApi welcomeApi,
   ) async {
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      if (dynamicLinkData.link.path == "/details") {
        menuEventsBloC.eventSink.add(MenuActions.article);
        ArticleModel statiModel =
            await articleBLoC.getArticle(token, welcomeApi.list[0].link);
        articleBLoC.sink.add(statiModel);
      }
    }).onError((error) {

    });
  }

  Future<void> createDynamicLink(String screenPath) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://hansalabru.page.link',
      link: Uri.parse('https://hansalabru.page.link/$screenPath'),
      androidParameters: const AndroidParameters(
        packageName: 'com.hansa.hansa_lab',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.hansa.hansahansalab',
        minimumVersion: '1',
      ),
    );

    Uri url;

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;
    Share.share(url.toString());
  }
}
