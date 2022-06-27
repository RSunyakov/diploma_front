import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'user_search_bloc.freezed.dart';

@prod
@lazySingleton
class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  UserSearchBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const UserSearchState.initial()) {
    on<_GetUsersEvent>(_getUsers);
  }

  final Repository _repo;

  Future _getUsers(_GetUsersEvent event, Emitter<UserSearchState> emit) async {
    emit(const UserSearchState.gotUsers(UserSearchStateData.loading()));
    try {
      final rez = await _repo.getUsersFromSearch(event.searchText);
      emit(UserSearchState.gotUsers(UserSearchStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserSearchState.gotUsers(UserSearchStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }
  }
}

@freezed
class UserSearchEvent with _$UserSearchEvent {
  const factory UserSearchEvent.getUsers(String? searchText) = _GetUsersEvent;
}

@freezed
class UserSearchState with _$UserSearchState {
  const factory UserSearchState.initial() = _Initial;

  const factory UserSearchState.gotUsers(
          UserSearchStateData<Either<ExtendedErrors, List<UserInfo>>> data) =
      _GotUsers;
}

@freezed
class UserSearchStateData<T> with _$UserSearchStateData<T> {
  const factory UserSearchStateData.initial() = _InitialData<T>;

  const factory UserSearchStateData.loading() = _LoadingData<T>;

  const factory UserSearchStateData.result(T data) = _ResultData<T>;
}
