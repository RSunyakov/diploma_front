import 'package:flutter/cupertino.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppSwitchContainer extends StatelessWidget {
  const AppSwitchContainer({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.text12,
        ),
        SizedBox(
          height: 30,
          child: CupertinoSwitch(
            value: value,
            activeColor: AppColors.activeText,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
