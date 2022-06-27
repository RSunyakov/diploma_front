import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'value_objects.dart';

/// Предполагается, что сохранены значение и возможный [failureTag].
/// Если [failureTag] отсутствует, он заменяется на [noTag
abstract class TaggableValueObjectConverter<T, S>
    implements JsonConverter<T, S> {
  const TaggableValueObjectConverter();

  static const noTag = 'noTag';

  Tuple2<E, String> getData<E>(String value) {
    final List back = jsonDecode(value) as List;
    final failureTag =
        back.length > 1 ? back[1] : TaggableValueObjectConverter.noTag;
    return Tuple2(back.first, failureTag);
  }

  /// Сохраняем
  String saveData<E>(covariant ValueObject<E> e) => jsonEncode(
      e.value.fold((l) => [l.failedValue, l.failureTag], (r) => [r]));
}

// /// Конвертер для [NonEmptyString]
// class NonEmptyStringConverter
//     extends TaggableValueObjectConverter<NonEmptyString, String> {
//   const NonEmptyStringConverter();
//
//   /// Предполагается, что в [value] сохранены значение и возможный [failureTag].
//   /// Если [failureTag] отсутствует, он заменяется на [noTag]
//   @override
//   NonEmptyString fromJson(String value) {
//     final data = getData<String>(value);
//     return NonEmptyString(data.first, failureTag: data.second);
//   }
//
//   /// Сохраняем
//   @override
//   String toJson(NonEmptyString e) => saveData(e);
// }
