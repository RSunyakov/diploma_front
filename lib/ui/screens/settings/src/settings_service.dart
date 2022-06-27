import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sphere/core/utils/get_rx_wrapper.dart';
import 'package:sphere/core/utils/get_rx_wrapper_2.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:sphere/data/dto/user_skills/user_skills.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/ui/shared/app_alert.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import '../../../../core/safe_coding/src/either.dart';
import '../../../../core/safe_coding/src/unit.dart';
import '../../../../domain/city/city.dart';
import '../../../../domain/core/extended_errors.dart';
import '../../../../domain/core/value_objects.dart';
import '../../../../domain/country/country.dart';
import '../../../../domain/notification/notification.dart';
import '../../../../domain/post/skill.dart';
import '../../../../domain/user_settings/user_settings.dart';
import '../../../../domain/user_skills/user_skills.dart';
import '../../../../logic/achievement/skills_list_bloc.dart';
import '../../../../logic/auth/auth_bloc.dart';
import '../../../../logic/user_settings/user_settings_bloc.dart';
import 'package:rxdart/rxdart.dart' as rx;

typedef OrUserSettings = Either<ExtendedErrors, UserSettings>;
typedef OrCountries = Either<ExtendedErrors, List<Country>>;
typedef OrCities = Either<ExtendedErrors, List<City>>;
typedef OrNotifications = Either<ExtendedErrors, List<Notification>>;
typedef OrUserSkills = Either<ExtendedErrors, List<UserSkills>>;
typedef OrSkillsList = Either<ExtendedErrors, List<Skill>>;
typedef OrUnit = Either<ExtendedErrors, Unit>;
typedef OrSimpleMessage = Either<ExtendedErrors, SimpleMessage>;

class SettingsService extends GetxService with StreamSubscriberMixin {
  SettingsService({
    UserSettingsBloc? userSettingsBloc,
    AuthBloc? authBloc,
    SkillsListBloc? skillsListBloc,
  })  : _userSettingsBloc = userSettingsBloc ?? GetIt.I.get(),
        _authBloc = authBloc ?? GetIt.I.get(),
        _skillsListBloc = skillsListBloc ?? GetIt.I.get();

  final AuthBloc _authBloc;

  final UserSettingsBloc _userSettingsBloc;

  final SkillsListBloc _skillsListBloc;

  final userSettingsData = GetRxWrapper2<OrUserSettings>(
    left(ExtendedErrors.empty()),
    forceRefresh: true,
  );

  final countries = GetRxWrapper2<OrCountries>(left(ExtendedErrors.empty()));

  final cities = GetRxWrapper2<OrCities>(left(ExtendedErrors.empty()));

  final notifications =
      GetRxWrapper2<OrNotifications>(left(ExtendedErrors.empty()));

  final userSkills = GetRxWrapper2<OrUserSkills>(left(ExtendedErrors.empty()));

  final userSettingsState = GetRxWrapper(const UserSettingsState.initial());

  final _userSettingsStateData =
      rx.BehaviorSubject.seeded(const UserSettingsStateData.loading());

  Stream<UserSettingsStateData> get userSettingsStateData$ =>
      _userSettingsStateData;

  final authState = GetRxWrapper(const AuthState.initial());

  final skillsListState = GetRxWrapper(const SkillsListState.initial());

  final isCodeForChangeLoginFetched = GetRxWrapper(false);

  final isCodeForChangeLoginRepeatedFetched = GetRxWrapper(false);

  final isLoginUpdated = GetRxWrapper(false);

  final skillsList = GetRxWrapper2<OrSkillsList>(left(ExtendedErrors.empty()));

  final delUserSkill =
      GetRxWrapper2<OrSimpleMessage>(left(ExtendedErrors.empty()));

  final savingUserSkill = GetRxWrapper2<OrUnit>(left(ExtendedErrors.empty()));

  @override
  void onInit() {
    super.onInit();
    subscribeIt(_userSettingsBloc.stream.listen(_processUserSettingsState));
    subscribeIt(_authBloc.stream.listen(_processAuthState));
    subscribeIt(_skillsListBloc.stream.listen(_processSkillsListState));
  }

