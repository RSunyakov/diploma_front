import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/question/question.dart';

part 'question.g.dart';

@JsonSerializable()
class QuestionListDto {
  QuestionListDto({
    this.data,
  });
  List<QuestionDataDto>? data;

  factory QuestionListDto.fromJson(Map<String, dynamic> json) => _$QuestionListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionListDtoToJson(this);
}

@JsonSerializable()
class QuestionDto {
  QuestionDto({
    required this.data,
});
  QuestionDataDto? data;

  factory QuestionDto.fromJson(Map<String, dynamic> json) => _$QuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionDtoToJson(this);
}


@JsonSerializable()
class QuestionDataDto {
  QuestionDataDto({
    required this.id,
    required this.question,
    required this.answer,
    required this.open,
    this.rightUsers,
    this.allUsers
  });

  int id;
  String question;
  String answer;
  List<dynamic>? rightUsers;
  List<dynamic>? allUsers;
  bool open;

  factory QuestionDataDto.fromJson(Map<String, dynamic> json) => _$QuestionDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionDataDtoToJson(this);
}


@JsonSerializable()
class AddQuestionBody {
  AddQuestionBody({
    required this.question,
    required this.answer,
    required this.open
});

  final String question;
  final String answer;
  final bool open;

  factory AddQuestionBody.fromJson(Map<String, dynamic> json) => _$AddQuestionBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddQuestionBodyToJson(this);
}

extension QuestionListDtoX on QuestionListDto {
  Either<ExtendedErrors, List<Question>> toDomain() {
    try {
      if (data == null) {
        debugPrint('test: $this');
        return Left(ExtendedErrors.simple('Question: data is null'));
      }
      final domain = data!.map((e) => Question(id: e.id, question: e.question, answer: e.answer, open: e.open)).toList();
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

extension QuestionDtoX on QuestionDto {
  Either<ExtendedErrors, Question> toDomain() {
    try {
      if (data == null) {
        debugPrint('test: $this');
        return Left(ExtendedErrors.simple('Question: data is null'));
      }
      final domain = Question(id: data!.id, question: data!.question, answer: data!.answer, open: data!.open);
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