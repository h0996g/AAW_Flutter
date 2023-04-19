import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Home/cubit/home_cubit.dart';
import '../shared/components/components.dart';
import '../shared/helper/cashHelper.dart';
import 'Auth/login/login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeCubit _homeCubit = BlocProvider.of(context);
    return BlocConsumer<HomeCubit, HomeState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            // type: BottomNavigationBarType.fixed,
            onTap: (index) {
              _homeCubit.changeButtonNav(index);
            },
            items: const [
              BottomNavigationBarItem(
                label: 'Chats',
                icon: Icon(Icons.chat_bubble),
              ),
              BottomNavigationBarItem(
                label: 'People',
                icon: Icon(Icons.people),
              ),
              BottomNavigationBarItem(
                label: 'Setting',
                icon: Icon(Icons.settings),
              ),
            ],
            currentIndex: _homeCubit.currentIndex,
          ),
          floatingActionButton: FloatingActionButton(onPressed: () {
            CachHelper.removdata(key: "token").then((value) {
              // _homeCubit.resetWhenLogout();
              navigatAndFinish(context: context, page: Login());
            });
          }),
          appBar: AppBar(
            title: Text(_homeCubit.appbarScreen[_homeCubit.currentIndex]),
          ),
          body: ConditionalBuilder(
            builder: (BuildContext context) {
              return _homeCubit.userScreen[_homeCubit.currentIndex];
            },
            condition: true,
            fallback: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
      listener: (BuildContext context, Object? state) {
        // if (state is ChangeButtonNavStateToAddPostsGood) {
        //   navigatAndReturn(context: context, page: const AddPost());
        // }
      },
    );
  }
}
