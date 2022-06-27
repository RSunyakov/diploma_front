import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/post/goal.dart';
import 'package:sphere/domain/post/post.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';
import 'package:sphere/logic/repository/repository.dart';
import 'package:vfx_flutter_common/utils.dart';

part 'global_search_bloc.freezed.dart';

@prod
@lazySingleton
class GlobalSearchBloc extends Bloc<GlobalSearchEvent, GlobalSearchState> {
  GlobalSearchBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const GlobalSearchState.initial()) {
    on<_StartSearchEvent>(_startSearch);
  }

  final Repository _repo;

  Future _startSearch(
      _StartSearchEvent event, Emitter<GlobalSearchState> emit) async {
    if (event.isPeoples ?? false) {
      emit(const GlobalSearchState.loading());
      await delayMilli(40);
      emit(const GlobalSearchState.gotPeoples(GlobalSearchStateData.loading()));
      try {
        final rez = await _repo.getUsersFromSearch(event.searchText);
        emit(GlobalSearchState.gotPeoples(GlobalSearchStateData.result(rez)));
      } on Exception catch (e) {
        emit(GlobalSearchState.gotPeoples(GlobalSearchStateData.result(
            left(ExtendedErrors.simple(e.toString())))));
      }
    } else {
      await delayMilli(40);
      emit(GlobalSearchState.gotPeoples(
          GlobalSearchStateData.result(right([]))));
    }

    if (event.isGoals ?? false) {
      emit(const GlobalSearchState.loading());
      try {
        await delayMilli(40);
        emit(const GlobalSearchState.gotGoals(GlobalSearchStateData.loading()));
        final rez = await _repo.searchGoals(event.searchText);
        emit(GlobalSearchState.gotGoals(GlobalSearchStateData.result(rez)));
      } on Exception catch (e) {
        emit(GlobalSearchState.gotGoals(GlobalSearchStateData.result(
            left(ExtendedErrors.simple(e.toString())))));
      }
    } else {
      await delayMilli(40);
      emit(GlobalSearchState.gotGoals(GlobalSearchStateData.result(right([]))));
    }

    if (event.isPosts ?? false) {
      emit(const GlobalSearchState.loading());
      try {
        await delayMilli(40);
        emit(const GlobalSearchState.gotPosts(GlobalSearchStateData.loading()));
        final rez = await _repo.searchPost(event.searchText);
        emit(GlobalSearchState.gotPosts(GlobalSearchStateData.result(rez)));
      } on Exception catch (e) {
        emit(GlobalSearchState.gotPosts(GlobalSearchStateData.result(
            left(ExtendedErrors.simple(e.toString())))));
      }
    } else {
      await delayMilli(40);
      emit(GlobalSearchState.gotPosts(GlobalSearchStateData.result(right([]))));
    }

    if (event.isMyPosts ?? false) {
      emit(const GlobalSearchState.loading());
      try {
        await delayMilli(40);
        emit(const GlobalSearchState.gotMyPosts(
            GlobalSearchStateData.loading()));
        final rez = await _repo.searchUserPosts(event.searchText);
        emit(GlobalSearchState.gotMyPosts(GlobalSearchStateData.result(rez)));
      } on Exception catch (e) {
        emit(GlobalSearchState.gotMyPosts(GlobalSearchStateData.result(
            left(ExtendedErrors.simple(e.toString())))));
      }
    } else {
      await delayMilli(40);
      emit(GlobalSearchState.gotMyPosts(
          GlobalSearchStateData.result(right([]))));
    }
  }
}

@freezed
class GlobalSearchEvent with _$GlobalSearchEvent {
  const factory GlobalSearchEvent.startSearch({
    required String searchText,
    bool? isGoals,
    bool? isPeoples,
    bool? isPosts,
    bool? isMyPosts,
  }) = _StartSearchEvent;
}

@freezed
class GlobalSearchState with _$GlobalSearchState {
  const factory GlobalSearchState.initial() = _Initial;
  const factory GlobalSearchState.loading() = _Loading;

  const factory GlobalSearchState.gotPeoples(
          GlobalSearchStateData<Either<ExtendedErrors, List<UserInfo>>> data) =
      _GotPeoples;

  const factory GlobalSearchState.gotGoals(
          GlobalSearchStateData<Either<ExtendedErrors, List<Goal>>> data) =
      _GotGoals;

  const factory GlobalSearchState.gotPosts(
          GlobalSearchStateData<Either<ExtendedErrors, List<Post>>> data) =
      _GotPosts;

  const factory GlobalSearchState.gotMyPosts(
          GlobalSearchStateData<Either<ExtendedErrors, List<Post>>> data) =
      _GotMyPosts;
}

@freezed
class GlobalSearchStateData<T> with _$GlobalSearchStateData<T> {
  const factory GlobalSearchStateData.initial() = _InitialData<T>;

  const factory GlobalSearchStateData.loading() = _LoadingData<T>;

  const factory GlobalSearchStateData.result(T data) = _ResultData<T>;
}
