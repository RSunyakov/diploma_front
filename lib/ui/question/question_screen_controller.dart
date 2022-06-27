import 'package:get/get.dart';
import 'package:sphere/domain/question/question.dart';
import 'package:sphere/ui/question/question_service.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class QuestionScreenController extends StatexController {
  QuestionScreenController({
    QuestionService? service
}) : _service = service ?? Get.find();

  final QuestionService _service;

  GetRxDecorator<List<Question>> get questions => _service.questions;
}