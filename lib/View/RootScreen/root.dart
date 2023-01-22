import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/initial_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/View/CartScreen/cart_screen.dart';
import 'package:flutter_application_ecommerce/View/HomeScreen/home_screen.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/profile_screen.dart';
import 'package:get/get.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, required this.index});
  final int index;
  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  final duplicateController = Get.find<DuplicateController>();
  final initialController = Get.find<InitialController>();
  late CustomColors colors = duplicateController.colors;
  late CustomTextStyle textStyle = duplicateController.textStyle;
  late int slectedIndex = widget.index;
  late PageController pageController =
      PageController(initialPage: slectedIndex, keepPage: true);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    duplicateController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      await initialController.closeHive();
      pageController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.whiteColor,
      body: PageView(
        physics: duplicateController.uiDuplicate.defaultScroll,
        controller: pageController,
        children: const [HomeScreen(), CartScreen(), ProfileScreen()],
        onPageChanged: (value) {
          setState(() {
            slectedIndex = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        curve: Curves.easeInOut,
        selectedIndex: slectedIndex,
        items: [
          BottomNavyBarItem(
              activeColor: colors.primary,
              textAlign: TextAlign.center,
              inactiveColor: colors.blackColor,
              icon: const Icon(
                CupertinoIcons.home,
              ),
              title: Text(
                "Home",
                style: textStyle.bodyNormal.copyWith(color: colors.primary),
              )),
          BottomNavyBarItem(
              activeColor: colors.primary,
              textAlign: TextAlign.center,
              inactiveColor: colors.blackColor,
              icon: const Icon(
                CupertinoIcons.cart,
              ),
              title: Text(
                "Cart",
                style: textStyle.bodyNormal.copyWith(color: colors.primary),
              )),
          BottomNavyBarItem(
              activeColor: colors.primary,
              inactiveColor: colors.blackColor,
              textAlign: TextAlign.center,
              icon: const Icon(CupertinoIcons.person_alt_circle),
              title: Text(
                "Profile",
                style: textStyle.bodyNormal.copyWith(color: colors.primary),
              )),
        ],
        onItemSelected: (value) {
          setState(() {
            slectedIndex = value;
            pageController.jumpToPage(slectedIndex);
          });
        },
      ),
    );
  }
}
