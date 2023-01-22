import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:hive/hive.dart';

part 'order_entity.g.dart';

@HiveType(typeId: 2)
class OrderEntity {
  @HiveField(0)
  final List<ProductEntity> productList;
  @HiveField(1)
  final String totalPrice;
  @HiveField(2)
  final DateTime time;

  OrderEntity(
      {required this.productList,
      required this.totalPrice,
      required this.time});
}
