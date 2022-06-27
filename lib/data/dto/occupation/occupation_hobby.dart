import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/logic/profile/occupation_bloc/occupation_bloc.dart';

part 'occupation_hobby.g.dart';

@JsonSerializable()
class OccupationHobbyDto with EquatableMixin {
  OccupationHobbyDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  final bool status;
  final List<OccupationHobbyDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory OccupationHobbyDto.fromJson(Map<String, dynamic> json) =>
      _$OccupationHobbyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccupationHobbyDtoToJson(this);

  @override
  List<Object?> get props => [status, data, message, errors];
}

@JsonSerializable()
class OccupationHobbyDataDto with EquatableMixin {
  OccupationHobbyDataDto({
    this.id,
    required this.title,
  });

  final int? id;
  final String title;

  factory OccupationHobbyDataDto.fromJson(Map<String, dynamic> json) =>
      _$OccupationHobbyDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccupationHobbyDataDtoToJson(this);

  @override
  List<Object?> get props => [id, title];
}

extension OccupationHobbyDtoX on OccupationHobbyDto {
  OrOccupations toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('OccupationWork: data is null'));
      }

      final domain = data!.map(
        (e) {
          return Occupation.hobby(
            id: e.id ?? 0,
            title: NonEmptyString(e.title),
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
class AddOccupationHobbyBody with EquatableMixin {
  AddOccupationHobbyBody({
    required this.title,
  });

  final String title;

  factory AddOccupationHobbyBody.fromJson(Map<String, dynamic> json) =>
      _$AddOccupationHobbyBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddOccupationHobbyBodyToJson(this);

  @override
  List<Object?> get props => [title];
}

@JsonSerializable()
class AddOccupationHobbyDto with EquatableMixin {
  AddOccupationHobbyDto({
    required this.status,
    this.data,
  });

  final bool status;
  final dynamic data;

  factory AddOccupationHobbyDto.fromJson(Map<String, dynamic> json) =>
      _$AddOccupationHobbyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddOccupationHobbyDtoToJson(this);

  @override
  List<Object?> get props => [status, data];
}
