import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    this.onTap,
    this.count,
    required this.icon,
    this.countColor,
    this.width,
    this.iconHeight,
    this.iconWidth,
    this.padding,
    Key? key,
  }) : super(key: key);

  final void Function()? onTap;
  final int? count;
  final String icon;
  final double? width;
  final Color? countColor;
  final double? iconHeight;
  final double? iconWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.kH,
        width: width ?? 84.kW,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 15.kW),
        decoration: BoxDecoration(
            boxShadow: AppColors.boxShadowButton,
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svgPicture(
              icon,
              height: iconHeight ?? 17,
              width: iconWidth,
            ),
            if (count != null) ...[
              8.w,
              Text(
                count!.toString(),
                style: AppStyles.text17
                    .andColor(countColor ?? AppColors.mainColor)
                    .andWeight(FontWeight.w500),
              )
            ]
          ],
        ),
      ),
    );
  }
}
