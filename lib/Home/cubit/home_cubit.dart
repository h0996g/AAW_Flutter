import 'package:flutter_aaw/dio/dioHalper.dart';
import 'package:flutter_aaw/models/userModel.dart';
import 'package:flutter_aaw/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  List<UserModel> userModelList = [];
  UserModel? userModel;

  Future<void> getUser() async {
    userModelList = [];
    emit(LodinGetUsersState());
    await DioHelper.getData(url: GETALLUSER).then((value) {
      print('jabhom');
      for (var element in value.data) {
        userModelList.add(UserModel.fromJson(element));
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
    DioHelper.postData(url: CREATEUSER, data: model.toMap()).then((value) {
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

      getUser();
      emit(DeleteUserStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(DeleteUserStateBad(e.toString()));
    });
  }

  void getUserDetail({required String id}) {
    emit(LodinGetUserDetailState());

    DioHelper.postData(
      url: GETUSERDETAIL + id.toString(),
    ).then((value) {
      print('dkhol l detail');
      userModel = UserModel.fromJson(value.data);
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
      userModel = UserModel.fromJson(value.data);
      getUser();
      emit(UpdateUserStateGood());
    }).catchError((e) {
      print(e.toString());
      emit(UpdateUserStateBad(e.toString()));
    });
  }
}
