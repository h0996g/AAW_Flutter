import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aaw/models/userModel.dart';
import 'package:flutter_aaw/pages/chatDetails.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../Home/cubit/home_cubit.dart';
import '../shared/components/components.dart';

class UserDetail extends StatefulWidget {
  final UserModel model;
  UserDetail({required this.model});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  void initState() {
    // TODO: implement initState
    HomeCubit.get(context).getUserDetail(id: widget.model.id.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(model.id);
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
                  Navigator.pop(context);
                  // navigatAndFinish(context: context, page: Users());
                }),
            body: SingleChildScrollView(
              child: Center(
                child: ConditionalBuilder(
                  builder: (BuildContext context) {
                    return Container(
                      height: size.height -
                          defaultAppBar().preferredSize.height * 2.5,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 80.0,
                            backgroundImage: NetworkImage(
                                HomeCubit.get(context).otherUserModel!.image!),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            HomeCubit.get(context).otherUserModel!.name!,
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
                            subtitle: Text(
                                HomeCubit.get(context).otherUserModel!.email!),
                            // onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('Phone'),
                            subtitle: Text(
                                HomeCubit.get(context).otherUserModel!.phone!),
                            // onTap: () {},
                          ),

                          SizedBox(
                            height: size.height * 0.1,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: defaultSubmit2(
                                text: 'Send Message',
                                background: Colors.grey,
                                onPressed: () {
                                  navigatAndReturn(
                                      context: context,
                                      page: ChatDetails(
                                        model: HomeCubit.get(context)
                                            .otherUserModel,
                                      ));
                                  // navigatAndReturn(
                                  //     context: context, page: UpdateUserForm());
                                }),
                          )
                        ],
                      ),
                    );

                    //  Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   // crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //       height: size.height * 0.05,
                    //     ),
                    //     CircleAvatar(
                    //       radius: 60,
                    //       backgroundColor: Colors.transparent,
                    //       backgroundImage: NetworkImage(
                    //           HomeCubit.get(context).otherUserModel!.image!),
                    //     ),
                    //     const SizedBox(
                    //       height: 20,
                    //     ),
                    //     Text(
                    //       HomeCubit.get(context).otherUserModel!.name!,
                    //       style: const TextStyle(
                    //           fontSize: 30, fontWeight: FontWeight.w400),
                    //     ),
                    //     const SizedBox(
                    //       height: 5,
                    //     ),
                    //     Text(
                    //       HomeCubit.get(context).otherUserModel!.email!,
                    //       style: const TextStyle(
                    //           fontSize: 20, fontWeight: FontWeight.w200),
                    //     ),
                    //     SizedBox(
                    //       height: size.height * 0.1,
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 20),
                    //       child: defaultSubmit2(
                    //           text: 'Send Message',
                    //           background: Colors.grey,
                    //           onPressed: () {
                    //             navigatAndReturn(
                    //                 context: context,
                    //                 page: ChatDetails(
                    //                   model:
                    //                       HomeCubit.get(context).otherUserModel,
                    //                 ));
                    //             // navigatAndReturn(
                    //             //     context: context, page: UpdateUserForm());
                    //           }),
                    //     )
                    //   ],
                    // );
                  },
                  condition: state is! LodinGetUserDetailState,
                  fallback: (BuildContext context) {
                    return SizedBox(
                        height: size.height -
                            defaultAppBar().preferredSize.height * 2,
                        width: size.width,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  },
                ),
              ),
            ));
      },
    ));
  }
}
