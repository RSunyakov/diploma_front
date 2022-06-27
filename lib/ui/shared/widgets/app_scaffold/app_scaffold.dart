import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';

import 'app_scaffold_service.dart';

class AppScaffold extends GetView<AppScaffoldService> {
  const AppScaffold({
    Key? key,
    required this.child,
    this.appBar,
    this.tabBarEnable = true,
    this.navBarEnable = true,
    this.backgroundColor = AppColors.mainBG,
    this.resizeToAvoidBottomInset,
    this.statusBarIconBrightness,
    this.floatingActionButton,
    this.gradient,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;
  final bool tabBarEnable;
  final bool navBarEnable;
  final PreferredSizeWidget? appBar;
  final bool? resizeToAvoidBottomInset;
  final Brightness? statusBarIconBrightness;
  final Widget? floatingActionButton;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    // [AnnotatedRegion] может и не сработать, когда под ним есть [AppBar]
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: WillPopScope(
        onWillPop: controller.tryExit,
        child: Obx(
          () {
            final service = controller;
              if (navBarEnable) {
                return Container(
                  decoration:
                      BoxDecoration(gradient: gradient, color: backgroundColor),
                  child: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child: SafeArea(
                      bottom: false,
                      maintainBottomViewPadding: false,
                      child: Scaffold(
                        appBar: appBar ?? _appBar(),
                        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                        body: GestureDetector(
                          onTap: FocusManager.instance.primaryFocus?.unfocus,
                          child: child,
                        ),
                        bottomNavigationBar: BottomNavigationBar(
                          enableFeedback: true,
                          items: [
                            for (var nav in service.listBottomNav)
                              BottomNavigationBarItem(
                                icon: Container(
                                  padding: 4.insetsAll,
                                  child: Image(
                                    image: AssetImage(nav.icon),
                                    height: 25,
                                  ),
                                ),
                                activeIcon: Container(
                                  padding: 4.insetsAll,
                                  child: Image(
                                    image: AssetImage(nav.iconActive),
                                    height: 25,
                                  ),
                                ),
                                label: nav.text,
                              ),
                          ],
                          iconSize: 25,
                          landscapeLayout:
                              BottomNavigationBarLandscapeLayout.centered,
                          currentIndex: service.currentNavIndex(),
                          selectedItemColor: AppColors.plainText,
                          selectedLabelStyle: AppStyles.text11,
                          unselectedLabelStyle:
                              AppStyles.text11.andWeight(FontWeight.w300),
                          onTap: service.goToPage,
                          backgroundColor: AppColors.white,
                          type: BottomNavigationBarType.fixed,
                        ),
                        floatingActionButton: floatingActionButton,
                      ),
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  appBar: appBar,
                  backgroundColor: backgroundColor,
                  body: child,
                  // GestureDetector(
                  //   onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  //   child: child,
                  // ),
                );
              }
            }
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: 0,
      toolbarHeight: 0,
      backgroundColor: backgroundColor,
      flexibleSpace: Container(),
    );
  }
}
