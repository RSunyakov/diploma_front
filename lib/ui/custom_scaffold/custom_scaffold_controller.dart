import 'package:get/get.dart';
import 'package:sphere/ui/custom_scaffold/custom_scaffold_service.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class CustomScaffoldController extends StatexController {
  CustomScaffoldController({
    CustomScaffoldService? service
}) : _service = service ?? Get.find();

  final CustomScaffoldService _service;

  GetRxDecorator<int> get currentIndex => _service.currentIndex;
}