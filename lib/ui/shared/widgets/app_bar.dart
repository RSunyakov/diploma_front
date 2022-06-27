import 'package:flutter/material.dart';
import 'package:sphere/ui/router/router.dart';
import 'package:sphere/ui/shared/all_shared.dart';

PreferredSizeWidget appBar(
  BuildContext context, {
  Color? color,
  required String text,
  bool isLeading = false,
  List<Widget>? actions,
  double? elevation,
  String? router,
  dynamic resultBack,
  Function()? funcBack,
  int? currentNavIndex,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: elevation ?? 0,
    title: Padding(
      padding: EdgeInsets.only(left: isLeading ? 0 : 25),
      child: Text(
        text,
        style: AppStyles.text17
            .andWeight(FontWeight.w600)
            .andColor(AppColors.white),
      ),
    ),
    titleSpacing: 0,
    centerTitle: false,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: AppColors.stdHGradient,
      ),
    ),
    backgroundColor: color ?? Colors.transparent,
    leading: isLeading
        ? IconButton(
            onPressed: () {
              funcBack?.call();
              AppRouter.navigateBack();
            },
            icon: svgPicture(
              AppIcons.leftArrow,
              width: 20,
              height: 20,
              color: AppColors.white,
            ),
            padding: const EdgeInsets.all(0),
          )
        // Если тут не null, то слева от заголовка нейправляемый промежуток.
        : null,
    actions: actions,
  );
}
