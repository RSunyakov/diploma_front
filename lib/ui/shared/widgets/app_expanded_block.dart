import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sphere/ui/shared/all_shared.dart';

const _defaultMinHeight = 30.0;
const _defaultMaxHeight = 275.0;
const _defaultHorizontalPadding = 22.0;

class AppExpandedBlock extends StatefulWidget {
  const AppExpandedBlock({
    required this.child,
    required this.title,
    this.closedHeight = _defaultMinHeight,
    this.openedHeight = _defaultMaxHeight,
    this.horizontalPadding = _defaultHorizontalPadding,
    Key? key,
  }) : super(key: key);

  final Widget? child;
  final String title;
  final double closedHeight;
  final double openedHeight;
  final double horizontalPadding;

  @override
  AppExpandedBlockState createState() => AppExpandedBlockState();
}

class AppExpandedBlockState extends State<AppExpandedBlock> {
  var _height = _defaultMinHeight;
  var _isOpened = false;

  @override
  void initState() {
    super.initState();
    _height = widget.closedHeight;
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.closedHeight / 2;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: AppColors.infoBody,
            boxShadow: AppColors.boxShadow,
          ),
          child: AnimatedSize(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: Get.width,
              height: _height,
              padding:
                  EdgeInsets.only(top: widget.closedHeight + 5, bottom: 10),
              child: Container(
                  width: Get.width,
                  padding: widget.horizontalPadding.insetsHor,
                  child: widget.child),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _updateSize(),
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            reverseDuration: const Duration(seconds: 1),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: !_isOpened
                    ? BorderRadius.circular(radius)
                    : BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        topRight: Radius.circular(radius),
                      ),
                gradient: AppColors.stdHGradient,
              ),
              height: widget.closedHeight,
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: AppStyles.text14
                        .andColor(Colors.white)
                        .andWeight(FontWeight.w500),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: Icon(
                      !_isOpened
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateSize() {
    setState(() {
      _isOpened = !_isOpened;
      _height = _isOpened ? widget.openedHeight : widget.closedHeight;
    });
  }
}
