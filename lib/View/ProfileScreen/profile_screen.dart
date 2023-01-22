import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/AddressScreen/address_screen.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/AuthenticationScreen/authentication_screen.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/FavoriteScreen/favorite_screen.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/OrderScreen/order_screen.dart';
import 'package:flutter_application_ecommerce/ViewModel/Profile/profile.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final duplicateController = Get.find<DuplicateController>();
    final profileController = Get.find<ProfileController>();
    final ProfileFunctions profileFunctions =
        profileController.profileFunctions;
    final colors = duplicateController.colors;
    final textStyle = duplicateController.textStyle;
    return DuplicateTemplate(
        colors: colors,
        textStyle: textStyle,
        title: "Profile",
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
          child: Column(
            children: [
              Badge(
                position: BadgePosition.bottomEnd(),
                badgeColor: colors.primary,
                badgeContent: SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: InkWell(
                        onTap: () async {
                          await profileFunctions.getUserImage();
                          profileController.userSetImageInstance
                              .update((val) {});
                        },
                        child: Icon(
                          CupertinoIcons.switch_camera,
                          color: colors.whiteColor,
                          size: 20,
                        ),
                      ),
                    )),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: colors.blackColor, shape: BoxShape.circle),
                  child: profileImage(colors: colors),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Column(
                  children: [
                    profileName(
                        textStyle: textStyle,
                        profileController: profileController),
                    const SizedBox(
                      height: 10,
                    ),
                    profileEmail(
                        textStyle: textStyle,
                        profileController: profileController)
                  ],
                ),
              ),
              profileItem(
                  callback: () {
                    Get.to(const FavoriteScreen());
                  },
                  itemName: "Favorits",
                  textStyle: textStyle,
                  colors: colors),
              profileItem(
                  callback: () {
                    bool isLogin = profileController.islogin;
                    if (isLogin) {
                      Get.to(const AddressScreen());
                    } else {
                      loginRequiredDialog(textStyle: textStyle);
                    }
                  },
                  itemName: "My Address",
                  textStyle: textStyle,
                  colors: colors),
              profileItem(
                  callback: () {
                    bool isLogin = profileController.islogin;
                    if (isLogin) {
                      Get.to(const OrderScreen());
                    } else {
                      loginRequiredDialog(textStyle: textStyle);
                    }
                  },
                  itemName: "Order History",
                  textStyle: textStyle,
                  colors: colors),
              Obx(
                () => profileItem(
                    callback: () {
                      final isLogin = profileController.authenticationFunctions
                          .isUserLogin();
                      if (isLogin) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                "Log Out",
                                style: textStyle.titleLarge
                                    .copyWith(color: colors.red),
                              ),
                              content: Text(
                                "Are you sure you want log out?",
                                style: textStyle.bodyNormal,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                              ),
                              actions: [
                                CupertinoButton(
                                  child:
                                      Text("No", style: textStyle.bodyNormal),
                                  onPressed: () async {
                                    Get.back();
                                  },
                                ),
                                CupertinoButton(
                                  child: Text(
                                    "yes",
                                    style: textStyle.bodyNormal
                                        .copyWith(color: colors.red),
                                  ),
                                  onPressed: () async {
                                    await profileController
                                        .authenticationFunctions
                                        .signOut();
                                    Get.back();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Get.to(const AuthenticationScreen());
                      }
                    },
                    itemName: signStatus(profileController: profileController),
                    textStyle: textStyle,
                    colors: colors),
              ),
            ],
          ),
        ));
  }

  Widget profileImage({
    required CustomColors colors,
  }) {
    return GetX<ProfileController>(
      builder: (controller) {
        if (controller.userSetImage) {
          final File file = controller.profileFunctions.imageFile()!;
          return ClipRRect(
            borderRadius: BorderRadius.circular(49),
            child: Image.file(
              file,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return Icon(
            CupertinoIcons.person_alt_circle,
            color: colors.whiteColor,
            size: 40,
          );
        }
      },
    );
  }

  Widget profileName(
      {required CustomTextStyle textStyle,
      required ProfileController profileController}) {
    return Obx(() {
      if (profileController.islogin) {
        return Text(
          profileController.information.name,
          style: textStyle.titleLarge,
        );
      } else {
        return Text(
          "Amir Bashiri",
          style: textStyle.titleLarge,
        );
      }
    });
  }

  Widget profileEmail(
      {required CustomTextStyle textStyle,
      required ProfileController profileController}) {
    return Obx(() {
      if (profileController.islogin) {
        return Text(
          profileController.information.userName,
          style: textStyle.bodyNormal,
        );
      } else {
        return Text(
          "emirbashiri@gmail.com",
          style: textStyle.bodyNormal,
        );
      }
    });
  }

  Widget profileItem(
      {required String itemName,
      required CustomTextStyle textStyle,
      required CustomColors colors,
      required GestureTapCallback callback}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemName,
                  style: textStyle.bodyNormal.copyWith(fontSize: 25),
                ),
                CupertinoButton(
                  onPressed: callback,
                  child: Icon(
                    CupertinoIcons.right_chevron,
                    color: colors.blackColor,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 2,
            width: Get.mediaQuery.size.width,
            color: colors.captionColor,
          )
        ],
      ),
    );
  }

  String signStatus({required ProfileController profileController}) {
    final bool isLogin =
        profileController.authenticationFunctions.isUserLogin();
    if (isLogin) {
      return "Log out";
    } else {
      return "Login";
    }
  }
}
