import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/achievement/achievement.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/post/skill.dart';
import 'package:sphere/domain/students/students.dart';

import '../../core/safe_coding/src/option.dart';
import '../city/city.dart';
import '../country/country.dart';

part 'user_settings.freezed.dart';

@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    required UserInfo userInfo,
    required Option<List<Setting>> settings,
    required Option<List<NotificationSetting>> notifications,
  }) = _UserSettings;
}

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required NonEmptyString uuid,
    required NonEmptyString photo,
    required Email email,
    required NonEmptyString phone,
    required int age,
    required NonEmptyString gender,
    required bool isBanned,
    required NonEmptyString firstName,
    String? middleName,
    required NonEmptyString lastName,
    String? geo,
    required NonEmptyString birthday,
    required NonEmptyString joinedAt,
    String? position,
    required Country country,
    required City city,
    required bool isMentor,
    double? rating,
    String? url,
    Students? students,
    List<WorkOccupation>? career,
    List<StudyOccupation>? education,
    List<HobbyOccupation>? skillsHobby,
    List<Achievement>? achievements,
    List<Goal>? goals,
    bool? alreadyFollow,
    bool? alreadyMentor,
    bool? isChoosen,
    List<MentorSkill>? skillsMentor,
  }) = _UserInfo;
}

@freezed
class Setting with _$Setting {
  const factory Setting({
    required NonEmptyString name,
    required NonEmptyString value,
  }) = _Setting;
}

// class OptionalSettingListConverter
//     implements JsonConverter<Option<List<Setting>>, String> {
//   const OptionalSettingListConverter();
//
//   @override
//   Option<List<Setting>> fromJson(String json) {
//     try {
//       final map = jsonDecode(json);
//       return some((map as List<dynamic>)
//           .map((item) => Setting.fromJson(item))
//           .toList());
//     } on Error catch (_) {
//       // Сработает в случае, если обломается JsonSerialization
//       return none();
//     } on Exception catch (_) {
//       return none();
//     }
//   }
//
//   @override
//   String toJson(Option<List<Setting>> object) {
//     return object.fold(
//         () => '{}', (a) => jsonEncode(a.map((e) => e.toJson()).toList()));
//   }
// }
//

@freezed
class NotificationSetting with _$NotificationSetting {
  const factory NotificationSetting({
    required NonEmptyString id,
    required NonEmptyString name,
  }) = _NotificationSetting;

  static NotificationSetting empty = NotificationSetting(
    id: NonEmptyString(''),
    name: NonEmptyString(''),
  );
}

// class OptionalNotificationListConverter
//     implements JsonConverter<Option<List<NotificationSetting>>, String> {
//   const OptionalNotificationListConverter();
//
//   @override
//   Option<List<NotificationSetting>> fromJson(String json) {
//     try {
//       final map = jsonDecode(json);
//       return some((map as List<dynamic>)
//           .map((item) => NotificationSetting.fromJson(item))
//           .toList());
//     } on Error catch (_) {
//       // Сработает в случае, если обломается JsonSerialization
//       return none();
//     } on Exception catch (_) {
//       return none();
//     }
//   }
//
//   @override
//   String toJson(Option<List<NotificationSetting>> object) {
//     return object.fold(
//         () => '{}', (a) => jsonEncode(a.map((e) => e.toJson()).toList()));
//   }
// }
