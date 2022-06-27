import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/users/user_domain.dart';
import 'package:sphere/logic/user/user_bloc.dart';
import 'package:sphere/ui/login/login_service.dart';
import 'package:sphere/ui/shared/app_alert.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';

class UserScreenService extends GetxService with StreamSubscriberMixin {
  UserScreenService({
    UserBloc? userBloc,
    LoginService? loginService
}) : _userBloc = userBloc ?? GetIt.I.get(),
     _loginService = loginService ?? Get.find();

  final UserBloc _userBloc;

  final LoginService _loginService;

  final users = <UserDomain>[].obsDeco();

  @override
  void onInit() {
    super.onInit();
    subscribeIt(_userBloc.stream.listen(_processUser));
    getUsers();
  }


  void _processUser(UserState state) {
    state.maybeWhen(orElse: () => left(ExtendedErrors.empty()),
    gotUserList: (d) => d.maybeWhen(orElse: () => left(ExtendedErrors.empty()),
    result: (r) {
      r.fold((l) => appAlert(value: l.error, color: AppColors.red), (r) => users.value = r);
    }),
    addTestsToUser: (d) => d.maybeWhen(orElse: () => left(ExtendedErrors.empty()),
    result: (r) => r.fold((l) => appAlert(value: l.error, color: AppColors.red), (r) {
      for (int i = 0; i < users.value.length; i++) {
        if (users.value[i].userId == r.userId) {
          users.value[i] = r;
          users.refresh();
        }
      }
    })));
  }

  void getUsers() {
    _userBloc.add(UserEvent.getUserList(_loginService.admin.value.id));
  }

  void addTestsToUser(String userId, List<TestDataDto> value) {
    _userBloc.add(UserEvent.addTestsToUser(userId, value));
  }
}