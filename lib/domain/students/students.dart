import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_settings/user_settings.dart';

part 'students.freezed.dart';

@freezed
class Students with _$Students {
  const factory Students({
    required int count,
    required List<UserInfo> data,
  }) = _Students;
}
