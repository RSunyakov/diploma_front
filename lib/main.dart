import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sphere/core/app_config.dart';
import 'package:sphere/core/injection.dart';
import 'package:sphere/core/utils/app_calcs.dart';
import 'package:sphere/logic/general_service/general_service.dart';
import 'package:sphere/ui/router/router.dart';
import 'package:sphere/ui/screens/settings/screens/language/language.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  debugPrint('$now: MAINMAIN');

  await AppConfig().load();

  configureDependencies(Environment.prod);

  await registerServices();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).whenComplete(
    () async {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
      final lang = Get.find<LanguageScreenService>();
      runApp(
        EasyLocalization(
          saveLocale: true,
          supportedLocales: lang.mapLang.keys.map((e) => Locale(e)).toList(),
          path: 'assets/translations',
          startLocale: Locale(lang.language$.name),
          fallbackLocale: Locale(lang.language$.name),
          child: const SiriusApp(),
        ),
      );
    },
  );
}
//

class SiriusApp extends StatelessWidget {
  const SiriusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GetMaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routerDelegate: AppRouter.delegate(),
        routeInformationProvider: AppRouter.routeInfoProvider(),
        routeInformationParser: AppRouter.defaultRouteParser(),
        // TODO(vvk): пришлось закомментить, чтобы прикрутить
        //  надо проверить!
        // builder: (_, router) => router!,
        builder: (ctx, router) {
          initContextApp(ctx);
          return router ?? const SizedBox();
        },
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          if (deviceLocale != context.locale) {
            Future.delayed(Duration.zero)
                .then((_) => Get.updateLocale(context.locale));
          }
          Get.find<LanguageScreenService>().startLang(deviceLocale, context);
          return deviceLocale;
        },
      ),
    );
  }
}
