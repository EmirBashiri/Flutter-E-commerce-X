part of 'order_bloc.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderInitialScreen extends OrderState {
  final DuplicateController duplicateController;
  final List<OrderEntity> orderHistoryList;
  OrderInitialScreen(
      {required this.duplicateController, required this.orderHistoryList});
}

class OrderEmpty extends OrderState {
  final DuplicateController duplicateController;

  OrderEmpty(this.duplicateController);
}
