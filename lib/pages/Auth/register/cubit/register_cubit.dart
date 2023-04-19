import 'package:flutter_aaw/models/registerModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Models/userModel.dart';
import '../../../../dio/dioHalper.dart';
import '../../../../shared/components/constants.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isvisibility = false;
  List<UserModel> userModelList = [];
  RegisterAndLoginModel? model;

  void showPassword() {
    isvisibility = !isvisibility;
    emit(ShowPasswordState());
  }

  void registerUser(
      {required String name,
      required String email,
      required String phone,
      required String password}) {
    emit(LodinRegisterUserState());
    UserModel _userModel =
        UserModel(name: name, email: email, password: password, phone: phone);
    DioHelper.postData(url: REGISTERUSER, data: _userModel.toMap())
        .then((value) {
      print('zado');
      model = RegisterAndLoginModel.fromjson(value.data);
      print(model!.token);
      // userModelList.add(UserModel.fromJson(value.data));

      emit(RegisterUserStateGood(model!.token));
    }).catchError((e) {
      print(e.toString());
      emit(RegisterUserStateBad(e.toString()));
    });
  }
}
