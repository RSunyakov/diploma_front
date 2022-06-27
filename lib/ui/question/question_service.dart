import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/safe_coding/src/option.dart';
import 'package:sphere/core/utils/stream_subscriber.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/question/question.dart';
import 'package:sphere/logic/question/question_bloc.dart';
import 'package:sphere/ui/shared/app_alert.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';

class QuestionService extends GetxService with StreamSubscriberMixin {
  QuestionService({
    QuestionBloc? questionBloc
}) : _questionBloc = questionBloc ?? GetIt.I.get();

  final QuestionBloc _questionBloc;

  final questions = <Question>[].obsDeco();

  @override
  void onInit() {
    super.onInit();
    subscribeIt(_questionBloc.stream.listen(_processQuestion));
    getQuestionList();
  }

  void _processQuestion(QuestionState state) {
    state.maybeWhen(
        orElse: () => left(ExtendedErrors.empty()),
        gotQuestionList: (d) => d.maybeWhen(
            orElse: () => left(ExtendedErrors.empty()),
            result: (r) {
              r.fold((l) => appAlert(value: l.error, color: AppColors.red),
                      (r) {
                    return questions.value = r;
                  });
            }));
    questions.refresh();
  }

  void getQuestionList() {
    _questionBloc.add(const QuestionEvent.getQuestionList());
  }
}