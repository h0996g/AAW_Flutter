import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aaw/Home/cubit/home_cubit.dart';
import 'package:flutter_aaw/pages/Auth/login/cubit/login_cubit.dart';
import 'package:flutter_aaw/pages/Auth/login/login.dart';
import 'package:flutter_aaw/pages/Auth/register/cubit/register_cubit.dart';
import 'package:flutter_aaw/pages/Home.dart';
import 'package:flutter_aaw/shared/blocObserver/observer.dart';
import 'package:flutter_aaw/shared/components/constants.dart';
import 'package:flutter_aaw/shared/helper/cashHelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dio/dioHalper.dart';
import 'firebase_options.dart';

Future<void> main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await CachHelper.init();
  DioHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Widget startWidget;
  TOKEN = await CachHelper.getData(key: 'token') ?? '';
  // CachHelper.removdata(key: "token");
  if (TOKEN != '') {
    DECODEDTOKEN = JwtDecoder.decode(TOKEN);
    print(DECODEDTOKEN['_id']);
  }

  // TOKEN = JWT.decode(CachHelper.getData(key: 'token') ?? '');
  // print(TOKEN.toString());
  if (TOKEN != '') {
    startWidget = const Home();
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
        BlocProvider(
            lazy: false,
            create: ((context) => HomeCubit()
              ..getCurrentUserInfo()
              ..getOtherUsers())),
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
