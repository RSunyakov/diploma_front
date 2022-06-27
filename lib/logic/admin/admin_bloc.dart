import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/domain/admin/admin.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'admin_bloc.freezed.dart';

@prod
@lazySingleton
class AdminBloc extends Bloc<AdminEvent, AdminState> {
AdminBloc({Repository? repo})
: _repo = repo ?? GetIt.I.get(),
super(const AdminState.initial()) {
  on<_LoginEvent>(_login);
  on<_RegisterEvent>(_register);
}

  final Repository _repo;

  Future _login(_LoginEvent event, Emitter<AdminState> emit) async {
    emit(const AdminState.login(AdminStateData.loading()));
    final res = await _repo.login(event.value);
    emit(AdminState.login(AdminStateData.result(res)));
    emit(const AdminState.logined());
  }

Future _register(_RegisterEvent event, Emitter<AdminState> emit) async {
  emit(const AdminState.register(AdminStateData.loading()));
  final res = await _repo.register(event.value);
  emit(AdminState.register(AdminStateData.result(res)));
  emit(const AdminState.registered());
}
}

@freezed
class AdminEvent with _$AdminEvent {
  const factory AdminEvent.login(AddAdminBody value) = _LoginEvent;

  const factory AdminEvent.register(AddAdminBody value) = _RegisterEvent;

}

@freezed
class AdminState with _$AdminState {
  const factory AdminState.initial() = _Initial;

  const factory AdminState.login(
      AdminStateData<Either<ExtendedErrors, Admin>> data) = _Login;

  const factory AdminState.register(
      AdminStateData<Either<ExtendedErrors, Admin>> data) = _Register;

  const factory AdminState.logined() = _Logined;

  const factory AdminState.registered() = _Registered;
}

@freezed
class AdminStateData<T> with _$AdminStateData<T> {
  const factory AdminStateData.initial() = _InitialData<T>;

  const factory AdminStateData.loading() = _LoadingData<T>;

  const factory AdminStateData.result(T data) = _ResultData<T>;
}
