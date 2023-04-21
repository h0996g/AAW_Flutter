import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aaw/pages/Auth/login/login.dart';
import 'package:flutter_aaw/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../Home/cubit/home_cubit.dart';
import '../shared/helper/cashHelper.dart';

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
        }
        if (state is DeleteUserStateGood) {
          showToast(msg: 'Delete Successfully', state: ToastStates.success);
          CachHelper.removdata(key: "token").then((value) {
            HomeCubit.get(context).resetValueWhenelogout();
            navigatAndFinish(context: context, page: Login());
          });

// CachHelper.removdata(key: "token").then((value) {
//             // _homeCubit.resetWhenLogout();
//             navigatAndFinish(context: context, page: Login());
//             HomeCubit.get(context).resetValueWhenelogout();
//           });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
              title: const Text('Update User'),
              canreturn: true,
              onPressed: () {
                if (state is LodinUpdateUserState) {
                  return null;
                }
                Navigator.pop(context);
                HomeCubit.get(context).comp = null;
                HomeCubit.get(context).linkProfileImg = null;
              }),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: SizedBox(
                  height:
                      size.height - defaultAppBar().preferredSize.height * 2.5,
                  child: Column(
                      //
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state is LodinUpdateUserState)
                          const Column(
                            children: [
                              LinearProgressIndicator(),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundImage: HomeCubit.get(context)
                                          .comp !=
                                      null
                                  ? Image.file(HomeCubit.get(context).comp!)
                                      .image
                                  : NetworkImage(
                                      HomeCubit.get(context).userModel!.image!),
                              radius: 60,
                            ),
                            IconButton(
                              splashRadius: double.minPositive,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title:
                                              const Text("Choose the source :"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  if (state
                                                      is LodinUpdateUserState) {
                                                    return null;
                                                  }
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
                                                  if (state
                                                      is LodinUpdateUserState) {
                                                    return null;
                                                  }
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
                                  if (state is LodinUpdateUserState) {
                                    return null;
                                  }
                                  HomeCubit.get(context).updateUser(
                                      id: HomeCubit.get(context).userModel!.id!,
                                      name: _nameController.text,
                                      email: _emailController.text);
                                }
                              }),
                        ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 60, vertical: 20),
                          child: defaultSubmit2(
                              text: 'Delete Account',
                              background: Colors.red,
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                            "Are you Sure ?",
                                            style: TextStyle(),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  // style: TextStyle(color: Colors.green),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  HomeCubit.get(context)
                                                      .deleteUser(
                                                          id: HomeCubit.get(
                                                                  context)
                                                              .userModel!
                                                              .id!)
                                                      .then((value) {
                                                    // Navigator.pop(context);
                                                  });
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ))
                                          ],
                                        ));
                                // HomeCubit.get(context)
                                //     .deleteUser(
                                //         id: HomeCubit.get(context)
                                //             .userModel!
                                //             .id!)
                                //     .then((value) async {
                                //   // await FirebaseFirestore.instance
                                //   //     .collection('users')
                                //   //     .doc(HomeCubit.get(context).userModel!.id)
                                //   //     .delete()
                                //   //     .then((value) {})
                                //   //     .catchError((e) {
                                //   //   print(e.toString());
                                //   // });
                                // });
                              }),
                        )
                      ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
