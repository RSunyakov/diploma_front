import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/simple_message.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'follow_bloc.freezed.dart';

@prod
@lazySingleton
class FollowBloc extends Bloc<FollowEvent, FollowState> {
  FollowBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const FollowState.initial()) {
    on<_FollowUserEvent>(_followUser);
  }

  final Repository _repo;

  Future _followUser(_FollowUserEvent event, Emitter<FollowState> emit) async {
    emit(const FollowState.followedUser(FollowStateData.loading()));
    try {
      final rez = await _repo.followUser(event.uuid);
      emit(FollowState.followedUser(FollowStateData.result(rez)));
    } on Exception catch (e) {
      emit(FollowState.followedUser(
          FollowStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }
}

@freezed
class FollowEvent with _$FollowEvent {
  const factory FollowEvent.followUser({required NonEmptyString uuid}) =
      _FollowUserEvent;
}

@freezed
class FollowState with _$FollowState {
  const factory FollowState.initial() = _InitialState;

  const factory FollowState.followedUser(
          FollowStateData<Either<ExtendedErrors, SimpleMessage>> data) =
      _FollowedUser;
}

@freezed
class FollowStateData<T> with _$FollowStateData<T> {
  const factory FollowStateData.initial() = _InitialData<T>;

  const factory FollowStateData.loading() = _LoadingData<T>;

  const factory FollowStateData.result(T data) = _ResultData<T>;
}
