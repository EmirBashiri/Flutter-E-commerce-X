part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutEvent {}

class CheckoutStart extends CheckoutEvent {}

class CheckoutGetUserAddress extends CheckoutEvent {}

class CheckoutSaveAddress extends CheckoutEvent {
  final AddressEntity addressEntity;

  CheckoutSaveAddress(this.addressEntity);
}
