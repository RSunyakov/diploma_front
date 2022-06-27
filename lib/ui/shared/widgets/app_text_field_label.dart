import 'package:flutter/material.dart';
import '../app_styles.dart';

/// Стандартный лейбл
class AppTextFieldLabel extends StatelessWidget {
  const AppTextFieldLabel(this.label, {Key? key}) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppStyles.textFieldLabel);
  }
}
