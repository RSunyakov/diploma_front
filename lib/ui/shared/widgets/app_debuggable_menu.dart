import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Постройка виджетов с элементом отладки.
/// Отрабатывает только если есть флаг [kDebugMode] и элементы списка.
/// Таким образом можно в отладке скакать куда угодно.
///
/// ```dart
///         return Scaffold(
///           body: WillPopScope(
///             onWillPop: c.tryClose,
///             child: SafeArea(
///               child: DebuggableMenu(
///                 top: 8,
///                 right: 8,
///                 debugItems: {
///                   'Logout from Auth': () =>
///                       Get.find<TokenService>().adjustSecurity(),
///                   'Logout from Data': () =>
///                       Get.find<DataService>().adjustSecurityTest(),
///                   'Drop security': () =>
///                       Get.find<UserPreferencesService>().saveSecurity(
///                         Security.none,
///                       ),
///                 },
///                 mainWidget: Stack(
///                   children: [
///                     PageView(
///                       controller: c.ScreenController,
/// ```
///
class AppDebuggableMenu extends StatelessWidget {
  const AppDebuggableMenu({
    Key? key,
    required this.mainWidget,
    this.debugItems,
    this.top = 25,
    this.bottom,
    this.left,
    this.right,
  }) : super(key: key);

  final Widget mainWidget;
  final Map<String, void Function()>? debugItems;
  final double top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    if (debugItems != null && kDebugMode) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            mainWidget,
            _PopupMenu(
              left: left,
              right: right,
              top: top,
              items: debugItems,
            ),
          ],
        ),
      );
    } else {
      return mainWidget;
    }
  }
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu({
    Key? key,
    this.items,
    this.top,
    // ignore: unused_element
    this.bottom,
    this.left,
    this.right,
  }) : super(key: key);

  final Map<String, void Function()>? items;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: PopupMenuButton(
        icon: const Icon(
          Icons.volunteer_activism,
          color: Colors.red,
        ),
        onSelected: (dynamic v) => v.value?.call(),
        itemBuilder: (context) {
          return items!.entries.map((e) {
            return PopupMenuItem(
              value: e,
              child: Text(e.key),
            );
          }).toList();
        },
      ),
    );
  }
}
