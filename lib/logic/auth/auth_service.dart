import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/utils/get_rx_wrapper.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:sphere/domain/auth_data/auth_data.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/logic/auth/auth_bloc.dart';
import 'package:sphere/ui/router/router.dart';
import 'package:sphere/ui/router/router.gr.dart';
import 'package:vfx_flutter_common/utils.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  AuthService get authService;
}

class AuthService extends GetxService with StreamSubscriberMixin {
  AuthService({AuthBloc? bloc}) : _bloc = bloc ?? GetIt.I.get() {
    // GetxReloadAllFixer.register(this);
  }

  final state = GetRxWrapper(const AuthState.initial());

  final authData = GetRxWrapper(AuthData.initial());

  late final login = GetRxWrapper(PhoneOrEmail.tagged(''));

  late final code = GetRxWrapper(NonEmptyString(''));

  final AuthBloc _bloc;

  var _loggedOut = false;

  void fetchCodeForSignIn() {
    _bloc.add(AuthEvent.fetchCodeForSignIn(
        login: NonEmptyString(login.value$.value.fold((l) => '', (r) => r))));
  }

  void fetchCodeForSignInViaPhone() {
    _bloc.add(AuthEvent.fetchCodeForSignIn(
        login: NonEmptyString(login.value$.value.fold((l) => '', (r) => r))));
  }

  void fetchCodeAgain() {
    _bloc.add(
      AuthEvent.fetchCodeForSignInRepeated(
        login: NonEmptyString(login.value$.value.fold((l) => '', (r) => r)),
      ),
    );
  }

  void signIn() {
    _bloc.add(
      AuthEvent.signIn(
        login: NonEmptyString(login.value$.value.fold((l) => '', (r) => r)),
        code: code.value$,
      ),
    );
  }

  void signInViaPhone() {
    _bloc.add(
      AuthEvent.signIn(
        login: NonEmptyString(login.value$.value.fold((l) => '', (r) => r)),
        code: code.value$,
      ),
    );
  }

  void logout() {
    if (_loggedOut) {
      return;
    }
    _loggedOut = true;

    _bloc.add(AuthEvent.logout(authData.value$));

    /*delayMilli(500).then((_) {
      AppRouter.replace(SplashRoute());
      GetxReloadAllFixer.reloadAll();
    });*/
  }

  void dropToken() {
    _bloc.add(const AuthEvent.dropToken());
  }

  void tryAuth() {
    _bloc.add(const AuthEvent.fetchAuthData());
  }

  void checkIfFirstTime() {
    _bloc.add(AuthEvent.firstTimeResolveUser(authData: authData.value$));
  }

  void viaGoogle() {
    _bloc.add(const AuthEvent.enterViaGoogle());
  }

  void viaFaceId() {
    _bloc.add(const AuthEvent.enterViaFaceId());
  }

  @override
  void onInit() {
    super.onInit();
    subscribeIt(_bloc.stream.listen(_processState));
  }

  void _processState(AuthState state) {
    debugPrint('$now: AuthService._processState: $state');
    this.state.value = state;
    try {
      /*authData.value = */ state.maybeWhen(
        authPassed: (d) => d.maybeWhen(
          result: (r) => r.fold((l) => AuthData.initial(), (r) {
            // в этом случае, увы надо прямо записать.
            // Иначе DIO еще не видит ничего
            authData.value = r;
            _bloc.add(AuthEvent.firstTimeResolveUser(authData: r));
            return r;
          }),
          orElse: () {},
        ),
        authDataFetched: (d) => d.maybeWhen(
          result: (r) => r.fold((l) => AuthData.initial(), (r) {
            // в этом случае, увы надо прямо записать.
            // Иначе DIO еще не видит ничего
            authData.value = r;
            checkIfFirstTime();
          }),
          orElse: () {},
        ),
        signInCodeFetched: (d) {},
        loggedOut: (d) => _loggedOut = false,
        orElse: () {},
      );
    } catch (e, s) {
      debugPrint(s.toString());
    }
  }
}
