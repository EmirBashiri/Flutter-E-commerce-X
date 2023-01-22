import 'package:flutter_application_ecommerce/Model/Tools/Entities/OrderEntity/order_entity.dart';
import 'package:hive/hive.dart';

class OrderFunctions {
  final String orderBoxName = "Order Box";
  Future<void> openOrderBox() async {
    bool isOpen = Hive.isBoxOpen(orderBoxName);
    if (!isOpen) {
      await Hive.openBox<OrderEntity>(orderBoxName);
    }
  }

  Future<bool> addToOrderBox({required OrderEntity orderEntity}) async {
    await openOrderBox();
    final box = Hive.box<OrderEntity>(orderBoxName);
    await box.add(orderEntity);
    await box.close();
    return true;
  }

  Future<List<OrderEntity>> getOrderList() async {
    await openOrderBox();
    final box = Hive.box<OrderEntity>(orderBoxName);
    final List<OrderEntity> orderList = box.values.toList();
    await box.close();
    return orderList;
  }
}
