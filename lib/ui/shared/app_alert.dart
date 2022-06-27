import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:vfx_flutter_common/utils.dart';

Future appAlert({
  required String value,
  required Color color,
  int durationSec = 2,
}) async {
  await delayMilli(250).then(
    (_) => showSimpleNotification(
      Text(value),
      background: color,
      duration: Duration(seconds: durationSec),
    ),
  );
}
