import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/reports/report.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/reports/report.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';
import 'package:sphere/ui/shared/all_shared.dart';

part 'reports.g.dart';

@JsonSerializable()
class ReportsDto {
  ReportsDto({
    required this.status,
    this.message,
    this.errors,
    this.data,
  });

  bool status;
  List<ReportDataDto>? data;
  final String? message;
  final Map<String, dynamic>? errors;

  factory ReportsDto.fromJson(Map<String, dynamic> json) =>
      _$ReportsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportsDtoToJson(this);
}

extension ReportsDtoX on ReportsDto {
  Either<ExtendedErrors, List<Report>> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Reports: data is null'));
      }
      final domain = data!.map((e) {
        debugPrint('$now: toDomain: e=$e');
        return Report(
            id: e.id ?? 0,
            description: (e.description ?? '').nonEmpty,
            file: (e.file ?? '').nonEmpty,
            createdAt: e.createdAt?.dateTimeFromBackend ?? now,
            commentsCount: e.commentsCount ?? 0);
      }).toList();

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
