import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'skill.freezed.dart';

@freezed
class Skill with _$Skill {
  const factory Skill({
    required int id,
    required NonEmptyString title,
    required bool isAllowed,
  }) = _Skill;

  static Skill empty = Skill(
    id: 0,
    title: NonEmptyString(''),
    isAllowed: false,
  );

  // const Skill._();

}

@freezed
class MentorSkill with _$MentorSkill {
  const factory MentorSkill({
    required int id,
    required Skill baseSkill,
    required List<Skill> nestedSkills,
  }) = _MentorSkill;

  // static MentorSkill empty =
  //     MentorSkill(id: 0, baseSkill: Skill.empty, nestedSkills: <Skill>[]);

}
