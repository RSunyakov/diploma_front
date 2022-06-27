import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting.g.dart';

@JsonSerializable()
class SettingDto {
  final String? name;
  final String? value;

  SettingDto({
    this.name,
    this.value,
  });

  factory SettingDto.fromJson(Map<String, dynamic> json) =>
      _$SettingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SettingDtoToJson(this);
}
