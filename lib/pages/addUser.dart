import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aaw/pages/users.dart';
import 'package:flutter_aaw/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Home/cubit/home_cubit.dart';

class AddUser extends StatelessWidget {
  AddUser({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is AddUserStateGood) {
          showToast(msg: 'Add User Successfuly', state: ToastStates.success);
          navigatAndFinish(context: context, page: Users());
        } else if (state is AddUserStateBad) {
          showToast(msg: state.err, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
              title: const Text('Add User'),
              canreturn: true,
              onPressed: () {
                Navigator.pop(context);
              }),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  defaultForm(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      label: 'Name',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name Must Be Not Empty";
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultForm(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email Must Be Not Empty";
                        }
                      },
                      label: "Email"),
                  const SizedBox(
                    height: 50,
                  ),
                  ConditionalBuilder(
                    builder: (BuildContext context) {
                      return defaultSubmit2(
                          text: 'Add user',
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              HomeCubit.get(context).addUser(
                                  name: nameController.text,
                                  email: emailController.text);
                            }
                          });
                    },
                    condition: state is! LodinAddUserState,
                    fallback: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
