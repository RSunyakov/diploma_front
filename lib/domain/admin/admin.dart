import 'package:freezed_annotation/freezed_annotation.dart';

part "admin.freezed.dart";

@freezed
class Admin with _$Admin {
  const factory Admin({
    required int id,
    required String login,
    required String password,
}) = _Admin;
}