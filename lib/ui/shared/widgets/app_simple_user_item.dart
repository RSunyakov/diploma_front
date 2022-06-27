import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/app_extensions.dart';
import 'package:sphere/ui/shared/app_icons.dart';
import 'package:sphere/ui/shared/app_styles.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';

class AppSimpleUserItem extends StatelessWidget {
  const AppSimpleUserItem(
      {required this.user,
      this.profileIcon,
      required this.target,
      required this.time,
      this.favourite = true,
      required this.lastMessageOrRate,
      this.onPressedFavourite,
      this.toggleStar,
      this.isNeedFavourite = true,
      Key? key})
      : super(key: key);

  final String user;
  final ImageProvider? profileIcon;
  final String target;
  final String time;
  final bool favourite;
  final bool isNeedFavourite;
  final String lastMessageOrRate;
  final bool? toggleStar;
  final Function()? onPressedFavourite;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 23.kW),
      child: Row(
        children: [
          const AppAvatarBlock(radius: 22.5, path: ''),
          5.w,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                user,
                style: AppStyles.text14.andColor(AppColors.plainText),
              ),
              5.h,
              Text(
                target,
                style: !isNeedFavourite
                    ? AppStyles.text12.andColor(AppColors.plainText)
                    : AppStyles.text12.andColor(AppColors.shadowColor),
              ),
              5.h,
              Text(
                lastMessageOrRate,
                style: AppStyles.text11.andColor(AppColors.plainText),
              )
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                time,
                style: AppStyles.text14.andColor(AppColors.plainText),
              ),
              if (isNeedFavourite) ...[
                5.h,
                IconButton(
                  constraints: BoxConstraints(maxHeight: 18.kH),
                  onPressed: onPressedFavourite,
                  padding: const EdgeInsets.all(0),
                  icon: favourite
                      ? svgPicture(AppIcons.starPressedIconPath, height: 18.kH)
                      : svgPicture(AppIcons.starIconPath, height: 18.kH),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
