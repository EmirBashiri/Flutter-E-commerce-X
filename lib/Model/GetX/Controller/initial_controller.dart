import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/home_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';

class InitialController extends GetxController {
  final String rememberStorge = "Remember";

  Future<void> closeHive() async {
    await Hive.close();
  }

  bool isRemember() {
    final GetStorage storage = GetStorage();
    bool? status = storage.read(rememberStorge);
    if (status != null) {
      return status;
    } else {
      return false;
    }
  }

  Future<void> init() async {
    Get.put(ProfileController());
    Get.put(HomeController());

    final duplicateContrller = Get.find<DuplicateController>();
    final profileController = Get.find<ProfileController>();
    await duplicateContrller.cartFunctions.openCartBox();
    await profileController.profileFunctions.openFavoriteBox();
    profileController.userSetImageInstance.value =
        profileController.profileFunctions.isUserSavedImage();

    bool remember = isRemember();
    if (remember) {
      final perviousAccount =
          profileController.authenticationFunctions.getUserInformation();
      if (perviousAccount != null) {
        profileController.informationInstance.value = perviousAccount;
        profileController.isLoginInstanse.value =
            profileController.authenticationFunctions.isUserLogin();
      }
    }
  }

  @override
  void onInit() async {
    await init();
    super.onInit();
  }
}
