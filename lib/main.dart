import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aaw/Home/cubit/home_cubit.dart';
import 'package:flutter_aaw/pages/Auth/login/cubit/login_cubit.dart';
import 'package:flutter_aaw/pages/Auth/login/login.dart';
import 'package:flutter_aaw/pages/Auth/register/cubit/register_cubit.dart';
import 'package:flutter_aaw/pages/users.dart';
import 'package:flutter_aaw/shared/blocObserver/observer.dart';
import 'package:flutter_aaw/shared/components/constants.dart';
import 'package:flutter_aaw/shared/helper/cashHelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dio/dioHalper.dart';

Future<void> main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await CachHelper.init();
  DioHelper.init();
  Widget startWidget;
  TOKEN = CachHelper.getData(key: 'token') ?? '';
  if (TOKEN != '') {
    startWidget = Users();
  } else {
    startWidget = Login();
  }
  runApp(MyApp(
    startwidget: startWidget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startwidget;

  const MyApp({super.key, required this.startwidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => RegisterCubit())),
        BlocProvider(create: ((context) => LoginCubit())),
        BlocProvider(create: ((context) => HomeCubit()..getUser())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: startwidget,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              titleSpacing: 20,
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark),
              backgroundColor: Colors.white,
              // shadowColor: Colors.white,
              elevation: 0),
          scaffoldBackgroundColor: Colors.white,
        ),
      ),
    );
  }
}
