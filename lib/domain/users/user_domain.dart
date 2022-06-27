import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/test/test.dart';

part 'user_domain.freezed.dart';

@freezed
class UserDomain with _$UserDomain {
  const factory UserDomain({
    required String userId,
    required String firstName,
    required String lastName,
    required List<Test> tests,
}) = _UserDomain;
}