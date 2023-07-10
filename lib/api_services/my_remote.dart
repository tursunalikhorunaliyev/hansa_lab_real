import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum UpdateType { none, small, middle, large }

class MyRemote {
  static RemoteConfig remoteConfig = RemoteConfig.instance;
  static Map<String, dynamic> dataUpdate = {};
  static Map<String, dynamic> dataUz = {};
  static Map<String, dynamic> dataRu = {};

  static Future<void> ensureInitialized() async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));

      await remoteConfig.fetchAndActivate();

      final data = remoteConfig.getAll();

      if (data["update_key"] != null) {
        dataUpdate = jsonDecode(data["update_key"]!.asString());
      }
    } catch (_) {}
  }

  static Future<UpdateType> getUpdateType() async {
    try {
      String serverVersion = dataUpdate[Platform.isAndroid ? "android" : "ios"];
      String currentVersion = (await PackageInfo.fromPlatform()).version;
      final serverList = serverVersion.split(".").map((e) => int.parse(e));
      final currentList = currentVersion.split(".").map((e) => int.parse(e));
      if (serverList.elementAt(0) > currentList.elementAt(0)) {
        return UpdateType.large;
      }
      if (serverList.elementAt(0) < currentList.elementAt(0)) {
        return UpdateType.none;
      }
      if (serverList.elementAt(1) > currentList.elementAt(1)) {
        return UpdateType.middle;
      }
      if (serverList.elementAt(1) < currentList.elementAt(1)) {
        return UpdateType.none;
      }
      if (serverList.elementAt(2) > currentList.elementAt(2)) {
        return UpdateType.small;
      }
      if (serverList.elementAt(2) < currentList.elementAt(2)) {
        return UpdateType.none;
      }
    } catch (_) {}
    return UpdateType.none;
  }
}
