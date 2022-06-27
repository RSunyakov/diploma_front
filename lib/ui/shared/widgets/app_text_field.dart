import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {required this.hintText,
      required this.customHeight,
      this.isButtonActive,
      required this.controller,
      this.hintStyle, //Added by Iosif Futerman
      this.style, //Added by Iosif Futerman
      this.onChanged, //Added by Iosif Futerman
      this.focusNode,
      this.keyboardType,
      Key? key})
      : super(key: key);

  final String hintText;
  final double customHeight;
  final bool? isButtonActive;
  final TextEditingController controller;
  final TextStyle? style; //Iosif Futerman. Нужно свойство пробросить наверх
  final TextStyle? hintStyle; //Iosif Futerman. Нужно свойство пробросить наверх
  final TextInputType? keyboardType;
  final void Function(String)?
      onChanged; //Iosif Futerman. Нужно свойство пробросить наверх
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: customHeight,
          width: MediaQuery.of(context).size.width - 38 * 2,
          // width: Get.width - (38 * 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Colors.white),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color(0xff7ACDAC).withOpacity(0.3),
                  blurRadius: 15.0,
                  offset: const Offset(0.0, 4.0))
            ],
            // boxShadow: kElevationToShadow[4],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: customHeight,
          width: MediaQuery.of(context).size.width - 38 * 2,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            keyboardType: keyboardType,
            onChanged: onChanged, //Added by Iosif Futerman
            style: style, //Added by Iosif Futerman
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: hintStyle ??
                  AppStyles.text11
                      .andColor(AppColors.mainStroke), //Added by Iosif Futerman
            ),
            controller: controller,
            focusNode: focusNode,
          ),
        ),
        if (isButtonActive != null && isButtonActive == true)
          Positioned(
              right: 0,
              height: customHeight,
              width: 35,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.buttonGreen,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border: Border.all(color: AppColors.buttonGreen),
                ),
                child: IconButton(
                    onPressed: () {},
                    icon: svgPicture(AppIcons.rightArrow,
                        height: customHeight / 2, width: customHeight / 2)),
              ))
      ],
    );
  }
}
