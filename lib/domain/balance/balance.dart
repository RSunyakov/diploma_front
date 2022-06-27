import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/balance/transaction.dart';

part 'balance.freezed.dart';

@freezed
class Balance with _$Balance {
  const factory Balance({
    required num balance,
    required List<Transaction> transactions,
  }) = _Balance;
}
