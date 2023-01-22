import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/ViewModel/Cart/cart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final duplicateController = Get.find<DuplicateController>();
  late CartFunctions cartFunctions = duplicateController.cartFunctions;
  CartBloc() : super(CartInitial()) {
    on<CartEvent>((event, emit) async {
      try {
        if (event is CartStart) {
          emit(CartLoading());
          final productList = await cartFunctions.getProductFromHive();
          final String totalPrice =
              cartFunctions.calculateTotalPrice(productList: productList);
              emit(CartLoading());
          if (productList.isNotEmpty) {
            emit(CartSuccess(productList: productList, totalPrice: totalPrice));
          } else {
            emit(CartEmpty());
          }
        }
      } catch (e) {
        emit(CartError());
      }
    });
  }
}
