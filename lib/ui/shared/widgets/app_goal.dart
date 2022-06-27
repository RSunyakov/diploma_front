import 'package:flutter/material.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/app_content_block.dart';
import 'package:sphere/ui/shared/widgets/app_overflow_block.dart';

class GoalWidget extends StatelessWidget {
  const GoalWidget(
      {required this.goal,
      this.removeBlock,
      this.editBlock,
      this.statusColor,
      this.statusTextColor,
      this.backgroundColor,
      this.status,
      this.repeatMeasure,
      this.hashTags,
      this.plusBlock,
      this.favoriteBlock,
      this.inDraft,
      this.isFavorite,
      this.onGoalTap,
      this.onTapOfferMentors,
      this.onTapFindMentor,
      this.userName,
      this.isHeader = false,
      this.entityName,
      this.avatarPath,
      this.paddingContent,
      this.paddingOverflow,
      Key? key})
      : super(key: key);

  final Goal goal;
  final String? userName;
  final Function()? removeBlock;
  final Function()? editBlock;
  final Function()? plusBlock;
  final Function()? favoriteBlock;
  final Color? statusColor;
  final Color? statusTextColor;
  final Color? backgroundColor;
  final String? status;
  final String? repeatMeasure;
  final String? hashTags;
  final bool? inDraft;
  final bool? isFavorite;
  final Function()? onGoalTap;
  final Function()? onTapOfferMentors;
  final Function()? onTapFindMentor;
  final bool isHeader;
  final String? entityName;
  final String? avatarPath;
  final EdgeInsets? paddingContent;
  final EdgeInsets? paddingOverflow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGoalTap,
      child: Column(
        children: [
          AppOverflowBlock(
            padding: paddingOverflow ??
                const EdgeInsets.only(top: 0, left: 22, right: 16),
            isGoal: true,
            inDraft: inDraft,
            isFavorite: isFavorite ?? false,
            statusColor: statusColor,
            statusTextColor: statusTextColor,
            backgroundColor:
                backgroundColor == AppColors.white ? null : backgroundColor,
            goalStatus: status,
            editBlock: editBlock,
            favoriteBlock: favoriteBlock,
            plusBlock: plusBlock,
            removeBlock: removeBlock,
            child: AppContentBlock(
              userName: userName,
              onTapFindMentors: onTapFindMentor,
              onTapOfferMentors: onTapOfferMentors,
              isBottomArrow: false,
              isMentorBlock: true,
              entityName: entityName,
              avatarPath: avatarPath,
              mentorName: goal.mentor.fold(
                  () => null,
                  (a) =>
                      '${a.firstName.getOrElse(dflt: '')} ${a.lastName.getOrElse(dflt: '')}'),
              mentorAvatarPath: goal.mentor
                  .fold(() => null, (a) => a.photo.getOrElse(dflt: '')),
              repeatMeasure: repeatMeasure,
              repeatTextEditingController: TextEditingController(),
              repeatButtonFunction: (v) {},
              statusColor:
                  statusColor == const Color(0x00000000) ? null : statusColor,
              padding: paddingContent ?? const EdgeInsets.only(top: 10),
              isHeader: isHeader,
              isPurpose: true,
              hashTag: hashTags,
              title: goal.title.getOrElse(),
              date: goal.startAt.stringFromDateTime,
              deadlineAt: goal.deadlineAt.stringFromDateTime,
              isProgressBar: true,
              progressPercent: goal.progress.toInt(),
            ),
          )
        ],
      ),
    );
  }
}
