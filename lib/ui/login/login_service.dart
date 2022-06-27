import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/domain/admin/admin.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/logic/admin/admin_bloc.dart';
import 'package:sphere/ui/shared/app_alert.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';

class LoginService extends GetxService with StreamSubscriberMixin {
  LoginService({
    AdminBloc? adminBloc
}) : _adminBloc = adminBloc ?? GetIt.I.get();

  final AdminBloc _adminBloc;

  final admin = const Admin(id: 0, login: '', password: '').obsDeco();


  @override
  void onInit() {
    super.onInit();
    subscribeIt(_adminBloc.stream.listen(_processAdmin));
  }

  void _processAdmin(AdminState state) {
    state.maybeWhen(orElse: () => left(ExtendedErrors.empty),
    login: (d) => d.maybeWhen(orElse: () => left(ExtendedErrors.empty()),
    result: (r) => r.fold(
        (l) => appAlert(value: l.error, color: AppColors.red),
        (r) => admin.value = r,
    )),
    register: (d) => d.maybeWhen(orElse: () => left(ExtendedErrors.empty()),
        result: (r) => r.fold(
              (l) => appAlert(value: l.error, color: AppColors.red),
              (r) => admin.value = r,
        )
    ));
  }

  Future<void> login(AddAdminBody value) async {
    _adminBloc.add(AdminEvent.login(value));
    await _adminBloc.stream.firstWhere((element) => element == const AdminState.logined());
  }

  Future<void> register(AddAdminBody value) async {
    _adminBloc.add(AdminEvent.register(value));
    await _adminBloc.stream.firstWhere((element) => element == const AdminState.registered());
  }
}