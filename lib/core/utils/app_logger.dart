import 'package:logger/logger.dart';

/// Прям логгер логгер - со стеком даже
final logger = Logger(
  printer: PrettyPrinter(
    printTime: true,
    methodCount: 4,
  ),
);

/// Простяцкий, но красивый
final loggerSimple = Logger(
  printer: SimplePrinter(
    printTime: true,
    colors: true,
  ),
);

/// В этом логгере нет особого смысла, лучше [loggerSimple]
final loggerNoStack = Logger(
  printer: PrettyPrinter(
    printTime: true,
    methodCount: 0,
  ),
);
