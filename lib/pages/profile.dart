import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aaw/pages/updateUserForm.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../Home/cubit/home_cubit.dart';
import '../shared/components/components.dart';
import '../shared/helper/cashHelper.dart';
import 'Auth/login/login.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // print(model.id);
    // HomeCubit.get(context).getUserDetail(id: model.id.toString());
    Size size = MediaQuery.of(context).size;
    return (BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            body: SingleChildScrollView(
          child: Center(
            child: ConditionalBuilder(
              builder: (BuildContext context) {
                return SizedBox(
                  height:
                      size.height - defaultAppBar().preferredSize.height * 2.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            HomeCubit.get(context).userModel!.image!),
                        radius: 60,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        HomeCubit.get(context).userModel!.name!,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        HomeCubit.get(context).userModel!.email!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w200),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: defaultSubmit2(
                            text: 'Edite Profile',
                            background: Colors.grey,
                            onPressed: () {
                              navigatAndReturn(
                                  context: context, page: UpdateUserForm());
                            }),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 30),
                        child: defaultSubmit2(
                            text: 'Logout',
                            background: Colors.grey.shade800,
                            onPressed: () {
                              CachHelper.removdata(key: "token").then((value) {
                                // _homeCubit.resetWhenLogout();
                                navigatAndFinish(
                                    context: context, page: Login());
                                HomeCubit.get(context).resetValueWhenelogout();
                              });
                            }),
                      ),
                    ],
                  ),
                );
              },
              condition: state is! LodinGetCurrentUserDetailState,
              fallback: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ));
      },
    ));
  }
}
