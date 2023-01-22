import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Constant/const.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/AddressEntity/address_entity.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/CartScreen/CheckoutScreen/bloc/checkout_bloc.dart';
import 'package:flutter_application_ecommerce/View/CartScreen/PaymentScreen/payment_screen.dart';
import 'package:flutter_application_ecommerce/View/CartScreen/cart_screen.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/AddressScreen/address_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CheckoutScreen extends StatefulWidget {
  final List<ProductEntity> productList;
  final String totalPrice;
  const CheckoutScreen(
      {super.key, required this.productList, required this.totalPrice});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CheckoutBloc? checkoutBloc;
  StreamSubscription? subscription;

  @override
  void dispose() {
    checkoutBloc?.close();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CheckoutBloc();
        checkoutBloc = bloc;
        bloc.add(CheckoutStart());
        subscription = bloc.stream.listen((state) {
          if (state is CheckoutGetAddreesScreen) {
            final colors = state.colors;
            final adNameController = TextEditingController();
            final GlobalKey<FormState> adNameKey = GlobalKey();
            final addressController = TextEditingController();
            final GlobalKey<FormState> addressKey = GlobalKey();
            final stateController = TextEditingController();
            final postalController = TextEditingController();
            final GlobalKey<FormState> postalKey = GlobalKey();
            final GlobalKey<FormState> stateKey = GlobalKey();
            final TextEditingController searchController =
                TextEditingController();
            String country = "";
            addAddressBottomSheet(
              textStyle: state.textStyle,
              colors: colors,
              scrollPhysics: state.uiDuplicate.defaultScroll,
              osSaveClicked: () {
                if (stateKey.currentState!.validate() &&
                    addressKey.currentState!.validate() &&
                    adNameKey.currentState!.validate() &&
                    postalKey.currentState!.validate()) {
                  if (country.isNotEmpty) {
                    Get.back();
                    checkoutBloc!.add(CheckoutSaveAddress(AddressEntity(
                        addressDetail: addressController.text,
                        country: country,
                        state: stateController.text,
                        addressName: adNameController.text,
                        postalCode: int.parse(postalController.text))));
                  } else {
                    snackBar(
                        title: "Country",
                        message: "Please slecet you're country",
                        textStyle: state.textStyle,
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
              dropDown: DropdownButtonFormField2(
                  buttonWidth: Get.size.width * 0.9,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  isDense: true,
                  hint: Text(
                    "select country",
                    style: state.textStyle.bodyNormal,
                  ),
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
                      decoration:
                          const InputDecoration(hintText: "search here"),
                    ),
                  ),
                  items: state.popupMenuItemList),
            );
          }
        });
        return bloc;
      },
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          if (state is CheckoutInitialScreen) {
            final addresList = state.addressList;
            final duplicateController = state.duplicateController;
            final profileController = state.profileController;
            final CustomColors colors = duplicateController.colors;
            final CustomTextStyle textStyle = duplicateController.textStyle;
            String addressDetail = "";
            return Scaffold(
              appBar: AppBar(
                foregroundColor: colors.blackColor,
                backgroundColor: colors.whiteColor,
                centerTitle: true,
                title: Text(
                  "Checkout",
                  style: textStyle.titleLarge,
                ),
                actions: [
                  CartLengthBadge(
                    duplicateController: duplicateController,
                    colors: colors,
                    textStyle: textStyle,
                    badgeCallback: () {
                      Get.to(const CartScreen());
                    },
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shipping Address",
                            style: textStyle.titleLarge,
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(top: 25, bottom: 15),
                            width: Get.mediaQuery.size.width,
                            decoration: BoxDecoration(
                                color: colors.gray,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                LottieBuilder.network(
                                  locationLottie,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.centerLeft,
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "your address",
                                        style: textStyle.bodyNormal.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      addresList.isNotEmpty
                                          ? SizedBox(
                                              width: Get.width * 0.45,
                                              height: 50,
                                              child: DropdownButtonFormField2(
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Select an address",
                                                    hintStyle:
                                                        textStyle.bodySmall),
                                                dropdownDecoration:
                                                    dropDownDecoration(),
                                                isExpanded: true,
                                                dropdownWidth: Get.width * 0.6,
                                                items: addresList,
                                                onChanged: (value) {
                                                  addressDetail = value;
                                                },
                                              ),
                                            )
                                          : Text(
                                              "you don't have any address",
                                              style: textStyle.bodySmall,
                                            ),
                                    ],
                                  ),
                                ),
                                addressEditButton(
                                    callback: () {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text(
                                              "Address",
                                              style: textStyle.bodyNormal,
                                            ),
                                            content: const Text(""),
                                            actions: [
                                              CupertinoButton(
                                                child: const Text(
                                                  "Edit address",
                                                ),
                                                onPressed: () {
                                                  Get.until(
                                                      (route) => route.isFirst);
                                                  Get.to(const AddressScreen(),
                                                      curve: Curves
                                                          .easeInToLinear);
                                                },
                                              ),
                                              CupertinoButton(
                                                child: const Text(
                                                  "Add new address",
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                  checkoutBloc!.add(
                                                      CheckoutGetUserAddress());
                                                },
                                              ),
                                              CupertinoButton(
                                                child: const Text(
                                                  "Cancel",
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    colors: colors,
                                    textStyle: textStyle)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 15),
                            child: Divider(
                              color: colors.captionColor,
                              thickness: 1,
                            ),
                          ),
                          Text(
                            "Order List",
                            style: textStyle.titleLarge,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            physics:
                                duplicateController.uiDuplicate.defaultScroll,
                            itemCount: widget.productList.length,
                            itemBuilder: (context, index) {
                              final product = widget.productList[index];
                              return HorizontalProductView(
                                  colors: colors,
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  product: product,
                                  textStyle: textStyle,
                                  widget: Icon(
                                    CupertinoIcons.shopping_cart,
                                    color: colors.whiteColor,
                                  ));
                            },
                          ))
                        ],
                      ),
                    ),
                  ),
                  CartBottomItem(
                    colors: colors,
                    navigateName: "Continue to Payment",
                    textStyle: textStyle,
                    callback: () {
                      final isLogin = profileController.islogin;
                      if (isLogin) {
                        if (addressDetail.isNotEmpty) {
                          Get.to(PaymentScreen(
                            totalPrice: widget.totalPrice,
                            productList: widget.productList,
                            addressDetail: addressDetail,
                          ));
                        } else {
                          snackBar(
                              title: "Address required",
                              message: "please select an address",
                              textStyle: textStyle,
                              colors: colors);
                        }
                      } else {
                        loginRequiredDialog(textStyle: textStyle);
                      }
                    },
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
