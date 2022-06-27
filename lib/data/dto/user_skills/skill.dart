import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill.g.dart';

@JsonSerializable()
class SkillDto {
  final int? id;
  final String? title;

  SkillDto({
    this.id,
    this.title,
  });

  factory SkillDto.fromJson(Map<String, dynamic> json) =>
      _$SkillDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SkillDtoToJson(this);
}
