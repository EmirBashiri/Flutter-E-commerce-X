import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Constant/const.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/entities.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/View/HomeScreen/HomeDetailScreen/detail_screen.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/AuthenticationScreen/authentication_screen.dart';
import 'package:flutter_application_ecommerce/ViewModel/Profile/profile.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class AppException extends StatelessWidget {
  const AppException({super.key, this.callback, this.errorMessage});
  final GestureTapCallback? callback;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DuplicateController>();
    final textStyle = controller.textStyle;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorMessage == null
                ? Text(
                    "Undefined Error",
                    style: textStyle.titleLarge,
                  )
                : Text(
                    errorMessage!,
                    style: textStyle.titleLarge,
                  ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: callback,
                child: Text(
                  "try Again",
                  style: textStyle.bodyNormal,
                ))
          ],
        ),
      ),
    );
  }
}

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomColors colors = CustomColors();
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
            color: colors.primary, size: 50),
      ),
    );
  }
}

Widget imageLoading() {
  final controller = Get.find<DuplicateController>();
  final colors = controller.colors;
  return LoadingAnimationWidget.halfTriangleDot(
      color: colors.primary, size: 20);
}

Widget networkImage({required String imageUrl, double? width, double? height}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    width: width,
    height: height,
    placeholder: (context, url) {
      return imageLoading();
    },
  );
}

class HomeProductView extends StatelessWidget {
  const HomeProductView(
      {Key? key,
      required this.product,
      required this.textStyle,
      required this.colors,
      required this.profileFunctions})
      : super(key: key);

  final ProductEntity product;
  final CustomTextStyle textStyle;
  final CustomColors colors;
  final ProfileFunctions profileFunctions;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: profileFunctions.favoriteListenable(),
      builder: (context, value, child) {
        return InkWell(
          onTap: () {
            Get.to(DetailScreen(productEntity: product));
          },
          child: Badge(
            position: const BadgePosition(end: 0, top: 0),
            badgeColor: colors.blackColor,
            badgeContent: FavoriteBadge(
              product: product,
              badgeBackgroundColor: colors.blackColor,
              activeColor: colors.whiteColor,
              inActive: colors.whiteColor,
            ),
            child: Column(
              children: [
                SizedBox(
                    width: 100,
                    height: 100,
                    child: networkImage(imageUrl: product.imageUrl)),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  product.name.split("Maybelline").last.substring(0, 7),
                  style: textStyle.bodyNormal,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "€${product.price}",
                  style: textStyle.bodyNormal,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class FavoriteBadge extends StatefulWidget {
  const FavoriteBadge(
      {super.key,
      required this.product,
      required this.badgeBackgroundColor,
      required this.activeColor,
      required this.inActive});
  final ProductEntity product;
  final Color badgeBackgroundColor;
  final Color activeColor;
  final Color inActive;
  @override
  State<FavoriteBadge> createState() => _FavoriteBadgeState();
}

class _FavoriteBadgeState extends State<FavoriteBadge> {
  @override
  Widget build(BuildContext context) {
    final profileFunctions = Get.find<ProfileController>().profileFunctions;
    final isInBox =
        profileFunctions.isInFavoriteBox(productEntity: widget.product);
    return SizedBox(
      width: 20,
      height: 20,
      child: CircleAvatar(
        backgroundColor: widget.badgeBackgroundColor,
        child: GestureDetector(
          onTap: () async {
            if (isInBox) {
              profileFunctions.removeFavorite(productEntity: widget.product);
              setState(() {});
            } else {
              await profileFunctions.addToFavorite(
                  productEntity: widget.product);
              setState(() {});
            }
          },
          child: isInBox
              ? Icon(
                  CupertinoIcons.heart_fill,
                  size: 20,
                  color: widget.activeColor,
                )
              : Icon(
                  CupertinoIcons.heart,
                  color: widget.inActive,
                  size: 20,
                ),
        ),
      ),
    );
  }
}

class ShopProductView extends StatelessWidget {
  const ShopProductView({
    Key? key,
    required this.product,
    required this.textStyle,
    required this.colors,
  }) : super(key: key);

  final ProductEntity product;
  final CustomTextStyle textStyle;
  final CustomColors colors;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Get.to(DetailScreen(productEntity: product));
      },
      child: Badge(
        badgeColor: colors.whiteColor,
        position: const BadgePosition(top: 0, end: 0),
        badgeContent: FavoriteBadge(
          product: product,
          badgeBackgroundColor: colors.whiteColor,
          activeColor: colors.blackColor,
          inActive: colors.blackColor,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: networkImage(imageUrl: product.imageUrl))),
            const SizedBox(
              height: 5,
            ),
            Text(
              product.name.split("Maybelline").last.substring(0, 7),
              style: textStyle.bodyNormal.copyWith(color: colors.whiteColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "€${product.price}",
              style: textStyle.bodyNormal.copyWith(color: colors.whiteColor),
            )
          ],
        ),
      ),
    );
  }
}

class CartLengthBadge extends StatelessWidget {
  const CartLengthBadge({
    Key? key,
    required this.duplicateController,
    required this.colors,
    required this.textStyle,
    required this.badgeCallback,
  }) : super(key: key);

