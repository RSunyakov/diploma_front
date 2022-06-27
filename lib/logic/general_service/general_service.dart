import 'package:get/get.dart';
import 'package:sphere/logic/auth/auth_service.dart';
import 'package:sphere/ui/custom_scaffold/custom_scaffold_service.dart';
import 'package:sphere/ui/login/login_service.dart';
import 'package:sphere/ui/question/question_service.dart';
import 'package:sphere/ui/screens/settings/screens/language/language.dart';
import 'package:sphere/ui/screens/settings/screens/private_settings/private_settings_screen_service.dart';
import 'package:sphere/ui/shared/widgets/app_scaffold/app_scaffold_service.dart';
import 'package:sphere/ui/test/test_service.dart';
import 'package:sphere/ui/user/user_screen_service.dart';

import '../../ui/screens/settings/src/settings_service.dart';
import '../../ui/shared/services/image_picker_service.dart';
import '../../ui/shared/services/timer_service.dart';

/// Рекомендуется все сервисы регать через ленивые фабрики.
/// Это единственный способ реинициализировать весь жизненный цикл.
Future registerServices() async {
  Get

    ..lazyPut(() => LanguageScreenService())
    ..lazyPut(() => AuthService()..registerOnCloseWhenReloadAll())
    ..lazyPut(() => ImagePickerService())
    ..lazyPut(() => TimerService()..registerOnCloseWhenReloadAll())
    ..lazyPut(() => AppScaffoldService()..registerOnCloseWhenReloadAll())
    ..lazyPut(() => SettingsService()..registerOnCloseWhenReloadAll())
    ..lazyPut(
        () => PrivateSettingsScreenService()..registerOnCloseWhenReloadAll())
    ..lazyPut(() => QuestionService()..registerOnCloseWhenReloadAll())
    ..lazyPut(() => TestService()..registerOnCloseWhenReloadAll())
    ..lazyPut(() => CustomScaffoldService()..registerOnCloseWhenReloadAll())
    ..lazyPut(() => UserScreenService()..registerOnCloseWhenReloadAll())
    ..lazyPut(() => LoginService());

  // Сразу инициализируем
  forceInitServices();
}

/// Реинициализация жизненного цикла.
/// Работает, если только сервис зареган при помощи фабрики.
Future forceInitServices() async {
  Get
    .find<LanguageScreenService>();
}
