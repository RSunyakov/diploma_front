import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: AppLogo(
            colorBg: AppColors.activeText,
            colorIcon: AppColors.white,
            colorText: AppColors.plainText,
          ),
        ),
        40.h,
        Text(
          title,
          style: AppStyles.text18,
        )
      ],
    );
  }
}
