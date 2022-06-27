import 'package:flutter/material.dart';
import 'package:sphere/domain/reports/report.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/app_content_block.dart';
import 'package:sphere/ui/shared/widgets/app_overflow_block.dart';

class ReportForLenta extends StatelessWidget {
  const ReportForLenta(
      {required this.report,
      Key? key,
      this.onReportTap,
      this.onTapOfferMentors,
      this.onTapFindMentor,
      this.entityName,
      this.avatarPath,
      required this.userName,
      this.isFavorite,
      this.plusBlock,
      this.favoriteBlock,
      required this.progress})
      : super(key: key);

  final Report report;
  final Function()? onReportTap;
  final Function()? onTapOfferMentors;
  final Function()? onTapFindMentor;
  final String? entityName;
  final String? avatarPath;
  final String userName;
  final bool? isFavorite;
  final Function()? plusBlock;
  final Function()? favoriteBlock;
  final int progress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onReportTap,
      child: Column(
        children: [
          AppOverflowBlock(
            padding: const EdgeInsets.only(top: 0, left: 22, right: 16),
            isGoal: true,
            isFavorite: isFavorite ?? false,
            favoriteBlock: favoriteBlock,
            plusBlock: plusBlock,
            child: AppContentBlock(
              userName: userName,
              onTapFindMentors: onTapFindMentor,
              onTapOfferMentors: onTapOfferMentors,
              isBottomArrow: false,
              isMentorBlock: false,
              entityName: entityName,
              avatarPath: avatarPath,
              repeatTextEditingController: TextEditingController(),
              repeatButtonFunction: (v) {},
              padding: const EdgeInsets.only(top: 10),
              isHeader: true,
              isPurpose: true,
              title: report.description.getOrElse(),
              date: report.createdAt.stringFromDateTime,
              isProgressBar: true,
              progressPercent: progress,
            ),
          )
        ],
      ),
    );
  }
}
