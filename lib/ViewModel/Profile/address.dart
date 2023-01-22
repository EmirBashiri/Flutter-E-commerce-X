import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/AddressEntity/address_entity.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:hive_flutter/adapters.dart';

class AddressFunctions {
  final String addressBox = "Address Box";
  final ValueNotifier<bool> valueNotifier = ValueNotifier(false);
  final List<String> countriesList = [
    "United States",
    "Canada",
    "Afghanistan",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Belgium",
    "Brazil",
    "Cayman Islands",
    "Finland",
    "France",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Iran (Islamic Republic of)",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Ivory Coast",
    "Japan",
    "Poland",
    "Spain",
    "Portugal",
    "Qatar",
    "Ukraine",
    "Germany",
    "Uruguay",
    "United Arab Emirates",
    "United Kingdom",
    "United States minor outlying islands",
  ];

  Future<void> openAddressBox() async {
    bool isBoxOpen = Hive.isBoxOpen(addressBox);
    if (!isBoxOpen) {
      await Hive.openBox<AddressEntity>(addressBox);
    }
  }

  Future<void> addToAddressBox({required AddressEntity addressEntity}) async {
    await openAddressBox();
    final box = Hive.box<AddressEntity>(addressBox);
    await box.put(addressEntity.postalCode, addressEntity);
    valueNotifier.value = !valueNotifier.value;
    await box.close();
  }

  Future<List<AddressEntity>> getAddressList() async {
    await openAddressBox();
    final box = Hive.box<AddressEntity>(addressBox);
    final List<AddressEntity> addressList = [];
    for (var element in (box.values.toList())) {
      addressList.add(element);
    }
    await box.close();
    return addressList;
  }

  Future<bool> removeAddress({required int postalCode}) async {
    await openAddressBox();
    final box = Hive.box<AddressEntity>(addressBox);
    await box.delete(postalCode);
    valueNotifier.value = !valueNotifier.value;
    await box.close();

    return true;
  }

  Future<List<DropdownMenuItem>> countryMenuList({
    required CustomTextStyle textStyle,
  }) async {
    List<DropdownMenuItem> popupMenuList = [];
    for (var element in countriesList) {
      popupMenuList.add(
        DropdownMenuItem(
          value: element,
          child: Text(
            element,
            style: textStyle.bodyNormal,
          ),
        ),
      );
    }
    return popupMenuList;
  }

  Future<List<DropdownMenuItem>> addressItemList(
      {required CustomTextStyle textStyle}) async {
    final List<AddressEntity> addressList = await getAddressList();
    final List<DropdownMenuItem> popupMenuList = [];
    for (var element in addressList) {
      popupMenuList.add(
        DropdownMenuItem(
         
          value: element.addressDetail,
          child: Text(
            element.addressName,
            style: textStyle.bodyNormal,
          ),
        ),
          
          );
    }
    return popupMenuList;
  }

  Future<bool> editAddress(
      {required AddressEntity addressEntity, required int postalCode}) async {
    await openAddressBox();
    final box = Hive.box<AddressEntity>(addressBox);
    await box.delete(postalCode);
    await box.put(addressEntity.postalCode, addressEntity);
    valueNotifier.value = !valueNotifier.value;
    await box.close();
    return true;
  }
}
