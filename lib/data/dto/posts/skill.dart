import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill.g.dart';

@JsonSerializable()
class SkillDto {
  int? id;
  SkillDataDto? baseSkill;
  List<SkillDataDto>? nestedSkills;

  SkillDto({this.id, this.baseSkill, this.nestedSkills});

  factory SkillDto.fromJson(Map<String, dynamic> json) =>
      _$SkillDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SkillDtoToJson(this);
}

@JsonSerializable()
class SkillDataDto {
  int? id;
  String? title;
  bool? isAllowed;
  List<SkillDataDto>? children;

  SkillDataDto({
    this.id,
    this.title,
    this.isAllowed,
    this.children,
  });

  factory SkillDataDto.fromJson(Map<String, dynamic> json) =>
      _$SkillDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SkillDataDtoToJson(this);
}
