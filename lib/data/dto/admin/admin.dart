import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/domain/admin/admin.dart';
import 'package:sphere/domain/core/extended_errors.dart';

part 'admin.g.dart';

@JsonSerializable()
class AdminDto {
  AdminDto({
    required this.data
});
  AdminDataDto? data;

  factory AdminDto.fromJson(Map<String, dynamic> json) => _$AdminDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminDtoToJson(this);
}

@JsonSerializable()
class AdminDataDto {
  AdminDataDto({
    required this.id,
    required this.login,
    required this.password
});

  int id;
  String login;
  String password;

  factory AdminDataDto.fromJson(Map<String, dynamic> json) =>
      _$AdminDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminDataDtoToJson(this);
}


@JsonSerializable()
class AddAdminBody {
  AddAdminBody({
    required this.login,
    required this.password,
});

  final String login;
  final String password;

  factory AddAdminBody.fromJson(Map<String, dynamic> json) =>
      _$AddAdminBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddAdminBodyToJson(this);
}

extension AdminDtoX on AdminDto {
  Either<ExtendedErrors, Admin> toDomain() {
    try {
      if (data == null) {
        return Left(ExtendedErrors.simple('Test: data is null'));
      }
      final domain = Admin(id: data!.id, login: data!.login, password: data!.password);
      return Right(domain);
    } on Error catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on CheckedFromJsonException catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    } on Exception catch (e) {
      return left(ExtendedErrors.simple(e.toString()));
    }
  }
}





