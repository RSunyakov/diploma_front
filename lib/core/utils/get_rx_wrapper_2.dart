import 'package:equatable/equatable.dart';
import 'package:get/get_rx/get_rx.dart';

/// Wrapper-2 for Rx<T> variables in Get library [https://pub.dev/packages/get]
/// This wrapper lets to apply UDF concept and makes it easier to work with obs.
/// Now you can replace 3 or 4 variables with just one
///
/// For example, instead this four's
/// ```dart
///
///  declarations:
///
///  /// 1. Rx-variable
///  final _evens = 0.obs;
///
///  /// 2. Getter
///  int get evens => _evens();
///
///  /// 3. Setter
///  set evens(int value)  {
///     if (_evens().isEven) {
///       _evens(value*2-1);
///    }else{
///       _evens(value);
///    }
///  }
///
/// /// 4. Stream
/// Stream<int> get evensStream => _evens.stream;
/// }
///
/// //=======================================================
///
/// using:
///
/// @override
/// void onInit() {
///  super.onInit();
///  // i.e Stream listener
///  evensStream.listen(print);
/// }
///
/// // Somewhere in View
/// return Center(
///  child: ElevatedButton(
///    child: Obx(
///          () => Text('value = ${controller.evens}'),
///    ),
///    onPressed: () => controller.evens += 1,
///  ),
/// );
///
/// ```
///
/// One can use that one's:
///
/// ```dart
///
/// declaration:
///
/// /// Encapsulated Rx variable
/// final evens = GetRxWrapper2<int>(0, setter: (oldValue, newValue, [_]) {
///  if(oldValue.isEven){
///    return (newValue ?? 1) * 2 - 1;
///  }else{
///    return newValue;
///  }
/// });
///
/// //=========================================================================
///
/// using:
///
///
/// @override
/// void onInit() {
///  super.onInit();
///  // Stream listener
///  evens.stream.listen(print);
/// }
///
/// // Somewhere in View
/// return Center(
///  child: ElevatedButton(
///    child: Obx(
///          () => Text('value = ${controller.evens.value$}'),
///    ),
///    onPressed: () => controller.evens.value(controller.evens.value$ + 1),
///  ),
/// );
///
/// ```
@Deprecated('Use GetRxDecorator instead')
class GetRxWrapper2<T> extends Equatable {
  GetRxWrapper2(T initial, {this.forceRefresh, this.setter})
      : _src = Rx<T>(initial);

  /// Inner .obs variable.
  final Rx<T> _src;

  /// Callback for adjust custom setter.
  /// [oldValue] parameter allows to apply specific algorithms,
  ///   e.g. without [newValue], like a Collatz conjecture (see tests).
  /// [sender] parameter allows using additional arguments in algorithms,
  ///   e.g. type or instance of variable's sender or something (see tests).
  final GetRxWrapper2Setter? setter;

  /// Force auto refresh.
  final bool? forceRefresh;

  /// Safe reference to inner value.
  T get value$ => _src();

  /// Reference to .obs inner stream.
  Stream<T> get stream => _src.stream;

  /// We can use either custom setter or default setting mechanism.
  ///
  /// newValue: value to be set. It may be null in some logic cases. Optional.
  /// sender: optional dynamic parameter. In some cases, you may need
  ///   an additional call context to select the logic of changing a variable.
  void value([T? newValue, dynamic sender]) {
    // Prepare for adjust latter auto refresh.
    final isSameValue = newValue == _src();

    if (setter == null) {
      _src(newValue);
    } else {
      // Here we can return as `wrong` either [oldValue] or null.
      final candidate = setter!(value$, newValue, sender);
      _src(candidate);
    }

    if (isSameValue && (forceRefresh ?? false)) {
      refresh();
    }
  }

  void refresh() => _src.refresh();

  @override
  List<Object?> get props => [_src];
}

typedef GetRxWrapper2Setter<T> = T? Function(
    T oldValue, T? newValue, dynamic sender);

////////////////////////////////////////////////////////////////////////////////

class GetRxWrapper2Int extends GetRxWrapper2<int> {
  GetRxWrapper2Int(int initial,
      {bool? forceRefresh, GetRxWrapper2Setter? setter})
      : super(initial, forceRefresh: forceRefresh, setter: setter);

  /// Addition operator.
  GetRxWrapper2Int operator +(int other) {
    _src.value = _src.value + other;
    return this;
  }
}
