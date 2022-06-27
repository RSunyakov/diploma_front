import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/logic/profile/occupation_bloc/occupation_bloc.dart';
import 'package:sphere/ui/shared/app_extensions.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

part 'occupation_work.g.dart';

@JsonSerializable()
class OccupationWorkDto with EquatableMixin {
  OccupationWorkDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  final bool status;
  final List<OccupationWorkDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory OccupationWorkDto.fromJson(Map<String, dynamic> json) =>
      _$OccupationWorkDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccupationWorkDtoToJson(this);

  @override
  List<Object?> get props => [status, data, message, errors];
}

@JsonSerializable()
class OccupationWorkDataDto with EquatableMixin {
  OccupationWorkDataDto({
    this.id,
    required this.companyName,
    required this.positionName,
    required this.dateStart,
    this.dateEnd,
  });

  final int? id;
  final String companyName;
  final String positionName;
  final String dateStart;
  final String? dateEnd;

  factory OccupationWorkDataDto.fromJson(Map<String, dynamic> json) =>
      _$OccupationWorkDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccupationWorkDataDtoToJson(this);

  @override
  List<Object?> get props =>
      [id, companyName, positionName, dateStart, dateEnd];
}

extension OccupationWorkDtoX on OccupationWorkDto {
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
          return Occupation.work(
            id: e.id ?? 0,
            title: NonEmptyString(e.companyName),
            occupation: NonEmptyString(e.positionName),
            beginDateTime: beginDateTime(e.dateStart.dateTimeFromBackend),
            endDateTime: some(endDateTime(
                e.dateEnd == null ? now : e.dateEnd!.dateTimeFromBackend)),
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
class AddOccupationWorkBody with EquatableMixin {
  AddOccupationWorkBody({
    required this.companyName,
    required this.positionName,
    required this.dateStart,
    this.dateEnd,
  });

  final String companyName;
  final String positionName;
  final String dateStart;
  final String? dateEnd;

  factory AddOccupationWorkBody.fromJson(Map<String, dynamic> json) =>
      _$AddOccupationWorkBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddOccupationWorkBodyToJson(this);

  @override
  List<Object?> get props => [companyName, positionName, dateStart, dateEnd];
}

@JsonSerializable()
class AddOccupationWorkDto with EquatableMixin {
  AddOccupationWorkDto({
    required this.status,
    this.data,
  });

  final bool status;
  final dynamic data;

  factory AddOccupationWorkDto.fromJson(Map<String, dynamic> json) =>
      _$AddOccupationWorkDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddOccupationWorkDtoToJson(this);

  @override
  List<Object?> get props => [status, data];
}