  void _processUserSettingsState(UserSettingsState state) {
    userSettingsState.value = state;
    state.maybeWhen(
      gotUserSettings: (d) {
        _userSettingsStateData.add(d);
        d.maybeWhen(
          // FIXME(vvk): Это проглатывало ошибку, она просто не показывалась.
          //    `result: (r) => userSettingsData.value(r),`
          //  Такое имеет смысл если где-то дальше userSettingsData.value()
          //  отображает свою левую часть.
          // Предлагаемый подход сразу отображает ошибку и в то же время
          // пробрасывает полные карманы дальше на всякий случай
          result: (res) {
            res.fold(
              (l) => appAlert(value: l.smartErrorsValue, color: AppColors.red),
              (r) => userSettingsData.value(res),
            );
          },
          orElse: () => left(ExtendedErrors.empty()),
        );
      },
      gotCountries: (d) => d.maybeWhen(
        result: (r) {
          countries.value(r);
        },
        orElse: () => left(ExtendedErrors.empty()),
      ),
      gotCities: (d) => d.maybeWhen(
        result: (r) {
          cities.value(r);
        },
        orElse: () => left(ExtendedErrors.empty()),
      ),
      gotNotifications: (d) => d.maybeWhen(
        result: (r) {
          notifications.value(r);
        },
        orElse: () => left(ExtendedErrors.empty()),
      ),
      gotUserSkills: (d) => d.maybeWhen(
        result: (r) {
          userSkills.value(r);
        },
        orElse: () => left(ExtendedErrors.empty()),
      ),
      userSettingsUpdated: (d) => d.maybeWhen(
        result: (res) {
          isLoginUpdated.value = true;
          userSettingsData.value(res);
        },
        orElse: () => left(ExtendedErrors.empty()),
      ),
      userLoginUpdated: (d) => d.maybeWhen(
        result: (r) => userSettingsData.value(r),
        orElse: () => left(ExtendedErrors.empty()),
      ),
      deletedUserSkill: (d) => d.maybeWhen(
        result: (r) {
          delUserSkill.value(r);
        },
        orElse: () => left(ExtendedErrors.empty()),
      ),
      orElse: () => left(ExtendedErrors.empty()),
    );
  }

  void _processAuthState(AuthState state) {
    authState.value = state;
    try {
      state.maybeWhen(
        changeLoginCodeFetched: (d) => d.maybeWhen(
          result: (r) => r.fold((l) => null, (r) {
            isCodeForChangeLoginFetched.value = r.status;
          }),
          orElse: () {},
        ),
        changeLoginCodeRepeatedFetched: (d) => d.maybeWhen(
          result: (r) => r.fold((l) => null, (r) {
            isCodeForChangeLoginRepeatedFetched.value = r.status;
          }),
          orElse: () {},
        ),
        orElse: () {},
      );
    } catch (e, s) {
      debugPrint('$s');
    }
  }

  void _processSkillsListState(SkillsListState state) {
    skillsListState.value = state;
    state.maybeWhen(
        orElse: () => left(ExtendedErrors.empty()),
        gotSkillsList: (d) => d.maybeWhen(
              result: (r) {
                skillsList.value(r);
              },
              orElse: () => left(ExtendedErrors.empty()),
            ));
  }

  void fetchUserSettings() {
    _userSettingsBloc.add(const UserSettingsEvent.getUserSettings());
  }

  void fetchUserSkills() {
    _userSettingsBloc.add(const UserSettingsEvent.getUserSkills());
  }

  void fetchSkillsList() {
    _skillsListBloc.add(const SkillsListEvent.getSkillsList());
  }

  void fetchCountries() {
    _userSettingsBloc.add(const UserSettingsEvent.getCountries());
  }

  void fetchCities(int countryId) {
    _userSettingsBloc.add(UserSettingsEvent.getCities(countryId));
  }

  void fetchNotifications() {
    _userSettingsBloc.add(const UserSettingsEvent.getNotifications());
  }

  void updateUserSettings({
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
  }) {
    _userSettingsBloc.add(
      UserSettingsEvent.updateUserSettings(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        birthday: birthday,
        photo: photo,
        countryId: countryId,
        cityId: cityId,
        isMentor: isMentor,
        notifications: notifications,
        mainInfoVisible: mainInfoVisible,
        statisticsVisible: statisticsVisible,
        searchVisible: searchVisible,
        goalsInProgressVisible: goalsInProgressVisible,
        achievementsVisible: achievementsVisible,
        goalsCompleteVisible: goalsCompleteVisible,
        goalsOverdueVisible: goalsOverdueVisible,
        goalsPausedVisible: goalsPausedVisible,
        goalsDetailsOpen: goalsDetailsOpen,
        goalsFavoritesAdd: goalsFavoritesAdd,
        goalsCopy: goalsCopy,
        goalsCommentsVisible: goalsCommentsVisible,
        goalsCommentsWrite: goalsCommentsWrite,
        mentoringOffer: mentoringOffer,
        mentoringBecome: mentoringBecome,
        reportsVisible: reportsVisible,
        reportsComments: reportsComments,
      ),
    );
  }

  void updateUserLogin({
    required String login,
    required String oldCode,
    required String newCode,
  }) {
    _userSettingsBloc.add(
      UserSettingsEvent.updateUserLogin(
        login: login,
        oldCode: oldCode,
        newCode: newCode,
      ),
    );
  }

  void fetchCodeForChangeLogin(String login, bool isForOldLogin) {
    isForOldLogin
        ? _authBloc.add(
            AuthEvent.fetchCodeForChangeLogin(
              login: NonEmptyString(login),
            ),
          )
        : _authBloc.add(
            AuthEvent.fetchCodeForChangeLoginRepeated(
              login: NonEmptyString(login),
            ),
          );
  }

  void deleteUserSkill(int id) {
    _userSettingsBloc.add(UserSettingsEvent.deleteUserSkill(id));
  }

  void storeUserSkill(
      int id, List<String> details, StoreMode mode, int editId) {
    _userSettingsBloc.add(
        UserSettingsEvent.storeUserSkill(id, details.join(','), mode, editId));
  }
}
