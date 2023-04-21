import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aaw/models/userModel.dart';
import 'package:flutter_aaw/pages/addUser.dart';
import 'package:flutter_aaw/pages/userDetail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Home/cubit/home_cubit.dart';
import '../shared/components/components.dart';
import '../shared/helper/cashHelper.dart';
import 'Auth/login/login.dart';

class Users extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          // floatingActionButton: defaultSubmit1(
          //   background: Colors.orangeAccent,
          //   onPressed: () {
          //     navigatAndReturn(context: context, page: AddUser());
          //   },
          //   isothericon: true,
          //   icon: const Icon(Icons.add),
          // ),

          body: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => defaultTask(
                  context, HomeCubit.get(context).userModelList[index], index),
              itemCount: HomeCubit.get(context).userModelList.length),
        );
      },
      listener: (BuildContext context, Object? state) async {
        if (state is DeleteUserStateGood) {
          showToast(msg: 'Deleted Successfully', state: ToastStates.success);

          Navigator.pop(context); //! hadi t3 showdialog
        } else if (state is DeleteUserStateBad) {
          showToast(msg: state.err, state: ToastStates.error);
        }
      },
    );
  }
}

Widget defaultTask(context, UserModel model, int id) => Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          navigatAndReturn(
              context: context,
              page: UserDetail(
                model: model,
              ));
        },
        // onLongPress: () {
        //   showDialog(
        //       context: context,
        //       builder: (context) {
        //         return AlertDialog(
        //           actions: [
        //             TextButton(
        //                 onPressed: () {},
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     const Icon(
        //                       Icons.delete,
        //                       color: Colors.red,
        //                     ),
        //                     const SizedBox(
        //                       width: 10,
        //                     ),
        //                     TextButton(
        //                       onPressed: () {
        //                         // HomeCubit.get(context)
        //                         //     .deleteUser(id: model.id!);
        //                       },
        //                       child: const Text(
        //                         'Delete',
        //                         style: TextStyle(
        //                           color: Colors.red,
        //                         ),
        //                       ),
        //                     )
        //                   ],
        //                 ))
        //           ],
        //         );
        //       });
        // },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(model.image!),
          ),
        ),
        title: Text(
          model.name!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.pink.shade800,
            ),
            Text(
              model.email!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        trailing: Icon(
          Icons.messenger_outline_outlined,
          size: 30,
          color: Colors.pink[800],
        ),
      ),
    );
