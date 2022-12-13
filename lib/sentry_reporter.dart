import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryReporter {
  static Future<void> setup(Widget child) async {

    await SentryFlutter.init(
          (option) {
        option.dsn = 'https://b5218ddd1c174a8a820f7bc93f855bb6@o4503926644801536.ingest.sentry.io/4504318739021824';
        option.tracesSampleRate = 1.0;
        option.reportPackages = false;
        option.considerInAppFramesByDefault = false;
      },
      appRunner: () => runApp(
        DefaultAssetBundle(
          bundle: SentryAssetBundle(enableStructuredDataTracing: true),
          child: child,
        ),),
    );
  }
}