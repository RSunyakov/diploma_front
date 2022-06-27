import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/domain/reports/report.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'reports_bloc.freezed.dart';

@prod
@lazySingleton
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const ReportsState.initial()) {
    on<_GetReportsEvent>(_getReports);
    on<_GetReportEvent>(_getReport);
    on<_StoreReportEvent>(_storeReport);
    on<_DeleteReportEvent>(_deleteReport);
  }

  final Repository _repo;

  Future _getReports(_GetReportsEvent event, Emitter<ReportsState> emit) async {
    emit(
      const ReportsState.gotReports(ReportsStateData.loading()),
    );
    try {
      final rez = await _repo.getReports();
      emit(ReportsState.gotReports(ReportsStateData.result(rez)));
    } on Exception catch (e) {
      emit(ReportsState.gotReports(
          ReportsStateData.result(left(ExtendedErrors.simple('$e')))));
    }
  }

  Future _getReport(_GetReportEvent event, Emitter<ReportsState> emit) async {
    emit(
      const ReportsState.gotReport(ReportsStateData.loading()),
    );
    try {
      final rez = await _repo.getReportDetail(event.id);
      emit(ReportsState.gotReport(ReportsStateData.result(rez)));
    } on Exception catch (e) {
      emit(ReportsState.gotReport(
          ReportsStateData.result(left(ExtendedErrors.simple('$e')))));
    }
  }

  Future _storeReport(
      _StoreReportEvent event, Emitter<ReportsState> emit) async {
    emit(
      const ReportsState.storeReport(ReportsStateData.loading()),
    );
    try {
      final rez = await _repo.storeReport(title: event.title, file: event.file);
      emit(ReportsState.storeReport(ReportsStateData.result(rez)));
      if (rez.isRight()) {
        add(const ReportsEvent.getReports());
      }
    } on Exception catch (e) {
      emit(ReportsState.gotReports(
          ReportsStateData.result(left(ExtendedErrors.simple('$e')))));
    }
  }

  Future _deleteReport(
      _DeleteReportEvent event, Emitter<ReportsState> emit) async {
    emit(
      const ReportsState.deleteReport(ReportsStateData.loading()),
    );
    try {
      final rez = await _repo.deleteReport(event.id);
      emit(ReportsState.deleteReport(ReportsStateData.result(rez)));
      if (rez.isRight()) {
        add(const ReportsEvent.getReports());
      }
    } on Exception catch (e) {
      emit(ReportsState.deleteReport(
          ReportsStateData.result(left(ExtendedErrors.simple('$e')))));
    }
  }
}

@freezed
class ReportsEvent with _$ReportsEvent {
  const factory ReportsEvent.getReports() = _GetReportsEvent;
  const factory ReportsEvent.getReport(int id) = _GetReportEvent;
  const factory ReportsEvent.deleteReport(int id) = _DeleteReportEvent;
  const factory ReportsEvent.storeReport({required String title, File? file}) =
      _StoreReportEvent;
}

@freezed
class ReportsState with _$ReportsState {
  const factory ReportsState.initial() = _Initial;

  const factory ReportsState.gotReports(
          ReportsStateData<Either<ExtendedErrors, List<Report>>> data) =
      _GotReports;

  const factory ReportsState.gotReport(
      ReportsStateData<Either<ExtendedErrors, Report>> data) = _GotReport;

  const factory ReportsState.deleteReport(
          ReportsStateData<Either<ExtendedErrors, SimpleMessage>> data) =
      _DeleteReports;

  const factory ReportsState.storeReport(
          ReportsStateData<Either<ExtendedErrors, SimpleMessage>> data) =
      _StoreReport;
}

@freezed
class ReportsStateData<T> with _$ReportsStateData<T> {
  const factory ReportsStateData.initial() = _InitialData<T>;

  const factory ReportsStateData.loading() = _LoadingData<T>;

  const factory ReportsStateData.result(T data) = _ResultData<T>;
}
