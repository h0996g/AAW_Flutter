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

class LodinGetOtherUsersState extends HomeState {}

class GetOtherUsersStateGood extends HomeState {}

class GetOtherUsersStateBad extends HomeState {
  final err;

  GetOtherUsersStateBad(this.err);
}

class LodinDeleteUserState extends HomeState {}

class DeleteUserStateGood extends HomeState {}

class DeleteUserStateBad extends HomeState {
  final err;

  DeleteUserStateBad(this.err);
}

class LodinGetCurrentUserDetailState extends HomeState {}

class GetCurrentUserDetailStateGood extends HomeState {}

class GetCurrentUserDetailStateBad extends HomeState {
  final err;

  GetCurrentUserDetailStateBad(this.err);
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

class ImagePickerProfileStateGood extends HomeState {}

class ImagePickerProfileStateBad extends HomeState {}

class UploadProfileImgAndGetUrlStateGood extends HomeState {}

class UploadProfileImgAndGetUrlStateBad extends HomeState {}
