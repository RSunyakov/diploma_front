import 'package:get/get.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';

class CustomScaffoldService extends GetxService with StreamSubscriberMixin {

  final currentIndex = 0.obsDeco();
}