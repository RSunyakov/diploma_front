import 'package:flutter/material.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/app_gradient_circular_progress.dart';

class AppCircularProgress extends StatefulWidget {
  const AppCircularProgress({
    Key? key,
    this.percent = 0.0,
    this.rating = 0.0,
    this.totalRating = 10.0,
    this.totalPercent = 100.0,
    this.size = 38,
    this.isRateChart = false,
    this.circularProgressStyle = const CircularProgressStyle(),
    this.animateDuration = 2,
    this.isDot = false,
    this.strokeCap,
  }) : super(key: key);

  ///Измеримая мера процентов. Стандартно: 100.0
  final double percent;

  ///Измеримая мера рейтинга. Стандартно: 5.0
  ///14.07.22 - новый расчет - 10.
  final double rating;

  ///Измеримая мера рейтинга. Стандартно: 5.0
  ///14.07.22 - новый расчет - 10.
  final double totalRating;

  ///Измеримая мера процентов. Стандартно: 100.0
  final double totalPercent;

  final double size;
  final bool isRateChart;
  final CircularProgressStyle circularProgressStyle;
  final StrokeCap? strokeCap;

  ///Длительность анимации заполнения круга
  final int animateDuration;

  ///Белая точка в графике (позиция pi/2)
  final bool isDot;

  @override
  State<AppCircularProgress> createState() {
    return _ProgressBlockState();
  }
}

class _ProgressBlockState extends State<AppCircularProgress>
    with TickerProviderStateMixin {
  // late Animation animation;
  // late AnimationController animationController;

  // void start({double? begin, double? end}) {
  //   animationController = AnimationController(
  //     duration: Duration(seconds: widget.animateDuration),
  //     vsync: this,
  //   );

  //   final chooseEnd = widget.isRateChart ? widget.rating : widget.percent;
  //   animation =
  //       Tween<double>(begin: begin ?? 0.0, end: end ?? checkTotal(chooseEnd))
  //           .animate(
  //     CurvedAnimation(
  //       parent: animationController,
  //       curve: Curves.fastLinearToSlowEaseIn,
  //     ),
  //   );
  //   animationController.forward();
  // }

  double checkTotal(double end) {
    final checkNotNegative = end < 0.0;
    final checkRating = checkNotNegative
        ? 0.0
        : end > widget.totalRating
            ? widget.totalRating
            : end;
    final checkPercent = checkNotNegative
        ? 0.0
        : end > widget.totalPercent
            ? widget.totalPercent
            : end;
    return widget.isRateChart ? checkRating : checkPercent;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   start();
  // }

  // @override
  // void didUpdateWidget(AppCircularProgress oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   widget.isRateChart
  //       ? start(begin: oldWidget.rating, end: widget.rating)
  //       : start(begin: oldWidget.percent, end: widget.percent);
  // }

  // @override
  // void dispose() {
  //   animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final terms = double.parse(animation.value.toString());
    final afterDot = widget.isRateChart ? 1 : 0;
    final opacity = widget.isRateChart ? 1.0 : 0.3;
    final textAnimated = checkTotal(widget.rating).toStringAsFixed(afterDot);

    final unselectedStrokeWidth =
        widget.circularProgressStyle.unselectedStrokeWidth;
    final selectedStrokeWidth =
        widget.circularProgressStyle.selectedStrokeWidth;

    final square =
        widget.size + (widget.isRateChart ? unselectedStrokeWidth : 0);

    final listGradientColors = widget.circularProgressStyle.listGradientColors;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: square,
          height: square,
          child: CircularProgressIndicator(
            strokeWidth: unselectedStrokeWidth,
            value: 1,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.circularProgressStyle.unselectedValueColor
                  .withOpacity(opacity),
            ),
          ),
        ),
        AppGradientCircularProgress(
          size: widget.size,
          listGradientColors: listGradientColors,
          strokeWidth: selectedStrokeWidth,
          strokeCap: widget.strokeCap ??
              (widget.isRateChart ? StrokeCap.butt : StrokeCap.round),
          value: widget.isRateChart
              ? widget.rating / widget.totalRating
              : widget.percent / widget.totalPercent,
        ),
        if (widget.isDot)
          Transform.translate(
            offset: Offset(0, -widget.size / 2),
            child: Container(
              // 0.8 - это отступ
              height: selectedStrokeWidth * 0.8,
              width: selectedStrokeWidth * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
              ),
            ),
          ),
        Container(
          width: widget.size - selectedStrokeWidth,
          height: widget.size - selectedStrokeWidth,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.circularProgressStyle.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$textAnimated${widget.isRateChart ? '' : '%'}',
            style: AppStyles.text17
                .andSize(widget.circularProgressStyle.fontSize)
                .andColor(widget.circularProgressStyle.fontColor)
                .andWeight(widget.circularProgressStyle.fontWeight),
            softWrap: false,
          ),
        ),
      ],
    );
  }
}

class CircularProgressStyle {
  const CircularProgressStyle({
    this.unselectedValueColor = AppColors.lightGrey,
    this.selectedValueColor = AppColors.firstCircularGradientColor,
    this.selectedStrokeWidth = 2,
    this.unselectedStrokeWidth = 1,
    this.backgroundColor = Colors.transparent,
    this.fontSize = 17.0,
    this.fontColor = AppColors.activeText,
    this.fontWeight = FontWeight.w500,
    this.listGradientColors = const [
      AppColors.firstCircularGradientColor,
      AppColors.secondCircularGradientColor,
    ],
  });

  ///Цвет невыделенной части окружности
  final Color unselectedValueColor;

  ///Цвет выделенной части окружности
  final Color selectedValueColor;

  final double selectedStrokeWidth;
  final double unselectedStrokeWidth;

  ///Цвет заливки внутреннего круга
  final Color backgroundColor;

  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;
  final List<Color> listGradientColors;
}
