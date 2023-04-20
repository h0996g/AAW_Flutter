import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_aaw/dio/dioHalper.dart';
import 'package:flutter_aaw/models/userModel.dart';
import 'package:flutter_aaw/pages/chats.dart';
import 'package:flutter_aaw/pages/profile.dart';
import 'package:flutter_aaw/pages/users.dart';
import 'package:flutter_aaw/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
    const Profile(),
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

  void getCurrentUserInfo() {
    emit(LodinGetCurrentUserDetailState());

    DioHelper.getData(
      url: GETUSERDETAIL + DECODEDTOKEN['_id'].toString(),
    ).then((value) {
      print('current user');
      userModel = UserModel.fromJson(value.data);
      emit(GetCurrentUserDetailStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(GetCurrentUserDetailStateBad(e.toString()));
    });
  }

  Future<void> getOtherUsers() async {
    userModelList = [];
    emit(LodinGetOtherUsersState());
    await DioHelper.getData(url: GETALLUSER).then((value) {
      print('jabhom');
      for (var element in value.data) {
        if (element['_id'] != userModel!.id) {
          userModelList.add(UserModel.fromJson(element));
        }
      }

      // print(userModelList[0].id);
      // print(value.data);
      emit(GetOtherUsersStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(GetOtherUsersStateBad(e.toString()));
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

      getOtherUsers();
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

  Future<void> updateUser(
      {required String id, required String name, required String email}) async {
    emit(LodinUpdateUserState());

    if (imageProfile != null) {
      await updateProfileImg();
    }
    UserModel _model = UserModel(
      name: name,
      email: email,
      image: linkProfileImg ?? userModel!.image,
    );

    await DioHelper.putData(
            url: GETUSERDETAIL + id.toString(), data: _model.toMap())
        .then((value) {
      print('badalt info user');
      userModel = UserModel.fromJson(value.data);
      getCurrentUserInfo();
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
  // !------------------------------

  // !--------imagepicker
  XFile? imageProfile;
  Future<void> imagePickerProfile(ImageSource source) async {
    final ImagePicker _pickerProfile = ImagePicker();
    _pickerProfile.pickImage(source: source).then((value) {
      imageProfile = value;
      emit(ImagePickerProfileStateGood());
    }).catchError((e) {
      emit(ImagePickerProfileStateBad());
    });
  }

  String? linkProfileImg;
  String? linkCoverImg;
  Future<void> updateProfileImg() async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(imageProfile!.path).pathSegments.last}')
        .putFile(File(imageProfile!.path))
        .then((p0) async {
      await p0.ref.getDownloadURL().then((value) {
        linkProfileImg = value;
        print(linkProfileImg);
        // emit(UploadProfileImgAndGetUrlStateGood());  //! bah matro7ch  LodingUpdateUserStateGood() t3 Widget LinearProgressIndicator
      }).catchError((e) {
        emit(UploadProfileImgAndGetUrlStateBad());
      });
    });
  }

  // !--------------------------------------------
}
