part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AuthenticationStart extends AuthenticationEvent {}

class AuthenticatioLogin extends AuthenticationEvent {
  final String userName;
  final String password;
  final bool isRemember;

  AuthenticatioLogin(
      {required this.userName,
      required this.password,
      required this.isRemember});
}

class AuthenticationSignUp extends AuthenticationEvent {
  final String name;
  final String userName;
  final String password;
  final bool isRemember;

  AuthenticationSignUp(
      {required this.name,
      required this.userName,
      required this.password,
      required this.isRemember});
}

class AuthenticationSignUpMode extends AuthenticationEvent {}

class AuthenticationLoginMode extends AuthenticationEvent {}

class AuthenticationChangeInformation extends AuthenticationEvent {}

class AuthenticationSaveChanges extends AuthenticationEvent {
  final String userName;
  final String password;

  AuthenticationSaveChanges({required this.userName, required this.password});
}
