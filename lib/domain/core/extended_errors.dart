import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/app_config.dart';

part 'extended_errors.freezed.dart';

part 'extended_errors.g.dart';

/// Класс отображающий сложную структуру ошибок,
/// которые могут придти с бэка.
///
/// Добавлено много полезной информации:
///
@freezed
class ExtendedErrors with _$ExtendedErrors {
  const factory ExtendedErrors({
    required String error,
    required List errors,
    @Default({}) Map<String, dynamic> dioErrors,
  }) = _ExtendedErrors;

  const ExtendedErrors._();

  factory ExtendedErrors.simple(String error) =>
      ExtendedErrors(error: error, errors: [error]);

  factory ExtendedErrors.empty() => const ExtendedErrors(error: '', errors: []);

  factory ExtendedErrors.fromJson(Map<String, dynamic> json) =>
      _$ExtendedErrorsFromJson(json);
}

extension ExtendedErrorsX on ExtendedErrors {
  static const isDioKey = 'is_dio';

  static const dioStatusCodeKey = 'dio_status_code';

  static const dioApiKey = 'dio_api';

  /// Общая ошибка, типа
  /// 'error': Случилось страшное
  static const errorKey = 'error';

  /// Лист карточек ошибок по полям, типа
  /// 'errors':
  ///   [
  ///     {
  ///       'error_name': photo
  ///       'error_descr': Не пролезло
  ///     },
  ///     {
  ///       'error_name': city
  ///       'error_descr': Не существует
  ///     }
  ///   ]
  static const errorsKey = 'errors';

  /// Лист чисто Dio ошибок, типа
  /// 'dio_errors':
  ///     {
  ///       'dio_status_code': 513
  ///       'dio_api': api/profile
  ///     },
  static const dioErrorsKey = 'dio_errors';

  bool get hasErrors => error.isNotEmpty;

  /// Основная ошибка
  String get mainErrorValue {
    return error;
  }

  /// Выборка ошибок по приоритету:
  /// 1. Если есть клиентские, показываем их.
  /// 2. Иначе если есть общие показываем их
  /// 3. Иначе показываем основную ошибку в виде листа
  String get smartErrorsValue {
    if (error.isNotEmpty) {
      return error.toString();
    }
    if (errors.isNotEmpty) {
      return errors.toString();
    }

    // В противном случае для продакшна надо только простую ошибку
    if (AppConfig.isProduction) {
      return mainErrorValue;
    }

    return mainErrorValue;
  }

  bool get isDioError {
    return dioErrors.containsKey(dioStatusCode);
  }

  /// Код АПИ (эндпойнта), с которого прилетела ошибка
  int get dioStatusCode {
    return dioErrors[dioStatusCodeKey];
  }

  /// АПИ (эндпойнт), с которого прилетела ошибка
  String get dioApi {
    return dioErrors[dioApiKey];
  }

  /// Выборка ошибок по приоритету + отладочные сообщения
  List get debugErrorsValue {
    return [...smartErrorsValue.split('\n'), dioApi, dioStatusCode];
  }
}

/// Парсит поле error из ответа
///
ExtendedErrors parseError(Map<String, dynamic> errorsMap) {
  try {
    final error = errorsMap[ExtendedErrorsX.errorKey] ?? '';
    final errors = !errorsMap.containsKey(ExtendedErrorsX.errorsKey)
        ? []
        : errorsMap[ExtendedErrorsX.errorsKey];
    final dioErrors = !errorsMap.containsKey(ExtendedErrorsX.dioErrorsKey)
        ? <String, dynamic>{}
        : errorsMap[ExtendedErrorsX.dioErrorsKey] as Map<String, dynamic>;
    return ExtendedErrors(error: error, errors: errors, dioErrors: dioErrors);
  } on Error catch (e) {
    return ExtendedErrors.simple(e.toString());
  } on Exception catch (e) {
    return ExtendedErrors.simple(e.toString());
  }
}
