import 'package:hive_flutter/adapters.dart';

part 'address_entity.g.dart';

@HiveType(typeId: 1)
class AddressEntity {
  @HiveField(0)
  final String addressName;
  @HiveField(1)
  final String country;
  @HiveField(2)
  final String state;
  @HiveField(3)
  final String addressDetail;
  @HiveField(4)
  final int postalCode;

  AddressEntity(
      {required this.addressName,
      required this.country,
      required this.state,
      required this.addressDetail,
      required this.postalCode});
}
