import 'package:flutter/material.dart';

import '../all_shared.dart';

/// [Chips] для [ProfileScreen].
/// Если потребуется, надо его развить
class AppChips extends StatelessWidget {
  const AppChips({required this.text, this.onClose, Key? key})
      : super(key: key);

  final String text;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 1, bottom: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.topLeft,
            // color: Colors.red,
            child: Text(
              text,
              style: AppStyles.text14.andWeight(FontWeight.w400),
            ),
          ),
          onClose != null
              ? GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: 4.insetsAll,
                    child: const Icon(Icons.close, color: AppColors.lightGrey),
                  ),
                )
              : Container(
                  padding: 4.insetsAll,
                  height: 30,
                ),
        ],
      ),
    );
  }
}
