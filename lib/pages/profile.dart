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
        if (state is DeleteUserStateGood) {
          showToast(msg: 'Delete Successfully', state: ToastStates.success);
          CachHelper.removdata(key: "token").then((value) {
            HomeCubit.get(context).resetValueWhenelogout();
            navigatAndFinish(context: context, page: Login());
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: ConditionalBuilder(
              builder: (BuildContext context) {
                return
                    // return SizedBox(
                    //   height:
                    //       size.height - defaultAppBar().preferredSize.height * 2.5,
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     // crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       SizedBox(
                    //         height: size.height * 0.05,
                    //       ),
                    //       CircleAvatar(
                    //         backgroundColor: Colors.transparent,
                    //         backgroundImage: NetworkImage(
                    //             HomeCubit.get(context).userModel!.image!),
                    //         radius: 60,
                    //       ),
                    //       const SizedBox(
                    //         height: 20,
                    //       ),
                    //       Text(
                    //         HomeCubit.get(context).userModel!.name!,
                    //         style: const TextStyle(
                    //             fontSize: 30, fontWeight: FontWeight.w400),
                    //       ),
                    //       const SizedBox(
                    //         height: 5,
                    //       ),
                    //       Text(
                    //         HomeCubit.get(context).userModel!.email!,
                    //         style: const TextStyle(
                    //             fontSize: 20, fontWeight: FontWeight.w200),
                    //       ),
                    //       SizedBox(
                    //         height: size.height * 0.1,
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 20),
                    //         child: defaultSubmit2(
                    //             text: 'Edite Profile',
                    //             background: Colors.grey,
                    //             onPressed: () {
                    //               navigatAndReturn(
                    //                   context: context, page: UpdateUserForm());
                    //             }),
                    //       ),
                    //       Spacer(),
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //           horizontal: 70,
                    //         ),
                    //         child: defaultSubmit2(
                    //             text: 'Logout',
                    //             background: Colors.grey.shade800,
                    //             onPressed: () {
                    //               CachHelper.removdata(key: "token").then((value) {
                    //                 // _homeCubit.resetWhenLogout();
                    //                 navigatAndFinish(
                    //                     context: context, page: Login());
                    //                 HomeCubit.get(context).resetValueWhenelogout();
                    //               });
                    //             }),
                    //       ),
                    //       TextButton(
                    //         onPressed: () async {
                    //           await showDialog(
                    //               context: context,
                    //               builder: (context) => AlertDialog(
                    //                     title: const Text(
                    //                       "Are you Sure ?",
                    //                       style: TextStyle(),
                    //                     ),
                    //                     actions: [
                    //                       TextButton(
                    //                           onPressed: () {
                    //                             Navigator.pop(context);
                    //                           },
                    //                           child: const Text(
                    //                             "Cancel",
                    //                             // style: TextStyle(color: Colors.green),
                    //                           )),
                    //                       TextButton(
                    //                           onPressed: () {
                    //                             HomeCubit.get(context).deleteUser(
                    //                                 id: HomeCubit.get(context)
                    //                                     .userModel!
                    //                                     .id!);
                    //                             Navigator.pop(context);
                    //                           },
                    //                           child: const Text(
                    //                             "Delete",
                    //                             style: TextStyle(color: Colors.red),
                    //                           ))
                    //                     ],
                    //                   ));
                    //         },
                    //         child: Text(
                    //           "Delete Account ",
                    //           style: TextStyle(
                    //               color: Colors.red,
                    //               fontSize: 20,
                    //               fontWeight: FontWeight.w600),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // );
                    Container(
                  height:
                      size.height - defaultAppBar().preferredSize.height * 2.5,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 80.0,
                        backgroundImage: NetworkImage(
                            HomeCubit.get(context).userModel!.image!),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        HomeCubit.get(context).userModel!.name!,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Text(
                      //   'Software Developer',
                      //   style: TextStyle(fontSize: 16.0),
                      // ),
                      // SizedBox(height: 16.0),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Email'),
                        subtitle:
                            Text(HomeCubit.get(context).userModel!.email!),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
                        subtitle:
                            Text(HomeCubit.get(context).userModel!.phone!),
                        onTap: () {},
                      ),

                      SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          navigatAndReturn(
                              context: context, page: UpdateUserForm());
                        },
                        child: Text('Edit Profile'),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 70,
                        ),
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
                      TextButton(
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
                                            HomeCubit.get(context).deleteUser(
                                                id: HomeCubit.get(context)
                                                    .userModel!
                                                    .id!);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  ));
                        },
                        child: Text(
                          "Delete Account ",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                );
              },
              condition: state is! LodinGetCurrentUserDetailState &&
                  state is! LodinDeleteUserState,
              fallback: (BuildContext context) {
                return SizedBox(
                    height:
                        size.height - defaultAppBar().preferredSize.height * 2,
                    width: size.width,
                    child: const Center(child: CircularProgressIndicator()));
              },
            ),
          ),
        ));
      },
    ));
  }
}
