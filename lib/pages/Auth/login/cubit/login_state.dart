part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class ShowPasswordState extends LoginState {}

class LodinLoginUserState extends LoginState {}

class LoginUserStateGood extends LoginState {
  final token;

  LoginUserStateGood(this.token);
}

class LoginUserStateBad extends LoginState {
  final err;

  LoginUserStateBad(this.err);
}
