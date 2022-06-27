import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/data/dto/user_skills/skill.dart';
import 'package:sphere/domain/core/value_objects.dart';

import '../../../core/safe_coding/src/either.dart';
import '../../../domain/core/extended_errors.dart';
import '../../../domain/user_skills/user_skills.dart';

part 'user_skills.g.dart';

@JsonSerializable()
class UserSkillsDto {
  UserSkillsDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<UserSkillDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory UserSkillsDto.fromJson(Map<String, dynamic> json) =>
      _$UserSkillsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserSkillsDtoToJson(this);
}

@JsonSerializable()
class UserSkillDataDto {
  final int id;
  final SkillDto? baseSkill;
  final List<SkillDto>? nestedSkills;

  UserSkillDataDto({required this.id, this.baseSkill, this.nestedSkills});

  factory UserSkillDataDto.fromJson(Map<String, dynamic> json) =>
      _$UserSkillDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserSkillDataDtoToJson(this);
}

extension UserSkillsDtoX on UserSkillsDto {
  Either<ExtendedErrors, List<UserSkills>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('UserSkills: data is null'));
      }

      final domain = data!
          .map((e) => UserSkills(
              id: e.id,
              skill: UserSkill(
                  id: e.baseSkill?.id ?? 0,
                  title: NonEmptyString(e.baseSkill?.title ?? '')),
              nestedSkills: e.nestedSkills != null
                  ? e.nestedSkills!
                      .map((e) => UserSkill(
                          id: e.id ?? 0, title: NonEmptyString(e.title ?? '')))
                      .toList()
                  : []))
          .toList();
      return Right(domain);
    } on Error catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on CheckedFromJsonException catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}

@JsonSerializable(createFactory: false)
class AddUserSkillBody with EquatableMixin {
  AddUserSkillBody({
    required this.skillId,
    this.title,
  });

  final String? title;
  final int skillId;
  Map<String, dynamic> toJson() => _$AddUserSkillBodyToJson(this);

  @override
  List<Object?> get props => [title, skillId];
}

enum StoreMode { create, edit }
