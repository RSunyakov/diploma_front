import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sphere/core/app_config.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/failures.dart';

/// Данные для облегчения тестинга приложения в flavor `dev`.
/// Помогают тестеру вывести связанную с полем ошибку
class AppTestableData extends Equatable {
  /// константа для маркировки "Не надо трекать ошибки"
  static const noDebug = AppTestableData._(failureString: '');

  /// Константа для использования дефолтного маркера [_DefaultMarker]
  const AppTestableData.simple(String failureString)
      : this._(failureString: failureString);

  /// Еще более упрощенное использование - просто передать стандартный [Either]
  /// Константа для использования дефолтного маркера [_DefaultMarker]
  AppTestableData.either(Either<ValueFailure<String>, String> value)
      : this._(failureString: value.fold((l) => l.toString(), (r) => r));

  /// Константа для настройки маркера снаружи
  const AppTestableData.withMarker({
    required String failureString,
    required Widget marker,
  }) : this._(
          failureString: failureString,
          marker: marker,
        );

  final String failureString;
  final Widget? marker;

  AppTestableData copyWith({
    Widget? marker,
  }) {
    return AppTestableData._(
      failureString: failureString,
      marker: marker ?? this.marker,
    );
  }

  const AppTestableData._({
    this.failureString = '',
    this.marker,
  });

  @override
  List<Object?> get props => [failureString, marker];
}

/// Базовый виджет для передачи поведения "Тестовое отображение ошибок".
/// Удобно для тестеров, когда например в сборке `dev` можно получить
/// маркировку переданных ошибок, и передать разработчикам
/// более расширенную информацию
///
/// Имплементация должна передавать поле типа `TestableData? testableData,`
/// клиенту, и действовать в зависимости от возвращаемого значения.
///
/// 1. Если клиент игнорирует это поле, значит ему не нужна функциональность.
/// 2. Если клиент передает только [AppTestableData.failureString], то маркер
/// будет определяться дефолтно или правилами имплементации.
///
/// Стандартная имплементация может просто напрямую передавать поле
/// в [AppTestableWidget] и полагаться на отображение по умолчанию.
///
/// Иначе имплементация может перехватить объект и перенастроить
/// [AppTestableData.marker] так, чтобы отображать маркер по-своему.
///
/// ```dart
/// // Пример когда клиент хочет передать свой маркер:
/// testableData: TestableData.withMarker(
///   failureString: 'ERROR: ${controller.email$.value.fold(
///     (l) => l.toString(),
///     (r) => '',
///   )}',
///   marker: const Align(
///     alignment: Alignment.center,
///     child: Icon(Icons.clear),
///   ),
/// ),
///
/// ```
///
/// ```dart
/// // Пример когда имплементация перехватывает объект с пустым маркером
/// //  и предлагает свой маркер (в конструкторе):
///     : controller = controller ?? TextEditingController(),
///       padding = padding ?? const EdgeInsets.all(0),
///       super(
///         testableData: testableData == null || testableData.marker != null
///         ? testableData
///         : testableData.copyWith(marker: const Icon(Icons.place)),
///         key: key);
/// ```
///
/// ```dart
/// Полный пример для отображения либо [Captcha], либо плейсхолдер + инфа для тестеров
///
/// /// Обертка для [Captcha] в стиле TypeDD.
/// /// В [super] передаем настройки для 'flavor dev'
/// /// В [buildMain] рисуем то, что должен видеть клиент в любом flavor
/// class _CaptchaInfo extends TestableWidget {
///   _CaptchaInfo(
///     this.controller, {
///     Key? key,
///   }) : super(
///             // Таким образом если левое значение будет отлично от `Empty`
///             // оно отобразится по клику на `тестовой иконке`
///             testableData: TestableData.simple(
///               controller.captcha$.fold(
///                 (l) => l.join('\n'),
///                 (r) => '',
///               ),
///             ),
///             key: key);
///
///   final SignUpScreenController controller;
///
///   @override
///   Widget buildMain(BuildContext context) {
///     // В то же время для `flavor prod` предназначен плейсхолдер, который выведет
///     //  1. _FailureContainer() если ошибка всего объекта или его поля [base64Image]
///     //  2. Нормальное значение, если все в порядке
///     final widget = controller.captcha$.fold(
///       // 1. Ошибка всего объекта
///       (l) => const _FailureContainer(),
///       (r) => r.base64Image.value.fold(
///         // 1. Ошибка поля [base64Image]
///         (l) => const _FailureContainer(),
///         // 2. Все нормуль
///         (r) => Image.memory(const Base64Decoder().convert(r)),
///       ),
///     );
///     return widget;
///   }
/// }
///
/// ```
///
abstract class AppTestableWidget extends StatelessWidget {
  const AppTestableWidget(
      {this.testableData,
      this.right = -6,
      this.left = -6,
      this.top = 0,
      this.bottom = 0,
      Key? key})
      : super(key: key);

  final AppTestableData? testableData;
  final double right;
  final double left;
  final double top;
  final double bottom;

  Widget buildMain(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final d = testableData ?? AppTestableData.noDebug;
    final isDev = !AppConfig.isProduction;

    if (isDev && d.failureString.isNotEmpty) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          buildMain(context),
          Positioned(
            right: right,
            top: top,
            child: GestureDetector(
              onTap: () {
                _showAppTestableDialog(
                  context,
                  title: Text('Failure in: $runtimeType'),
                  content: Text(d.failureString),
                );
              },
              child: Container(
                color: Colors.red.withOpacity(0.2),
                child: _DefaultMarker(d.marker),
              ),
            ),
          ),
        ],
      );
    }
    return buildMain(context);
  }
}

/// Дефолтный виджет для отображения в качестве тестового маркера ошибки.
class _DefaultMarker extends StatelessWidget {
  const _DefaultMarker(this.marker, {Key? key}) : super(key: key);

  final Widget? marker;

  @override
  Widget build(BuildContext context) {
    return marker ??
        Icon(
          Icons.error,
          color: Colors.red.withOpacity(0.4),
          size: 20,
        );
  }
}

/// Отображение стандартного диалога с описанием ошибки
Future _showAppTestableDialog(BuildContext context,
    {required Widget title, required Widget content}) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      content: content,
    ),
  );
}
