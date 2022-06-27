/*
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sphere/data/dto/user_skills/user_skills.dart';
import 'package:sphere/ui/shared/app_extensions.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:sphere/ui/shared/widgets/app_bottom_sheet/app_bottom_sheet_controller.dart';
import 'package:sphere/ui/shared/widgets/app_skill_block.dart';
import 'package:sphere/ui/shared/widgets/app_skill_item.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:vfx_flutter_common/utils.dart';

import '../../../../router/router.dart';
import '../../../../shared/app_colors.dart';
import '../../../../shared/app_consts.dart';
import '../../../../shared/app_expandable_panel.dart';
import '../../../../shared/app_styles.dart';
import '../../../../shared/widgets/app_discolored_button.dart';
import '../../../../shared/widgets/app_switch_container.dart';
import 'mentor_settings_screen_controller.dart';

class MentorSettingsScreen
    extends StatexWidget<MentorSettingsScreenController> {
  MentorSettingsScreen({Key? key})
      : super(() => MentorSettingsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => const _MentorSettingsScreen();
}

class _MentorSettingsScreen extends GetView<MentorSettingsScreenController> {
  const _MentorSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.settings'.tr(),
        isLeading: true,
      ),
      child: SingleChildScrollView(
        child: Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.kW),
              child: Column(
                children: [
                  16.h,
                  AppSwitchContainer(
                    title: 'general.mentor'.tr(),
                    value: controller.isMentor$,
                    onChanged: controller.setIsMentor,
                  ),
                  if (controller.isMentor$)
                    Column(
                      children: [
                        20.h,
                        (controller.currentUserSkillForAdd$ ==
                                controller.initialSkill)
                            ? AppExpandablePanel(
                                initialValue:
                                    controller.currentUserSkillForAdd$,
                                values: controller.skillsTitleListForAdd$,
                                onChosen: controller.setSkill,
                              )
                            : AppSkillBlock(
                                header: 'general.new_category'.tr(),
                                initialValue:
                                    controller.currentUserSkillForAdd$,
                                values: controller.skillsTitleListForAdd$,
                                setSkill: controller.setSkill,
                                detailController:
                                    controller.addingDetailsTextController,
                                addNestedSkill: controller.addNestedSkill,
                                removeNestedSkill: controller.removeNestedSkill,
                                nestedValues: controller.userNestedSkillsList$,
                                cancelAddNewSkill: controller.cancelAddNewSkill,
                                storeMode: StoreMode.create,
                                storeUserSkill: controller.storeUserSkill,
                                saveTitle: 'general.add'.tr(),
                              ),
                        20.h,
                        ..._buildSkills(context),
                      ],
                    ),
                  30.h,
                  AppTextButton(
                    onPressed: controller.updateUserSettings,
                    text: 'general.save'.tr(),
                    width: 160,
                  ),
                  24.h,
                ],
              ),
            )),
      ),
    );
  }

  List<Widget> _buildSkills(BuildContext context) {
    List<Widget> list = [];
    for (var title in controller.userSkillsList$) {
      list.add((controller.currentUserSkillForEdit$ == title)
          ? AppSkillBlock(
              header: 'general.edit_category'.tr(),
              initialValue: title,
              detailController: controller.editingDetailsTextController,
              addNestedSkill: controller.addNestedSkillForEdit,
              removeNestedSkill: controller.removeNestedSkillForEdit,
              nestedValues: controller.userNestedSkillsListForEdit$,
              cancelAddNewSkill: controller.cancelEditSkill,
              storeMode: StoreMode.edit,
              storeUserSkill: controller.storeUserSkillAfterEdit,
              saveTitle: 'general.ok',
            )
          : AppSkillItem(
              title: title,
              details: controller.getNestedTitleBySkillTitle(title),
              editSkill: () => controller.editSkill(title),
              deleteSkill: () {
                controller.titleStringForDelete = title;
                _openBottomSheet(context, child: const _AlertBottomSheet());
              },
            ));
      list.add(10.h);
    }
    return list;
  }

  void _openBottomSheet(BuildContext context, {required Widget child}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return AppBottomSheet(child: child);
      },
    );
  }
}

class _AlertBottomSheet extends GetViewSim<MentorSettingsScreenController> {
  const _AlertBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomCtrl = Get.find<AppBottomSheetController>();
    delayMilli(AppConsts.delayForEscapeVisualConflict).then((_) {
      bottomCtrl.height.value = 160;
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'general.sure_delete_category'.tr(),
          style: AppStyles.text14
              .andWeight(FontWeight.w700)
              .andColor(AppColors.plainText),
          textAlign: TextAlign.center,
        ),
        20.h,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IgnorePointer(
              ignoring: c.isTap.value$,
              child: AppDiscoloredButton(
                text: 'general.cancel'.tr(),
                onPressed: () {
                  c.isTap.value(true);
                  AppRouter.pop();
                  c.isTap.value(false);
                },
              ),
            ),
            AppDiscoloredButton(
              text: 'general.ok',
              onPressed: () =>
                  controller.removeUserSkill(controller.titleStringForDelete),
            ),
          ],
        )
      ],
    );
  }
}
*/
