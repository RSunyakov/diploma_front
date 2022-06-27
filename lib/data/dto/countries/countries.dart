import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';

import '../../../core/safe_coding/src/either.dart';
import '../../../domain/core/extended_errors.dart';
import '../../../domain/country/country.dart';

part 'countries.g.dart';

@JsonSerializable()
class CountriesDto {
  CountriesDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<CountryDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory CountriesDto.fromJson(Map<String, dynamic> json) =>
      _$CountriesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CountriesDtoToJson(this);
}

@JsonSerializable()
class CountryDataDto {
  int id;
  String name;

  CountryDataDto({
    required this.id,
    required this.name,
  });

  factory CountryDataDto.fromJson(Map<String, dynamic> json) =>
      _$CountryDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDataDtoToJson(this);
}

extension CountriesDtoX on CountriesDto {
  Either<ExtendedErrors, List<Country>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Country: data is null'));
      }

      final domain = data!
          .map((e) => Country(
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
