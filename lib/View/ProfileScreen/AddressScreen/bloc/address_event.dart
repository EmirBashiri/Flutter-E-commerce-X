part of 'address_bloc.dart';

@immutable
abstract class AddressEvent {}

class AddressStart extends AddressEvent {}

class AddressRemove extends AddressEvent {
  final int postalCode;

  AddressRemove(this.postalCode);
}

class AddressEdit extends AddressEvent {
  final AddressEntity addressEntity;
  final int postalCode;
  AddressEdit({required this.addressEntity, required this.postalCode});
}

class AddressAddNew extends AddressEvent {
  final AddressEntity addressEntity;

  AddressAddNew(this.addressEntity);
}
