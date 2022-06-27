import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/domain/balance/balance.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/logic/repository/repository.dart';

part 'balance_bloc.freezed.dart';

@prod
@lazySingleton
class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  BalanceBloc({Repository? repo})
      : _repo = repo ?? GetIt.I.get(),
        super(const BalanceState.initial()) {
    on<_GetBalanceEvent>(_getBalance);
  }

  final Repository _repo;

  Future _getBalance(_GetBalanceEvent event, Emitter<BalanceState> emit) async {
    emit(const BalanceState.gotBalance(
      BalanceStateData.loading(),
    ));
    try {
      final rez = await _repo.getBalance();
      emit(BalanceState.gotBalance(BalanceStateData.result(rez)));
    } on Exception catch (e) {
      emit(BalanceState.gotBalance(
          BalanceStateData.result(left(ExtendedErrors.simple(e.toString())))));
    }
  }
}

@freezed
class BalanceEvent with _$BalanceEvent {
  const factory BalanceEvent.getBalance() = _GetBalanceEvent;
}

@freezed
class BalanceState with _$BalanceState {
  const factory BalanceState.initial() = _Initial;

  const factory BalanceState.gotBalance(
      BalanceStateData<Either<ExtendedErrors, Balance>> data) = _GotBalance;
}

@freezed
class BalanceStateData<T> with _$BalanceStateData<T> {
  const factory BalanceStateData.initial() = _InitialData<T>;

  const factory BalanceStateData.loading() = _LoadingData<T>;

  const factory BalanceStateData.result(T data) = _ResultData<T>;
}
