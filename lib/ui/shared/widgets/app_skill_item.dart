import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppSkillItem extends StatelessWidget {
  const AppSkillItem({
    Key? key,
    this.title = '',
    this.details = '',
    required this.editSkill,
    required this.deleteSkill,
  }) : super(key: key);

  final String title;
  final String details;
  final VoidCallback editSkill;
  final VoidCallback deleteSkill;
  final topPadding = 10.0;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: AppColors.boxShadow,
          color: AppColors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: topPadding),
              child: Text(
                title,
                style: AppStyles.text12
                    .andColor(AppColors.mainColor)
                    .andWeight(FontWeight.w500),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: topPadding, bottom: 5),
                child: Text(
                  details,
                  style: AppStyles.text12.andWeight(FontWeight.w400),
                ),
              ),
            ),
            GestureDetector(
              onTap: editSkill,
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Container(
                  padding: 4.insetsAll,
                  child: const Icon(
                    Icons.mode_edit,
                    color: AppColors.mainColor,
                    size: 17,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: deleteSkill,
              child: Container(
                padding: 4.insetsAll,
                child: const Icon(Icons.close, color: AppColors.lightGrey),
              ),
            )
          ],
        ),
      );
}
