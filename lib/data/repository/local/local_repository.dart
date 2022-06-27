export 'src/shared_pref_repo_impl.dart';

import 'package:sphere/core/safe_coding/safe_coding.dart';
import 'package:sphere/domain/auth_data/auth_data.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/occupation/occupation.dart';
import 'package:sphere/logic/profile/occupation_bloc/occupation_bloc.dart';

/// Абстракция локального репозитория.
/// [saveProfileDtoString] / [getProfileDtoString]:
///   Предположим - локальный репозиторий манипулирует профилями, как строками.
abstract class LocalRepository {
  Future<Either<String, Unit>> writeAuthMethod(AuthMethod value);
  Future<Either<String, AuthMethod>> readAuthMethod();

  Future<Either<String, NonEmptyString>> readLanguage();
  Future<Either<String, NonEmptyString>> writeLanguage(NonEmptyString value);

  Future<OrOccupations> fetchOccupations(Type tag);

  Future<OrOccupations> saveOccupations(List<Occupation> value, Type tag);
}
