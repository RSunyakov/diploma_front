/*
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:sphere/ui/shared/widgets/app_switch_container.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import '../../../../../domain/city/city.dart';
import '../../../../../domain/country/country.dart';
import '../../../../shared/app_expandable_panel.dart';
import '../../../../shared/widgets/app_autocomplete_text_field.dart';
import '../../../../shared/widgets/app_calendar.dart';
import 'page_settings_screen_controller.dart';

class PageSettingsScreen extends StatexWidget<PageSettingsScreenController> {
  PageSettingsScreen({Key? key})
      : super(() => PageSettingsScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) => _PageSettingsScreen();
}

class _PageSettingsScreen extends GetView<PageSettingsScreenController> {
  final GlobalKey<AppAutocompleteTextFieldState> _countriesKey = GlobalKey();
  final GlobalKey<AppAutocompleteTextFieldState> _citiesKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      gradient: AppColors.stdHGradient,
      appBar: appBar(
        context,
        text: 'general.settings'.tr(),
        isLeading: true,
        funcBack: FocusScope.of(context).unfocus,
      ),
      child: GestureDetector(
        onTap: () {
          _countriesKey.currentState!.refresh();
          _citiesKey.currentState!.refresh();
          FocusManager.instance.primaryFocus?.unfocus();
          debugPrint('_PageSettingsScreen.build');
        },
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            onChanged: () {},
            child: Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.kW),
                child: Column(children: [
                  16.h,
                  AppAvatarBlock(
                    path: controller.avatar$,
                    file: controller.avatarFile,
                    radius: 22.5,
                    color: AppColors.white,
                  ),
                  4.h,
                  GestureDetector(
                    onTap: () => controller.openBottomSheet(context),
                    child: Text(
                      controller.avatar$ != ''
                          ? 'settings.change_photo'.tr()
                          : 'settings.add_photo'.tr(),
                      style: AppStyles.text12
                          .andColor(AppColors.activeText)
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                  26.h,
                  AppInput(
                    margin: EdgeInsets.zero,
                    hintText: 'general.last_name'.tr(),
                    onChanged: controller.changeLastName,
                    controller: controller.lastNameTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'general.required_field'.tr();
                      }
                      return null;
                    },
                  ),
                  10.h,
                  AppInput(
                    margin: EdgeInsets.zero,
                    hintText: 'general.name'.tr(),
                    onChanged: controller.changeFirstName,
                    controller: controller.firstNameTextController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'general.required_field'.tr();
                      }
                      return null;
                    },
                  ),
                  10.h,
                  Obx(
                    () => AppExpandablePanel(
                      initialValue: controller.sex$,
                      values: controller.sexes,
                      onChosen: controller.setSex,
                    ),
                  ),
                  10.h,
                  if (controller.isShowBirthday$)
                    Obx(
                      () => AppCalendar(
                        label: 'general.day_of_birth'.tr(),
                        initialValue: controller.birthday$,
                        onChosen: controller.setBirthday,
                        maxHeight: 135,
                        margin: 0.insetsAll,
                      ),
                    ),
                  10.h,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.kW),
                    child: AppSwitchContainer(
                      title: 'settings.show_birth_day'.tr(),
                      value: controller.isShowBirthday$,
                      onChanged: controller.setIsShowBirthday,
                    ),
                  ),
                  10.h,
                  Obx(
                    () => AppAutocompleteTextField<Country>(
                      key: _countriesKey,
                      controller: controller.countryTextController,
                      hint: 'general.country'.tr(),
                      initialValue: controller.country$.name.getOrElse(),
                      getSuggestions: controller.getCountries,
                      convertToString: (v) => v.name.getOrElse(),
                      onChosen: (v) {
                        controller.clearCities();
                        controller.setCountry(v);
                      },
                      noItemsFoundText: 'general.no_countries_found'.tr(),
                    ),
                  ),
                  10.h,
                  Obx(
                    () => AppAutocompleteTextField<City>(
                      key: _citiesKey,
                      controller: controller.cityTextController,
                      hint: 'general.city'.tr(),
                      initialValue: controller.city$.name.getOrElse(),
                      getSuggestions: controller.getCities,
                      convertToString: (v) => v.name.getOrElse(),
                      onChosen: controller.setCity,
                      noItemsFoundText: 'general.no_cities_found'.tr(),
                    ),
                  ),
                  100.h,
                  AppTextButton(
                    onPressed: () {
                      controller.formKey.currentState!.validate()
                          ? controller.updateUserSettings()
                          : null;
                    },
                    text: 'general.save'.tr(),
                    width: 160,
                  ),
                  24.h,
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
