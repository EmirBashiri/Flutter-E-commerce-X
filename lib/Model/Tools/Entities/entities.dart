import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';


class UiDuplicate {
  final defaultScroll = const BouncingScrollPhysics();
}

class HttpPackage {
  final Dio dio = Dio();
}

class UserInformation {
  final String name;
  final String userName;
  final String password;

  UserInformation(
      {required this.userName, required this.password, required this.name});
}