  final DuplicateController duplicateController;
  final CustomColors colors;
  final CustomTextStyle textStyle;
  final GestureTapCallback badgeCallback;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: duplicateController.cartBoxListenable,
      builder: (context, value, child) {
        return Badge(
          badgeColor: colors.primary,
          position: const BadgePosition(bottom: 5, end: 10),
          badgeContent: Container(
            alignment: Alignment.center,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: colors.primary),
            child: Text(
              value.values.length.toString(),
              style: textStyle.bodySmall.copyWith(color: colors.whiteColor),
            ),
          ),
          child: CupertinoButton(
            onPressed: badgeCallback,
            child: Icon(
              CupertinoIcons.bag,
              color: colors.blackColor,
            ),
          ),
        );
      },
    );
  }
}

class HorizontalProductView extends StatelessWidget {
  const HorizontalProductView({
    Key? key,
    required this.colors,
    required this.product,
    required this.textStyle,
    required this.widget,
    required this.margin,
  }) : super(key: key);

  final CustomColors colors;
  final ProductEntity product;
  final CustomTextStyle textStyle;
  final Widget widget;
  final EdgeInsetsGeometry margin;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(DetailScreen(productEntity: product));
      },
      child: Container(
        margin: margin,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: colors.blackColor, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: networkImage(imageUrl: product.imageUrl))),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.mediaQuery.size.width * 0.57,
                  child: Text(
                    product.name,
                    style: textStyle.bodyNormal.copyWith(
                        fontWeight: FontWeight.bold, color: colors.whiteColor),
                    overflow: TextOverflow.clip,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: Get.mediaQuery.size.width * 0.55,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            product.productType,
                            style: textStyle.bodyNormal
                                .copyWith(color: colors.whiteColor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "€${product.price}",
                            style: textStyle.bodyNormal.copyWith(
                                color: colors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      widget
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartBottomItem extends StatelessWidget {
  const CartBottomItem({
    Key? key,
    required this.colors,
    required this.textStyle,
    this.widget,
    required this.callback,
    required this.navigateName,
  }) : super(key: key);

  final CustomColors colors;
  final CustomTextStyle textStyle;
  final GestureTapCallback callback;
  final Widget? widget;
  final String navigateName;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: Container(
          width: Get.mediaQuery.size.width,
          height: 100,
          decoration: BoxDecoration(
              color: colors.gray,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15))),
          padding:
              const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget != null ? widget! : Container(),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(colors.blackColor)),
                        onPressed: callback,
                        child: Text(
                          navigateName,
                          style: textStyle.bodyNormal
                              .copyWith(color: colors.whiteColor),
                        )),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

Widget duplicateContainer(
    {required CustomColors colors, required Widget child}) {
  return Container(
    width: Get.mediaQuery.size.width,
    margin: const EdgeInsets.only(top: 30),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        color: colors.whiteColor),
    child: child,
  );
}

void snackBar(
    {required String title,
    required String message,
    required CustomTextStyle textStyle,
    required CustomColors colors}) {
  Get.snackbar(title, "",
      messageText: AutoSizeText(
        message,
        style: textStyle.bodyNormal,
        maxLines: 1,
      ),
      backgroundColor: colors.gray);
}

