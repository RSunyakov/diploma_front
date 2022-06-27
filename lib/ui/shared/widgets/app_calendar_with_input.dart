import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:sphere/ui/shared/all_shared.dart';
import 'app_month_year_picker.dart';

class AppCalendarWithInput extends StatefulWidget {
  AppCalendarWithInput({
    TextEditingController? controller,
    required this.initialValue,
    this.supportingInitialDateTime,
    required this.onChosen,
    required this.label,
    this.minHeight = 30,
    this.maxHeight = 130,
    this.margin,
    this.mode,
    this.height = 30,
    this.fontSize = 11.0,
    Key? key,
  })  : controller = controller ?? TextEditingController(),
        super(key: key);

  final double minHeight;
  final TextEditingController? controller;
  final double height;
  final double maxHeight;
  final double fontSize;
  final String label;
  final String initialValue;
  final DateTime? supportingInitialDateTime;
  final Function(String) onChosen;
  final EdgeInsetsGeometry? margin;
  final CupertinoDatePickerMode? mode;

  @override
  AppCalendarWithInputState createState() => AppCalendarWithInputState();
}

class AppCalendarWithInputState extends State<AppCalendarWithInput> {
  late double _height;
  var _isOpened = false;
  late DateTime _chosenDateTime;
  late String _value;
  late String _initialValue;

  bool get isOpened => _isOpened;

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
  void didUpdateWidget(AppCalendarWithInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _initialValue = widget.initialValue;
      _refreshVariables();
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = widget.minHeight < 30.kH ? 30.kH : widget.minHeight;
    final textStyle = AppStyles.text14
        .andSize(widget.fontSize)
        .andColor(AppColors.lightGreyText)
        .andWeight(FontWeight.w300);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          //При закрытом календаре нехватает 2 пикселя
          height: !_isOpened ? _height + 2 : _height,
          width: Get.width,
          margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 15.kW),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppColors.boxShadow,
            color: AppColors.white,
            border: Border.all(
                color: _isOpened ? AppColors.mainColor : AppColors.invisible),
          ),
          child: Column(
            children: [
              if (!_isOpened)
                TextFormField(
                  controller: widget.controller,
                  style: textStyle,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                        20,
                        (h - widget.fontSize) / 2,
                        20,
                        (h - widget.fontSize) / 2),
                    suffixIcon: !_isOpened
                        ? Padding(
                            padding: const EdgeInsets.only(right: 13),
                            child: svgPicture(AppIcons.calendar,
                                color: AppColors.mainColor,
                                onTap: () => _updateFocus()),
                          )
                        : Container(),
                    suffixIconConstraints: const BoxConstraints(
                      minHeight: 20,
                      minWidth: 20,
                    ),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 0, color: AppColors.white.withOpacity(0)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide:
                          BorderSide(width: 0, color: AppColors.mainColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 0, color: AppColors.white.withOpacity(0)),
                    ),
                  ),
                ),
              Focus(
                onFocusChange: (_) {
                  setState(() {
                    _isOpened = !_isOpened;
                    final minHeight = widget.minHeight;
                    final maxHeight = widget.maxHeight;
                    // +1 из-за странного эффекта нехватки полпикселя
                    _height =
                        _isOpened ? maxHeight + minHeight + 1 : minHeight + 1;
                  });
                },
                child: Builder(
                  builder: (context) {
                    _focusNode = Focus.of(context);
                    return Column(
                      children: [
                        if (_isOpened)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 27, top: 11, right: 12),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Text('Дедлайн',
                                      style: AppStyles.text12
                                          .andWeight(FontWeight.w400)
                                          .andColor(AppColors.plainText)),
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
                                          .andColor(AppColors.mainColor)
                                          .andWeight(
                                            FontWeight.w300,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 10, 25, 10),
                                    child: Column(children: [
                                      SizedBox(
                                        //Оверфлоу в 11 пикселей, так как имеются отступы сверху и снизу
                                        height: widget.maxHeight - 11,
                                        child: CupertinoDatePicker(
                                          selectionOverlay: true,
                                          initialDateTime: _chosenDateTime,
                                          onDateTimeChanged: (DateTime value) {
                                            setState(() {
                                              _chosenDateTime = value;
                                            });
                                          },
                                          mode: widget.mode ??
                                              CupertinoDatePickerMode.date,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        _value != widget.label && !_isOpened
            ? Column(
                children: [
                  7.h,
                  Text(
                    'До $_value',
                    style: AppStyles.text12
                        .andWeight(FontWeight.w400)
                        .andColor(AppColors.lightGrey),
                  )
                ],
              )
            : Container(),
      ],
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
