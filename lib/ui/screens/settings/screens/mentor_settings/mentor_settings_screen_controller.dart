import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/core/utils/get_rx_wrapper_2.dart';
import 'package:sphere/data/dto/user_skills/user_skills.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/safe_coding/src/either.dart';
import '../../../../../core/utils/stream_subscriber.dart';
import '../../../../../domain/core/extended_errors.dart';
import '../../../../../domain/core/simple_message.dart';
import '../../../../../domain/post/skill.dart';
import '../../../../../domain/user_settings/user_settings.dart';
import '../../../../../domain/user_skills/user_skills.dart';
import '../../../../router/router.dart';
import '../../../../shared/app_alert.dart';
import '../../../../shared/app_colors.dart';
import '../../src/settings_service.dart';

class MentorSettingsScreenController extends StatexController
    with StreamSubscriberMixin {
  MentorSettingsScreenController({SettingsService? settingsService})
      : _settingsService = settingsService ?? Get.find();

  final SettingsService _settingsService;
  final String initialSkill = 'general.choose_category'.tr();

  /// Shortcut for [DateTime.now]
  DateTime get now => DateTime.now();
  final isTap = GetRxWrapper2(false);
  String titleStringForDelete = '';
  UserSettings? get userSettings$ =>
      _settingsService.userSettingsData.value$.fold((l) => null, (r) => r);

  //Ментор
  final _isMentor = false.obs;

  bool get isMentor$ => _isMentor();

  void setIsMentor(bool v) {
    if (!v) _currentUserSkillForAdd(initialSkill);
    _isMentor(v);
  }

  //редактирование скила
  final _currentUserSkillForEdit = ''.obs;

  get currentUserSkillForEdit$ => _currentUserSkillForEdit();

  final _userNestedSkillsListForEdit = <String>[].obs;

  List<String> get userNestedSkillsListForEdit$ =>
      _userNestedSkillsListForEdit();

  void removeNestedSkillForEdit(int index) {
    _userNestedSkillsListForEdit().removeAt(index);
    _userNestedSkillsListForEdit([..._userNestedSkillsListForEdit()]);
  }

  void addNestedSkillForEdit(String detail) {
    _userNestedSkillsListForEdit().add(detail);
    _userNestedSkillsListForEdit([..._userNestedSkillsListForEdit()]);
    editingDetailsTextController.clear();
  }

  void storeUserSkillAfterEdit(StoreMode mode) {
    final id = getBaseIdBySkillTitle(currentUserSkillForEdit$);
    final editId = getIdByUserSkillTitle(currentUserSkillForEdit$);
    _settingsService.storeUserSkill(
        id, userNestedSkillsListForEdit$, mode, editId);
    //Зачистка данных

    _currentUserSkillForEdit('');
    userNestedSkillsListForEdit$.clear();
  }

  void cancelEditSkill() {
    _currentUserSkillForEdit('');
  }

  void editSkill(String title) {
    _currentUserSkillForEdit(title);
    _userNestedSkillsListForEdit.clear();
    if (!userSkillsList$.contains(title)) return;
    _userNestedSkillsListForEdit.addAll(_userSkills
        .firstWhere(
            (e) => e.skill.title.getOrElse() == currentUserSkillForEdit$)
        .nestedSkills
        .map((e) => e.title.getOrElse()));
  }

  //добавление нового скила

  final _currentUserSkillForAdd = ''.obs;

  get currentUserSkillForAdd$ => _currentUserSkillForAdd();

  void setSkill(String v) {
    _currentUserSkillForAdd(v);
    _userNestedSkillsList.clear();
    if (!userSkillsList$.contains(v)) return;
    _userNestedSkillsList.addAll(_userSkills
        .firstWhere((e) => e.skill.title.getOrElse() == currentUserSkillForAdd$)
        .nestedSkills
        .map((e) => e.title.getOrElse()));
  }

  final addingDetailsTextController = TextEditingController();
  final editingDetailsTextController = TextEditingController();

  void cancelAddNewSkill() {
    _currentUserSkillForAdd(initialSkill);
  }

  //сохраненные увлечения

  final _userSkills = <UserSkills>[].obs;

  List<UserSkills> get userSkills$ => _userSkills();

  final _userSkillsList = <String>[].obs;

  List<String> get userSkillsList$ => _userSkillsList();

  final _userNestedSkillsList = <String>[].obs;

  List<String> get userNestedSkillsList$ => _userNestedSkillsList();

  void removeNestedSkill(int index) {
    _userNestedSkillsList().removeAt(index);
    _userNestedSkillsList([..._userNestedSkillsList()]);
  }

  void addNestedSkill(String detail) {
    _userNestedSkillsList().add(detail);
    _userNestedSkillsList([..._userNestedSkillsList()]);
    addingDetailsTextController.clear();
  }

  void storeUserSkill(StoreMode mode) {
    final id = getBaseIdBySkillTitle(currentUserSkillForAdd$);
    _settingsService.storeUserSkill(id, userNestedSkillsList$, mode, 0);
    //Зачистка данных
    _currentUserSkillForAdd(initialSkill);
    userNestedSkillsList$.clear();
  }

  //Список увлечений
  final _skills = <Skill>[].obs;
  List<Skill> get skills$ => _skills();

  final _skillsTitleList = <String>[].obs;
  List<String> get skillsTitleList$ => _skillsTitleList();

  final _skillsTitleListForAdd = <String>[].obs;
  List<String> get skillsTitleListForAdd$ => _skillsTitleListForAdd();

  void updateUserSettings() {
    _settingsService.updateUserSettings(isMentor: isMentor$ ? '1' : '0');
  }

  String getNestedTitleBySkillTitle(String skillTitle) {
    final details = _userSkills
        .firstWhere((e) => e.skill.title.getOrElse() == skillTitle)
        .nestedSkills
        .map((e) => e.title.getOrElse());
    return (details.isEmpty) ? '' : details.join(', ');
  }

  int getIdByUserSkillTitle(String skillTitle) {
    final skill =
        _userSkills.firstWhere((e) => e.skill.title.getOrElse() == skillTitle);
    return skill.id;
  }

  int getBaseIdBySkillTitle(String skillTitle) {
    final skill = skills$.firstWhere((e) => e.title.getOrElse() == skillTitle);
    return skill.id;
  }

  @override
  void onInit() {
    super.onInit();
    setIsMentor(getIsMentor());
    _currentUserSkillForAdd(initialSkill);
    subscribeIt(_settingsService.userSkills.stream.listen(_processUserSkills));
    subscribeIt(_settingsService.skillsList.stream.listen(_processSkills));
    subscribeIt(
        _settingsService.delUserSkill.stream.listen(_processDeleteUserSkill));
    subscribeIt(
        _settingsService.userSettingsData.stream.listen(_processUserSettings));
  }

  @override
  void onWidgetInitState() {
    super.onWidgetInitState();
    _settingsService.fetchUserSkills();
    _settingsService.fetchSkillsList();
  }

  bool getIsMentor() {
    return userSettings$?.userInfo.isMentor ?? false;
  }

  void _processUserSkills(Either<ExtendedErrors, List<UserSkills>> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      _userSkills.assignAll(r);
      _userSkillsList.assignAll(r.map((e) => e.skill.title.getOrElse()));
      filterForAdd();
    });
  }

  void _processSkills(Either<ExtendedErrors, List<Skill>> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      _skills.addAll(r);
      _skillsTitleList.addAll(r.map((e) => e.title.getOrElse()));
      filterForAdd();
    });
  }

  void _processDeleteUserSkill(Either<ExtendedErrors, SimpleMessage> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      appAlert(value: (r.message.getOrElse()), color: AppColors.mainColor);
    });
  }

  void _processUserSettings(Either<ExtendedErrors, UserSettings> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      setIsMentor(r.userInfo.isMentor);
    });
  }

  void filterForAdd() {
    if (skillsTitleList$.isEmpty || userSkillsList$.isEmpty) return;
    _skillsTitleListForAdd.assignAll(
        skillsTitleList$.where((title) => !userSkillsList$.contains(title)));
  }

  void removeUserSkill(String title) {
    titleStringForDelete = '';
    final id = getIdByUserSkillTitle(title);
    _settingsService.deleteUserSkill(id);
    AppRouter.pop();
  }
}
