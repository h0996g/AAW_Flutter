part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class ChangeButtonNavStateGood extends HomeState {}

class LodinAddUserState extends HomeState {}

class AddUserStateGood extends HomeState {}

class AddUserStateBad extends HomeState {
  final err;

  AddUserStateBad(this.err);
}

class LodinGetUsersState extends HomeState {}

class GetUsersStateGood extends HomeState {}

class GetUsersStateBad extends HomeState {
  final err;

  GetUsersStateBad(this.err);
}

class LodinDeleteUserState extends HomeState {}

class DeleteUserStateGood extends HomeState {}

class DeleteUserStateBad extends HomeState {
  final err;

  DeleteUserStateBad(this.err);
}

class LodinGetUserDetailState extends HomeState {}

class GetUserDetailStateGood extends HomeState {}

class GetUserDetailStateBad extends HomeState {
  final err;

  GetUserDetailStateBad(this.err);
}

class LodinUpdateUserState extends HomeState {}

class UpdateUserStateGood extends HomeState {}

class UpdateUserStateBad extends HomeState {
  final err;

  UpdateUserStateBad(this.err);
}

class SendMessageDataStateGood extends HomeState {}

class SendMessageDataStateBad extends HomeState {
  final e;

  SendMessageDataStateBad(this.e);
}

class ReciveMessageDataStateGood extends HomeState {}

class ReciveMessageDataStateBad extends HomeState {
  final e;

  ReciveMessageDataStateBad(this.e);
}

class GetMessageDataStateGood extends HomeState {}
