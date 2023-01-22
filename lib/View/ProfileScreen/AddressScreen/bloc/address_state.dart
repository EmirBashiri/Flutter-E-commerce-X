part of 'address_bloc.dart';

@immutable
abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressDefaultScreen extends AddressState {
  final List<AddressEntity> addressList;
  final List<DropdownMenuItem> countryItemList;
  AddressDefaultScreen(
      {required this.addressList, required this.countryItemList});
}

class AddressLoading extends AddressState {}

class AddressError extends AddressState {}

class AddressEmpty extends AddressState {
  final List<DropdownMenuItem> countryList;

  AddressEmpty(this.countryList);
}

class AddressEditedSuccessfully extends AddressState {}
