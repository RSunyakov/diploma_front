import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'user_skills.freezed.dart';

@freezed
class UserSkills with _$UserSkills {
  const factory UserSkills({
    required int id,
    required UserSkill skill,
    required List<UserSkill> nestedSkills,
  }) = _UserSkills;

  const UserSkills._();

  static UserSkills empty =
      UserSkills(id: 0, skill: UserSkill.empty, nestedSkills: []);
}

@freezed
class UserSkill with _$UserSkill {
  const factory UserSkill({
    required int id,
    required NonEmptyString title,
  }) = _UserSkill;

  static UserSkill empty = UserSkill(
    id: 0,
    title: NonEmptyString(''),
  );
}
