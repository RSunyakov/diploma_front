import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shared/common.dart';

void main() {
  group('Utils tests', () {
    ///
    myTest('_calculateAgeStringBy test', () async {
      // ignore: unused_local_variable
      const ints = {
        1: '1 год',
        2: '2 года',
        3: '3 года',
        4: '4 года',
        5: '5 лет',
        6: '6 лет',
        7: '7 лет',
        8: '8 лет',
        9: '9 лет',
        10: '10 лет',
        11: '11 лет',
        12: '12 лет',
        13: '13 лет',
        14: '14 лет',
        15: '15 лет',
        16: '16 лет',
        17: '17 лет',
        18: '18 лет',
        19: '19 лет',
        20: '20 лет',
        21: '21 год',
        22: '22 года',
        23: '23 года',
        24: '24 года',
        25: '25 лет',
        30: '30 лет',
        100: '100 лет',
        101: '101 год',
        102: '102 года',
        103: '103 года',
        104: '104 года',
        105: '105 лет',
        110: '110 лет',
        120: '120 лет',
        400: '400 лет',
        401: '401 год',
        402: '402 года',
        403: '403 года',
        404: '404 года',
        405: '405 лет',
        410: '410 лет',
        420: '420 лет'
      };
    });
  });
}

// TODO(vvk): отладить склонение
// ignore: unused_element
String _calculateAgeStringBy(int age) {
  if (age == 1) {
    return '$age год';
  }
  final lastChar = '$age'.characters.last;
  if (['2', '3', '4'].contains(lastChar)) {
    return '$age года';
  }
  return '$age лет';
}