class ProductListView extends StatelessWidget {
  const ProductListView(
      {super.key,
      required this.colors,
      required this.textStyle,
      required this.productList,
      required this.title,
      required this.physics,
      required this.reverse,
      required this.callback,
      required this.profileFunctions});
  final CustomColors colors;
  final CustomTextStyle textStyle;
  final List<ProductEntity> productList;
  final String title;
  final ScrollPhysics physics;
  final bool reverse;
  final GestureTapCallback callback;
  final ProfileFunctions profileFunctions;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textStyle.titleLarge.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),
              CupertinoButton(
                onPressed: callback,
                child: Row(
                  children: [
                    Text(
                      "See all",
                      style:
                          textStyle.bodyNormal.copyWith(color: colors.primary),
                    ),
                    Icon(
                      Icons.keyboard_double_arrow_right,
                      color: colors.primary,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              reverse: reverse,
              physics: physics,
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: HomeProductView(
                    profileFunctions: profileFunctions,
                    product: product,
                    textStyle: textStyle,
                    colors: colors,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class BannerListView extends StatelessWidget {
  const BannerListView(
      {super.key,
      required this.produtList,
      required this.colors,
      required this.textStyle,
      required this.callback});
  final List<ProductEntity> produtList;
  final CustomColors colors;
  final CustomTextStyle textStyle;
  final GestureTapCallback callback;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Top deals",
                style: textStyle.titleLarge
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              CupertinoButton(
                onPressed: callback,
                child: Row(
                  children: [
                    Text(
                      "See all",
                      style:
                          textStyle.bodyNormal.copyWith(color: colors.primary),
                    ),
                    Icon(
                      Icons.keyboard_double_arrow_right,
                      color: colors.primary,
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          CarouselSlider.builder(
              itemCount: produtList.length - 20,
              itemBuilder: (context, index, realIndex) {
                return networkImage(
                  imageUrl: produtList[index].imageUrl,
                );
              },
              options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayCurve: Curves.easeInCubic,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ))
        ],
      ),
    );
  }
}

class ProductGrideView extends StatelessWidget {
  const ProductGrideView({
    Key? key,
    required this.productList,
    required this.uiDuplicate,
    required this.colors,
    required this.textStyle,
  }) : super(key: key);

  final List<ProductEntity> productList;
  final UiDuplicate uiDuplicate;
  final CustomColors colors;
  final CustomTextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.mediaQuery.size.width,
      height: Get.mediaQuery.size.height,
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: productList.length,
        physics: uiDuplicate.defaultScroll,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colors.captionColor,
                borderRadius: BorderRadius.circular(15)),
            child: ShopProductView(
              product: productList[index],
              textStyle: textStyle,
              colors: colors,
            ),
          );
        },
      ),
    );
  }
}

Widget gridViewScreensContainer(
    {required Widget child, required CustomColors colors}) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.only(top: 30),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15))),
    child: child,
  );
}

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    Key? key,
    required this.colors,
    required this.textStyle,
    required this.title,
    required this.content,
    required this.lottieName,
  }) : super(key: key);

  final CustomColors colors;
  final CustomTextStyle textStyle;
  final String title;
  final String content;
  final String lottieName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.blackColor,
      appBar: AppBar(
        backgroundColor: colors.blackColor,
        centerTitle: true,
        title: Text(
          title,
          style: textStyle.titleLarge.copyWith(color: colors.whiteColor),
        ),
      ),
      body: duplicateContainer(
          colors: colors,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.network(
                lottieName,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Get.mediaQuery.size.width * 0.6,
                child: Center(
                  child: Text(
                    content,
                    style: textStyle.bodyNormal
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class DuplicateTemplate extends StatelessWidget {
  const DuplicateTemplate({
    Key? key,
    required this.colors,
    required this.textStyle,
    required this.child,
    required this.title,
  }) : super(key: key);

  final CustomColors colors;
  final CustomTextStyle textStyle;
  final Widget child;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: colors.whiteColor,
        backgroundColor: colors.blackColor,
        centerTitle: true,
        title: Text(
          title,
          style: textStyle.titleLarge.copyWith(color: colors.whiteColor),
        ),
      ),
      body: Container(
        color: colors.blackColor,
        child: duplicateContainer(colors: colors, child: child),
      ),
    );
  }
}

Widget textField(
    {required CustomTextStyle textStyle,
    required TextEditingController controller,
    required GlobalKey<FormState> formKey,
    required String lable,
    required CustomColors colors,
    required EdgeInsetsGeometry edgeInsetsGeometry,
    TextInputType inputType = TextInputType.emailAddress,
    bool obscureText = false,Widget? suffix}) {
  return Padding(
      padding: edgeInsetsGeometry,
      child: Theme(
        data: ThemeData(
            colorScheme: ColorScheme.light(
                primary: colors.captionColor, onSurface: colors.captionColor)),
        child: Form(
          key: formKey,
          child: TextFormField(
              obscureText: obscureText,
              keyboardType: inputType,
              validator: (value) {
                if (value!.isEmpty) {
                  return "this item required";
                } else if (value.length < 4) {
                  return "item less than 4 characters ";
                } else {
                  return null;
                }
              },
              controller: controller,
              cursorColor: colors.captionColor,
              focusNode: FocusNode(),
              decoration: InputDecoration(
                  labelText: lable,
                  labelStyle: textStyle.bodyNormal,
                  suffix: suffix,
                  floatingLabelStyle:
                      textStyle.bodySmall.copyWith(fontWeight: FontWeight.w700),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)))),
        ),
      ));
}

