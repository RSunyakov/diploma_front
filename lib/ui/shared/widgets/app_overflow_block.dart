import 'package:flutter/material.dart';
import 'package:sphere/core/utils/app_calcs.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppOverflowBlock extends StatelessWidget {
  const AppOverflowBlock({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.editBlock,
    this.plusBlock,
    this.favoriteBlock,
    this.isFavorite = false,
    this.inDraft,
    this.isGoal,
    this.statusColor,
    this.backgroundColor,
    this.goalStatus,
    this.removeBlock,
    this.statusTextColor,
  }) : super(key: key);

  final Widget child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final Function()? editBlock;
  final Function()? plusBlock;
  final Function()? favoriteBlock;
  final Function()? removeBlock;
  final bool? inDraft;
  final bool isFavorite;
  final bool? isGoal;
  final Color? statusColor;
  final Color? backgroundColor;
  final String? goalStatus;
  final Color? statusTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: appWidth,
      margin: margin ?? EdgeInsets.only(bottom: 23.kH),
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 23.kW, vertical: 23.kH),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        boxShadow: backgroundColor != null
            ? AppColors.goalShadow
            : AppColors.boxShadow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            child: Row(
              children: [
                const Spacer(),
                if (goalStatus != null) ...[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: statusColor ?? AppColors.goalDeadline,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 7),
                      child: Text(goalStatus!,
                          style: AppStyles.text9
                              .andWeight(FontWeight.w400)
                              .andColor(statusTextColor ?? AppColors.white)),
                    ),
                  ),
                ],
                21.w,
                if (editBlock != null) ...[
                  IconButton(
                    onPressed: editBlock,
                    padding: const EdgeInsets.only(top: 5),
                    constraints: BoxConstraints(maxHeight: 20.kW),
                    icon:
                        svgPicture(AppIcons.edit, color: AppColors.activeText),
                  ),
                ],
                if (removeBlock != null) ...[
                  IconButton(
                    onPressed: removeBlock,
                    padding: const EdgeInsets.only(top: 5),
                    constraints: BoxConstraints(maxHeight: 16.kW),
                    icon:
                        svgPicture(AppIcons.close, color: AppColors.lightGrey),
                  ),
                ],
                if (plusBlock != null) ...[
                  IconButton(
                    onPressed: plusBlock,
                    padding: const EdgeInsets.only(top: 5),
                    constraints: BoxConstraints(maxHeight: 20.kW),
                    icon: inDraft != null && inDraft == true
                        ? svgPicture(AppIcons.iconDone,
                            color: isGoal != null
                                ? AppColors.textGreen
                                : AppColors.lightGrey)
                        : svgPicture(AppIcons.plus,
                            color: isGoal != null
                                ? AppColors.textGreen
                                : AppColors.lightGrey),
                  )
                ],
                if (favoriteBlock != null) ...[
                  IconButton(
                    onPressed: favoriteBlock,
                    padding: const EdgeInsets.only(top: 5),
                    constraints: BoxConstraints(maxHeight: 20.kW),
                    icon: isFavorite
                        ? svgPicture(AppIcons.starPressedIconPath,
                            color: AppColors.activeText)
                        : svgPicture(AppIcons.starIconPath,
                            color: isGoal != null
                                ? AppColors.textGreen
                                : AppColors.lightGrey),
                  )
                ],
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
