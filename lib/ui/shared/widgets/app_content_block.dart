import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class AppContentBlock extends StatelessWidget {
  const AppContentBlock({
    Key? key,
    this.isHeader = true,
    this.avatarPath,
    this.userName,
    this.userRate,
    this.entityName,
    this.title,
    this.date,
    this.content,
    this.imageOnly,
    this.isProgressBar = false,
    this.progressPercent,
    this.progressGradient,
    this.isMentorBlock = false,
    this.mentorAvatarPath,
    this.mentorName,
    this.mentorRate,
    this.onTapOfferMentors,
    this.isBottomArrow = true,
    this.bottomArrowFunc,
    this.comments,
    this.hashTag,
    this.onUserNameTap,
    this.isPurpose = false,
    this.padding,
    this.statusColor,
    this.onTapFindMentors,
    this.repeatMeasure,
    this.repeatTextEditingController,
    this.repeatButtonFunction,
    this.deadlineAt,
  }) : super(key: key);

  final bool isHeader;
  final String? avatarPath;
  final String? userName;
  final String? userRate;
  final String? entityName;
  final Function()? onUserNameTap;

  final String? title;
  final String? date;
  final String? deadlineAt;
  final String? content;
  final String? imageOnly;

  final bool isPurpose;
  final String? hashTag;
  final int? comments;

  final bool isProgressBar;
  final int? progressPercent;
  final Gradient? progressGradient;

  final bool isMentorBlock;
  final String? mentorAvatarPath;
  final String? mentorName;
  final String? mentorRate;
  final Function()? onTapOfferMentors;
  final Function()? onTapFindMentors;

  final String? repeatMeasure;
  final TextEditingController? repeatTextEditingController;
  final Function(String text)? repeatButtonFunction;

  final bool isBottomArrow;
  final Function()? bottomArrowFunc;

  final EdgeInsetsGeometry? padding;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    final styleText = AppStyles.text12.andWeight(FontWeight.w300);
    final styleTitle = AppStyles.text14.andWeight(FontWeight.bold);
    final styleDate = AppStyles.text11.andColor(AppColors.lightGreyText);
    final styleComments = AppStyles.text11.andWeight(FontWeight.w400);
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isHeader)
            GestureDetector(
              onTap: () {
                if (onUserNameTap != null) {
                  onUserNameTap!();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppAvatarBlock(
                    path: avatarPath ?? '',
                    radius: 35 / 2,
                  ),
                  9.w,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleRichText(
                        '${userName ?? 'Tony Hay'}   ',
                        style: AppStyles.text14
                            .andWeight(FontWeight.bold)
                            .andColor(AppColors.plainText),
                      ),
                      entityName != null
                          ? Column(
                              children: [
                                6.h,
                                Text(
                                  entityName!,
                                  style: AppStyles.text12
                                      .andWeight(FontWeight.w400),
                                )
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          if (hashTag != null) ...[
            Text(hashTag ?? '',
                style: AppStyles.text12.andColor(AppColors.textGreen))
          ],
          if (title != null) ...[
            isPurpose ? 10.h : 14.h,
            Text(title ?? '', style: styleTitle)
          ],
          if (isPurpose && date != null) ...[
            3.h,
            Text('$date-${deadlineAt ?? ''}', style: styleDate),
          ],
          if (isProgressBar) ...[
            10.h,
            AppProgressBlock(
              percent: progressPercent ?? 0,
              gradient: progressGradient,
              progressColor: statusColor,
            ),
          ],
          if (date != null && !isPurpose) ...[
            12.h,
            Text(date ?? '', style: styleDate),
          ],
          if (content != null) ...[
            12.h,
            Text(content ?? '', style: styleText.andHeight(1.6)),
          ],
          if (imageOnly != null) ...[
            12.h,
            FadeInImage.assetNetwork(
              fit: BoxFit.cover,
              placeholder: AppIcons.iconLoaderGif,
              image: imageOnly ?? '',
              imageErrorBuilder: (context, url, error) => const Icon(
                Icons.image_not_supported,
                color: AppColors.red,
              ),
            )
          ],
          if (repeatMeasure != null &&
              repeatTextEditingController != null &&
              repeatButtonFunction != null) ...[
            16.h,
            _RepeatInput(
              controller: repeatTextEditingController!,
              measure: repeatMeasure!,
              buttonHandler: repeatButtonFunction!,
            )
          ],
          if (isMentorBlock) ...[
            12.h,
            Row(
              children: [
                mentorAvatarPath == null || mentorAvatarPath == ''
                    ? svgPicture(AppIcons.questionAvatar, height: 25, width: 25)
                    : AppAvatarBlock(isMentor: true, path: mentorAvatarPath!),
                8.w,
                if (mentorName == null || mentorName == ' ')
                  onTapOfferMentors != null
                      ? _MentorBlock(
                          onTap: onTapOfferMentors,
                          text: 'general.offer_mentoring'.tr())
                      : _MentorBlock(
                          onTap: onTapFindMentors,
                          text: 'general.look_up_mentor'.tr())
                else
                  RichText(
                    text: TextSpan(
                        text: 'general.mentor_content_block'.tr(),
                        style: styleText,
                        children: [
                          TextSpan(
                              text: mentorName!,
                              style: styleText.andColor(AppColors.activeText))
                        ]),
                  ),
              ],
            ),
          ],
          Row(
            children: [
              if (comments != null) ...[
                Text('general.comments_counter'.tr(args: [comments.toString()]),
                    style: styleComments)
              ],
              const Spacer(),
              if (isBottomArrow) ...[
                32.h,
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: bottomArrowFunc,
                      child: svgPicture(AppIcons.bigArrow)),
                ),
              ],
              17.h,
            ],
          ),
        ],
      ),
    );
  }
}

class _RepeatInput extends StatelessWidget {
  const _RepeatInput(
      {required this.controller,
      required this.measure,
      required this.buttonHandler,
      Key? key})
      : super(key: key);

  final TextEditingController controller;
  final String measure;
  final Function(String controllerValue) buttonHandler;

  @override
  Widget build(BuildContext context) {
    final buttonShadow = [
      const BoxShadow(
          color: AppColors.mainColor,
          blurStyle: BlurStyle.outer,
          blurRadius: 10)
    ];
    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 30,
          child: AppInput(
            borderRadius: 5,
            shadow: buttonShadow,
            margin: EdgeInsets.zero,
            controller: controller,
          ),
        ),
        20.w,
        Container(
          decoration: BoxDecoration(
              boxShadow: buttonShadow,
              borderRadius: BorderRadius.circular(5),
              color: AppColors.mainBG),
          width: 56,
          height: 30,
          child: Center(
              child: Text(
            measure,
            style: AppStyles.text12
                .andWeight(FontWeight.w300)
                .andColor(AppColors.mainColor),
          )),
        ),
        const Spacer(),
        AppTextButton(
          shadow: buttonShadow,
          width: 130,
          height: 30,
          text: 'general.mark_progress'.tr(),
          onPressed: () {
            buttonHandler(controller.text);
          },
        )
      ],
    );
  }
}

class _MentorBlock extends StatelessWidget {
  const _MentorBlock({Key? key, required this.onTap, required this.text})
      : super(key: key);

  final Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Text(text,
            style: AppStyles.text12
                .andWeight(FontWeight.w300)
                .andColor(AppColors.activeText)
                .copyWith(decoration: TextDecoration.underline, height: 1.5)));
  }
}
