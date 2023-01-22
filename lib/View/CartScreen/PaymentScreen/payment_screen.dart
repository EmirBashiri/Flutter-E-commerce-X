import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/OrderEntity/order_entity.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/RootScreen/root.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen(
      {super.key,
      required this.totalPrice,
      required this.productList,
      required this.addressDetail});
  final String totalPrice;
  final List<ProductEntity> productList;
  final String addressDetail;
  @override
  Widget build(BuildContext context) {
    final duplicateController = Get.find<DuplicateController>();
    final profileController = Get.find<ProfileController>();
    final colors = duplicateController.colors;
    final textStyle = duplicateController.textStyle;
    final paymentFunctions = duplicateController.paymentFunctions;
    final DateTime dateTime = DateTime.now();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 60,
        width: Get.mediaQuery.size.width * 0.7,
        child: FloatingActionButton.extended(
            backgroundColor: colors.primary,
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      "Pay",
                      style: textStyle.bodyNormal,
                    ),
                    content: Text(
                      "Do you want pay?",
                      style: textStyle.bodyNormal,
                    ),
                    actions: [
                      CupertinoButton(
                        child: const Text("No"),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      CupertinoButton(
                        child: const Text("Yes"),
                        onPressed: () async {
                          await profileController.orderFunctions.addToOrderBox(
                              orderEntity: OrderEntity(
                                  time: dateTime,
                                  totalPrice: totalPrice,
                                  productList: productList));
                          bool isCommpleated = await duplicateController
                              .cartFunctions
                              .clearCartBox();

                          if (isCommpleated) {
                            Get.offAll(const RootScreen(
                              index: 1,
                            ));

                            snackBar(
                                title: "Pay",
                                message: "Successfully payed",
                                textStyle: textStyle,
                                colors: colors);
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            label: Text(
              "Pay",
              style: textStyle.titleLarge.copyWith(color: colors.whiteColor),
            )),
      ),
      appBar: AppBar(
        backgroundColor: colors.whiteColor,
        foregroundColor: colors.blackColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          "E-Payment",
          style: textStyle.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          physics: duplicateController.uiDuplicate.defaultScroll,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.string(
                  paymentFunctions.createBarcode(),
                ),
              ),
              duplicateContainer(
                colors: colors,
                widget: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: Get.mediaQuery.size.width * 0.8,
                      child: GridView.builder(
                        physics: duplicateController.uiDuplicate.defaultScroll,
                        itemCount: productList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 40,
                            child: CircleAvatar(
                              backgroundColor: colors.whiteColor,
                              foregroundImage: CachedNetworkImageProvider(
                                  productList[index].imageUrl),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: Get.mediaQuery.size.width * 0.48,
                            child: Row(
                              children: [
                                Text(
                                  productList[0].name.substring(0, 10),
                                  style: textStyle.bodyNormal
                                      .copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  "and more",
                                  style: textStyle.bodySmall,
                                ),
                              ],
                            )),
                        Column(
                          children: [
                            Icon(
                              CupertinoIcons.number_circle,
                              color: colors.blackColor,
                              size: 20,
                            ),
                            Text(
                              "Count : ${productList.length}",
                              style: textStyle.bodySmall
                                  .copyWith(color: colors.blackColor),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              duplicateContainer(
                  colors: colors,
                  widget: Column(
                    children: [
                      duplicateRowItem(
                          colors: colors,
                          prefix: Text(
                            "Recipient Name",
                            style: textStyle.bodyNormal,
                          ),
                          suffix: Text(
                            profileController.information.name,
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                      duplicateRowItem(
                          colors: colors,
                          prefix: Text(
                            "Address",
                            style: textStyle.bodyNormal,
                          ),
                          suffix: Text(
                            addressDetail,
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                      duplicateRowItem(
                          colors: colors,
                          prefix: Text(
                            "Payment Methods",
                            style: textStyle.bodyNormal,
                          ),
                          suffix: Text(
                            "My E-Wallet",
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                      duplicateRowItem(
                          colors: colors,
                          prefix: Text(
                            "Date",
                            style: textStyle.bodyNormal,
                          ),
                          suffix: Text(
                            dateTime.toString().substring(0, 16),
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                      duplicateRowItem(
                          colors: colors,
                          prefix: Text(
                            "Total",
                            style: textStyle.bodyNormal,
                          ),
                          suffix: Text(
                            "€$totalPrice",
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget duplicateContainer(
      {required Widget widget, required CustomColors colors}) {
    return Container(
        width: Get.mediaQuery.size.width,
        margin: const EdgeInsets.only(top: 25, bottom: 25),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colors.gray,
          borderRadius: BorderRadius.circular(15),
        ),
        child: widget);
  }

  Widget duplicateRowItem(
      {required Widget prefix,
      required Widget suffix,
      required CustomColors colors}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [prefix, suffix],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 0.5,
          height: 1,
          color: colors.captionColor,
        )
      ],
    );
  }
}
