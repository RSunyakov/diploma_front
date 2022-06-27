import 'package:flutter/cupertino.dart';
import 'package:sphere/ui/shared/all_shared.dart';

class AppCheckboxContainer extends StatefulWidget {
  const AppCheckboxContainer(
      {Key? key,
      required this.title,
      required this.value,
      required this.onChanged,
      this.titleStyle})
      : super(key: key);

  final String title;
  final bool value;
  final Function(bool) onChanged;
  final TextStyle? titleStyle;

  @override
  State<AppCheckboxContainer> createState() {
    return _AppCheckboxContainerState();
  }
}

class _AppCheckboxContainerState extends State<AppCheckboxContainer> {
  var _value = false;

  @override
  Widget build(BuildContext context) {
    _value = widget.value;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.kW),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: widget.titleStyle ?? AppStyles.text12,
          ),
          GestureDetector(
            onTap: () => setState(() {
              _value = !_value;
              widget.onChanged(_value);
            }),
            child: _value
                ? const Image(image: AppIcons.checkboxOnPng)
                : const Image(image: AppIcons.checkboxOffPng),
          ),
        ],
      ),
    );
  }
}
