import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sphere/domain/webhook/webhook.dart';
import 'package:sphere/logic/repository/repository.dart';
import 'package:sphere/ui/login/login_service.dart';
import 'package:vfx_flutter_common/get_rx_decorator.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class SkilLScreenController extends StatexController {
  SkilLScreenController({
    Repository? repo,
    LoginService? loginService
}) : _repo = repo ?? GetIt.I.get(),
     _loginService = loginService ?? Get.find();

  final Repository _repo;

  final LoginService _loginService;

  var showUrl = false.obsDeco();

  var webhook = const Webhook(aliceUrl: '', marusiaUrl: '', sberUrl: '').obsDeco();

  void showButton() async {
    getWebhooks();
  }

  void getWebhooks() async {
    final res = await _repo.getWebhooks(_loginService.admin.value.id);
    res.fold((l) => null, (r) => webhook.value = r);
    showUrl.value = true;
  }
}