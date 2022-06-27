import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere/data/dto/admin/admin.dart';
import 'package:sphere/ui/login/login_service.dart';
import 'package:sphere/ui/router/router.dart';
import 'package:sphere/ui/router/router.gr.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class LoginScreenController extends StatexController{
  LoginScreenController({
    LoginService? service
}) : _service = service ?? Get.find();

  final LoginService _service;

  var loginController = TextEditingController();

  var passwordController = TextEditingController();

  void login() async {
    await _service.login(AddAdminBody(login: loginController.text, password: passwordController.text));
    AppRouter.push(TestRoute());
  }

  void register() {
    AppRouter.push(RegistrationRoute());
  }
}