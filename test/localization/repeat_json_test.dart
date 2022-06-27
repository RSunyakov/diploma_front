import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

final pluralsSet =
    HashSet<String>.from(['zero', 'one', 'two', 'few', 'many', 'other']);

void main() async {
  group('Localization test', () {
    late String jsonString;
    late dynamic json;
    late Map<String, List<String>> jsonValuesMap;
    File file = File('assets/translations/ru.json');
    test('Reading localization file', () async {
      expect(file.existsSync(), true);
      jsonString = await file.readAsString();
      expect(jsonString.isEmpty, false);
      json = const JsonCodec().decoder.convert(jsonString);
      expect(json, isNotNull);
      expect(json is Map<String, dynamic>, true);
    });
    test('Check content', () {
      jsonValuesMap = processJson(json as Map<String, dynamic>);
      bool flag = checkKeys(jsonValuesMap);
      expect(flag, true, reason: 'Duplicated strings detected: $file');
    });
  });
}

bool checkKeys(Map<String, List<String>> map) {
  bool result = true;
  for (var entry in map.entries) {
    if (entry.value.length == 1) {
      continue;
    }
    result = pluralsSet.containsAll(entry
        .value); // Проверка, что все элементы массива из подмножества plurals
    if (!result) {
      //Если в массиве ключей, с идентичными значениями, больше одного элемента,
      // не входящего в множество plurals, значит есть запреженные повторы
      //
      result =
          entry.value.toSet().difference(pluralsSet).length > 1 ? false : true;
    }
    if (result) {
      debugPrint('Warning. Duplication possible.  ${entry.key};\nkeys list:');
    } else {
      debugPrint('Duplication detected. String: ${entry.key};\nkeys list:');
    }
    for (var str in entry.value) {
      debugPrint('Repeating key: $str;');
    }
  }
  return result;
}

Map<String, List<String>> processJson(Map<String, dynamic> json) {
  final result = <String, List<String>>{};
  for (var entry in json.entries) {
    if (entry.value is! String) {
      if (entry.value is int) {
        int v = entry.value;
        var e = MapEntry<String, String>(entry.key, '$v');
        addEntry(e, result);
        continue;
      }
      var subResult = processJson(entry.value);
      merge(result, subResult);
      continue;
    }
    addEntry(entry, result);
  }
  return result;
}

void addEntry(MapEntry entry, Map<String, List<String>> map) {
  if (map.containsKey(entry.value)) {
    map[entry.value]!.add(entry.key);
  } else {
    map[entry.value] = <String>[entry.key];
  }
}

void merge(Map<String, List<String>> to, Map<String, List<String>> from) {
  for (var entry in from.entries) {
    if (to.containsKey(entry.key)) {
      to[entry.key]!.addAll(entry.value);
      continue;
    }
    to[entry.key] = entry.value;
  }
}
