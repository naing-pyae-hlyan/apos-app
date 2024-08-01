import 'dart:async';

import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoUtils {
  static PackageInfo? _packageInfo;

  static Future<PackageInfo> packageInfo() async {
    if (_packageInfo != null) {
      return _packageInfo!;
    }

    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (e) {
      _packageInfo = PackageInfo(
        version: '',
        buildNumber: '',
        packageName: '',
        appName: '',
      );
    }

    return _packageInfo!;
  }
}
