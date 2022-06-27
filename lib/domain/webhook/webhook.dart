import 'package:freezed_annotation/freezed_annotation.dart';

part 'webhook.freezed.dart';

@freezed
class Webhook with _$Webhook {
  const factory Webhook({
    required String aliceUrl,
    required String marusiaUrl,
    required String sberUrl
}) = _Webhook;
}