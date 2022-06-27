import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/question/question.dart';
import 'package:sphere/domain/test/test.dart';
import 'package:sphere/domain/users/user_domain.dart';

part 'user.g.dart';

@JsonSerializable()
class UserDto {
  UserDto({
    required this.data,
  });

  UserDataDto? data;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@JsonSerializable()
class UserListDto {
  UserListDto({
    required this.data,
  });

  List<UserDataDto>? data;

  factory UserListDto.fromJson(Map<String, dynamic> json) =>
      _$UserListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserListDtoToJson(this);
}

@JsonSerializable()
class UserDataDto {
  UserDataDto({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.tests,
  });

  String userId;
  String firstName;
  String lastName;
  List<TestDataDto> tests;

  factory UserDataDto.fromJson(Map<String, dynamic> json) =>
      _$UserDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataDtoToJson(this);
}

extension UserDtoX on UserDto {
  Either<ExtendedErrors, UserDomain> toDomain() {
    try {
      if (data == null) {
        return Left(ExtendedErrors.simple('Test: data is null'));
      }
      final domain = UserDomain(
          userId: data!.userId,
          firstName: data!.firstName,
          lastName: data!.lastName,
          tests: data!.tests
              .map((e) => Test(
                  id: e.id,
                  name: e.name,
                  questions: e.questions
                          ?.map((e) => Question(
                              id: e.id,
                              question: e.question,
                              answer: e.answer,
                              open: e.open))
                          .toList() ??
                      <Question>[]))
              .toList());
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

extension UserListDtoX on UserListDto {
  Either<ExtendedErrors, List<UserDomain>> toDomain() {
    try {
      if (data == null) {
        return Left(ExtendedErrors.simple('Test: data is null'));
      }
      final domain = data!.map((e) => UserDomain(
          userId: e.userId,
          firstName: e.firstName,
          lastName: e.lastName,
          tests: e.tests
              .map((e) => Test(
              id: e.id,
              name: e.name,
              questions: e.questions
                  ?.map((e) => Question(
                  id: e.id,
                  question: e.question,
                  answer: e.answer,
                  open: e.open))
                  .toList() ??
                  <Question>[]))
              .toList())).toList();
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
