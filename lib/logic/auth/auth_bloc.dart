import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as local_auth_error;
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/auth_data/auth_data.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/user/user.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';
import 'package:sphere/logic/repository/repository.dart';
import 'package:sphere/logic/auth/firebase_service.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

part 'auth_bloc.freezed.dart';

@prod
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.initial()) {
    on<_FetchAuthDataEvent>(_fetchAuthData);
    on<_FetchCodeForSignInEvent>(_fetchCodeForSignIn);
    on<_FetchCodeForSignInRepeatedEvent>(_fetchCodeForSignInRepeated);
    on<_FetchCodeForChangeLoginEvent>(_fetchCodeForChangeLogin);
    on<_FetchCodeForChangeLoginRepeatedEvent>(_fetchCodeForChangeLoginRepeated);
    on<_SignInEvent>(_signIn);
    on<_FirstTimeResolveUser>(_firstTimeResolveUser);
    on<_EnterViaGoogleEvent>(_enterViaGoogle);
    on<_EnterViaFaceIdEvent>(_enterViaFaceId);
    on<_LogoutEvent>(_logout);
    on<_DropTokenEvent>(_dropToken);
  }

  late final Repository _repo = GetIt.I.get();

  /// Запрос сохраненных данных авторизации
  Future _fetchAuthData(AuthEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.authDataFetched(AuthStateData.loading()));

    Either<String, AuthData> authData = right(AuthData.initial());
    final authMethod = await _repo.readAuthMethod();

    authData = await authMethod.fold(
      (l) => left(l),
      (r) async {
        if (r is AuthMethodInitial) {
          return left('messages.should_auth'.tr());
        }

        //
        if (r is AuthMethodGoogle) {
        }

        //
        return right(AuthData(authMethod: r, user: User.empty()));
      },
    );

    emit(AuthState.authDataFetched(AuthStateData.result(authData)));
  }

  /// Запрос кода для авторизации по телефономылу.
  Future _fetchCodeForSignIn(
      _FetchCodeForSignInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.signInCodeFetched(AuthStateData.loading()));
    try {
      final rez = await _repo.fetchCode(login: event.login);
      emit(AuthState.signInCodeFetched(AuthStateData.result(rez)));
    } on Exception catch (e) {
      emit(AuthState.signInCodeFetched(
          AuthStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }

  /// Запрос кода для авторизации по телефономылу.
  Future _fetchCodeForSignInRepeated(
      _FetchCodeForSignInRepeatedEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.signInCodeRepeatedFetched(AuthStateData.loading()));
    await delayMilli(500);
    try {
      final rez = await _repo.fetchCode(login: event.login);
      emit(AuthState.signInCodeRepeatedFetched(AuthStateData.result(rez)));
    } on Exception catch (e) {
      emit(AuthState.signInCodeRepeatedFetched(
          AuthStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }

  /// Вход по телефономылу.
  Future _signIn(_SignInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.authPassed(AuthStateData.loading()));

    Either<String, AuthData> authData = right(AuthData.initial());
    var authMethod = const AuthMethod.initial();

    try {
      final rez = await _repo.signIn(login: event.login, code: event.code);

      // FIXME(vvk): история с токеном жопская конечно, дублировать его
      //  не надо бы. По идее токен должен быть например в authMethod только.
      //  Но вот из Гугло в фече мы возвращаем юзера с токеном гугла
      //  (который может меняться гуглом каждый раз).
      //  Пока токен юзера мы не будем использовать.
      // final user = User(
      //     name: event.login,
      //     deprecatedToken:
      //         rez.fold((l) => const Token.invalid(), (r) => r.token));

      await rez.fold(
        (l) async {
          authMethod = AuthMethod.phoneOrEmail(
            login: event.login,
            token: Token.tagged(''),
          );
          authData = left(l.error);
        },
        (r) async {
          authMethod = AuthMethod.phoneOrEmail(
            login: event.login,
            token: r.token,
          );
          await _repo.writeAuthMethod(authMethod);
          authData =
              right(AuthData(authMethod: authMethod, user: User.empty()));
        },
      );
    } on Exception catch (e) {
      authData = left('$e');
    }

    emit(AuthState.authPassed(AuthStateData.result(authData)));
  }

  Future _firstTimeResolveUser(
      _FirstTimeResolveUser event, Emitter<AuthState> emit) async {
    emit(const AuthState.firstTimeUserResolved(AuthStateData.loading()));
    final us = await _repo.getUserSettings();
    emit(AuthState.firstTimeUserResolved(AuthStateData.result(us)));
  }

  /// Вход по GoogleSignIn
  Future _enterViaGoogle(AuthEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.authPassed(AuthStateData.loading()));
    Either<String, AuthData> authData = right(AuthData.initial());
    var authMethod = const AuthMethod.initial();

   /* try {
      final service = FirebaseService();
      final user = await service.signInWithGoogle();
      authMethod = const AuthMethod.google(token: Token.invalid());
      authData = right(AuthData(authMethod: authMethod, user: user));
    } on fb.FirebaseAuthException catch (_) {
      authData = left('messages.auth_repo_error'.tr());
    } on PlatformException catch (_) {
      authData = left('general.wrong_platform'.tr());
    } catch (e) {
      authData = left('$e');
    }
*/
    emit(AuthState.authPassed(AuthStateData.result(authData)));
    await _repo.writeAuthMethod(authMethod);
  }

  /// Вход по FaceId
  Future _enterViaFaceId(AuthEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.authPassed(AuthStateData.loading()));
    Either<String, AuthData> authData = right(AuthData.initial());
    // в этом раскладе [authMethod] не выходит из состояния
    // [AuthMethod.initial()] так как каждый раз входим как первый раз.
    const authMethod = AuthMethod.initial();
    final localAuth = LocalAuthentication();
    var isAuthorized = false;
    try {
      isAuthorized = await localAuth.authenticate(
        localizedReason: 'messages.should_auth'.tr(),
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: false,
        ),
      );
      if (!isAuthorized) {
        authData = left('messages.auth_error'.tr());
      }
    } on PlatformException catch (exception) {
      if (exception.code == local_auth_error.notAvailable) {
        authData = left('general.wrong_platform'.tr());
      } else if (exception.code == local_auth_error.passcodeNotSet) {
        authData = left('messages.not_configured'.tr());
      } else if (exception.code == local_auth_error.notEnrolled) {
        authData = left('messages.fingerprints_not_found');
      } else {
        authData = left('messages.unknown_error'.tr());
      }
    }

    emit(AuthState.authPassed(AuthStateData.result(authData)));
    await _repo.writeAuthMethod(authMethod);
  }

  Future _logout(_LogoutEvent event, Emitter<AuthState> emit) async {
    _repo.writeAuthMethod(const AuthMethod.initial());

    if (event.data.authMethod is AuthMethodGoogle) {
      //final service = FirebaseService();
      //await service.signOutFromGoogle();
    }

    _repo.logOut();
    Either<String, AuthData> authData = right(AuthData.initial());
    emit(AuthState.loggedOut(AuthStateData.result(authData)));
  }

  Future _fetchCodeForChangeLogin(
      _FetchCodeForChangeLoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.changeLoginCodeFetched(AuthStateData.loading()));
    try {
      final rez = await _repo.fetchCode(login: event.login);
      emit(AuthState.changeLoginCodeFetched(AuthStateData.result(rez)));
    } on Exception catch (e) {
      emit(AuthState.changeLoginCodeFetched(
          AuthStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _fetchCodeForChangeLoginRepeated(
      _FetchCodeForChangeLoginRepeatedEvent event,
      Emitter<AuthState> emit) async {
    emit(const AuthState.changeLoginCodeRepeatedFetched(
        AuthStateData.loading()));
    try {
      final rez = await _repo.fetchCode(login: event.login);
      emit(AuthState.changeLoginCodeRepeatedFetched(AuthStateData.result(rez)));
    } on Exception catch (e) {
      emit(AuthState.changeLoginCodeRepeatedFetched(
          AuthStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _dropToken(_DropTokenEvent event, Emitter<AuthState> emit) async {
    _repo.writeAuthMethod(const AuthMethod.initial());
  }
}

/// Евенты для авторизации
@freezed
class AuthEvent with _$AuthEvent {
  /// Запрос сохраненных данных авторизации.
  const factory AuthEvent.fetchAuthData() = _FetchAuthDataEvent;

  /// Запрос кода через Email/Phone
  const factory AuthEvent.fetchCodeForSignIn({
    required NonEmptyString login,
  }) = _FetchCodeForSignInEvent;

  /// Повторный(!) запрос кода через Email/Phone
  const factory AuthEvent.fetchCodeForSignInRepeated({
    required NonEmptyString login,
  }) = _FetchCodeForSignInRepeatedEvent;

  const factory AuthEvent.fetchCodeForChangeLogin({
    required NonEmptyString login,
  }) = _FetchCodeForChangeLoginEvent;

  const factory AuthEvent.fetchCodeForChangeLoginRepeated({
    required NonEmptyString login,
  }) = _FetchCodeForChangeLoginRepeatedEvent;

  /// SignIn
  const factory AuthEvent.signIn({
    required NonEmptyString login,
    required NonEmptyString code,
  }) = _SignInEvent;

  /// Запрашивает данные об юзере в первый раз.
  /// Это необходимо для определения кейсов - первый вход / повторный вход.
  /// Вызывается когда токен уже вернулся.
  const factory AuthEvent.firstTimeResolveUser({
    required AuthData authData,
  }) = _FirstTimeResolveUser;

  ///
  const factory AuthEvent.enterViaGoogle() = _EnterViaGoogleEvent;

  ///
  const factory AuthEvent.enterViaFaceId() = _EnterViaFaceIdEvent;

  /// Выход.
  const factory AuthEvent.logout(AuthData data) = _LogoutEvent;

  /// Просто удаление токена в случае непредвиденности.
  const factory AuthEvent.dropToken() = _DropTokenEvent;
}

/// Состояния авторизации.
/// Передается внутреннее подсостояние типа [AuthStateData], каждое из которых
/// может содержать динамику.
@freezed
class AuthState with _$AuthState {
  /// Стартовое состояние.
  const factory AuthState.initial() = _InitialState;

  /// Токен запросили из репозитория
  const factory AuthState.authDataFetched(
      AuthStateData<Either<String, AuthData>> data) = _AuthDataFetched;

  /// Запросили код для входм
  const factory AuthState.signInCodeFetched(
          AuthStateData<Either<ExtendedErrors, SimpleMessage>> data) =
      _SignInCodeFetched;

  /// Повторно (!) запросили код для входа
  const factory AuthState.signInCodeRepeatedFetched(
          AuthStateData<Either<ExtendedErrors, SimpleMessage>> data) =
      _SignInCodeRepeatedFetched;

  const factory AuthState.changeLoginCodeFetched(
          AuthStateData<Either<ExtendedErrors, SimpleMessage>> data) =
      _ChangeLoginCodeFetched;

  const factory AuthState.changeLoginCodeRepeatedFetched(
          AuthStateData<Either<ExtendedErrors, SimpleMessage>> data) =
      _ChangeLoginCodeRepeatedFetched;

  /// Результат авторизации
  const factory AuthState.authPassed(
      AuthStateData<Either<String, AuthData>> data) = _AuthPassed;

  /// Результат определения кейса первый/повторный вход
  ///
  const factory AuthState.firstTimeUserResolved(
          AuthStateData<Either<ExtendedErrors, UserSettings>> data) =
      _FirstTimeUserResolved;

  ///
  const factory AuthState.loggedOut(
      AuthStateData<Either<String, AuthData>> data) = _AuthLoggedOut;
}

/// Динамические данные для каждого из [AuthState]
/// Позволяют использовать каждый [AuthState] в трех внутренних режимах:
/// [initial], [loading] & [result]
@freezed
class AuthStateData<T> with _$AuthStateData<T> {
  const factory AuthStateData.initial() = _InitialData<T>;

  const factory AuthStateData.loading() = _LoadingData<T>;

  /// Подразумевается, что (на данном этапе) данные какбэ не нужны,
  /// важно только лево/право
  const factory AuthStateData.result(T data) = _ResultData<T>;
}
