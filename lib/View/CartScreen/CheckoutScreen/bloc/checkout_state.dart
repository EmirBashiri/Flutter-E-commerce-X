part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutInitialScreen extends CheckoutState {
  final List<DropdownMenuItem> addressList;
  final DuplicateController duplicateController;
  final ProfileController profileController;

  CheckoutInitialScreen(
      {required this.duplicateController,
      required this.profileController,
      required this.addressList});
}

class CheckoutGetAddreesScreen extends CheckoutState {
  final List<DropdownMenuItem> popupMenuItemList;
  final CustomColors colors;
  final CustomTextStyle textStyle;
  final UiDuplicate uiDuplicate;
  CheckoutGetAddreesScreen(
      {required this.popupMenuItemList,
      required this.colors,
      required this.uiDuplicate,
      required this.textStyle});
}
