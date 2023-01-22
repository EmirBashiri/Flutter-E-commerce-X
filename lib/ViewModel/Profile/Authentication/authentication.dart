import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/entities.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationFunctions {
  final String storagePassword = "Password Storge";
  final String storageUserName = "User Name Storge";
  final String storageName = "Name Storge";
  final String rememberStorge = "Remember";
  final GetStorage storage = GetStorage();

  Future<bool> saveInformation({required UserInformation information}) async {
    final GetStorage storage = GetStorage();
    await storage.write(storageName, information.name);
    await storage.write(storageUserName, information.userName);
    await storage.write(storagePassword, information.password);
    return true;
  }

  UserInformation? getUserInformation() {
    final name = storage.read(storageName);
    final userName = storage.read(storageUserName);
    final password = storage.read(storagePassword);
    if (userName != null && password != null) {
      return UserInformation(
          password: password, userName: userName, name: name);
    } else {
      return null;
    }
  }

  Future<bool> signOut() async {
    final profileController = Get.find<ProfileController>();
    await storage.remove(rememberStorge);
    profileController.informationInstance.value =
        UserInformation(name: "", userName: "", password: "");
    profileController.rememberMeStatusInstance.value = false;
    profileController.isLoginInstanse.value = false;
    return true;
  }

  Future<bool> signUser({required UserInformation information}) async {
    final profileController = Get.find<ProfileController>();
    await saveInformation(information: information);
    profileController.informationInstance.value = information;
    profileController.isLoginInstanse.value = true;
    return true;
  }

  bool loginUser({required UserInformation pI, required UserInformation i}) {
    final profileController = Get.find<ProfileController>();
    final bool type1 = pI.userName == i.userName;
    final bool type2 = pI.password == i.password;
    if (type1 && type2) {
      profileController.informationInstance.value = getUserInformation()!;
      profileController.isLoginInstanse.value = true;
      return true;
    } else {
      return false;
    }
  }

  bool isUserLogin() {
    final profileController = Get.find<ProfileController>();

    bool type = profileController.information.userName.isNotEmpty &&
        profileController.information.password.isNotEmpty;
    if (type) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateUserInformation({required UserInformation i}) async {
    await storage.remove(storageUserName);
    await storage.remove(storagePassword);
    await storage.write(storageUserName, i.userName);
    await storage.write(storagePassword, i.password);
    return true;
  }

  Future<bool> saveRemember({required bool remember}) async {
    final GetStorage storage = GetStorage();
    await storage.write(rememberStorge, remember);
    return true;
  }
}
