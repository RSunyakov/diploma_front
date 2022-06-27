import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/logic/repository/repository.dart';

import '../../../core/safe_coding/src/either.dart';
import '../../../domain/core/extended_errors.dart';
import '../../../domain/user_settings/user_settings.dart';

part 'user_profile_bloc.freezed.dart';

@prod
@lazySingleton
class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const UserProfileState.initial()) {
    on<_GetProfileEvent>(_getProfile);
  }

  final Repository _repo;

  Future _getProfile(
      _GetProfileEvent event, Emitter<UserProfileState> emit) async {
   /* emit(
      const UserProfileState.gotProfile(
        UserProfileStateData.loading(),
      ),
    );
    try {
      final rez = await _repo.(event.uuid);
      emit(UserProfileState.gotProfile(UserProfileStateData.result(rez)));
    } on Exception catch (e) {
      emit(UserProfileState.gotProfile(UserProfileStateData.result(
          left(ExtendedErrors.simple(e.toString())))));
    }*/
  }
}

@freezed
class UserProfileEvent with _$UserProfileEvent {
  const factory UserProfileEvent.getProfile(String uuid) = _GetProfileEvent;
}

@freezed
class UserProfileState with _$UserProfileState {
  const factory UserProfileState.initial() = _Initial;

  const factory UserProfileState.gotProfile(
          UserProfileStateData<Either<ExtendedErrors, UserInfo>> data) =
      _GotProfile;
}

@freezed
class UserProfileStateData<T> with _$UserProfileStateData<T> {
  const factory UserProfileStateData.initial() = _InitialData<T>;

  const factory UserProfileStateData.loading() = _LoadingData<T>;

  const factory UserProfileStateData.result(T data) = _ResultData<T>;
}
