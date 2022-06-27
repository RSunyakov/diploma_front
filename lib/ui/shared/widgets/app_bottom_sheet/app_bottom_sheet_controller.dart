import 'package:sphere/core/utils/get_rx_wrapper.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'app_bottom_sheet.dart';

/// Контроллер для динамического изменения высоты [AppBottomSheet].
class AppBottomSheetController extends StatexController<AppBottomSheet> {
  /// Умолчательная высота согласно фигмы - 206, но
  /// в этом случае при меньше высоте скачки некрасивые.
  static final defaultHeight = 70.kH;

  final height = GetRxWrapper(defaultHeight);
}
