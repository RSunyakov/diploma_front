import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class AppCell extends StatelessWidget {
  const AppCell({
    Key? key,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.onTap,
    this.isAvatar = false,
    this.isRightWidget = false,
    this.isMainText = false,
    this.username,
    this.userSkill,
    this.widget,
    this.target,
    this.hashtag,
    this.date,
    this.description,
    this.bottomArrowFunc,
    this.avatarPath,
    this.isVisible = true,
  }) : super(key: key);

  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;

  final bool isRightWidget;
  final bool isVisible;

  ///Если указан Avatar, MainText не отображается
  final bool isAvatar;
  final String? avatarPath;

  ///Если указан MainText, Avatar не отображается
  final bool isMainText;

  final String? username;
  final String? userSkill;
  final Widget? widget;
  final Function()? bottomArrowFunc;

  final String? target;
  final String? hashtag;
  final String? date;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final isOpen = false.obs;
    final isBottomArrow =
        bottomArrowFunc != null && !isAvatar && description == null;
    return GestureDetector(
      onTap: onTap,
      child: Visibility(
        visible: isVisible,
        child: Container(
          height: height,
          width: width,
          margin: margin ?? EdgeInsets.symmetric(horizontal: 17.kW),
          padding: padding ??
              EdgeInsets.symmetric(horizontal: 10.kW, vertical: 10.kH),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: AppColors.boxShadowButton,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  if (isAvatar && !isMainText) ...[
                    AppAvatarBlock(radius: 20, path: avatarPath ?? ''),
                    15.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          username ?? 'general.noname'.tr(),
                          style: AppStyles.text14
                              .andColor(AppColors.plainText)
                              .andWeight(FontWeight.w400),
                        ),
                        3.h,
                        Text(
                          userSkill ?? 'general.no_description'.tr(),
                          style: AppStyles.text11
                              .andColor(AppColors.lightGrey)
                              .andWeight(FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                  if (!isAvatar && isMainText) ...[
                    18.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SimpleRichText(
                          date ?? 'general.no_date'.tr(),
                          post: TextSpan(
                            text: '   #${hashtag ?? 'general.no_hashtag'.tr()}',
                            style: AppStyles.text12
                                .andColor(AppColors.textGreen)
                                .andWeight(FontWeight.w400),
                          ),
                          style: AppStyles.text11
                              .andColor(AppColors.lightGrey)
                              .andWeight(FontWeight.w300),
                        ),
                        3.h,
                        Text(
                          target ?? 'general.no_goal'.tr(),
                          style: AppStyles.text12
                              .andColor(AppColors.plainText)
                              .andWeight(FontWeight.w500),
                        ),
                        3.h,
                      ],
                    ),
                  ],
                  if (isRightWidget) ...[
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 3.kW),
                      child: Column(
                        children: [
                          if (!isAvatar && description == null) 10.h,
                          widget ?? const SizedBox.shrink(),
                          if (isBottomArrow) ...[
                            10.h,
                            GestureDetector(
                              onTap: bottomArrowFunc,
                              child: svgPicture(AppIcons.bigArrow),
                            ),
                          ],
                        ],
                      ),
                    )
                  ],
                ],
              ),
              if (description != null)
                Row(
                  crossAxisAlignment: isOpen()
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    18.w,
                    Expanded(
                      child: LayoutBuilder(
                        builder: ((context, constraints) {
                          return Obx(
                            () => Container(
                              width: constraints.maxWidth,
                              margin:
                                  EdgeInsets.only(right: isOpen() ? 0 : 27.kW),
                              child: Text(
                                description!,
                                style: AppStyles.text11
                                    .andColor(AppColors.plainText)
                                    .andWeight(FontWeight.w400)
                                    .andHeight(1.4),
                                overflow:
                                    isOpen() ? null : TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    if (description != null && description != '') ...[
                      Obx(
                        () => IconButton(
                            padding: const EdgeInsets.all(0),
                            constraints: const BoxConstraints(maxHeight: 15),
                            onPressed: () => isOpen(!isOpen()),
                            icon: isOpen()
                                ? svgPicture(AppIcons.arrowUp)
                                : svgPicture(AppIcons.arrowDown)),
                      )
                    ]
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
