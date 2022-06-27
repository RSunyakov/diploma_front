import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/data/dto/achievements/achievement.dart';
import 'package:sphere/domain/achievement/achievement.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'achievements_bloc.freezed.dart';

@prod
@lazySingleton
class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  AchievementBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const AchievementState.initial()) {
    on<_GetAchievementEvent>(_getAchievementsList);
    on<_DeleteAchievementEvent>(_deleteAchievement);
    on<_RefreshAchievementEvent>(_refreshAchievements);
    on<_StoreAchievementEvent>(_storeAchievement);
  }

  final Repository _repo;

  Future _getAchievementsList(
      _GetAchievementEvent event, Emitter<AchievementState> emit) async {
    emit(
      const AchievementState.gotAchievement(
        AchievementStateData.loading(),
      ),
    );
    try {
      final rez = await _repo.getAchievementsList();
      emit(AchievementState.gotAchievement(AchievementStateData.result(rez)));
    } on Exception catch (e) {
      emit(AchievementState.gotAchievement(AchievementStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _refreshAchievements(
      _RefreshAchievementEvent event, Emitter<AchievementState> emit) async {
    emit(AchievementState.dataRefreshed(
        AchievementStateData.result(right(event.items))));
  }

  Future _deleteAchievement(
      _DeleteAchievementEvent event, Emitter<AchievementState> emit) async {
    emit(const AchievementState.deleteAchievement(
        AchievementStateData.loading()));
    final res = await _repo.deleteAchievement(event.id);
    emit(AchievementState.deleteAchievement(AchievementStateData.result(res)));
    final rez = await _repo.getAchievementsList();
    emit(AchievementState.gotAchievement(AchievementStateData.result(rez)));
  }

  Future _storeAchievement(
      _StoreAchievementEvent event, Emitter<AchievementState> emit) async {
    emit(const AchievementState.storeAchievement(
        AchievementStateData.loading()));
    final res = await _repo.storeAchievement(event.value);
    emit(AchievementState.storeAchievement(AchievementStateData.result(res)));
    final rez = await _repo.getAchievementsList();
    emit(AchievementState.gotAchievement(AchievementStateData.result(rez)));
  }
}

@freezed
class AchievementEvent with _$AchievementEvent {
  const factory AchievementEvent.getAchievement() = _GetAchievementEvent;

  const factory AchievementEvent.refreshItems(List<Achievement> items) =
      _RefreshAchievementEvent;

  const factory AchievementEvent.deleteAchievement(int id) =
      _DeleteAchievementEvent;

  const factory AchievementEvent.storeAchievement(AddAchievementBody value) =
      _StoreAchievementEvent;
}

@freezed
class AchievementState with _$AchievementState {
  const factory AchievementState.initial() = _Initial;

  const factory AchievementState.gotAchievement(
      AchievementStateData<Either<ExtendedErrors, List<Achievement>>>
          data) = _GotAchievement;

  const factory AchievementState.dataRefreshed(
      AchievementStateData<Either<ExtendedErrors, List<Achievement>>>
          data) = _DataRefreshed;

  const factory AchievementState.deleteAchievement(
          AchievementStateData<Either<ExtendedErrors, Unit>> data) =
      _DataDeleteAchievement;

  const factory AchievementState.storeAchievement(
          AchievementStateData<Either<ExtendedErrors, Achievement>> data) =
      _StoreAchievement;
}

@freezed
class AchievementStateData<T> with _$AchievementStateData<T> {
  const factory AchievementStateData.initial() = _InitialData<T>;

  const factory AchievementStateData.loading() = _LoadingData<T>;

  const factory AchievementStateData.result(T data) = _ResultData<T>;
}
