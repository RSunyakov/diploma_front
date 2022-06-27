import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'city.freezed.dart';

@freezed
class City with _$City {
  const factory City({
    required int id,
    required NonEmptyString name,
  }) = _City;

  static City empty = City(
    id: 0,
    name: ''.nonEmpty,
  );
}
