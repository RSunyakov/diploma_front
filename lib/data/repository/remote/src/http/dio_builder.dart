import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:injectable/injectable.dart';
import 'package:sphere/core/app_config.dart';
import 'package:sphere/core/utils/app_logger.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/utils.dart';

import '../../../../../logic/auth/auth_service.dart';

abstract class IDioProvider {
  Dio get dio;

  String get baseUrl;
}

@prod
@LazySingleton(as: IDioProvider)
class DioBuilder implements IDioProvider {
  // DioBuilder({LocalRepository? repo}) : _repoLocal = repo ?? GetIt.I.get();
  //
  // // ignore: unused_field
  // final LocalRepository _repoLocal;

  Dio? _dio;

  @override
  String get baseUrl => dio.options.baseUrl;

  @override
  Dio get dio => _dio ??= _buildDio();

  Dio _buildDio() {
    final options = BaseOptions(baseUrl: AppConfig.apiEndpoint, /*contentType: Headers.jsonContentType*/);
    final dio = Dio(options);

    if (!kIsWeb) {
      //Обработка ошибки об истекшем сертификате
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        await _setHeaders(options);
        log(
          '${options.method} ${options.uri.toString()}\n${options.headers}\n${options.extra}',
          name: 'HTTP REQUEST',
        );
        log(options.data.toString());
        debugPrint('ttt: ${options.headers}');
        if (!AppConfig.isProduction &&
            options.data != null &&
            options.data is Map) {
          // TODO: do for FormData
          final bodyAsString = jsonEncode(options.data);
          log(
            bodyAsString,
            name: 'HTTP REQUEST BODY',
          );
        }

        return handler.next(options);
      },
      onResponse: (response, handler) async {
        final respString = response.toString();
        log(
            respString.substring(
              0,
              respString.length > 300 ? 300 : respString.length - 1,
            ),
            name: 'HTTP RESPONSE');
        return handler.next(response);
      },
      onError: (DioError e, handler) async {
        return _onError(e, handler);
      },
    ));

    final headers = {
      'Content-Type': 'application/json',
    };

    dio.options.headers = headers;
    debugPrint('${dio.options.headers}');
    return dio;
  }

  Future _onError(DioError e, handler) async {
    if (e.response == null) {
      final respNew = Response(
          requestOptions: RequestOptions(path: e.toString()),
          data: <String, dynamic>{
            'status': false,
            'errors': {ExtendedErrorsX.errorKey: e.toString().crop(200)},
          });
      return handler.resolve(respNew);
    }
    return _resolveErrorForClient(e.response?.statusCode ?? -1, e, handler);
  }

  /// Помощь для передачи разного рода ошибок клиенту
  /// Передается код и ендпойнт
  Future _resolveErrorForClient(int statusCode, DioError e, handler) async {
    // Тупо режем ошибку до вменяемой длины
    final partOf = e.toString().crop(220);

    loggerSimple.e(
        'DioBuilder._resolveErrorForClient: errors.0=${e.response}, [$statusCode]');
    // loggerSimple.e(
    //     'DioBuilder._resolveErrorForClient: errors.0=${e.response?.data}, [$statusCode]');

    // иногда все-таки приходит не то, например, при неправильном домене.
    if (e.response?.data is! Map<String, dynamic>) {
      loggerSimple.e('DioBuilder._resolveErrorForClient: errors.0.0 LOGOUT');
      delayMilli(AppConsts.delayForEscapeVisualConflict).then((_) {
        appAlert(
            value: 'Неизвестная ошибка сервера: [$statusCode]',
            color: AppColors.red);
      });

      Get.find<AuthService>().logout(/*true*/);
      return;
    }

    // когда ошибка вменяемая - работает первая часть, нет - ошибка DIO (true)
    // FIXME(vvk): похоже, это уже не так - теперь все ошибки оформлены ОК.
    final errors =
        e.response?.data as Map<String, dynamic>? ?? <String, dynamic>{};

    // loggerSimple
    //     .i('DioBuilder._resolveErrorForClient: errors.1=$errors, $statusCode');

    // e.response!.data может быть невалидна по структуре!!!!!
    try {
      if (!errors.containsKey(ExtendedErrorsX.errorKey)) {
        errors[ExtendedErrorsX.errorKey] = partOf;
      }
      if (!errors.containsKey(ExtendedErrorsX.errorsKey)) {
        errors[ExtendedErrorsX.errorsKey] = <String, dynamic>{
          ExtendedErrorsX.errorKey: [errors[ExtendedErrorsX.errorKey]],
        };
      }

      // В случае облома авторизации выходим!
      // Но не отправляем reject, чтобы не нарушать систему ошибок
      if ([401].contains(statusCode)) {
        delayMilli(AppConsts.delayForEscapeVisualConflict).then((_) {
          appAlert(value: 'Ошибка сервера [$statusCode]', color: AppColors.red);
        });
        Get.find<AuthService>().logout(/*true*/);
      }

      if ([500].contains(statusCode)) {
        delayMilli(AppConsts.delayForEscapeVisualConflict).then((_) {
          appAlert(value: 'Ошибка сервера [$statusCode]', color: AppColors.red);
        });
        errors[ExtendedErrorsX.dioErrorsKey][ExtendedErrorsX.dioStatusCodeKey] =
            500;
        errors[ExtendedErrorsX.dioErrorsKey][ExtendedErrorsX.dioApiKey] =
            e.requestOptions.path;
      }

      // loggerSimple.i('DioBuilder._resolveErrorForClient: errors.2=$errors');
      // loggerSimple.i('DioBuilder._resolveErrorForClient: errors.2=${errors[ExtendedErrorsX.errorsKey]}');
      // loggerSimple.i('DioBuilder._resolveErrorForClient: errors.2=${errors[ExtendedErrorsX.errorsKey].runtimeType}');

      /// Тут добавим полезную инфу
      // errors[ExtendedErrorsX.errorsKey]
      //     [ExtendedErrorsX.dioStatusCodeKey] = [statusCode];
      // errors[ExtendedErrorsX.errorsKey]
      //     [ExtendedErrorsX.dioApiKey] = [e.requestOptions.path];

      errors[ExtendedErrorsX.errorsKey] = [statusCode];

      // loggerSimple.i('DioBuilder._resolveErrorForClient: errors.3=$errors');

      final respNew = Response(
          requestOptions:
              e.response?.requestOptions ?? RequestOptions(path: 'No Response'),
          data: <String, dynamic>{
            'status': false,
            'errors': errors,
          });
      return handler.resolve(respNew);
    } on Error catch (e) {
      final respNew = Response(
          requestOptions: RequestOptions(path: e.toString()),
          data: <String, dynamic>{
            'status': false,
            'errors': {ExtendedErrorsX.errorKey: partOf},
          });
      return handler.resolve(respNew);
    } on Exception catch (e) {
      final respNew = Response(
          requestOptions: RequestOptions(path: e.toString()),
          data: <String, dynamic>{
            'status': false,
            'errors': {ExtendedErrorsX.errorKey: partOf},
          });
      return handler.resolve(respNew);
    }
  }

  Future _setHeaders(RequestOptions options) async {
    options.headers['Content-Type'] = 'application/json';

    // для проверки 401 прикручивал 999 к любому токену
    // 'Bearer 999' + _tokenService.token$.getOrElse('');

    // options.headers['Locale'] = (await _repoLocal.readLanguage())
    //     .fold((l) => '', (r) => r.value.getOrElse(() => 'en'));
    // loggerSimple.i('DioBuilder._setHeaders: ${options.headers}');

    // if (!isStringNullOrEmpty(_accessTokenService.token) &&
    //     !_shouldIgnoreAuth(options.uri.toString())) {
    //   options.headers['Authorization'] = 'Bearer ' + _accessTokenService.token!;
    // } else {
    //   options.headers.remove('Authorization');
    // }
    //
    // options.headers['Service-Lang'] = _localStorage.getLang();
  }
}
