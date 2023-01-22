part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartError extends CartState {
}

class CartEmpty extends CartState {}

class CartSuccess extends CartState {
  final List<ProductEntity> productList;
  final String totalPrice;
  CartSuccess({required this.productList,required this.totalPrice});
}
