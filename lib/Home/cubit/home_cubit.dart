import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_aaw/dio/dioHalper.dart';
import 'package:flutter_aaw/models/userModel.dart';
import 'package:flutter_aaw/pages/chats.dart';
import 'package:flutter_aaw/pages/profile.dart';
import 'package:flutter_aaw/pages/users.dart';
import 'package:flutter_aaw/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/messageModel.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  List<UserModel> userModelList = [];
  UserModel? otherUserModel;
  UserModel? userModel;
  int currentIndex = 0;
  List<Widget> userScreen = [
    const Chats(),
    Users(),
    Profile(),
  ];
  List<String> appbarScreen = const [
    'Chats',
    'People',
    'Setting',
  ];

  void resetValueWhenelogout() {
    currentIndex = 0;
    userModel = null;
    otherUserModel = null;
    userModelList = [];
    messageModelList = [];
  }

  changeButtonNav(int currentIndex) {
    this.currentIndex = currentIndex;
    emit(ChangeButtonNavStateGood());
  }

  void getUserInfo() {
    emit(LodinGetUserDetailState());

    DioHelper.getData(
      url: GETUSERDETAIL + DECODEDTOKEN['_id'].toString(),
    ).then((value) {
      print('dkhol l detail');
      userModel = UserModel.fromJson(value.data);
      emit(GetUserDetailStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(GetUserDetailStateBad(e.toString()));
    });
  }

  Future<void> getUsers() async {
    userModelList = [];
    emit(LodinGetUsersState());
    await DioHelper.getData(url: GETALLUSER).then((value) {
      print('jabhom');
      for (var element in value.data) {
        if (element['_id'] != userModel!.id) {
          userModelList.add(UserModel.fromJson(element));
        }
      }

      print(userModelList[0].id);
      // print(value.data);
      emit(GetUsersStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(GetUsersStateBad(e.toString()));
    });
  }

  void addUser({required String name, required String email}) {
    emit(LodinAddUserState());
    UserModel model = UserModel(name: name, email: email);
    DioHelper.postData(url: REGISTERUSER, data: model.toMap()).then((value) {
      print('zado');
      // _userModel = UserModel.fromJson(value.data);
      userModelList.add(UserModel.fromJson(value.data));

      emit(AddUserStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(AddUserStateBad(e.toString()));
    });
  }

  void deleteUser({required String id}) {
    emit(LodinDeleteUserState());

    DioHelper.deleteData(
      url: DELETEUSER + id.toString(),
    ).then((value) {
      print('na7a');

      getUsers();
      emit(DeleteUserStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(DeleteUserStateBad(e.toString()));
    });
  }

  void getUserDetail({required String id}) {
    emit(LodinGetUserDetailState());

    DioHelper.getData(
      url: GETUSERDETAIL + id.toString(),
    ).then((value) {
      print('dkhol l detail');
      otherUserModel = UserModel.fromJson(value.data);
      emit(GetUserDetailStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(GetUserDetailStateBad(e.toString()));
    });
  }

  void updateUser(
      {required String id, required String name, required String email}) {
    emit(LodinUpdateUserState());

    DioHelper.putData(
        url: GETUSERDETAIL + id.toString(),
        data: {'email': email, 'name': name}).then((value) {
      print('badalt info user');
      otherUserModel = UserModel.fromJson(value.data);
      getUserInfo();
      emit(UpdateUserStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(UpdateUserStateBad(e.toString()));
    });
  }

  // !---------------------chats
  void sendMessage({required String otheruser, String? message}) {
    MessageModel model = MessageModel(
        dateTime: DateTime.now().toString(),
        resiverId: otheruser,
        senderId: userModel!.id,
        text: message);
    // emit(LodinSendAndReciveMessageDataState());

    //set my chat messeger (lmn b3et le usermodel.uid ta3i)

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.id)
        .collection('chats')
        .doc(otheruser)
        .collection('messages')
        // .doc()
        .add(model.toMap())
        .then((value) {
      emit(SendMessageDataStateGood());
    }).catchError((e) {
      emit(SendMessageDataStateBad(e.toString()));
    });
    // set reciver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(otheruser)
        .collection('chats')
        .doc(userModel!.id)
        .collection('messages')
        // .doc()
        .add(model.toMap())
        .then((value) {
      emit(ReciveMessageDataStateGood());
    }).catchError((e) {
      emit(ReciveMessageDataStateBad(e.toString()));
    });
  }

  List<MessageModel> messageModelList = [];
  void getMessage({required String reciverUid}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.id)
        .collection('chats')
        .doc(reciverUid)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messageModelList = [];

      for (var element in event.docs) {
        messageModelList.add(MessageModel.fromJson(element.data()));
      }
      emit(GetMessageDataStateGood());
    });
  }
}
