import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/core/value_objects/date_time_range.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

part 'occupation.freezed.dart';

@freezed
class Occupation with _$Occupation {
  ///
  const factory Occupation.hobby({
    @Default(0) int id,
    required NonEmptyString title,

    /// В режиме редактирования или просмотра
    @Default(false) bool isUnderEdit,
  }) = HobbyOccupation;

  ///
  const factory Occupation.study({
    @Default(0) int id,

    /// Где
    required NonEmptyString title,

    /// Кем
    required NonEmptyString speciality,

    /// Начало
    required DateTimeRange beginDateTime,

    /// Завершение
    @Default(None<DateTimeRange>()) Option<DateTimeRange> endDateTime,

    /// В режиме редактирования или просмотра
    @Default(false) bool isUnderEdit,
  }) = StudyOccupation;

  ///
  const factory Occupation.work({
    @Default(0) int id,

    /// Где
    required NonEmptyString title,

    /// Кем
    required NonEmptyString occupation,

    /// Начало
    required DateTimeRange beginDateTime,

    /// Завершение
    @Default(None<DateTimeRange>()) Option<DateTimeRange> endDateTime,

    /// В режиме редактирования или просмотра
    @Default(false) bool isUnderEdit,
  }) = WorkOccupation;

  const Occupation._();
}

///
extension OccupationX on Occupation {
  bool isSameAs(Occupation rhs) => rhs.id == this.id;

  bool get isHobby => this is HobbyOccupation;

  bool get isWork => this is WorkOccupation;

  bool get isStudy => this is StudyOccupation;

  Option<HobbyOccupation> get asHobby =>
      isHobby ? some(this as HobbyOccupation) : none();

  Option<WorkOccupation> get asWork =>
      isWork ? some(this as WorkOccupation) : none();

  Option<StudyOccupation> get asStudy =>
      isStudy ? some(this as StudyOccupation) : none();
}

///
extension StudyOccupationX on StudyOccupation {
  /// Флаг определяющий что занятие в данный момент времени не закончено.
  bool get isTillNow {
    return this.endDateTime.fold(() => true, (a) {
      return a.getOrElse().year == now.year && a.getOrElse().month == now.month;
    });
  }

  /// Установка текущего времени, как завершающего или нет.
  /// Если да, то все понятно.
  /// В противном случае мы делаем завершающий равный начальному
  StudyOccupation withTillNow(bool value) => copyWith(
      endDateTime: value
          ? some(endDateTime(DateTime(now.year, now.month)))
          : some(this.beginDateTime.copyWith()));
}

///
extension WorkOccupationX on WorkOccupation {
  /// Флаг определяющий что занятие в данный момент времени не закончено.
  bool get isTillNow {
    return this.endDateTime.fold(() => true, (a) {
      return a.getOrElse().year == now.year;
    });
  }

  /// Установка текущего времени, как завершающего или нет.
  /// Если да, то все понятно.
  /// В противном случае мы делаем завершающий равный начальному
  WorkOccupation withTillNow(bool value) => copyWith(
      endDateTime: value
          ? some(endDateTime(DateTime(now.year)))
          : some(this.beginDateTime.copyWith()));
}

/// Упрощение конструкций типа DateTime(2005) до [2005.asYear]
extension DateTimeRangeX on int {
  DateTime get asYear => DateTime(this);
}

///
extension DateTimeX on DateTime {
  /// Представляет месяц в именительном падеже!
  String get formatMY {
    final m2 = DateFormat.MMM(Get.locale!.toLanguageTag()).format(
      DateFormat('M').parse(month.toString()),
    );
    return '$m2 ${DateFormat('yyyy').format(this)}';
  }

  /// Представляет дату для бека!
  String get formatForBackend {
    return DateFormat('dd-MM-yyyy').format(this);
  }
}

const beginYearTag = 'begin_dt';
const endYearTag = 'end_dt';
final defaultBeginYearMin = 1900.asYear;
final defaultEndYearMin = 1901.asYear;

/// Генератор идентификатора как текущей микросекунды
int createUidFromNow() => now.microsecondsSinceEpoch;

/// Пусть для [beginDateTime] минимальным годом начала занятости считается
/// [defaultBeginYearMin], а максимальным предполагается "прошлый"
DateTimeRange beginDateTime(DateTime value, {DateTime? min, DateTime? max}) =>
    DateTimeRange(value,
        min: defaultBeginYearMin,
        max: max ?? DateTime(now.year, now.month),
        failureTag: beginYearTag);

/// Пусть для [endDateTime] минимальным годом начала занятости считается
/// [defaultEndYearMin], а максимальным предполагается "текущий"
DateTimeRange endDateTime(DateTime value, {DateTime? min, DateTime? max}) =>
    DateTimeRange(
      value,
      min: defaultEndYearMin,
      max: DateTime(now.year, now.month),
      failureTag: endYearTag,
    );
