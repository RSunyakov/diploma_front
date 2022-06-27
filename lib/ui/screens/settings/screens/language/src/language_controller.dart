import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sphere/data/repository/local/local_repository.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';

import 'language_service.dart';

class LanguageScreenController extends StatexController {
  LanguageScreenController(
      {LocalRepository? repo, LanguageScreenService? service})
      : repoLocal = repo ?? GetIt.I.get(),
        _service = service ?? Get.find();

  final LocalRepository repoLocal;
  final LanguageScreenService _service;

  LanguageApp get language$ => _service.language$;

  Map<String, Language> get mapLang => _service.mapLang;

  bool selectedLang(String lang) => _service.selectedLang(lang);

  Future changeLanguage(String language, BuildContext context) async {
    _service.changeLanguage(language, context);
  }

  Future startLang(Locale? locale, BuildContext context) async {
    _service.startLang(locale, context);
  }
}
