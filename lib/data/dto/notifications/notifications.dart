import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/core/value_objects.dart';

import '../../../core/safe_coding/src/either.dart';
import '../../../domain/core/extended_errors.dart';
import '../../../domain/notification/notification.dart';

part 'notifications.g.dart';

@JsonSerializable()
class NotificationsDto {
  NotificationsDto({
    required this.status,
    this.data,
    this.message,
    this.errors,
  });

  bool status;
  List<NotificationDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory NotificationsDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsDtoToJson(this);
}

@JsonSerializable()
class NotificationDataDto {
  final int id;
  final String? type;
  final num? amount;
  final String? status;
  final String? initiator;
  final String? goal;

  NotificationDataDto(
      {required this.id,
      this.type,
      this.amount,
      this.status,
      this.initiator,
      this.goal});

  factory NotificationDataDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataDtoToJson(this);
}

extension NotificationsDtoX on NotificationsDto {
  Either<ExtendedErrors, List<Notification>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Notification: data is null'));
      }

      final domain = data!
          .map((e) => Notification(
                id: e.id,
                type: NonEmptyString(e.type ?? ''),
                amount: e.amount?.toInt() ?? 0,
                status: NonEmptyString(e.status ?? ''),
                initiator: NonEmptyString(e.initiator ?? ''),
                goal: NonEmptyString(e.goal ?? ''),
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
