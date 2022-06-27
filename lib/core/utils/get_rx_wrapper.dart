import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/get_rx.dart';

/// Обертка для UDF-реактивных Get-переменных.
/// Благодаря настраиваемому сеттеру [Factory Method] можно настраивать
/// сеттинг на стороне клиента.
@immutable
@Deprecated('Use GetRxDecorator instead')
class GetRxWrapper<T> extends Equatable {
  GetRxWrapper(T initial, {this.forceRefresh, T Function(T v)? setter})
      : _src = Rx<T>(initial) {
    _setter = setter ?? _call;
  }

  final Rx<T> _src;
  final bool? forceRefresh;
  late final T Function(T v) _setter;

  Stream<T> get stream => _src.stream;

  T get value$ => _src();

  set value(T value) {
    final same = value == _src();
    _src(_setter(value));
    if (same && (forceRefresh ?? false)) {
      refresh();
    }
  }

  void refresh() => _src.refresh();

  /// Умолчательный прокси-сеттер
  T _call(T v) => _src(v);

  @override
  List<Object?> get props => [_src];
}
