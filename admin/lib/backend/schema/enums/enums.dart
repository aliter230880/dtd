// ignore_for_file: constant_identifier_names, type_literal_in_constant_pattern

import 'package:collection/collection.dart';

enum AdminStatus {
  wait,
  accept,
  reject,
}

enum AdminAccess {
  all,
  support,
  payments,
  edit_users,
}

enum UserType {
  Diller,
  Carrier,
}

enum DealStatus {
  InSearch,
  InConfirm,
  InActive,
  InDispute,
  Completed,
  Canceled,
  InConfirmComplete,
}

enum DealsViewMode {
  List,
  Map,
}

enum FilterRate {
  five,
  fourAndOver,
  threeAndOver,
  any,
}

enum Role {
  superuser,
  worker,
}

enum ComplainType {
  deal,
  user,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (AdminStatus):
      return AdminStatus.values.deserialize(value) as T?;
    case (AdminAccess):
      return AdminAccess.values.deserialize(value) as T?;
    case (UserType):
      return UserType.values.deserialize(value) as T?;
    case (DealStatus):
      return DealStatus.values.deserialize(value) as T?;
    case (DealsViewMode):
      return DealsViewMode.values.deserialize(value) as T?;
    case (FilterRate):
      return FilterRate.values.deserialize(value) as T?;
    case (Role):
      return Role.values.deserialize(value) as T?;
    case (ComplainType):
      return ComplainType.values.deserialize(value) as T?;
    default:
      return null;
  }
}


String? adminAccessName(AdminAccess? access) {
  if (access == null) return null;

  switch (access) {
    case AdminAccess.edit_users:
      return 'Изменение пользователей';
    case AdminAccess.payments:
      return 'Платежи';
    case AdminAccess.support:
      return 'Поддержка';
    default:
      return 'Все';
  }
}