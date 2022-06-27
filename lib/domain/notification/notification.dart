import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'notification.freezed.dart';

@freezed
class Notification with _$Notification {
  const factory Notification({
    required int id,
    required NonEmptyString type,
    required int amount,
    required NonEmptyString status,
    required NonEmptyString initiator,
    required NonEmptyString goal,
  }) = _Notification;

  static Notification empty = Notification(
    id: 0,
    type: NonEmptyString(''),
    amount: 0,
    status: NonEmptyString(''),
    initiator: NonEmptyString(''),
    goal: NonEmptyString(''),
  );
}
