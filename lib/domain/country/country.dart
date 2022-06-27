import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'country.freezed.dart';

@freezed
class Country with _$Country {
  const factory Country({
    required int id,
    required NonEmptyString name,
  }) = _Country;

  static Country empty = Country(
    id: 0,
    name: NonEmptyString(''),
  );
}
