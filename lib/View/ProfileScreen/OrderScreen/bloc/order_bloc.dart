import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/OrderEntity/order_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<OrderEvent>((event, emit) async {
      final profileController = Get.find<ProfileController>();
      final duplicateController = Get.find<DuplicateController>();

      if (event is OrderInitialEvent) {
        emit(OrderLoading());
        final orderHistoryList =
            await profileController.orderFunctions.getOrderList();
        if (orderHistoryList.isNotEmpty) {
          emit(OrderInitialScreen(
              duplicateController: duplicateController,
              orderHistoryList: orderHistoryList));
        } else {
          emit(OrderEmpty(duplicateController));
        }
      }
    });
  }
}
