import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphere/core/safe_coding/src/either.dart';
import 'package:sphere/data/dto/user/user.dart';
import 'package:sphere/domain/balance/balance.dart';
import 'package:sphere/domain/balance/transaction.dart';
import 'package:sphere/domain/city/city.dart';
import 'package:sphere/domain/core/extended_errors.dart';
import 'package:sphere/domain/core/value_objects.dart';
import 'package:sphere/domain/country/country.dart';
import 'package:sphere/domain/user_settings/user_settings.dart';

part 'balance.g.dart';

@JsonSerializable()
class BalanceDto {
  BalanceDto({
    required this.status,
    this.data,
    this.errors,
    this.balance,
  });

  final bool status;
  final List<TransactionDataDto>? data;
  final num? balance;
  final Map<String, dynamic>? errors;

  factory BalanceDto.fromJson(Map<String, dynamic> json) =>
      _$BalanceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceDtoToJson(this);
}

@JsonSerializable()
class TransactionDataDto {
  TransactionDataDto({
    this.type,
    this.amount,
    this.sender,
    this.recipient,
    this.createdAt,
  });

  final String? type;
  final num? amount;
  final UserDataDto? sender;
  final UserDataDto? recipient;
  final String? createdAt;

  factory TransactionDataDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDataDtoToJson(this);
}

extension BalanceDtoX on BalanceDto {
  Either<ExtendedErrors, Balance> toDomain() {
    try {
      if (!status) {
        return Left(parseError(errors ?? <String, dynamic>{}));
      }
      if (data == null) {
        return Left(ExtendedErrors.simple('Balance: data is null'));
      }

      final domain = Balance(
        balance: balance ?? 0,
        transactions: data!
            .map((e) => Transaction(
                  type: NonEmptyString(e.type ?? ''),
                  sender: UserInfo(
                    uuid: NonEmptyString(e.sender?.uuid ?? ''),
                    email: Email.tagged(e.sender?.email ?? ''),
                    phone: NonEmptyString(e.sender?.phone ?? ''),
                    age: e.sender?.age ?? 0,
                    firstName: NonEmptyString(e.sender?.firstName ?? ''),
                    lastName: NonEmptyString(e.sender?.lastName ?? ''),
                    country: Country(
                        id: e.sender?.country?.id ?? 0,
                        name: NonEmptyString(e.sender?.country?.name ?? '')),
                    city: City(
                        id: e.sender?.city?.id ?? 0,
                        name: NonEmptyString(e.sender?.city?.name ?? '')),
                    photo: NonEmptyString(e.sender?.photo ?? ''),
                    joinedAt: NonEmptyString(e.sender?.joinedAt ?? ''),
                    position: e.sender?.position ?? '',
                    isMentor: e.sender?.isMentor ?? false,
                    rating: e.sender?.rating?.toDouble() ?? 0,
                    isBanned: false,
                    birthday: NonEmptyString(''),
                    gender: NonEmptyString(''),
                  ),
                  createdAt: DateFormat('dd-MM-yyyy').parse(e.createdAt ?? ''),
                  recipient: UserInfo(
                    uuid: NonEmptyString(e.recipient?.uuid ?? ''),
                    email: Email.tagged(e.recipient?.email ?? ''),
                    phone: NonEmptyString(e.recipient?.phone ?? ''),
                    age: e.recipient?.age ?? 0,
                    firstName: NonEmptyString(e.recipient?.firstName ?? ''),
                    lastName: NonEmptyString(e.recipient?.lastName ?? ''),
                    country: Country(
                        id: e.recipient?.country?.id ?? 0,
                        name: NonEmptyString(e.recipient?.country?.name ?? '')),
                    city: City(
                        id: e.recipient?.city?.id ?? 0,
                        name: NonEmptyString(e.recipient?.city?.name ?? '')),
                    photo: NonEmptyString(e.recipient?.photo ?? ''),
                    joinedAt: NonEmptyString(e.recipient?.joinedAt ?? ''),
                    position: e.recipient?.position ?? '',
                    isMentor: e.recipient?.isMentor ?? false,
                    rating: e.recipient?.rating?.toDouble() ?? 0,
                    isBanned: false,
                    birthday: NonEmptyString(''),
                    gender: NonEmptyString(''),
                  ),
                ))
            .toList(),
      );
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
