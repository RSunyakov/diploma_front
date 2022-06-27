import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sphere/ui/shared/all_shared.dart';
import 'package:sphere/ui/shared/widgets/app_camera_gallery_bottom_sheet.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:vfx_flutter_common/utils.dart';

import '../../../../../core/safe_coding/src/either.dart';
import '../../../../../core/utils/stream_subscriber.dart';

import '../../../../../domain/city/city.dart';
import '../../../../../domain/core/extended_errors.dart';
import '../../../../../domain/country/country.dart';
import '../../../../../domain/user_settings/user_settings.dart';
import '../../../../shared/file_extension.dart';
import '../../../../shared/image_compressor.dart';
import '../../../../shared/services/image_picker_service.dart';
import '../../src/settings_service.dart';

class PageSettingsScreenController extends StatexController
    with StreamSubscriberMixin {
  PageSettingsScreenController(
      {SettingsService? service, ImagePickerService? imagePickerService})
      : _service = service ?? Get.find(),
        _imagePickerService = imagePickerService ?? Get.find();

  final SettingsService _service;
  final ImagePickerService _imagePickerService;

  final formKey = GlobalKey<FormState>();

  // Фамилия
  final firstName = ''.obs;

  final firstNameTextController = TextEditingController();

  void changeFirstName(String value) => firstName.value = value;

  // Имя
  final lastName = ''.obs;

  final lastNameTextController = TextEditingController();

  void changeLastName(String value) => lastName.value = value;

  // Пол

  final _sex = 'Пол'.obs;

  get sex$ => _sex();

  void setSex(String v) => _sex(v);

  final sexes = [
    'general.woman'.tr(),
    'general.man'.tr(),
  ];

  // День рождения

  final _birthday = 'general.day_of_birth'.tr().obs;

  get birthday$ => _birthday();

  void setBirthday(String value) => _birthday.value = value;

  final _isShowBirthday = true.obs;

  get isShowBirthday$ => _isShowBirthday();

  void setIsShowBirthday(bool v) => _isShowBirthday(v);

  // Аватар

  late File avatarFile = File('');

  final _avatar = ''.obs;

  get avatar$ => _avatar();

  void setAvatar(String v) => _avatar(v);

  // FIXME(vvk): уменьшил размер, так как в бэк не пролазило.
  static const avatarMaxSizeInBytes = 1024000;

  Future uploadAvatar({required bool isFromGallery}) async {
    final res = isFromGallery
        ? await _imagePickerService.getGalleryFile()
        : await _imagePickerService.getCameraFile();
    res.fold((l) {
      delayMilli(25).then((value) => showSimpleNotification(
          Text(l.smartErrorsValue),
          duration: const Duration(seconds: 4),
          background: Colors.red));
    }, (r) async {
      if (r!.isEmpty) {
        return;
      }
      if (FilePathExtensions.getExtension(r) == FileExtension.unknown) {
        showSimpleNotification(Text('general.wrong_file_format'.tr()),
            duration: const Duration(seconds: 4), background: Colors.red);
        return;
      }

      final compressedFileResult =
          await ImageCompressor.compress(r, avatarMaxSizeInBytes);

      compressedFileResult.fold(
          (l) => showSimpleNotification(Text('general.zip_error'.tr()),
              duration: const Duration(seconds: 4),
              background: Colors.red), (r) {
        avatarFile = File(r!.path);
        setAvatar(r.path);
      });
    });
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return AppCameraGalleryBottomSheet(
          onTapGallery: () => uploadAvatar(isFromGallery: true),
          onTapPhoto: () => uploadAvatar(isFromGallery: false),
        );
      },
    );
  }

  //Страны

  final countryTextController = TextEditingController();

  final _countries = <Country>[].obs;

  List<Country> get countries$ => _countries();

  final _country = Country.empty.obs;

  Country get country$ => _country();

  void setCountry(Country v) {
    _country(v);
    countryTextController.withText(v.name.getOrElse());
    fetchCities();
  }

  Future<List<Country>> getCountries(String query) async {
    final matches = <String>[];
    matches.addAll(countries$.map((e) => e.name.getOrElse()).toList());
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    final selectedCountries = <Country>[];
    for (var countryName in matches) {
      selectedCountries
          .add(countries$.firstWhere((e) => e.name.getOrElse() == countryName));
    }
    return selectedCountries;
  }

  //Города

  final cityTextController = TextEditingController();

  final _cities = <City>[].obs;

  List<City> get cities$ => _cities();

  final _city = City.empty.obs;

  City get city$ => _city();

  Future<List<City>> getCities(String query) async {
    final matches = <String>[];
    matches.addAll(cities$.map((e) => e.name.getOrElse()).toList());
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    final selectedCities = <City>[];
    for (var cityName in matches) {
      selectedCities
          .add(cities$.firstWhere((e) => e.name.getOrElse() == cityName));
    }
    return selectedCities;
  }

  void setCity(City v) {
    _city(v);
    cityTextController.withText(v.name.getOrElse());
  }

  void clearCities() {
    cityTextController.text = '';
    cities$.clear();
    setCity(City.empty);
  }

  @override
  void onInit() {
    super.onInit();
    subscribeIt(_service.countries.stream.listen(_processCountries));
    subscribeIt(_service.cities.stream.listen(_processCities));
    subscribeIt(_service.userSettingsData.stream.listen(_processUserSettings));
  }

  @override
  void onWidgetInitState() {
    super.onWidgetInitState();
    _service.fetchUserSettings();
    _service.fetchCountries();
  }

  void _processUserSettings(Either<ExtendedErrors, UserSettings> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      firstName.value = r.userInfo.firstName.getOrElse();
      firstNameTextController.withText(firstName.value);

      lastName.value = r.userInfo.lastName.getOrElse();
      lastNameTextController.withText(lastName.value);

      r.userInfo.gender.getOrElse().isNotEmpty
          ? r.userInfo.gender.value.fold(
              (l) => null,
              (r) => r == 'male'
                  ? setSex('general.man'.tr())
                  : setSex('general.woman'.tr()))
          : null;
      r.userInfo.birthday.getOrElse().isNotEmpty
          ? r.userInfo.birthday.value.fold((l) => null, (r) => setBirthday(r))
          : null;
      r.userInfo.photo.getOrElse().isNotEmpty
          ? r.userInfo.photo.value.fold((l) => null, (r) {
              setAvatar(r);
            })
          : null;

      setCountry(r.userInfo.country);
      setCity(r.userInfo.city);
    });
  }

  void _processCountries(Either<ExtendedErrors, List<Country>> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      _countries.addAll(r);
    });
  }

  void _processCities(Either<ExtendedErrors, List<City>> info) {
    info.fold((l) {
      appAlert(value: l.error, color: AppColors.red);
    }, (r) {
      _cities.addAll(r);
    });
  }

  void updateUserSettings() {
    _service.updateUserSettings(
        firstName: firstName.value.isNotEmpty ? firstName.value : null,
        lastName: lastName.value.isNotEmpty ? lastName.value : null,
        gender: sex$ == 'general.man'.tr()
            ? 'male'
            : sex$ == 'general.female'.tr()
                ? 'female'
                : null,
        birthday: _birthday.value != 'general.day_of_birth'.tr()
            ? _birthday.value
            : null,
        photo: avatarFile.path.isNotEmpty ? avatarFile : null,
        countryId: country$.id != 0 ? country$.id : null,
        cityId: city$.id != 0 ? city$.id : null);
  }

  void fetchCities() {
    if (country$.id != 0) {
      _service.fetchCities(country$.id);
    }
  }
}
