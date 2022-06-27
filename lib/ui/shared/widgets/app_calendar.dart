import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'app_month_year_picker.dart';

/// Календарь для всех раскрывающихся календарей.
///
/// !!!ВАЖНО!!! Чтобы календарь корректно работал, необходимо,
/// чтобы label = initialValue (если начальная дата пустая)
///
/// !!!Тоже важно блин как!!!! [supportingInitialDateTime] нужно в случае,
/// когда строка [initialValue] содержит нестандартную "типа дату",
/// как в случае с Учебой и Работой. Тогда обратный парсинг ломается,
/// а [supportingInitialDateTime] поправляет ситуацию.
class AppCalendar extends StatefulWidget {
  const AppCalendar({
    required this.initialValue,
    this.supportingInitialDateTime,
    required this.onChosen,
    required this.label,
    this.minHeight = 30,
    this.maxHeight = 130,
    this.margin,
    this.mode,
    Key? key,
  }) : super(key: key);

  final double minHeight;
  final double maxHeight;
  final String label;
  final String initialValue;
  final DateTime? supportingInitialDateTime;
  final Function(String) onChosen;
  final EdgeInsetsGeometry? margin;
  final CupertinoDatePickerMode? mode;

  @override
  AppCalendarState createState() => AppCalendarState();
}

class AppCalendarState extends State<AppCalendar> {
  late double _height;
  var _isOpened = false;
  late DateTime _chosenDateTime;
  late String _value;
  late String _initialValue;

  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _initialValue = widget.supportingInitialDateTime != null
        ? DateFormat('dd-MM-yyyy').format(widget.supportingInitialDateTime!)
        : widget.initialValue;
    _refreshVariables();
  }

  void _refreshVariables() {
    _initialValue == widget.label
        ? _value = _initialValue
        : _value = DateFormat('dd MMMM yyyy')
            .format(DateFormat('dd-MM-yyyy').parse(_initialValue));

    _initialValue == widget.label
        ? _chosenDateTime = DateTime.now()
        : _chosenDateTime = DateFormat('dd-MM-yyyy').parse(_initialValue);

    _height = widget.minHeight;
  }

  @override
  void didUpdateWidget(AppCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _initialValue = widget.initialValue;
      _refreshVariables();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: Get.width,
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 15.kW),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppColors.boxShadow,
        color: AppColors.white,
        border: Border.all(
            color: _isOpened ? AppColors.mainColor : AppColors.invisible),
      ),
      child: Focus(
        onFocusChange: (_) {
          setState(() {
            _isOpened = !_isOpened;
            final minHeight = widget.minHeight;
            final maxHeight = widget.maxHeight;
            // +1 из-за странного эффекта нехватки полпикселя
            _height = _isOpened ? maxHeight + minHeight + 1 : minHeight + 1;
          });
        },
        child: Builder(builder: (context) {
          _focusNode = Focus.of(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _updateFocus(),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (_value != widget.label && !_isOpened)
                            ? _value
                            : widget.label,
                        style: AppStyles.text14
                            .andSize(11)
                            .andColor((_value != widget.label && !_isOpened)
                                ? AppColors.plainText
                                : AppColors.lightGreyText)
                            .andWeight(
                              FontWeight.w300,
                            ),
                      ),
                      _isOpened
                          ? const Icon(
                              Icons.keyboard_arrow_up,
                              color: AppColors.mainColor,
                            )
                          : svgPicture(
                              AppIcons.calendar,
                              width: 16,
                              color: AppColors.mainColor,
                            ),
                    ],
                  ),
                ),
              ),
              if (_isOpened)
                Stack(children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: Column(children: [
                      SizedBox(
                        height: 80,
                        child: CupertinoDatePicker(
                          initialDateTime: _chosenDateTime,
                          onDateTimeChanged: (DateTime value) {
                            setState(() {
                              _chosenDateTime = value;
                            });
                          },
                          mode: widget.mode ?? CupertinoDatePickerMode.date,
                        ),
                      ),
                      10.h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _updateFocus,
                            child: Text(
                              'general.cancel'.tr(),
                              style: AppStyles.text14
                                  .andColor(AppColors.lightGreyText)
                                  .andWeight(
                                    FontWeight.w300,
                                  ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _value = DateFormat('dd MMMM yyyy', 'ru')
                                  .format(_chosenDateTime);
                              widget.onChosen(DateFormat('dd-MM-yyyy')
                                  .format(_chosenDateTime));
                              _updateFocus();
                            },
                            child: Text(
                              'general.ready'.tr(),
                              style: AppStyles.text14
                                  .andColor(AppColors.lightGreyText)
                                  .andWeight(
                                    FontWeight.w300,
                                  ),
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                  IgnorePointer(
                    child: Container(
                      margin: const EdgeInsets.only(top: 32),
                      width: Get.width,
                      height: 36,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ]),
            ],
          );
        }),
      ),
    );
  }

  void _updateFocus() {
    if (_isOpened) {
      _focusNode?.unfocus();
    } else {
      _focusNode?.requestFocus();
    }
  }
}
