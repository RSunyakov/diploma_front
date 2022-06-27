import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/logic/profile/occupation_bloc/occupation_bloc.dart';
import 'package:sphere/ui/shared/app_extensions.dart';

part 'occupation_study.g.dart';

@JsonSerializable()
class OccupationStudyDto with EquatableMixin {
  OccupationStudyDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  final bool status;
  final List<OccupationStudyDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory OccupationStudyDto.fromJson(Map<String, dynamic> json) =>
      _$OccupationStudyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccupationStudyDtoToJson(this);

  @override
  List<Object?> get props => [status, data, message, errors];
}

@JsonSerializable()
class OccupationStudyDataDto with EquatableMixin {
  OccupationStudyDataDto({
    this.id,
    required this.university,
    required this.speciality,
    required this.dateStart,
    this.dateEnd,
  });

  final int? id;
  final String university;
  final String speciality;
  final String dateStart;
  final String? dateEnd;

  factory OccupationStudyDataDto.fromJson(Map<String, dynamic> json) =>
      _$OccupationStudyDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccupationStudyDataDtoToJson(this);

  @override
  List<Object?> get props => [id, university, speciality, dateStart, dateEnd];
}

extension OccupationStudyDtoX on OccupationStudyDto {
  OrOccupations toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('OccupationStudy: data is null'));
      }

      final domain = data!.map(
        (e) {
          return Occupation.study(
            id: e.id ?? 0,
            title: NonEmptyString(e.university),
            speciality: NonEmptyString(e.speciality),
            beginDateTime: beginDateTime(e.dateStart.dateTimeFromBackend),
            endDateTime: e.dateEnd == null
                ? none()
                : some(
                    endDateTime(
                      e.dateEnd!.dateTimeFromBackend,
                    ),
                  ),
          );
        },
      ).toList();
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

@JsonSerializable()
class AddOccupationStudyBody with EquatableMixin {
  AddOccupationStudyBody({
    required this.university,
    required this.speciality,
    required this.dateStart,
    this.dateEnd,
  });

  final String university;
  final String speciality;
  final String dateStart;
  final String? dateEnd;

  factory AddOccupationStudyBody.fromJson(Map<String, dynamic> json) =>
      _$AddOccupationStudyBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddOccupationStudyBodyToJson(this);

  @override
  List<Object?> get props => [university, speciality, dateStart, dateEnd];
}

@JsonSerializable()
class AddOccupationStudyDto with EquatableMixin {
  AddOccupationStudyDto({
    required this.status,
    this.data,
  });

  final bool status;
  final dynamic data;

  factory AddOccupationStudyDto.fromJson(Map<String, dynamic> json) =>
      _$AddOccupationStudyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddOccupationStudyDtoToJson(this);

  @override
  List<Object?> get props => [status, data];
}
