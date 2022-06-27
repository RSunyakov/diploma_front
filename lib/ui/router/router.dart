import 'package:auto_route/auto_route.dart';
import 'package:sphere/ui/login/login_screen.dart';
import 'package:sphere/ui/login/registration_screen.dart';
import 'package:sphere/ui/question/question_screen.dart';
import 'package:sphere/ui/skill/skill_screen.dart';
import 'package:sphere/ui/test/test_screen.dart';
import 'package:sphere/ui/user/user_screen.dart';

import 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen|Dialog,Route',
  routes: <AutoRoute>[
    CustomRoute(page: LoginScreen, initial: true),
    CustomRoute(
      page: RegistrationScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: TestScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(page: SkillScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: UserScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $RootRouter {}

// ignore: non_constant_identifier_names
final AppRouter = RootRouter();

/// Для быстрой передачи аргументов дебага роутера
/// ```dart
///   debugPrint('$now: Some.someMethod: $debugRouter');
/// ```
String get debugRouter {
  return '(${AppRouter.stack.length}) : ${AppRouter.stack}';
}

/// Позволяет работать как-то так
/// ```dart
///   void clickAddButton(Widget child) {
///     chooseBottomSheet(appContext, child: child);
///   }
/// ```
final appContext = AppRouter.navigatorKey.currentContext!;
