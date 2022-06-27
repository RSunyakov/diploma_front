import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sphere/ui/login/registration_screen_controller.dart';
import 'package:sphere/ui/shared/app_colors.dart';
import 'package:sphere/ui/shared/app_extensions.dart';
import 'package:sphere/ui/shared/app_styles.dart';
import 'package:sphere/ui/shared/widgets/all_widgets.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

class RegistrationScreen extends StatexWidget<RegistrationScreenController> {
  RegistrationScreen({Key? key}) : super(() => RegistrationScreenController(), key: key);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              const Text("Добро пожаловать в сервис для создания кроссплатформенного навыка", style: AppStyles.text25,),
              50.h,
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.boxShadow),
                  width: 800,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    const Text('Регистрация', style: AppStyles.text18,),
                50.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const Text('Логин', style: AppStyles.text14,),
                  22.w,
                  SizedBox(
                    width: 300,
                      child: AppInput(controller: controller.loginController, hintText: 'Введите логин',))
                ],),
                10.h,
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Пароль', style: AppStyles.text14,),
                    20.w,
                    SizedBox(
                        width: 300,
                        child: AppInput(controller: controller.passwordController, hintText: 'Введите пароль',obscureText: true,))
                  ],),
                10.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Повтор пароля', style: AppStyles.text14,),
                    5.w,
                    SizedBox(
                        width: 300,
                        child: AppInput(controller: controller.repeatController, hintText: 'Введите пароль', obscureText: true,))
                  ],),
                50.h,
                      MaterialButton(onPressed: () => controller.login(), child: Container(width: 180,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green,
                          ),
                          alignment: Alignment.center,
                          child: Center(child: Text('Уже зарегистрирован', style: AppStyles.text14.andColor(AppColors.white),))),),
                20.h,
                MaterialButton(onPressed: () => controller.register(), child: Container(width: 180,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.green,
                    ),
                    alignment: Alignment.center,
                    child: Center(child: Text('Зарегистрироваться', style: AppStyles.text14.andColor(AppColors.white),))),)
              ],),
                )],
          ),
        ),
      ),),
    );
  }

}