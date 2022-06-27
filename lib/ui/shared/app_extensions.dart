import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sphere/core/utils/app_calcs.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

extension NumX on num {
  SizedBox get h => SizedBox(height: this * kHeight);

  SizedBox get w => SizedBox(width: this * kWidth);

  double get kW => this * kWidth;

  double get kH => this * kHeight;

  EdgeInsets get insetsHor => EdgeInsets.symmetric(horizontal: this * 1.0);

  EdgeInsets get insetsVert => EdgeInsets.symmetric(vertical: this * 1.0);

  EdgeInsets get insetsAll => EdgeInsets.all(this * 1.0);
}

extension StringX on String {
  /// Обрезать строку, если больше максимальной длины
  String crop(int maxLength) {
    assert(maxLength > -1);
    return length <= maxLength ? this : substring(0, maxLength);
  }

  ///
  String safeEnds(int endLength, {String delimiter = '..'}) {
    assert(endLength > -1);
    if (endLength == 0) {
      return this;
    }
    if (endLength * 2 >= length) {
      return this;
    }
    final start = substring(0, endLength);
    final end = substring(length - endLength, length);
    return '$start$delimiter$end';
  }

  /// переводим строку в дату.
  /// Ошибку просто глотаем и выводим текущую дату.
  DateTime get dateTimeFromBackend {
    try {
      return DateFormat('dd-MM-yyyy').parse(this);
    } on Exception catch (_) {
      return now;
    }
  }

  /// переводим из "10-11-1978"
  /// в "10  ноября 1978 г."
  /// Ошибку просто глотаем и выводим пустую строку.
  String get toLongFormat {
    if (isEmpty) {
      return '';
    }
    try {
      final dt = DateFormat('dd-MM-yyyy').parse(this);
      return DateFormat('yMMMMd').format(dt);
    } on Exception catch (_) {
      return '';
    }
  }
}

extension BoolX on bool {
  bool toggle() => !this;
}

/// Расширения для [TextEditingController]
extension TextEditingControllerX on TextEditingController {
  /// Устанавливает текст и одновременно позиционирует курсор в конец.
  ///
  /// ```dart
  ///  someTextController.withText(value);
  /// ```
  TextEditingController withText(String text) {
    this.text = text;
    selection = TextSelection.collapsed(offset: text.length);
    return this;
  }
}

extension DateTimeX on DateTime {
  String get stringFromDateTime {
    try {
      return DateFormat('dd.MM.yyyy').format(this);
    } on Exception catch (_) {
      return '';
    }
  }
}
