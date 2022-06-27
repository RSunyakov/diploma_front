import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';

import '../../../core/safe_coding/src/either.dart';
import '../../../domain/city/city.dart';
import '../../../domain/core/extended_errors.dart';

part 'cities.g.dart';

@JsonSerializable()
class CitiesDto {
  CitiesDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<CityDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory CitiesDto.fromJson(Map<String, dynamic> json) =>
      _$CitiesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CitiesDtoToJson(this);
}

@JsonSerializable()
class CityDataDto {
  int id;
  String name;

  CityDataDto({
    required this.id,
    required this.name,
  });

  factory CityDataDto.fromJson(Map<String, dynamic> json) =>
      _$CityDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CityDataDtoToJson(this);
}

extension CitiesDtoX on CitiesDto {
  Either<ExtendedErrors, List<City>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('City: data is null'));
      }

      final domain = data!
          .map((e) => City(
                id: e.id,
                name: NonEmptyString(e.name),
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
