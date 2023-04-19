import 'package:flutter_aaw/models/registerModel.dart';
import 'package:flutter_aaw/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../Models/userModel.dart';
import '../../../../dio/dioHalper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isvisibility = false;
  RegisterAndLoginModel? model;

  void showPassword() {
    isvisibility = !isvisibility;
    emit(ShowPasswordState());
  }

  void loginUser({required String email, required String password}) {
    emit(LodinLoginUserState());
    UserModel _userModel = UserModel(email: email, password: password);
    DioHelper.postData(url: LOGINUSER, data: _userModel.toMap()).then((value) {
      print('Dkhol');
      model = RegisterAndLoginModel.fromjson(value.data);
      print(model!.token);
      // userModelList.add(UserModel.fromJson(value.data));

      emit(LoginUserStateGood(model!.token));
    }).catchError((e) {
      print(e.toString());
      emit(LoginUserStateBad(e.toString()));
    });
  }
}