Widget addressEditButton(
    {required GestureTapCallback callback,
    required CustomColors colors,
    required CustomTextStyle textStyle}) {
  return CupertinoButton(
      onPressed: callback,
      child: Icon(
        CupertinoIcons.pencil,
        color: colors.blackColor,
        size: 24,
      ));
}

void addAddressBottomSheet(
    {required CustomTextStyle textStyle,
    required CustomColors colors,
    required ScrollPhysics scrollPhysics,
    required GestureTapCallback osSaveClicked,
    required TextEditingController adNameController,
    required GlobalKey<FormState> adNameKey,
    required TextEditingController stateController,
    required GlobalKey<FormState> stateKey,
    required TextEditingController addressController,
    required GlobalKey<FormState> addressKey,
    required TextEditingController postalController,
    required GlobalKey<FormState> postalKey,
    required Widget dropDown}) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    context: Get.context!,
    builder: (context) {
      return Container(
        height: Get.size.height * 0.8,
        padding: const EdgeInsets.fromLTRB(15, 4, 15, 15),
        decoration: BoxDecoration(
            color: colors.whiteColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(15))),
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
              width: Get.size.width * 0.5,
              child: FloatingActionButton.extended(
                  backgroundColor: colors.primary,
                  onPressed: osSaveClicked,
                  label: Text(
                    "Save",
                    style:
                        textStyle.bodyNormal.copyWith(color: colors.whiteColor),
                  ))),
          body: SingleChildScrollView(
            physics: scrollPhysics,
            child: Column(
              children: [
                CupertinoButton(
                  child: Container(
                    width: 40,
                    height: 7,
                    decoration: BoxDecoration(
                        color: colors.captionColor,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: Get.size.height * 0.6,
                  child: SingleChildScrollView(
                    physics: scrollPhysics,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        dropDown,
                        textField(
                            inputType: TextInputType.streetAddress,
                            textStyle: textStyle,
                            controller: stateController,
                            formKey: stateKey,
                            lable: "State",
                            colors: colors,
                            edgeInsetsGeometry: const EdgeInsets.all(12)),
                        textField(
                            inputType: TextInputType.streetAddress,
                            textStyle: textStyle,
                            controller: addressController,
                            formKey: addressKey,
                            lable: "Address detail",
                            colors: colors,
                            edgeInsetsGeometry: const EdgeInsets.all(12)),
                        textField(
                            inputType: TextInputType.streetAddress,
                            textStyle: textStyle,
                            controller: adNameController,
                            formKey: adNameKey,
                            lable: "Address name",
                            colors: colors,
                            edgeInsetsGeometry: const EdgeInsets.all(12)),
                        textField(
                            textStyle: textStyle,
                            controller: postalController,
                            formKey: postalKey,
                            lable: "Postal code",
                            colors: colors,
                            edgeInsetsGeometry: const EdgeInsets.all(12),
                            inputType: TextInputType.number),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

BoxDecoration dropDownDecoration() {
  return BoxDecoration(borderRadius: BorderRadius.circular(15));
}

void loginRequiredDialog({required CustomTextStyle textStyle}) {
  showCupertinoDialog(
      context: Get.context!,
      builder: (context) => CupertinoAlertDialog(
            title: Text(
              "Login",
              style: textStyle.titleLarge,
            ),
            content: Column(
              children: [
                LottieBuilder.network(
                  loginLottie,
                  width: 200,
                  height: 200,
                ),
                Text(
                  "To continue to payment please login",
                  style: textStyle.bodyNormal,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.start,
                ),
              ],
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
                  onPressed: () {
                    Get.back();
                    Get.to(const AuthenticationScreen());
                  },
                  child: Text(
                    "Login",
                    style: textStyle.bodyNormal,
                  )),
            ],
          ));
}
