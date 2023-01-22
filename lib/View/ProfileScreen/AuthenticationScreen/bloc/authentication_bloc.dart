import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/entities.dart';
import 'package:flutter_application_ecommerce/ViewModel/Profile/Authentication/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      final profileController = Get.find<ProfileController>();
      final duplicateController = Get.find<DuplicateController>();
      final AuthenticationFunctions profileFunctions =
          profileController.authenticationFunctions;
      try {
        if (event is AuthenticationStart) {
          emit(AuthenticationLoading());
          final perviousAccount = profileFunctions.getUserInformation();
          if (perviousAccount != null) {
            emit(AuthenticationLoginScreen(
                profileController: profileController,
                duplicateController: duplicateController));
          } else {
            emit(AuthenticationSignUpScreen(
                profileController: profileController,
                duplicateController: duplicateController));
          }
        } else if (event is AuthenticationSignUpMode) {
          emit(AuthenticationLoading());
          emit(AuthenticationSignUpScreen(
              profileController: profileController,
              duplicateController: duplicateController));
        } else if (event is AuthenticationLoginMode) {
          emit(AuthenticationLoading());
          emit(AuthenticationLoginScreen(
              profileController: profileController,
              duplicateController: duplicateController));
        } else if (event is AuthenticatioLogin) {
          emit(AuthenticationLoading());
          final perviousAccount = profileFunctions.getUserInformation();
          if (perviousAccount != null) {
            await profileFunctions.saveRemember(remember: event.isRemember);
            bool isLogin = profileFunctions.loginUser(
                pI: perviousAccount,
                i: UserInformation(
                    userName: event.userName,
                    password: event.password,
                    name: ""));
            if (isLogin) {
              emit(LoginSuccess());
            } else {
              emit(LoginUnSuccess());
              emit(AuthenticationLoginScreen(
                  profileController: profileController,
                  duplicateController: duplicateController));
            }
          } else {
            emit(UserHaveNoAccount());
            emit(AuthenticationLoginScreen(
                profileController: profileController,
                duplicateController: duplicateController));
          }
        } else if (event is AuthenticationSignUp) {
          emit(AuthenticationLoading());

          await profileFunctions.saveRemember(remember: event.isRemember);
          final isSign = await profileFunctions.signUser(
              information: UserInformation(
                  userName: event.userName,
                  password: event.password,
                  name: event.name));
          if (isSign) {
            emit(SignSuccess());
          }
        } else if (event is AuthenticationChangeInformation) {
          emit(ChangeInformation());
          emit(AuthenticationLoginScreen(
              profileController: profileController,
              duplicateController: duplicateController));
        } else if (event is AuthenticationSaveChanges) {
          emit(AuthenticationLoading());
          final bool isCommpleted =
              await profileFunctions.updateUserInformation(
                  i: UserInformation(
                      userName: event.userName,
                      password: event.password,
                      name: ""));
          if (isCommpleted) {
            emit(AuthenticationLoginScreen(
                profileController: profileController,
                duplicateController: duplicateController));
          }
        }
      } catch (e) {
        emit(AuthenticationError());
      }
    });
  }
}
