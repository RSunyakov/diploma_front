import 'package:auto_route/auto_route.dart';
import 'package:sphere/ui/login/login_screen.dart';
import 'package:sphere/ui/login/registration_screen.dart';
import 'package:sphere/ui/question/question_screen.dart';
import 'package:sphere/ui/screens/settings/src/settings_screen.dart';
import 'package:sphere/ui/skill/skill_screen.dart';
import 'package:sphere/ui/test/test_screen.dart';
import 'package:sphere/ui/user/user_screen.dart';

import '../screens/settings/screens/account_notification_settings/account_notification_settings_screen.dart';
import '../screens/settings/screens/general_settings/change_email_screen.dart';
import '../screens/settings/screens/general_settings/change_phone_screen.dart';
import '../screens/settings/screens/general_settings/general_settings_screen.dart';
import '../screens/settings/screens/generate_report/generate_report_screen.dart';
import '../screens/settings/screens/license_agreement/license_agreement_screen.dart';
import '../screens/settings/screens/mentor_settings/mentor_settings_screen.dart';
import '../screens/settings/screens/notification_settings/notification_settings_screen.dart';
import '../screens/settings/screens/page_settings/page_settings_screen.dart';
import '../screens/settings/screens/private_settings/private_settings_screen.dart';
import '../screens/settings/screens/safety_settings/two_fa_verification_screen.dart';
import '../screens/settings/screens/safety_settings/account_logins_screen.dart';
import '../screens/settings/screens/safety_settings/safety_settings_screen.dart';
import '../screens/settings/screens/wallet_settings/wallet_settings_screen.dart';
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
    CustomRoute(
      page: SettingsScreen,
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
    CustomRoute(
      page: GeneralSettingsScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: ChangeEmailScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: ChangePhoneScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: LicenseAgreementScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: NotificationSettingsScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: GenerateReportScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: PrivateSettingsScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: SafetySettingsScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: WalletSettingsScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: AccountLoginsScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: TwoFAVerificationScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: AccountNotificationSettingsScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: SettingsScreen,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      durationInMilliseconds: 500,
    ),
    CustomRoute(
      page: AccountNotificationSettingsScreen,
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
