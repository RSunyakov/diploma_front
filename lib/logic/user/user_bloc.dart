import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/test/test.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/users/user_domain.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'user_bloc.freezed.dart';

@prod
@lazySingleton
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({Repository ? repo})
  : _repo = repo ?? GetIt.I.get(),
  super(const UserState.initial()) {
    on<_GetUserListEvent>(_getUserList);
    on<_AddTestsToUserEvent>(_addTestsToUser);
  }

  final Repository _repo;

  Future _getUserList(_GetUserListEvent event, Emitter<UserState> emit) async {
    emit(const UserState.gotUserList(UserStateData.loading()));
    try {
      final rez = await _repo.getAllUsers(event.adminId);
      emit(UserState.gotUserList(UserStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserState.gotUserList(UserStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }

  Future _addTestsToUser(_AddTestsToUserEvent event, Emitter<UserState> emit) async {
    emit(const UserState.addTestsToUser(UserStateData.loading()));
    final rez = await _repo.addTestsToUser(event.userId, event.value);
    emit(UserState.addTestsToUser(UserStateData.result(rez)));
  }
}

@freezed
class UserEvent with _$UserEvent {

  const factory UserEvent.getUserList(int adminId) = _GetUserListEvent;

  const factory UserEvent.addTestsToUser(String userId, List<TestDataDto> value) = _AddTestsToUserEvent;
}

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;

  const factory UserState.gotUserList(
      UserStateData<Either<ExtendedErrors, List<UserDomain>>> data) = _GotUserList;

  const factory UserState.addTestsToUser(
      UserStateData<Either<ExtendedErrors, UserDomain>> data) = _AddTestsToUser;
}

@freezed
class UserStateData<T> with _$UserStateData<T> {
  const factory UserStateData.initial() = _InitialData<T>;

  const factory UserStateData.loading() = _LoadingData<T>;

  const factory UserStateData.result(T data) = _ResultData<T>;
}