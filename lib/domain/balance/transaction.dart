import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    @NonEmptyStringConverter() required NonEmptyString type,
    required UserInfo sender,
    required UserInfo recipient,
    required DateTime createdAt,
  }) = _Transaction;
}
