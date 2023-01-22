part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoginScreen extends AuthenticationState {
  final ProfileController profileController;
  final DuplicateController duplicateController;

  AuthenticationLoginScreen(
      {required this.profileController, required this.duplicateController});
}

class AuthenticationSignUpScreen extends AuthenticationState {
  final ProfileController profileController;
  final DuplicateController duplicateController;

  AuthenticationSignUpScreen(
      {required this.profileController, required this.duplicateController});
}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {}

class LoginSuccess extends AuthenticationState{}

class UserHaveNoAccount extends AuthenticationState{}

class SignSuccess extends AuthenticationState{}

class LoginUnSuccess extends AuthenticationState{}

class ChangeInformation extends AuthenticationState{}