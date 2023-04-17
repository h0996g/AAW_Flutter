import 'package:flutter/material.dart';
import 'package:flutter_aaw/models/userModel.dart';
import 'package:flutter_aaw/pages/updateUserForm.dart';
import 'package:flutter_aaw/pages/users.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Home/cubit/home_cubit.dart';
import '../shared/components/components.dart';

class UserDetail extends StatelessWidget {
  final UserModel model;
  UserDetail({required this.model});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: defaultAppBar(
                title: const Text('Profile'),
                canreturn: true,
                onPressed: () {
                  // Navigator.pop(context);
                  navigatAndFinish(context: context, page: Users());
                }),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9-6bTSqGzEDlxq6CbtlyAHvfr47PT5BpaGTi0nq4&s'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      model.name!,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.email!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: defaultSubmit2(
                          text: 'Edite',
                          background: Colors.grey,
                          onPressed: () {
                            navigatAndReturn(
                                context: context,
                                page: UpdateUserForm(
                                  model: model,
                                ));
                          }),
                    )
                  ],
                ),
              ),
            ));
      },
    ));
  }
}
