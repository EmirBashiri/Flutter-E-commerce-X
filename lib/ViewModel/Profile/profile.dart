import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

class ProfileFunctions {
  final String imageStorge = "ImageSotrge";
  final GetStorage storage = GetStorage();
  final String favoriteBox = "Favorite Box";

  Future<bool> saveImageInSotrge({required String path}) async {
    await storage.write(imageStorge, path);
    return true;
  }

  Future<bool> getUserImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    final ProfileController profileController = Get.find<ProfileController>();
    if (xFile != null) {
      bool isSved = await saveImageInSotrge(path: xFile.path);
      profileController.userSetImageInstance.value = isSved;
      return isSved;
    }
    return false;
  }

  File? imageFile() {
    String? imagePath = storage.read(imageStorge);
    if (imagePath != null) {
      return File(imagePath);
    } else {
      return null;
    }
  }

  bool isUserSavedImage() {
    final File? file = imageFile();
    if (file != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> openFavoriteBox() async {
    await Hive.openBox<ProductEntity>(favoriteBox);
  }

  Future<bool> addToFavorite({required ProductEntity productEntity}) async {
    final box = Hive.box<ProductEntity>(favoriteBox);
    await box.put(productEntity.id, productEntity);
    return true;
  }

  Future<List<ProductEntity>> getFavoriteProducts() async {
    final box = Hive.box<ProductEntity>(favoriteBox);

    final List<ProductEntity> productList = [];
    for (var element in (box.values.toList())) {
      productList.add(element);
    }
    return productList;
  }

  bool isInFavoriteBox({required ProductEntity productEntity}) {
    final box = Hive.box<ProductEntity>(favoriteBox);
    for (var element in box.values) {
      if (productEntity.id == element.id) {
        return true;
      }
    }
    return false;
  }

  Future<bool> removeFavorite({required ProductEntity productEntity}) async {
    final box = Hive.box<ProductEntity>(favoriteBox);
    await box.delete(productEntity.id);
    return true;
  }

  ValueListenable favoriteListenable() {
    final box = Hive.box<ProductEntity>(favoriteBox);
    return box.listenable();
  }
}
