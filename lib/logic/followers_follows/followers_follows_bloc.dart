import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/domain/followers_follows/followers_follows.dart';
import 'package:sphere/logic/repository/repository.dart';

import '../../core/safe_coding/src/either.dart';
import '../../domain/core/extended_errors.dart';

part 'followers_follows_bloc.freezed.dart';

@prod
@lazySingleton
class FollowersFollowsBloc
    extends Bloc<FollowersFollowsEvent, FollowersFollowsState> {
  FollowersFollowsBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const FollowersFollowsState.initial()) {
    on<_GetFollowersEvent>(_getFollowers);
    on<_GetFollowsEvent>(_getFollows);
    on<_RemoveFollowersEvent>(_removeFollowers);
    on<_RemoveFollowsEvent>(_removeFollows);
  }

  final Repository _repo;

  Future _getFollowers(
      _GetFollowersEvent event, Emitter<FollowersFollowsState> emit) async {
    emit(const FollowersFollowsState.loading());
    try {
      final rez = await _repo.getFollowers();
      emit(FollowersFollowsState.gotFollowers(rez));
    } on Exception catch (e) {
      emit(FollowersFollowsState.gotFollowers(
          left(ExtendedErrors.simple(e.toString()))));
    }
  }

  Future _getFollows(
      _GetFollowsEvent event, Emitter<FollowersFollowsState> emit) async {
    emit(const FollowersFollowsState.loading());
    try {
      final rez = await _repo.getFollows();
      emit(FollowersFollowsState.gotFollows(rez));
    } on Exception catch (e) {
      emit(FollowersFollowsState.gotFollows(
          left(ExtendedErrors.simple(e.toString()))));
    }
  }

  Future _removeFollowers(
      _RemoveFollowersEvent event, Emitter<FollowersFollowsState> emit) async {
    try {
      final rez = await _repo.removeFollowers(event.uuid);
      emit(FollowersFollowsState.gotRemoveFF(rez));

      final rezFollowers = await _repo.removeFollowers(event.uuid);
      emit(FollowersFollowsState.gotRemoveFF(rezFollowers));
    } on Exception catch (e) {
      emit(
        FollowersFollowsState.gotRemoveFF(
          left(ExtendedErrors.simple(e.toString())),
        ),
      );
    }
  }

  Future _removeFollows(
      _RemoveFollowsEvent event, Emitter<FollowersFollowsState> emit) async {
    try {
      final rez = await _repo.removeFollows(event.uuid);
      emit(FollowersFollowsState.gotRemoveFF(rez));
      final rezFollows = await _repo.getFollows();
      emit(FollowersFollowsState.gotFollows(rezFollows));
    } on Exception catch (e) {
      emit(
        FollowersFollowsState.gotRemoveFF(
          left(ExtendedErrors.simple(e.toString())),
        ),
      );
    }
  }
}

@freezed
class FollowersFollowsEvent with _$FollowersFollowsEvent {
  const factory FollowersFollowsEvent.getFollowers() = _GetFollowersEvent;
  const factory FollowersFollowsEvent.getFollows() = _GetFollowsEvent;
  const factory FollowersFollowsEvent.removeFollowers(String uuid) =
      _RemoveFollowersEvent;
  const factory FollowersFollowsEvent.removeFollows(String uuid) =
      _RemoveFollowsEvent;
}

@freezed
class FollowersFollowsState with _$FollowersFollowsState {
  const factory FollowersFollowsState.initial() = _Initial;
  const factory FollowersFollowsState.loading() = _Loading;

  const factory FollowersFollowsState.gotFollowers(
      Either<ExtendedErrors, List<FollowersFollows>> data) = _GotFollowers;
  const factory FollowersFollowsState.gotFollows(
      Either<ExtendedErrors, List<FollowersFollows>> data) = _GotFollows;
  const factory FollowersFollowsState.gotRemoveFF(
      Either<ExtendedErrors, SimpleMessage> data) = _GotRemoveFF;
}
