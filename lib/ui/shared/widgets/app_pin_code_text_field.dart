import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppPinCodeTextField extends StatelessWidget {
  const AppPinCodeTextField({Key? key, required this.onCompleted, this.padding})
      : super(key: key);

  final Function(String) onCompleted;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.kW),
      child: PinCodeTextField(
        appContext: context,
        length: 4,
        onChanged: (v) {},
        onCompleted: onCompleted,
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        autoFocus: true,
        pinTheme: PinTheme(
          fieldHeight: 43,
          fieldWidth: 43,
          shape: PinCodeFieldShape.box,
          inactiveFillColor: Colors.white,
          activeFillColor: Colors.white,
          selectedColor: Colors.white,
          selectedFillColor: Colors.white,
          inactiveColor: Colors.white,
          disabledColor: Colors.white,
          activeColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          borderWidth: 3,
        ),
        boxShadows: AppColors.boxShadow,
      ),
    );
  }
}
