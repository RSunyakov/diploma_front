import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'occupation_bloc.freezed.dart';

@prod
@lazySingleton
class OccupationBloc extends Bloc<OccupationEvent, OccupationState> {
  OccupationBloc() : super(const OccupationState.initial()) {
    on<_RefreshOccupationEvent>(_refreshOccupations);
    on<_FetchOccupationEvent>(_fetchOccupations);
    on<_TryAddOccupationEvent>(_tryAddOccupation);
    on<_ConfirmAddOccupationEvent>(_confirmAddOccupation);
    on<_ConfirmEditOccupationEvent>(_confirmEditOccupation);
    on<_MarkedToDeleteEvent>(_markedToDelete);
    on<_CancelDeleteEvent>(_cancelDelete);
    on<_ConfirmDeleteEvent>(_confirmDelete);
  }

  Future _refreshOccupations(
      _RefreshOccupationEvent event, Emitter<OccupationState> emit) async {
    emit(OccupationState.dataRefreshed(
        OccupationStateData.result(right(event.items))));
  }

  Future _fetchOccupations(
      _FetchOccupationEvent event, Emitter<OccupationState> emit) async {
    emit(const OccupationState.dataFetched(OccupationStateData.loading()));
    // FIXME(vvk): тестовая задержка
    // await delayMilli(1000);
    final res = await GetIt.I.get<Repository>().fetchOccupations(event.tag);
    emit(OccupationState.dataFetched(OccupationStateData.result(res)));
  }

  Future _tryAddOccupation(
      _TryAddOccupationEvent event, Emitter<OccupationState> emit) async {
    emit(const OccupationState.tryItemAdded(OccupationStateData.loading()));
    emit(OccupationState.tryItemAdded(
        OccupationStateData.result(right(event.item))));
  }

  Future _confirmAddOccupation(
      _ConfirmAddOccupationEvent event, Emitter<OccupationState> emit) async {
    emit(const OccupationState.confirmItemAdded(OccupationStateData.loading()));
    final res = await GetIt.I
        .get<Repository>()
        .addOccupation(event.item, StudyOccupation);
    emit(OccupationState.confirmItemAdded(OccupationStateData.result(res)));
  }

  Future _confirmEditOccupation(
      _ConfirmEditOccupationEvent event, Emitter<OccupationState> emit) async {
    emit(const OccupationState.confirmItemAdded(OccupationStateData.loading()));
    final res = await GetIt.I
        .get<Repository>()
        .editOccupation(event.item, StudyOccupation);

    emit(OccupationState.confirmItemAdded(OccupationStateData.result(res)));
  }

  Future _markedToDelete(
      _MarkedToDeleteEvent event, Emitter<OccupationState> emit) async {
    emit(
        OccupationState.markedToDelete(OccupationStateData.result(event.item)));
  }

  Future _cancelDelete(
      OccupationEvent event, Emitter<OccupationState> emit) async {
    emit(const OccupationState.canceledDelete());
  }

  Future _confirmDelete(
      _ConfirmDeleteEvent event, Emitter<OccupationState> emit) async {
    emit(const OccupationState.confirmedDelete(OccupationStateData.loading()));
    final res =
        await GetIt.I.get<Repository>().deleteOccupation(event.id, event.type);
    emit(OccupationState.confirmedDelete(OccupationStateData.result(res)));
  }
}

/// Events для листа [Occupation]
@freezed
class OccupationEvent with _$OccupationEvent {
  /// Тупо рефрешнуть лист
  const factory OccupationEvent.refreshItems(List<Occupation> items) =
      _RefreshOccupationEvent;

  /// Запросить лист
  const factory OccupationEvent.fetchItems(Type tag) = _FetchOccupationEvent;

  /// Сохранить лист
  const factory OccupationEvent.saveItems(List<Occupation> items, Type tag) =
      _SaveOccupationEvent;

  /// Начать добавление итема в лист
  const factory OccupationEvent.tryAddItem(Occupation item) =
      _TryAddOccupationEvent;

  /// Добавить итем в лист
  const factory OccupationEvent.confirmAddItem(Occupation item) =
      _ConfirmAddOccupationEvent;

  /// Отредактировать итем в листе
  const factory OccupationEvent.confirmEditItem(Occupation item) =
      _ConfirmEditOccupationEvent;

  /// Выбор итема для удаления
  const factory OccupationEvent.markToDelete(Occupation item) =
      _MarkedToDeleteEvent;

  /// Подтверждение удаления
  const factory OccupationEvent.confirmDelete(int id, Type type) =
      _ConfirmDeleteEvent;

  /// Отмена удаления
  const factory OccupationEvent.cancelDelete() = _CancelDeleteEvent;
}

/// Состояния для листа [Occupation]
/// Передается внутреннее подсостояние типа [OccupationStateData],
/// каждое из которых может содержать динамику.
@freezed
class OccupationState with _$OccupationState {
  /// Стартовое состояние.
  const factory OccupationState.initial() = _InitialState;

  /// Рефрешнули лист
  const factory OccupationState.dataRefreshed(
      OccupationStateData<OrOccupations> data) = _DataRefreshed;

  /// Запросили лист из репозитория
  const factory OccupationState.dataFetched(
      OccupationStateData<OrOccupations> data) = _DataFetched;

  /// Сохранили лист в репозиторий
  const factory OccupationState.dataSaved(
      OccupationStateData<OrOccupations> data) = _DataSaved;

  /// Попытка добавления
  const factory OccupationState.tryItemAdded(
      OccupationStateData<OrOccupation> data) = _DataTryItemAdded;

  /// Завершение добавления
  const factory OccupationState.confirmItemAdded(
      OccupationStateData<OrOccupation> data) = _DataConfirmItemAdded;

  /// Пометка для удаления прошла.
  const factory OccupationState.markedToDelete(
      OccupationStateData<Occupation> data) = _DataMarkedToDelete;

  /// Удаление подтвердилось
  const factory OccupationState.confirmedDelete(
          OccupationStateData<Either<ExtendedErrors, Unit>> data) =
      _DataConfirmedDelete;

  /// Удаление отменилось
  const factory OccupationState.canceledDelete() = _DataCanceledDelete;
}

/// Динамические данные для каждого из [OccupationState]
/// Позволяют использовать каждый [OccupationState] в трех внутренних режимах:
/// [initial], [loading] & [result]
@freezed
class OccupationStateData<T> with _$OccupationStateData<T> {
  const factory OccupationStateData.initial() = _InitialStateData<T>;

  const factory OccupationStateData.loading() = _LoadingStateData<T>;

  /// Конкретный результат
  const factory OccupationStateData.result(T data) = _ResultStateData<T>;
}

/// Сокращатель типа.
typedef OrOccupations = Either<ExtendedErrors, List<Occupation>>;

/// Сокращатель типа.
typedef OrOccupation = Either<ExtendedErrors, Occupation>;

/// Сокращатель типа.
typedef OrOptionOccupation = Either<ExtendedErrors, Option<Occupation>>;
