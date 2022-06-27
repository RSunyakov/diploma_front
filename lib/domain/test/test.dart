import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/domain/question/question.dart';

part 'test.freezed.dart';

@freezed
class Test with _$Test {
  const factory Test({
    required int id,
    required String name,
    required List<Question> questions,
}) = _Test;
}