import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/value_objects/int_range.dart';

import 'common_interfaces.dart';
import 'failures.dart';
import 'value_parsers.dart';

/// Базовый класс TypeDD
@immutable
abstract class ValueObject<T> implements IValidatable {
  const ValueObject(this.failureTag);

  final String? failureTag;

  Either<ValueFailure<T>, T> get value;

  /// Use it as functional object
  Either<ValueFailure<T>, T> call() => value;

  /// Сокращатель для выкастовывания к значению.
  /// Причем, можно вернуть как реально дефолтное значение,
  /// так и [failureValue] если опустить параметр.
  T getOrElse({T? dflt}) {
    if (dflt == null) {
      return value.fold((l) => l.failedValue, (r) => r);
    }
    return value.getOrElse(() => dflt);
  }

  Either<ValueFailure<T>, Unit> get failureOrUnit {
    return value.fold(
      (l) => left(l),
      (r) => right(unit),
    );
  }

  /// [copyWith] позволяет упростить изменение данных в наследниках сложного
  /// типа, например [IntRange], где для изменения потребуется всегда
  /// указывать все поля (min, max).
  /// Используя такой подход, можно просто сделать так
  /// ```dart
  /// myTest('IntRange copyWith test', () async {
  ///   var data = IntRange(31, min: 20, max: 30, failureTag: 'int');
  ///   expect(data.isValid(), isFalse);
  ///   data = data.copyWith(max: 31);
  ///   expect(data.isValid(), isTrue);
  ///   data = data.copyWith(value: 19);
  ///   expect(data.isValid(), isFalse);
  ///   data = data.copyWith(min: 19);
  ///   expect(data.isValid(), isTrue);
  /// });
  /// ```
  ValueObject<T> copyWith({String? failureTag}) {
    throw UnimplementedError(
        'Should realize it in class $runtimeType before using');
  }

  @override
  bool isValid() {
    return value.isRight();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '$runtimeType($value)';
}

////////////////////////////////////////////////////////////////////////////////

/// Просто непустая строка, сверка только на наличие
class NonEmptyString extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory NonEmptyString(String input, {String? failureTag}) {
    return NonEmptyString._(
      parseIsNotEmpty(input, failureTag: failureTag),
      failureTag,
    );
  }

  const NonEmptyString._(this.value, String? failureTag) : super(failureTag);
}

extension NonEmptyStringX on String {
  NonEmptyString get nonEmpty => NonEmptyString(this);
}

/// Просто непустой лист, сверка только на наличие как минимум одного значения
class NonEmptyList<T> extends ValueObject<List<T>> {
  @override
  final Either<ValueFailure<List<T>>, List<T>> value;

  factory NonEmptyList(List<T> input, {String? failureTag}) {
    return NonEmptyList._(
      _parse(input, failureTag: failureTag),
      failureTag,
    );
  }

  const NonEmptyList._(this.value, String? failureTag) : super(failureTag);

  /// Проверка на то, что строка непустая
  static Either<ValueFailure<List<T>>, List<T>> _parse<T>(List<T> input,
      {String? failureTag}) {
    if (input.isNotEmpty) {
      return right(input);
    }
    return left(ValueFailure.empty(failedValue: input, failureTag: failureTag));
  }
}

extension NonEmptyListX<T> on List<T> {
  NonEmptyList<T> get ne => NonEmptyList<T>(this);
}

/// Просто непустая карта, сверка только на наличие как минимум одного значения
class NonEmptyMap<K, V> extends ValueObject<Map<K, V>> {
  @override
  final Either<ValueFailure<Map<K, V>>, Map<K, V>> value;

  factory NonEmptyMap(Map<K, V> input, {String? failureTag}) {
    return NonEmptyMap._(
      _parse(input, failureTag: failureTag),
      failureTag,
    );
  }

  const NonEmptyMap._(this.value, String? failureTag) : super(failureTag);

  /// Проверка на то, что строка непустая
  static Either<ValueFailure<Map<K, V>>, Map<K, V>> _parse<K, V>(
      Map<K, V> input,
      {String? failureTag}) {
    if (input.isNotEmpty) {
      return right(input);
    }
    return left(ValueFailure.empty(failedValue: input, failureTag: failureTag));
  }
}

extension NonEmptyMapX<K, V> on Map<K, V> {
  NonEmptyMap<K, V> get ne => NonEmptyMap<K, V>(this);
}

/// Token as ValueObject
class Token extends ValueObject<String> {
  static const minLength = 28;
  static const _tag = 'token';

  @override
  final Either<ValueFailure<String>, String> value;

  factory Token(String input, {String? failureTag}) {
    return Token._(_parse(input, failureTag: failureTag), failureTag);
  }

  /// Инвалидный токен
  const Token.invalid()
      : value = const Left(
          ValueFailure.tooShort(
            failedValue: '',
            minLength: Token.minLength,
            failureTag: _tag,
          ),
        ),
        super(_tag);

  factory Token.tagged(String input) {
    return Token._(_parse(input, failureTag: _tag), _tag);
  }

  static Either<ValueFailure<String>, String> _parse(String input,
      {String? failureTag}) {
    if (input.length < Token.minLength) {
      return left(ValueFailure.tooShort(
          failedValue: input,
          failureTag: failureTag,
          minLength: Token.minLength));
    }
    return right(input);
  }

  const Token._(this.value, String? failureTag) : super(failureTag);
}

class TokenConverter implements JsonConverter<Token, String> {
  const TokenConverter();

  @override
  Token fromJson(String value) => Token(value, failureTag: 'token');

