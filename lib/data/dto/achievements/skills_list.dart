import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/posts/skill.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/post/skill.dart';

part 'skills_list.g.dart';

@JsonSerializable()
class SkillsListDto {
  SkillsListDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<SkillDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory SkillsListDto.fromJson(Map<String, dynamic> json) =>
      _$SkillsListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SkillsListDtoToJson(this);
}

extension SkillsListDtox on SkillsListDto {
  Either<ExtendedErrors, List<Skill>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('SkillsListDto: data is null'));
      }
      final domain = data!
          .map((e) => Skill(
                id: e.id ?? 0,
                title: NonEmptyString(e.title ?? ''),
                isAllowed: false,
              ))
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
