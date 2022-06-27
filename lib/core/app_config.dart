import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class IAppConfig {
  PackageInfo get packageInfo;
}

class AppConfig implements IAppConfig {
  factory AppConfig() {
    return _singleton;
  }

  AppConfig._();

  static final AppConfig _singleton = AppConfig._();

  // ignore: non_constant_identifier_names
  static bool get isProduction =>
      kReleaseMode || environment.toLowerCase().startsWith('prod');
  // // ignore: non_constant_identifier_names
  // ignore: non_constant_identifier_names
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'dev';

  // ignore: non_constant_identifier_names
  static String get apiEndpoint => dotenv.env['API_URI'] ?? '';

  // ignore: non_constant_identifier_names
  static String? get sentryDNS => dotenv.env['SENTRY_DNS'];

  // Only for development
  static String? get devUsername => dotenv.env['DEV_USER_NAME'];
  static String? get devPassword => dotenv.env['DEV_USER_PASSWORD'];

  // ignore: non_constant_identifier_names
  static String get OS => Platform.operatingSystem;

  static String? _appVersion;
  // ignore: non_constant_identifier_names
  static String? get appVersion => _appVersion;

  static String? _packageName;
  // ignore: non_constant_identifier_names
  static String? get packageName => _packageName;

  static bool _isAndroid = false;
  static bool get isAndroid => _isAndroid;

  static bool _isIOS = false;
  static bool get isIOS => _isIOS;

  static const String appName = 'Teremok';

  static String _deviceName = '';
  // ignore: non_constant_identifier_names
  static String get deviceName => _deviceName;

  // ignore: non_constant_identifier_names
  static List<String> get testers => dotenv.env.containsKey('TESTERS')
      ? dotenv.env['TESTERS']!.split(',').toList()
      : [''];

  @override
  late PackageInfo packageInfo;

  Future load() async {
    await dotenv.load(fileName: 'assets/.env');

    packageInfo = await PackageInfo.fromPlatform();
    _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

    _packageName = packageInfo.packageName;

    /*final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final di = await deviceInfo.androidInfo;
      _isAndroid = true;
      _deviceName = '${di.model} ${di.product}';
    } else if (Platform.isIOS) {
      final di = await deviceInfo.iosInfo;
      _isIOS = true;
      _deviceName = '${di.name} ${di.systemName} ${di.systemVersion}';
    }*/

    log('APP_ID: $packageName');
    log('ENVIRONMENT: $environment');
    log('APP_VERSION: $appVersion');
    log('DEVICE: $_deviceName');
    log('API ENDPOINT: $apiEndpoint');
  }
}
