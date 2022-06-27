import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/utils.dart';

class AppAutocompleteTextField<T> extends StatefulWidget {
  const AppAutocompleteTextField({
    required this.hint,
    required this.initialValue,
    required this.onChosen,
    required this.getSuggestions,
    required this.noItemsFoundText,
    required this.controller,
    required this.convertToString,
    this.height = 30.0,
    Key? key,
  }) : super(key: key);

  final String hint;
  final String initialValue;
  final String noItemsFoundText;
  final double height;
  final Function(T) onChosen;
  final Function(String) getSuggestions;
  final Function(T) convertToString;
  final TextEditingController controller;

  @override
  AppAutocompleteTextFieldState<T> createState() =>
      AppAutocompleteTextFieldState<T>();
}

class AppAutocompleteTextFieldState<T>
    extends State<AppAutocompleteTextField<T>> {
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();
  final _focusNode = FocusNode();

  bool _isOpenSuggestedBox = false;

  @override
  void didUpdateWidget(AppAutocompleteTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height < 30.kH ? 30.kH : widget.height;
    final vPadding = (height - 11) / 2;
    final textStyle = AppStyles.text14
        .andSize(11)
        .andColor(AppColors.lightGreyText)
        .andWeight(FontWeight.w300);
    return Container(
      decoration: BoxDecoration(
        boxShadow: AppColors.boxShadow,
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TypeAheadField<T>(
        suggestionsBoxController: _suggestionsBoxController,
        textFieldConfiguration: TextFieldConfiguration(
          controller: widget.controller,
          focusNode: _focusNode,
          style: textStyle.andColor(
            AppColors.plainText,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(20, vPadding, 20, vPadding),
            hintText: widget.initialValue.isNotEmpty &&
                    widget.controller.text.isNotEmpty
                ? widget.initialValue
                : widget.hint,
            fillColor: AppColors.white,
            filled: true,
            hintStyle: widget.initialValue.isNotEmpty &&
                    widget.controller.text.isNotEmpty
                ? textStyle.andColor(
                    AppColors.plainText,
                  )
                : textStyle,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(width: 0, color: AppColors.white.withOpacity(0)),
            ),
            suffixIconConstraints:
                const BoxConstraints(minHeight: 30, minWidth: 30),
            suffixIcon: _isOpenSuggestedBox
                ? GestureDetector(
                    onTap: refresh,
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: AppColors.mainColor,
                      size: 24,
                    ),
                  )
                : const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.mainColor,
                    size: 24,
                  ),
          ),
        ),
        suggestionsBoxDecoration: const SuggestionsBoxDecoration(
          elevation: 0,
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ),
        suggestionsCallback: (value) async {
          delayMilli(AppConsts.delayForEscapeVisualConflict).then((_) {
            _isOpenSuggestedBox = true;
            setState(() {});
          });
          return widget.getSuggestions(value);
        },
        itemBuilder: (context, value) {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            height: widget.height.kH,
            child: Text(
              widget.convertToString(value),
              style: textStyle.andColor(
                AppColors.plainText,
              ),
            ),
          );
        },
        onSuggestionSelected: (value) {
          setState(() {
            widget.onChosen(value);
            _isOpenSuggestedBox = false;
          });
        },
        noItemsFoundBuilder: (BuildContext context) => Container(
          height: widget.height.kH,
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(50)),
          ),
          child: Text(widget.noItemsFoundText, style: textStyle),
        ),
      ),
    );
  }

  refresh() {
    setState(() {});
    _isOpenSuggestedBox = false;
    _suggestionsBoxController.close();
  }
}
