import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/AuthenticationScreen/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthenticationBloc? authenticationBloc;
  StreamSubscription? subscription;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> nameKey = GlobalKey();
  final GlobalKey<FormState> userNameKey = GlobalKey();
  final GlobalKey<FormState> passwordKey = GlobalKey();
  @override
  void dispose() {
    authenticationBloc?.close();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final CustomColors colors = Get.find<DuplicateController>().colors;
        final CustomTextStyle textStyle =
            Get.find<DuplicateController>().textStyle;
        final bloc = AuthenticationBloc();
        bloc.add(AuthenticationStart());
        subscription = bloc.stream.listen((state) {
          if (state is SignSuccess) {
            snackBar(
                title: "sign",
                message: "sign in successfull",
                textStyle: textStyle,
                colors: colors);
            Navigator.pop(context);
          } else if (state is LoginSuccess) {
            snackBar(
                title: "sign",
                message: "sign in successfull",
                textStyle: textStyle,
                colors: colors);
            Navigator.pop(context);
          } else if (state is ChangeInformation) {
            final TextEditingController userNameController =
                TextEditingController();
            final TextEditingController passwordController =
                TextEditingController();
            final GlobalKey<FormState> userNameKey = GlobalKey();
            final GlobalKey<FormState> passwordKey = GlobalKey();
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: Get.mediaQuery.size.height * 0.6,
                  child: AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    titlePadding: EdgeInsets.zero,
                    shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)),
                    title: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          color: colors.blackColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15))),
                      child: Text(
                        "Change password",
                        style: textStyle.titleLarge
                            .copyWith(color: colors.whiteColor),
                      ),
                    ),
                    content: Container(
                      color: colors.blackColor,
                      child: duplicateContainer(
                        colors: colors,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          width: Get.mediaQuery.size.width * 0.8,
                          height: Get.mediaQuery.size.height * .45,
                          child: Column(
                            children: [
                              textField(
                                  textStyle: textStyle,
                                  controller: userNameController,
                                  formKey: userNameKey,
                                  lable: "user name",
                                  colors: colors,
                                  edgeInsetsGeometry: const EdgeInsets.all(5)),
                              textField(
                                  textStyle: textStyle,
                                  controller: passwordController,
                                  formKey: passwordKey,
                                  lable: "Password",
                                  colors: colors,
                                  edgeInsetsGeometry: const EdgeInsets.all(5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: CupertinoTheme(
                          data:
                              CupertinoThemeData(primaryColor: colors.primary),
                          child: CupertinoButton.filled(
                            child: Text(
                              "Save",
                              style: textStyle.bodyNormal,
                            ),
                            onPressed: () {
                              if (userNameKey.currentState!.validate() &&
                                  passwordKey.currentState!.validate()) {
                                authenticationBloc!.add(
                                    AuthenticationSaveChanges(
                                        userName: userNameController.text,
                                        password: passwordController.text));
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else if (state is UserHaveNoAccount) {
            snackBar(
                title: "Account",
                message: "Account not found",
                textStyle: textStyle,
                colors: colors);
          } else if (state is LoginUnSuccess) {
            snackBar(
                title: "Incorrect information",
                message: "Incorrect username and password entered",
                textStyle: textStyle,
                colors: colors);
          }
        });
        authenticationBloc = bloc;
        return bloc;
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationLoginScreen) {
            final duplicateController = state.duplicateController;
            final profileController = state.profileController;

            final CustomColors colors = duplicateController.colors;
            final CustomTextStyle textStyle = duplicateController.textStyle;

            const EdgeInsetsGeometry edgeInsets = EdgeInsets.all(15);
            return DuplicateTemplate(
              colors: colors,
              textStyle: textStyle,
              title: "Login",
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: duplicateController.uiDuplicate.defaultScroll,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  "Let's sign you in",
                                  style: textStyle.titleLarge,
                                  maxLines: 1,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "welcome back, we've been missed you",
                                  style: textStyle.bodySmall,
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          textField(
                              edgeInsetsGeometry: edgeInsets,
                              colors: colors,
                              textStyle: textStyle,
                              controller: userNameController,
                              formKey: userNameKey,
                              lable: "UserName or Email"),
                          Obx(
                            () => textField(
                                suffix: CupertinoButton(
                                  child: Icon(profileController.obscureText
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash),
                                  onPressed: () {
                                    profileController
                                            .obscureTextInstance.value =
                                        !profileController
                                            .obscureTextInstance.value;
                                  },
                                ),
                                obscureText: profileController.obscureText,
                                edgeInsetsGeometry: edgeInsets,
                                colors: colors,
                                textStyle: textStyle,
                                controller: passwordController,
                                formKey: passwordKey,
                                lable: "Password"),
                          ),
                          Padding(
                            padding: edgeInsets,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Obx(
                                      () => Checkbox(
                                        activeColor: colors.primary,
                                        value:
                                            profileController.rememberMeStatus,
                                        onChanged: (value) {
                                          if (value != null) {
                                            profileController
                                                .rememberMeStatusInstance
                                                .value = value;
                                          }
                                        },
                                      ),
                                    ),
                                    Text(
                                      "Remember me",
                                      style: textStyle.bodySmall,
                                    )
                                  ],
                                ),
                                CupertinoButton(
                                  child: Text(
                                    "Forgat password?",
                                    style: textStyle.bodyNormal,
                                  ),
                                  onPressed: () {
                                    authenticationBloc!
                                        .add(AuthenticationChangeInformation());
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: edgeInsets,
                            child: CupertinoTheme(
                                data: CupertinoThemeData(
                                    primaryColor: colors.primary),
                                child: CupertinoButton.filled(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Text(
                                      "Login",
                                      style: textStyle.bodyNormal
                                          .copyWith(color: colors.whiteColor),
                                    ),
                                    onPressed: () async {
                                      authenticationBloc!.add(
                                          AuthenticatioLogin(
                                              userName: userNameController.text,
                                              password: passwordController.text,
                                              isRemember: profileController
                                                  .rememberMeStatus));
                                    })),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        "Don't have an account?",
                        style: textStyle.bodySmall,
                      ),
                      CupertinoButton(
                        child: Text(
                          "SignUp",
                          style: textStyle.bodyNormal.copyWith(
                              fontSize: 19,
                              decoration: TextDecoration.underline),
                        ),
                        onPressed: () {
                          authenticationBloc!.add(AuthenticationSignUpMode());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is AuthenticationSignUpScreen) {
            final duplicateController = state.duplicateController;
            final profileController = state.profileController;
            final CustomColors colors = duplicateController.colors;
            final CustomTextStyle textStyle = duplicateController.textStyle;

            const EdgeInsetsGeometry edgeInsets = EdgeInsets.all(15);
            return DuplicateTemplate(
                colors: colors,
                textStyle: textStyle,
                title: "Signup",
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: duplicateController.uiDuplicate.defaultScroll,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    "Let's sign you in",
                                    style: textStyle.titleLarge,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  AutoSizeText(
                                    "welcome back, we've been missed you",
                                    style: textStyle.bodySmall,
                                    maxLines: 1,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            textField(
                                edgeInsetsGeometry: edgeInsets,
                                colors: colors,
                                textStyle: textStyle,
                                controller: nameController,
                                formKey: nameKey,
                                lable: "Full Name"),
                            textField(
                                edgeInsetsGeometry: edgeInsets,
                                colors: colors,
                                textStyle: textStyle,
                                controller: userNameController,
                                formKey: userNameKey,
                                lable: "UserName or Email"),
                            Obx(
                              () => textField(
                                  suffix: CupertinoButton(
                                    child: Icon(profileController.obscureText
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash),
                                    onPressed: () {
                                      profileController
                                              .obscureTextInstance.value =
                                          !profileController
                                              .obscureTextInstance.value;
                                    },
                                  ),
                                  obscureText: profileController.obscureText,
                                  edgeInsetsGeometry: edgeInsets,
                                  colors: colors,
                                  textStyle: textStyle,
                                  controller: passwordController,
                                  formKey: passwordKey,
                                  lable: "Password"),
                            ),
                            Padding(
                              padding: edgeInsets,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => Checkbox(
                                      activeColor: colors.primary,
                                      value: profileController.rememberMeStatus,
                                      onChanged: (value) {
                                        if (value != null) {
                                          profileController
                                              .rememberMeStatusInstance
                                              .value = value;
                                        }
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Remember me",
                                    style: textStyle.bodySmall,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: edgeInsets,
                              child: CupertinoTheme(
                                  data: CupertinoThemeData(
                                      primaryColor: colors.primary),
                                  child: CupertinoButton.filled(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Text(
                                        "SignUp",
                                        style: textStyle.bodyNormal
                                            .copyWith(color: colors.whiteColor),
                                      ),
                                      onPressed: () async {
                                        if (nameKey.currentState!.validate() &&
                                            userNameKey.currentState!
                                                .validate() &&
                                            passwordKey.currentState!
                                                .validate()) {
                                          authenticationBloc!.add(
                                              AuthenticationSignUp(
                                                  name: nameController.text,
                                                  userName:
                                                      userNameController.text,
                                                  password:
                                                      passwordController.text,
                                                  isRemember: profileController
                                                      .rememberMeStatus));
                                        }
                                      })),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          "have an account?",
                          style: textStyle.bodySmall,
                        ),
                        CupertinoButton(
                          child: Text(
                            "Login",
                            style: textStyle.bodyNormal.copyWith(
                                fontSize: 19,
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () {
                            authenticationBloc!.add(AuthenticationLoginMode());
                          },
                        ),
                      ],
                    ),
                  ],
                ));
          } else if (state is AuthenticationLoading) {
            return const CustomLoading();
          } else if (state is AuthenticationError) {
            return AppException(
              callback: () {
                authenticationBloc!.add(AuthenticationStart());
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
