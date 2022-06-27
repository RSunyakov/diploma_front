import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppProgressBlock extends StatefulWidget {
  const AppProgressBlock({
    Key? key,
    this.title,
    required this.percent,
    this.gradient,
    this.bgColor,
    this.borderRadius,
    this.progressColor,
  }) : super(key: key);

  final String? title;
  final int percent;
  final Gradient? gradient;
  final Color? bgColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? progressColor;

  @override
  State<AppProgressBlock> createState() => _AppProgressBlockState();
}

class _AppProgressBlockState extends State<AppProgressBlock>
    with TickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;

  void start({int? begin, int? end}) {
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = IntTween(begin: begin ?? 0, end: end ?? widget.percent).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
    animationController.forward();
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  void didUpdateWidget(AppProgressBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    start(begin: oldWidget.percent, end: widget.percent);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, _) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (ctx, constraints) {
                    return Stack(
                      children: [
                        Container(
                          width: constraints.maxWidth,
                          height: 10,
                          decoration: BoxDecoration(
                            color: widget.bgColor ?? AppColors.mainBk,
                            borderRadius: widget.borderRadius ??
                                BorderRadius.circular(20),
                          ),
                        ),
                        widget.progressColor == null
                            ? Container(
                                width: constraints.maxWidth *
                                    (animation.value / 100),
                                height: 10,
                                decoration: BoxDecoration(
                                  gradient:
                                      widget.gradient ?? AppColors.stdHGradient,
                                  borderRadius: widget.borderRadius ??
                                      BorderRadius.circular(20),
                                ),
                              )
                            : Container(
                                width: constraints.maxWidth *
                                    (animation.value / 100),
                                height: 10,
                                decoration: BoxDecoration(
                                  color: widget.progressColor,
                                  borderRadius: widget.borderRadius ??
                                      BorderRadius.circular(20),
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                width: 40.kW,
                child: Text(
                  '${animation.value}%',
                  style: AppStyles.text14
                      .andColor(widget.progressColor ?? AppColors.activeText)
                      .andWeight(FontWeight.w500),
                  softWrap: false,
                  textAlign: TextAlign.right,
                ),
              ),
              3.w,
              svgPicture(AppIcons.progressArrow, color: widget.progressColor)
            ],
          );
        });
  }
}
