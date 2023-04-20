import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_aaw/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../Home/cubit/home_cubit.dart';

class UpdateUserForm extends StatefulWidget {
  // final UserModel model;

  final emailController = TextEditingController();

  UpdateUserForm({super.key});

  @override
  State<UpdateUserForm> createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement setState
    _emailController.text = HomeCubit.get(context).userModel!.email!;
    _nameController.text = HomeCubit.get(context).userModel!.name!;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is UpdateUserStateGood) {
          showToast(msg: 'Updated Successfully', state: ToastStates.success);
          Navigator.pop(context);
          // navigatAndFinish(
          //     context: context,
          //     page: UserDetail(model: HomeCubit.get(context).userModel!));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
              title: const Text('Update User'),
              canreturn: true,
              onPressed: () {
                Navigator.pop(context);
              }),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formkey,
              child: Column(children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      backgroundImage: HomeCubit.get(context).imageProfile !=
                              null
                          ? Image.file(File(
                                  HomeCubit.get(context).imageProfile!.path))
                              .image
                          : const NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9-6bTSqGzEDlxq6CbtlyAHvfr47PT5BpaGTi0nq4&s'),
                      radius: 60,
                    ),
                    IconButton(
                      splashRadius: double.minPositive,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Choose the source :"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          HomeCubit.get(context)
                                              .imagePickerProfile(
                                                  ImageSource.camera)
                                              .then((value) {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text("Camera")),
                                    TextButton(
                                        onPressed: () {
                                          HomeCubit.get(context)
                                              .imagePickerProfile(
                                                  ImageSource.gallery)
                                              .then((value) {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text("Gallery"))
                                  ],
                                ));
                      },
                      icon: const CircleAvatar(
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                defaultForm(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    label: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name Must Be Not Empty";
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
                defaultForm(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    label: 'Phone',
                    prefixIcon: const Icon(Icons.email),
                    type: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email Must Be Not Empty";
                      }
                    }),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: defaultSubmit2(
                      text: 'Update',
                      background: Colors.grey,
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          HomeCubit.get(context).updateUser(
                              id: HomeCubit.get(context).userModel!.id!,
                              name: _nameController.text,
                              email: _emailController.text);
                        }
                      }),
                )
              ]),
            ),
          ),
        );
      },
    );
  }
}
