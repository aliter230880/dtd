// ignore_for_file: constant_identifier_names, type_literal_in_constant_pattern

import 'package:collection/collection.dart';

enum DealStatus {
  InSearch,
  InConfirm,
  InActive,
  InDispute,
  Completed,
  Canceled,
  CanceledByAdmin,
  InConfirmComplete,
}

enum UserType {
  Diller,
  Carrier,
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

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (DealStatus):
      return DealStatus.values.deserialize(value) as T?;
    case (UserType):
      return UserType.values.deserialize(value) as T?;
    case (DealsViewMode):
      return DealsViewMode.values.deserialize(value) as T?;
    case (FilterRate):
      return FilterRate.values.deserialize(value) as T?;
    default:
      return null;
  }
}
