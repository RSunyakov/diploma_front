import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

/// Упрощение контроля подписок на стримы
///
/// {@tool snippet}
/// ```dart
/// final s = Stream<>
/// subscribeIt(s.listen((event){ ... }))///
///}
/// ```
/// {@end-tool}
///
/// Закрытие и отписка произойдут автоматически при закрытии объекта.
mixin StreamSubscriberMixin on DisposableInterface {
  final _subscriptions = <StreamSubscription>[];

  void subscribeIt(StreamSubscription ss) => _subscriptions.add(ss);

  /// Регистрация объекта в карте onClose колбеков.
  /// Уместно сделать ее прямо в момент регистрации фабрики сервиса:
  /// ```dart
  ///
  /// Get.lazyPut(() => TimerService()..registerOnCloseWhenReloadAll())
  ///
  /// ```
  /// Этого достаточно для того, чтобы в момент вызова
  /// [GetxReloadAllFixer.reloadAll()] вызвались [GetxService.onClose]
  void registerOnCloseWhenReloadAll() {
    if (this is! GetxService) {
      throw Exception('$runtimeType is not a GetxService');
    }
    GetxReloadAllFixer._register(this);
  }

  @mustCallSuper
  @override
  void onClose() {
    debugPrint('$now: StreamSubscriberMixin.onClose: $runtimeType');
    for (var it in _subscriptions) {
      it.cancel();
    }
    _subscriptions.clear();
    super.onClose();
  }
}

/// Фиксер кривого поведение [Get.reloadAll] для [GetxService], когда у объектов
/// не вызывается onClose, и создаются новые копии объектов,
/// а старые неубитые, например подписки, остаются в памяти.
///
/// Для работы достаточно зарегать экземпляр синглтона сервиса в карте колбеков.
/// Для этого следует замиксовать сервис с [StreamSubscriberMixin]
/// Впоследствии вместо вызова [Get.reloadAll] в нужной точке следует вызвать
/// [GetxReloadAllFixer.reloadAll()], и для всех зарегистрированных сервисов
/// будет вызван [onClose].
///
/// Пример:
///
/// ```dart
///
///   // 1. Зарегались где-то одновременно с фабрикой
///   Get
///     ..lazyPut(() => InternetScreenService()..registerOnCloseWhenReloadAll())
///     ..lazyPut(() => AuthService()..registerOnCloseWhenReloadAll())
///
///   // 2. Сделать GetxReloadAllFixer.reloadAll() в необходимой точке,
///   // например, при логауте
///     GetxReloadAllFixer.reloadAll();
///
/// ```
///
class _GetxReloadAllFixer {
  final _map = <StreamSubscriberMixin, VoidCallback>{};

  /// [register] можно делать прямо в конструкторе объекта
  void _register(StreamSubscriberMixin instance) {
    if (_map.containsKey(instance)) {
      throw Exception('StreamSubscriberMixin $instance already in the map');
    }

    /// В качестве колбека автоматически регается именно [onClose].
    _map[instance] = instance.onClose;

    debugPrint('$now: StreamSubscriberMixin._register: ${_map.length}');
  }

  /// Этот метод следует вызвать в точке "перезагрузки", например,
  /// при logOut.
  ///
  /// Сперва вызывает штатный [Get.reloadAll], а затем колбеки
  /// [disposeOnReloadAll], после чего самовычищается.
  void reloadAll() {
    Get.reloadAll();

    _map.forEach((_, value) {
      value();
    });
    _map.clear();
  }
}

/// Синглтон фиксера.
// ignore: non_constant_identifier_names
final GetxReloadAllFixer = _GetxReloadAllFixer();
