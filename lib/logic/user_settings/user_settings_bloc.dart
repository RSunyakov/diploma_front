import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

import '../../core/safe_coding/src/either.dart';
import '../../core/safe_coding/src/unit.dart';
import '../../data/dto/user_skills/user_skills.dart';
import '../../domain/city/city.dart';
import '../../domain/core/extended_errors.dart';
import '../../domain/core/simple_message.dart';
import '../../domain/country/country.dart';
import '../../domain/notification/notification.dart';
import '../../domain/user_settings/user_settings.dart';
import '../../domain/user_skills/user_skills.dart';
import '../repository/repository.dart';

part 'user_settings_bloc.freezed.dart';

@prod
@lazySingleton
class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  UserSettingsBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const UserSettingsState.initial()) {
    on<_GetUserSettingsEvent>(_getUserSettings);
    on<_UpdateUserSettingsEvent>(_updateUserSettings);
    on<_UpdateUserLoginEvent>(_updateUserLogin);
    on<_GetCountriesEvent>(_getCountries);
    on<_GetCitiesEvent>(_getCities);
    on<_GetNotificationsEvent>(_getNotifications);
    on<_GetUserSkillsEvent>(_getUserSkills);
    on<_DeleteUserSkillEvent>(_deleteUserSkill);
    on<_StoreUserSkillEvent>(_storeUserSkill);
  }

  final Repository _repo;

  Future _getUserSettings(
      _GetUserSettingsEvent event, Emitter<UserSettingsState> emit) async {
    emit(
      const UserSettingsState.gotUserSettings(
        UserSettingsStateData.loading(),
      ),
    );
    try {
      final rez = await _repo.getUserSettings();
      emit(
          UserSettingsState.gotUserSettings(UserSettingsStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserSettingsState.gotUserSettings(UserSettingsStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _updateUserSettings(
      _UpdateUserSettingsEvent event, Emitter<UserSettingsState> emit) async {
    emit(const UserSettingsState.userSettingsUpdated(
        UserSettingsStateData.loading()));

    try {
      final rez = await _repo.updateUserSettings(
        firstName: event.firstName,
        lastName: event.lastName,
        gender: event.gender,
        birthday: event.birthday,
        photo: event.photo,
        countryId: event.countryId,
        cityId: event.cityId,
        isMentor: event.isMentor,
        notifications: event.notifications,
        mainInfoVisible: event.mainInfoVisible,
        statisticsVisible: event.statisticsVisible,
        searchVisible: event.searchVisible,
        goalsInProgressVisible: event.goalsInProgressVisible,
        achievementsVisible: event.achievementsVisible,
        goalsCompleteVisible: event.goalsCompleteVisible,
        goalsOverdueVisible: event.goalsOverdueVisible,
        goalsPausedVisible: event.goalsPausedVisible,
        goalsDetailsOpen: event.goalsDetailsOpen,
        goalsFavoritesAdd: event.goalsFavoritesAdd,
        goalsCopy: event.goalsCopy,
        goalsCommentsVisible: event.goalsCommentsVisible,
        goalsCommentsWrite: event.goalsCommentsWrite,
        mentoringOffer: event.mentoringOffer,
        mentoringBecome: event.mentoringBecome,
        reportsVisible: event.reportsVisible,
        reportsComments: event.reportsComments,
      );
      emit(UserSettingsState.userSettingsUpdated(
          UserSettingsStateData.result(rez)));
    } on Error catch (e) {
      debugPrint('$now: UserSettingsBloc._updateUserSettings.2: Error = $e');
    } on Exception catch (e) {
      emit(UserSettingsState.userSettingsUpdated(UserSettingsStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _updateUserLogin(
      _UpdateUserLoginEvent event, Emitter<UserSettingsState> emit) async {
    emit(const UserSettingsState.userLoginUpdated(
        UserSettingsStateData.loading()));

    try {
      final rez = await _repo.updateUserLogin(
        login: event.login,
        oldCode: event.oldCode,
        newCode: event.newCode,
      );
      emit(UserSettingsState.userLoginUpdated(
          UserSettingsStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserSettingsState.userLoginUpdated(UserSettingsStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _getCountries(
      _GetCountriesEvent event, Emitter<UserSettingsState> emit) async {
    emit(
      const UserSettingsState.gotCountries(
        UserSettingsStateData.loading(),
      ),
    );
    try {
      final rez = await _repo.getCountries();
      emit(UserSettingsState.gotCountries(UserSettingsStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserSettingsState.gotCountries(UserSettingsStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _getCities(
      _GetCitiesEvent event, Emitter<UserSettingsState> emit) async {
    emit(
      const UserSettingsState.gotCities(
        UserSettingsStateData.loading(),
      ),
    );
    try {
      final rez = await _repo.getCities(event.countryId);
      emit(UserSettingsState.gotCities(UserSettingsStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserSettingsState.gotCities(UserSettingsStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _getNotifications(
      _GetNotificationsEvent event, Emitter<UserSettingsState> emit) async {
    emit(
      const UserSettingsState.gotNotifications(
        UserSettingsStateData.loading(),
      ),
    );
    try {
      final rez = await _repo.getNotifications();
      emit(UserSettingsState.gotNotifications(
          UserSettingsStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserSettingsState.gotNotifications(UserSettingsStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _getUserSkills(
      _GetUserSkillsEvent event, Emitter<UserSettingsState> emit) async {
    emit(
      const UserSettingsState.gotUserSkills(
        UserSettingsStateData.loading(),
      ),
    );
    try {
      final rez = await _repo.getUserSkills();
      emit(UserSettingsState.gotUserSkills(UserSettingsStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserSettingsState.gotUserSkills(UserSettingsStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _deleteUserSkill(
      _DeleteUserSkillEvent event, Emitter<UserSettingsState> emit) async {
    emit(const UserSettingsState.deletedUserSkill(
        UserSettingsStateData.loading()));
    final res = await _repo.deleteUserSkill(event.id);
    emit(UserSettingsState.deletedUserSkill(UserSettingsStateData.result(res)));
    final rez = await _repo.getUserSkills();
    emit(UserSettingsState.gotUserSkills(UserSettingsStateData.result(rez)));
  }

  Future _storeUserSkill(
      _StoreUserSkillEvent event, Emitter<UserSettingsState> emit) async {
    emit(
      const UserSettingsState.storedUserSkill(
        UserSettingsStateData.loading(),
      ),
    );
    try {
      if (event.mode == StoreMode.edit) {
        await _repo.deleteUserSkill(event.editId);
      }
      final res =
          await _repo.storeUserSkill(AddUserSkillBody(skillId: event.id));
      final details = event.details.split(',');
      if (details.isNotEmpty) {
        final List<Future> futureList = <Future>[];
        for (int i = 0; i < details.length; i++) {
          futureList.add(storeDetail(event.id, details[i]));
        }
        await Future.wait(futureList);
      }
      emit(
          UserSettingsState.storedUserSkill(UserSettingsStateData.result(res)));
      final rez = await _repo.getUserSkills();
      emit(UserSettingsState.gotUserSkills(UserSettingsStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserSettingsState.storedUserSkill(UserSettingsStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future storeDetail(int id, String detail) async {
    await _repo.storeUserSkill(AddUserSkillBody(skillId: id, title: detail));
  }
}

@freezed
class UserSettingsEvent with _$UserSettingsEvent {
  const factory UserSettingsEvent.getUserSettings() = _GetUserSettingsEvent;

  const factory UserSettingsEvent.updateUserSettings({
    String? firstName,
    String? lastName,
    String? gender,
    String? birthday,
    File? photo,
    int? countryId,
    int? cityId,
    String? isMentor,
    String? notifications,
    String? mainInfoVisible,
    String? statisticsVisible,
    String? searchVisible,
    String? goalsInProgressVisible,
    String? achievementsVisible,
    String? goalsCompleteVisible,
    String? goalsOverdueVisible,
    String? goalsPausedVisible,
    String? goalsDetailsOpen,
    String? goalsFavoritesAdd,
    String? goalsCopy,
    String? goalsCommentsVisible,
    String? goalsCommentsWrite,
    String? mentoringOffer,
    String? mentoringBecome,
    String? reportsVisible,
    String? reportsComments,
  }) = _UpdateUserSettingsEvent;

  const factory UserSettingsEvent.updateUserLogin({
    required String login,
    required String oldCode,
    required String newCode,
  }) = _UpdateUserLoginEvent;

  const factory UserSettingsEvent.getCountries() = _GetCountriesEvent;

  const factory UserSettingsEvent.getCities(int countryId) = _GetCitiesEvent;

  const factory UserSettingsEvent.getNotifications() = _GetNotificationsEvent;

  const factory UserSettingsEvent.getUserSkills() = _GetUserSkillsEvent;

  const factory UserSettingsEvent.deleteUserSkill(int id) =
      _DeleteUserSkillEvent;

  const factory UserSettingsEvent.storeUserSkill(
          int id, String details, StoreMode mode, int editId) =
      _StoreUserSkillEvent;
}

@freezed
class UserSettingsState with _$UserSettingsState {
  const factory UserSettingsState.initial() = _Initial;

  const factory UserSettingsState.gotUserSettings(
          UserSettingsStateData<Either<ExtendedErrors, UserSettings>> data) =
      _GotUserSettings;

  const factory UserSettingsState.userSettingsUpdated(
          UserSettingsStateData<Either<ExtendedErrors, UserSettings>> data) =
      _UserSettingsUpdated;

  const factory UserSettingsState.userLoginUpdated(
          UserSettingsStateData<Either<ExtendedErrors, UserSettings>> data) =
      _UserLoginUpdated;

  const factory UserSettingsState.gotCountries(
          UserSettingsStateData<Either<ExtendedErrors, List<Country>>> data) =
      _GotCountries;

  const factory UserSettingsState.gotCities(
          UserSettingsStateData<Either<ExtendedErrors, List<City>>> data) =
      _GotCities;

  const factory UserSettingsState.gotNotifications(
      UserSettingsStateData<Either<ExtendedErrors, List<Notification>>>
          data) = _GotNotifications;

  const factory UserSettingsState.gotUserSkills(
      UserSettingsStateData<Either<ExtendedErrors, List<UserSkills>>>
          data) = _GotUserSkills;

  const factory UserSettingsState.deletedUserSkill(
          UserSettingsStateData<Either<ExtendedErrors, SimpleMessage>> data) =
      _DataDeletedUserSkill;

  const factory UserSettingsState.storedUserSkill(
          UserSettingsStateData<Either<ExtendedErrors, Unit>> data) =
      _DataStoredUserSkill;
}

/// Динамические данные для каждого из [UserSettingsState]
/// Позволяют использовать каждый [UserSettingsState] в трех внутренних режимах:
/// [initial], [loading] & [result]
@freezed
class UserSettingsStateData<T> with _$UserSettingsStateData<T> {
  const factory UserSettingsStateData.initial() = _InitialData<T>;

  const factory UserSettingsStateData.loading() = _LoadingData<T>;

  /// Подразумевается, что (на данном этапе) данные какбэ не нужны,
  /// важно только лево/право
  const factory UserSettingsStateData.result(T data) = _ResultData<T>;
}
