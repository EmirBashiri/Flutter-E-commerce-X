import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Constant/const.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/AddressEntity/address_entity.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/AddressScreen/bloc/address_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  AddressBloc? addressBloc;
  StreamSubscription? subscription;

  @override
  void dispose() {
    addressBloc?.close();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duplicateController = Get.find<DuplicateController>();
    final colors = duplicateController.colors;
    final textStyle = duplicateController.textStyle;
    return BlocProvider(
      create: (context) {
        final bloc = AddressBloc();
        addressBloc = bloc;
        bloc.add(AddressStart());
        subscription = bloc.stream.listen((state) {
          if (state is AddressEditedSuccessfully) {
            snackBar(
                title: "Address",
                message: "Your address edited successfully",
                textStyle: textStyle,
                colors: colors);
          }
        });
        return bloc;
      },
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          final adNameController = TextEditingController();
          final stateController = TextEditingController();
          final postalController = TextEditingController();
          final searchController = TextEditingController();
          final addressController = TextEditingController();
          final GlobalKey<FormState> adNameKey = GlobalKey();
          final GlobalKey<FormState> addressKey = GlobalKey();
          final GlobalKey<FormState> postalKey = GlobalKey();
          final GlobalKey<FormState> stateKey = GlobalKey();
          String country = "";
          final defaultPhysics = duplicateController.uiDuplicate.defaultScroll;
          Widget dropDown({required List<DropdownMenuItem> countryList}) {
            return DropdownButtonFormField2(
                buttonWidth: Get.size.width * 0.9,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                isDense: true,
                hint: Text(
                  "select country",
                  style: textStyle.bodyNormal,
                ),
                validator: (value) {
                  if (value == null) {
                    return "please select country";
                  } else {
                    return null;
                  }
                },
                dropdownMaxHeight: Get.size.height * 0.4,
                dropdownDecoration: dropDownDecoration(),
                onChanged: (value) {
                  country = value;
                },
                searchController: searchController,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(hintText: "search here"),
                  ),
                ),
                items: countryList);
          }

          if (state is AddressDefaultScreen) {
            return DuplicateTemplate(
              colors: colors,
              textStyle: textStyle,
              title: "My Address",
              child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: SizedBox(
                  height: 60,
                  width: Get.size.width * 0.5,
                  child: FloatingActionButton.extended(
                      backgroundColor: colors.primary,
                      onPressed: () {
                        addAddressBottomSheet(
                            scrollPhysics: defaultPhysics,
                            textStyle: textStyle,
                            colors: colors,
                            osSaveClicked: () {
                              if (adNameKey.currentState!.validate() &&
                                  addressKey.currentState!.validate() &&
                                  stateKey.currentState!.validate() &&
                                  postalKey.currentState!.validate()) {
                                if (country.isNotEmpty) {
                                  Get.back();
                                  addressBloc!.add(AddressAddNew(AddressEntity(
                                      addressDetail: addressController.text,
                                      addressName: adNameController.text,
                                      state: stateController.text,
                                      postalCode:
                                          int.parse(postalController.text),
                                      country: country)));
                                } else {
                                  snackBar(
                                      title: "Country",
                                      message: "Please select your country",
                                      textStyle: textStyle,
                                      colors: colors);
                                }
                              }
                            },
                            adNameController: adNameController,
                            adNameKey: adNameKey,
                            stateController: stateController,
                            stateKey: stateKey,
                            addressController: addressController,
                            addressKey: addressKey,
                            postalController: postalController,
                            postalKey: postalKey,
                            dropDown:
                                dropDown(countryList: state.countryItemList));
                      },
                      label: AutoSizeText(
                        "Add new address",
                        style: textStyle.bodyNormal
                            .copyWith(color: colors.whiteColor),
                        maxLines: 2,
                      )),
                ),
                body: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  physics: duplicateController.uiDuplicate.defaultScroll,
                  itemCount: state.addressList.length,
                  itemBuilder: (context, index) {
                    final address = state.addressList[index];

                    return Container(
                      decoration: BoxDecoration(
                          color: colors.gray,
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircleAvatar(
                              backgroundColor: colors.whiteColor,
                              child: LottieBuilder.network(locationLottie),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: Get.size.width * 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.addressName,
                                  style: textStyle.titleLarge,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                AutoSizeText(
                                  address.addressDetail,
                                  maxLines: 2,
                                  style: textStyle.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                CupertinoButton(
                                  child: Icon(
                                    CupertinoIcons.delete,
                                    color: colors.blackColor,
                                  ),
                                  onPressed: () {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text(
                                            "Remove address",
                                            style: textStyle.titleLarge,
                                          ),
                                          content: Text(
                                            "Are you sure to remove address",
                                            style: textStyle.bodyNormal,
                                          ),
                                          actions: [
                                            CupertinoButton(
                                              child: Text(
                                                "Cancel",
                                                style: textStyle.bodyNormal,
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                            CupertinoButton(
                                              child: Text(
                                                "Yes",
                                                style: textStyle.bodyNormal
                                                    .copyWith(
                                                        color: colors.red),
                                              ),
                                              onPressed: () {
                                                Get.back();
                                                addressBloc!.add(AddressRemove(
                                                    address.postalCode));
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                addressEditButton(
                                    callback: () {
                                      adNameController.text =
                                          address.addressName;
                                      addressController.text =
                                          address.addressDetail;
                                      postalController.text =
                                          address.postalCode.toString();
                                      stateController.text = address.state;

                                      addAddressBottomSheet(
                                        scrollPhysics: defaultPhysics,
                                        textStyle: textStyle,
                                        colors: colors,
                                        osSaveClicked: () {
                                          if (adNameKey.currentState!
                                                  .validate() &&
                                              addressKey.currentState!
                                                  .validate() &&
                                              stateKey.currentState!
                                                  .validate() &&
                                              postalKey.currentState!
                                                  .validate()) {
                                            if (country.isNotEmpty) {
                                              Get.back();
                                              addressBloc!.add(AddressEdit(
                                                  addressEntity: AddressEntity(
                                                      addressDetail:
                                                          addressController
                                                              .text,
                                                      addressName:
                                                          adNameController.text,
                                                      state:
                                                          stateController.text,
                                                      postalCode: int.parse(
                                                          postalController
                                                              .text),
                                                      country: country),
                                                  postalCode:
                                                      address.postalCode));
                                            } else {
                                              snackBar(
                                                  title: "Country",
                                                  message:
                                                      "Please select your country",
                                                  textStyle: textStyle,
                                                  colors: colors);
                                            }
                                          }
                                        },
                                        adNameController: adNameController,
                                        adNameKey: adNameKey,
                                        stateController: stateController,
                                        stateKey: stateKey,
                                        addressController: addressController,
                                        addressKey: addressKey,
                                        postalController: postalController,
                                        postalKey: postalKey,
                                        dropDown: dropDown(
                                            countryList: state.countryItemList),
                                      );
                                    },
                                    colors: colors,
                                    textStyle: textStyle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state is AddressLoading) {
            return const CustomLoading();
          } else if (state is AddressError) {
            return AppException(
              callback: () {
                addressBloc!.add(AddressStart());
              },
            );
          } else if (state is AddressEmpty) {
            return DuplicateTemplate(
              colors: colors,
              textStyle: textStyle,
              title: "My Address",
              child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: SizedBox(
                  height: 60,
                  width: Get.size.width * 0.5,
                  child: FloatingActionButton.extended(
                      backgroundColor: colors.primary,
                      onPressed: () {
                        addAddressBottomSheet(
                            scrollPhysics: defaultPhysics,
                            textStyle: textStyle,
                            colors: colors,
                            osSaveClicked: () {
                              if (adNameKey.currentState!.validate() &&
                                  addressKey.currentState!.validate() &&
                                  stateKey.currentState!.validate() &&
                                  postalKey.currentState!.validate()) {
                                if (country.isNotEmpty) {
                                  Get.back();
                                  addressBloc!.add(AddressAddNew(AddressEntity(
                                      addressDetail: addressController.text,
                                      addressName: adNameController.text,
                                      state: stateController.text,
                                      postalCode:
                                          int.parse(postalController.text),
                                      country: country)));
                                } else {
                                  snackBar(
                                      title: "Country",
                                      message: "Please select your country",
                                      textStyle: textStyle,
                                      colors: colors);
                                }
                              }
                            },
                            adNameController: adNameController,
                            adNameKey: adNameKey,
                            stateController: stateController,
                            stateKey: stateKey,
                            addressController: addressController,
                            addressKey: addressKey,
                            postalController: postalController,
                            postalKey: postalKey,
                            dropDown: dropDown(countryList: state.countryList));
                      },
                      label: AutoSizeText(
                        "Add new address",
                        style: textStyle.bodyNormal
                            .copyWith(color: colors.whiteColor),
                        maxLines: 2,
                      )),
                ),
                body: Column(
                  children: [
                    LottieBuilder.network(
                      emptyListLottie,
                      width: Get.size.width * 0.8,
                      height: Get.size.height * 0.6,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                      child: AutoSizeText(
                        "your address list is empty try to add new one",
                        style: textStyle.bodyNormal
                            .copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
