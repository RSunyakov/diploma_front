import 'package:flutter/material.dart';

/// Метод для скрытия клавиутары после ввода текста
/// В инпуте
void unFocus() {
  FocusManager.instance.primaryFocus!
      .unfocus(disposition: UnfocusDisposition.scope);
}
