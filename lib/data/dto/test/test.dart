import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/question/question.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/question/question.dart';
import 'package:sphere/domain/test/test.dart';

part 'test.g.dart';

@JsonSerializable()
class TestDto {
  TestDto({
    required this.data,
});

  TestDataDto? data;

  factory TestDto.fromJson(Map<String, dynamic> json) => _$TestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TestDtoToJson(this);
}

@JsonSerializable()
class TestListDto {
  TestListDto({
    required this.data,
  });

  List<TestDataDto>? data;

  factory TestListDto.fromJson(Map<String, dynamic> json) => _$TestListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TestListDtoToJson(this);
}


@JsonSerializable()
class TestDataDto {
  TestDataDto({
    required this.id,
    required this.name,
    this.questions,
});

  int id;
  String name;
  List<QuestionDataDto>? questions;

  factory TestDataDto.fromJson(Map<String, dynamic> json) =>
      _$TestDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TestDataDtoToJson(this);
}

@JsonSerializable()
class AddTestBody {
  AddTestBody({
    required this.name,
    this.questions
});

  final String name;
  final List<QuestionDataDto>? questions;

  factory AddTestBody.fromJson(Map<String, dynamic> json) =>
      _$AddTestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddTestBodyToJson(this);
}

extension TestDtoX on TestDto {
  Either<ExtendedErrors, Test> toDomain() {
    try {
      if (data == null) {
        return Left(ExtendedErrors.simple('Test: data is null'));
      }
      final domain = Test(id: data!.id, name: data!.name, questions: data!.questions?.map((e) => Question(id: e.id, question: e.question, answer: e.answer, open: e.open)).toList() ?? <Question>[]);
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

extension TestListDtoX on TestListDto {
  Either<ExtendedErrors, List<Test>> toDomain() {
    try {
      if (data == null) {
        return Left(ExtendedErrors.simple('Test: data is null'));
      }
      final domain = data!.map((e) => Test(id: e.id, name: e.name, questions: e.questions?.map((e) => Question(id: e.id, question: e.question, answer: e.answer, open: e.open)).toList() ?? <Question>[])).toList();
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

