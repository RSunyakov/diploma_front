import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_code.g.dart';

@JsonSerializable()
class FetchCodeBody {
  FetchCodeBody({
    required this.login,
  });

  factory FetchCodeBody.fromJson(Map<String, dynamic> json) =>
      _$FetchCodeBodyFromJson(json);
  Map<String, dynamic> toJson() => _$FetchCodeBodyToJson(this);

  final String login;
}
