import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/webhook/webhook.dart';

part 'webhook.g.dart';

@JsonSerializable()
class WebhookDto {
  WebhookDto({
    required this.data
});
  WebhookDataDto? data;

  factory WebhookDto.fromJson(Map<String, dynamic> json) => _$WebhookDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WebhookDtoToJson(this);
}

@JsonSerializable()
class WebhookDataDto {
  WebhookDataDto({
    required this.aliceUrl,
    required this.marusiaUrl,
    required this.sberUrl
});

  String aliceUrl;
  String marusiaUrl;
  String sberUrl;

  factory WebhookDataDto.fromJson(Map<String, dynamic> json) =>
      _$WebhookDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WebhookDataDtoToJson(this);
}

extension WebhookDtoX on WebhookDto {
  Either<ExtendedErrors, Webhook> toDomain() {
    try {
      if (data == null) {
        return Left(ExtendedErrors.simple('Webhook: data is null'));
      }
      final domain = Webhook(aliceUrl: data!.aliceUrl, marusiaUrl: data!.marusiaUrl, sberUrl: data!.sberUrl);
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