  @override
  String toJson(Token e) => e.value.fold((l) => l.failedValue, (r) => r);
}

class Email extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Email(String input, {String? failureTag}) {
    return Email._(_parse(input, failureTag: failureTag), failureTag);
  }

  /// Для упрощения создания (автоматически ставит [failureTag])
  factory Email.tagged(String input) {
    const failureTag = 'email';
    return Email._(_parse(input, failureTag: failureTag), failureTag);
  }

  /// Валидирование строки, как EMail
  static Either<ValueFailure<String>, String> _parse(String input,
      {String? failureTag}) {
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (RegExp(emailRegex).hasMatch(input)) {
      return right(input);
    } else {
      return left(ValueFailure.invalidEmail(
          failedValue: input, failureTag: failureTag));
    }
  }

  const Email._(this.value, String? failureTag) : super(failureTag);
}

/// Конвертация JSON
class EmailConverter extends TaggableValueObjectConverter<Email, String> {
  const EmailConverter();

  @override
  Email fromJson(String value) {
    final data = getData<String>(value);
    return Email(data.first, failureTag: data.second);
  }

  @override
  String toJson(Email e) => saveData(e);
}

class Phone extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory Phone(String input, {String? failureTag}) {
    return Phone._(_parse(input, failureTag: failureTag), failureTag);
  }

  /// Для упрощения создания (автоматически ставит [failureTag])
  factory Phone.tagged(String input) {
    const failureTag = 'phone';
    return Phone._(_parse(input, failureTag: failureTag), failureTag);
  }

  /// Валидирование строки, как EMail
  static Either<ValueFailure<String>, String> _parse(String input,
      {String? failureTag}) {
    const phoneRegex = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    if (input.isNotEmpty && RegExp(phoneRegex).hasMatch(input)) {
      return right(input);
    } else {
      return left(ValueFailure.invalidEmail(
          failedValue: input, failureTag: failureTag));
    }
  }

  const Phone._(this.value, String? failureTag) : super(failureTag);
}

/// Конвертация JSON
class PhoneConverter extends TaggableValueObjectConverter<Phone, String> {
  const PhoneConverter();

  @override
  Phone fromJson(String value) {
    final data = getData<String>(value);
    return Phone(data.first, failureTag: data.second);
  }

  @override
  String toJson(Phone e) => saveData(e);
}

/// Сложный тип, инкапсулирующий работу с Phone || Email
/// Обработка сразу двух регулярок.
class PhoneOrEmail extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  factory PhoneOrEmail(String input, {String? failureTag}) {
    return PhoneOrEmail._(_parse(input, failureTag: failureTag), failureTag);
  }

  /// Для упрощения создания (автоматически ставит [failureTag])
  factory PhoneOrEmail.tagged(String input) {
    const failureTag = 'phone_or_email';
    return PhoneOrEmail._(_parse(input, failureTag: failureTag), failureTag);
  }

  /// Валидирование строки, как Phome or EMail
  static Either<ValueFailure<String>, String> _parse(String input,
      {String? failureTag}) {
    const phoneRegex = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,10}$';
    if (input.isNotEmpty &&
        (RegExp(phoneRegex).hasMatch(input) ||
            RegExp(emailRegex).hasMatch(input))) {
      return right(input);
    } else {
      return left(ValueFailure.invalidEmail(
          failedValue: input, failureTag: failureTag));
    }
  }

  const PhoneOrEmail._(this.value, String? failureTag) : super(failureTag);
}

/// Конвертация JSON
class PhoneOrEmailConverter
    extends TaggableValueObjectConverter<PhoneOrEmail, String> {
  const PhoneOrEmailConverter();

  @override
  PhoneOrEmail fromJson(String value) {
    final data = getData<String>(value);
    return PhoneOrEmail(data.first, failureTag: data.second);
  }

  @override
  String toJson(PhoneOrEmail e) => saveData(e);
}

/// Конвертер для [NonEmptyString]
class NonEmptyStringConverter
    extends TaggableValueObjectConverter<NonEmptyString, String> {
  const NonEmptyStringConverter();

  /// Предполагается, что в [value] сохранены значение и возможный [failureTag].
  /// Если [failureTag] отсутствует, он заменяется на [noTag]
  @override
  NonEmptyString fromJson(String value) {
    final data = getData<String>(value);
    return NonEmptyString(data.first, failureTag: data.second);
  }

  /// Сохраняем
  @override
  String toJson(NonEmptyString e) => saveData(e);
}

///
///

class EmptyStringConverter
    extends TaggableValueObjectConverter<NonEmptyString?, String> {
  const EmptyStringConverter();

  @override
  NonEmptyString fromJson(String value) {
    final data = getData<String>(value);
    return NonEmptyString(data.first, failureTag: data.second);
  }

  /// Сохраняем
  @override
  String toJson(NonEmptyString? e) =>
      saveData(e ?? NonEmptyString('', failureTag: 'toJson'));
}

abstract class TaggableValueObjectConverter<T, S>
    implements JsonConverter<T, S> {
  const TaggableValueObjectConverter();

  static const noTag = 'no_tag';

  Tuple2<E, String?> getData<E>(String value) {
    final back = jsonDecode(value) as List;
    final failureTag =
        back.length > 1 ? back[1] : TaggableValueObjectConverter.noTag;
    return Tuple2(back.first, failureTag);
  }

  /// Сохраняем
  String saveData<E>(covariant ValueObject<E> e) => jsonEncode(
      e.value.fold((l) => [l.failedValue, l.failureTag], (r) => [r]));
}
