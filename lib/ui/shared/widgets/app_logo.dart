import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key? key,
    this.colorIcon,
    this.colorText,
    this.colorBg,
  }) : super(key: key);

  final Color? colorText;
  final Color? colorBg;
  final Color? colorIcon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorBg,
          ),
          child: svgPicture(AppIcons.sphereIconPath, color: colorIcon),
        ),
        20.h,
        svgPicture(AppIcons.sphereTextPath, color: colorText),
      ],
    );
  }
}
