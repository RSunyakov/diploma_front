import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/core/safe_coding/src/unit.dart';
import 'package:sphere/domain/auth_data/auth_data.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/logic/profile/occupation_bloc/occupation_bloc.dart';

import '../local_repository.dart';

/// Имплементация локального репозитория
/// как адаптера к Preference
@prod
@LazySingleton(as: LocalRepository)
class SharedPreferenceRepositoryImpl implements LocalRepository {
  SharedPreferences? _pref;

  static const _authMethodKey = 'auth_method';
  static const _languageKey = 'language';

  @override
  Future<Either<String, AuthMethod>> readAuthMethod() async {
    return _safeWrapperS(() async {
      final s = await _getString(_authMethodKey, def: '');
      final json = jsonDecode(s);
      final o = AuthMethod.fromJson(json);
      return right(o);
    });
  }

  @override
  Future<Either<String, Unit>> writeAuthMethod(AuthMethod value) async {
    return _safeWrapperS(() async {
      final json = value.toJson();
      final s = jsonEncode(json);
      _saveString(_authMethodKey, s);
      return right(unit);
    });
  }

  @override
  Future<Either<String, NonEmptyString>> readLanguage() async {
    final rez = await _getString(_languageKey, def: '');
    return right(NonEmptyString(rez, failureTag: _languageKey));
  }

  @override
  Future<Either<String, NonEmptyString>> writeLanguage(
      NonEmptyString value) async {
    _saveString(_languageKey, value.getOrElse());
    return right(value);
  }

  @override
  Future<OrOccupations> fetchOccupations(Type tag) {
    throw Exception('NRY');
    // return _safeWrapperExt(() async {
    //   final key = '$_occupationsKey-$tag';
    //   final s = await _getString(key, def: '');
    //   final list = jsonDecode(s) as List;
    //   final items = list.map((e) => Occupation.fromJson(e)).toList();
    //   return right(items);
    // });
  }

  @override
  Future<OrOccupations> saveOccupations(List<Occupation> value, Type tag) {
    throw Exception('NRY');
    // return _safeWrapperExt(() async {
    //   final json = value.map((e) => e.toJson()).toList();
    //   final s = jsonEncode(json);
    //   final key = '$_occupationsKey-$tag';
    //   _saveString(key, s);
    //   return right(value);
    // });
  }

  //////////////////////////////////////////////////////////////////////////////

  Future _init() async {
    _pref ??= await SharedPreferences.getInstance();
    return;
  }

  Future _saveString(String key, String data) async {
    await _init();
    await _pref?.setString(key, data);
  }

  Future<String> _getString(String key, {String? def}) async {
    return _init().then((_) => _pref?.getString(key) ?? def ?? '');
  }

  Future<Either<String, R>> _safeWrapperS<R>(
      Future<Either<String, R>> Function() f) async {
    try {
      final r = await f.call();
      return r;
    } on Error catch (e) {
      return left(e.toString());
    } on Exception catch (e) {
      return left(e.toString());
    }
  }

  // Future<Either<ExtendedErrors, R>> _safeWrapperExt<R>(
  //     Future<Either<ExtendedErrors, R>> Function() f) async {
  //   try {
  //     final r = await f.call();
  //     return r;
  //   } on Error catch (e) {
  //     return left(ExtendedErrors.simple(e.toString()));
  //   } on Exception catch (e) {
  //     return left(ExtendedErrors.simple(e.toString()));
  //   }
  // }
}
