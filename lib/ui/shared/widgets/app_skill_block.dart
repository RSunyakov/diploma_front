/*
import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/app_extensions.dart';

import '../../../data/dto/user_skills/user_skills.dart';
import '../app_colors.dart';
import '../app_expandable_panel.dart';
import '../app_styles.dart';
import 'app_chips.dart';
import 'app_discolored_button.dart';
import 'app_input.dart';
import 'app_text_button.dart';
import 'package:easy_localization/easy_localization.dart';

class AppSkillBlock extends StatelessWidget {
  const AppSkillBlock({
    Key? key,
    required this.header,
    this.initialValue = '', //controller.currentUserSkillForAdd$
    this.values = const <String>[], //controller.skillsTitleListForAdd$
    this.setSkill,
    required this.detailController, //controller.addingDetailsTextController
    this.addNestedSkill,
    this.nestedValues = const <String>[],
    this.removeNestedSkill,
    required this.cancelAddNewSkill,
    required this.storeMode,
    required this.storeUserSkill,
    required this.saveTitle,
  }) : super(key: key);

  final String header;
  final String initialValue;
  final List<String> values;
  final ValueChanged<String>? setSkill;
  final TextEditingController detailController;
  final ValueChanged<String>? addNestedSkill;
  final List<String> nestedValues;
  final ValueChanged<int>? removeNestedSkill;
  final VoidCallback cancelAddNewSkill;
  final StoreMode storeMode;
  final ValueChanged<StoreMode> storeUserSkill;
  final String saveTitle;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: AppColors.boxShadow,
          color: AppColors.white,
        ),
        padding: const EdgeInsets.only(
            left: 15.0, top: 10.0, right: 15.0, bottom: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                header,
                style: AppStyles.text12.andWeight(FontWeight.w400),
              ),
            ),
            10.h,
            if (storeMode == StoreMode.create)
              AppExpandablePanel(
                initialValue: initialValue,
                values: values,
                onChosen: (v) => setSkill?.call(v),
              ),
            if (storeMode == StoreMode.edit)
              Container(
                height: 30.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: AppColors.boxShadow,
                  color: AppColors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(initialValue,
                          style: AppStyles.text11
                              .andColor(AppColors.plainText)
                              .andWeight(
                                FontWeight.w300,
                              )),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.lightGrey,
                      )
                    ],
                  ),
                ),
              ),
            10.h,
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppInput(
                  margin: EdgeInsets.zero,
                  controller: detailController,
                  hintText: 'Например, гельштат-терапия',
                  isNeedAcceptButton: true,
                  onAcceptButtonTap: () {
                    if (detailController.text.isNotEmpty) {
                      addNestedSkill?.call(detailController.text);
                    }
                  }),
            ),
            if (nestedValues.isNotEmpty)
              Wrap(
                children: List.generate(
                  nestedValues.length,
                  (i) => Container(
                    margin: EdgeInsets.only(right: 10.kW),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: AppColors.boxShadow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppChips(
                      text: nestedValues[i],
                      onClose: () => removeNestedSkill?.call(i),
                    ),
                  ),
                ),
              ),
            20.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppDiscoloredButton(
                  onPressed: cancelAddNewSkill,
                  text: 'general.cancel'.tr(),
                ),
                30.w,
                AppTextButton(
                  onPressed: () => storeUserSkill(storeMode),
                  text: saveTitle,
                  width: 120,
                ),
              ],
            ),
          ],
        ),
      );
}
*/
