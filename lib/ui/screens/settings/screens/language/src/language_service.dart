import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sphere/data/repository/local/local_repository.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

enum LanguageApp { ru, en }

extension LanguageAppEx on LanguageApp {
  String get name => describeEnum(this);
}

class LanguageScreenService extends GetxService {
  LanguageScreenService({LocalRepository? repo})
      : repoLocal = repo ?? GetIt.I.get() {
    debugPrint('$now: LanguageScreenService.LanguageScreenService');
  }

  final LocalRepository repoLocal;

  final _language = LanguageApp.ru.obs;
  LanguageApp get language$ => _language();

  //выбор языка
  final mapLang = {
    'ru': Language(lang: 'Русский', path: AppIcons.ruPath),
    'en': Language(lang: 'English', path: AppIcons.englandPath),
  };

  bool selectedLang(String lang) => language$.name == lang;

  LanguageApp _lang(String l) => LanguageApp.values.byName(l);

  Future changeLanguage(String language, BuildContext context) async {
    _language(_lang(language));
    EasyLocalization.of(context)?.setLocale(Locale(language));
    await repoLocal.writeLanguage(NonEmptyString(language));
  }

  Future startLang(Locale? locale, BuildContext context) async {
    _language(_lang(locale?.languageCode ?? ''));
    EasyLocalization.of(context)?.setLocale(context.locale);
    await repoLocal.writeLanguage(NonEmptyString(locale?.languageCode ?? ''));
  }

  @override
  void onReady() async {
    super.onReady();
    _language(_lang((await repoLocal.readLanguage())
        .fold((l) => l, (r) => r.value.getOrElse(() => ''))));
  }
}

class Language {
  Language({required this.path, required this.lang});
  final String path;
  final String lang;
}
