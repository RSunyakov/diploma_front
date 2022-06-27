import 'package:get/get.dart';
import 'package:sphere/ui/custom_scaffold/custom_scaffold_service.dart';
import 'package:sphere/ui/login/login_service.dart';
import 'package:sphere/ui/question/question_service.dart';
import 'package:sphere/ui/screens/settings/screens/language/language.dart';
import 'package:sphere/ui/test/test_service.dart';
import 'package:sphere/ui/user/user_screen_service.dart';

/// Рекомендуется все сервисы регать через ленивые фабрики.
/// Это единственный способ реинициализировать весь жизненный цикл.
Future registerServices() async {
  Get

    ..lazyPut(() => LanguageScreenService())
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
