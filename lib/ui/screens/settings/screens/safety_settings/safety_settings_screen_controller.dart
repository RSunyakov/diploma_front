import 'package:vfx_flutter_common/getx_helpers.dart';

import '../../../../router/router.dart';
import '../../../../router/router.gr.dart';

class SafetySettingsScreenController extends StatexController {
  void toAccountLogins() => AppRouter.push(AccountLoginsRoute());

  void to2FAVerification() => AppRouter.push(TwoFAVerificationRoute());
}
