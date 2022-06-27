import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/domain/core/value_objects.dart';

part 'simple_message.g.dart';

/// Получаем капчу
@JsonSerializable()
class SimpleMessageDto with EquatableMixin {
  const SimpleMessageDto({
    required this.status,
    this.message,
    this.errors,
    this.error,
  });

  factory SimpleMessageDto.fromJson(Map<String, dynamic> json) =>
      _$SimpleMessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SimpleMessageDtoToJson(this);

  final bool status;
  final String? message;
  final Map<String, dynamic>? errors;
  final String? error;

  @override
  List<Object?> get props => [status, message, errors, error];
}

extension SimpleMessageDtoX on SimpleMessageDto {
  /// На этом этапе по состоянию статуса надо возвратить либо объект
  /// либо ошибки
  Either<ExtendedErrors, SimpleMessage> toDomain() {
    try {
      if (!status) {
        return (error != null)
            ? Left(ExtendedErrors.simple(error!))
            : Left(parseError(errors ?? <String, dynamic>{}));
      }

      final domain = SimpleMessage(
        status: status,
        message: NonEmptyString(message ?? '', failureTag: 'message'),
      );
      // Если в порядке, возвращаем домен
      return Right(domain);
    } on Exception catch (e) {
      // Возвращаем исключение
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}
