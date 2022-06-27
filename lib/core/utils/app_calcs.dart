import 'package:flutter/material.dart';

const figmaWidth = 375;
const figmaHeight = 747;

BuildContext? _contextApp;

void initContextApp(BuildContext context) => _contextApp ??= context;

double get appHeight => MediaQuery.of(_contextApp!).size.height;

double get appWidth => MediaQuery.of(_contextApp!).size.width;

double get kHeight => appHeight / figmaHeight;

double get kWidth => appWidth / figmaWidth;
