import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/posts/comment.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/reports/report.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';
import 'package:sphere/ui/shared/all_shared.dart';

part 'report.g.dart';

@JsonSerializable()
class ReportDataDto {
  int? id;
  String? description;
  String? date;
  String? file;
  String? createdAt;
  List<CommentDataDto>? comments;
  int? commentsCount;

  ReportDataDto(
      {this.id,
      this.description,
      this.date,
      this.file,
      this.comments,
      this.createdAt,
      this.commentsCount});

  factory ReportDataDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDataDtoToJson(this);

  @override
  String toString() {
    return 'ReportDataDto{id: $id, description: $description, date: $date, file: $file, createdAt: $createdAt, comments: $comments, commentsCount: $commentsCount}';
  }
}

extension ReportDataDtoX on ReportDataDto {
  Either<ExtendedErrors, Report> toDomain() {
    try {
      return Right(Report(
          id: this.id ?? 0,
          description: (description ?? '').nonEmpty,
          file: (file ?? '').nonEmpty,
          createdAt: createdAt?.dateTimeFromBackend ?? now,
          commentsCount: commentsCount ?? 0));
    } on Error catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on CheckedFromJsonException catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}
