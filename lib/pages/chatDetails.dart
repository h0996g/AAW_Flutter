import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Home/cubit/home_cubit.dart';
import '../shared/components/components.dart';

class ChatDetails extends StatelessWidget {
  final model;
  final messageController = TextEditingController();
  final _scrollController = ScrollController();

  ChatDetails({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getMessage(reciverUid: model.id);

    // HomeCubit.get(context).getMessage(reciverUid: model.uid!);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) {
    //     _scrollController.jumpTo(
    //       _scrollController.position.maxScrollExtent,
    //     );
    //   }
    // });
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener

        // ! hadi bh yscroll lal end dima (mb3d n3awedha tban mch s7i7a 100% )
        // if (state is GetMessageDataStateGood) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     if (_scrollController.hasClients) {
        //       _scrollController.jumpTo(
        //         _scrollController.position.maxScrollExtent,
        //       );
        //     }
        //   });
        // }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
              title: Row(
                children: [
                  const CircleAvatar(
                      // backgroundImage: NetworkImage(model.img!),
                      ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(model.name!)
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          body: Column(
            children: [
              Expanded(
                child: ConditionalBuilder(
                  builder: (BuildContext context) {
                    // scrollController
                    //     .jumpTo(scrollController.position.maxScrollExtent);

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),

                                // addAutomaticKeepAlives: false,
                                // addSemanticIndexes: false,

                                // addRepaintBoundaries: false,
                                itemBuilder: ((context, index) {
                                  if (model.id ==
                                      HomeCubit.get(context)
                                          .messageModelList[index]
                                          .resiverId) {
                                    return buildMyMessage(HomeCubit.get(context)
                                        .messageModelList[index]
                                        .text);
                                  }
                                  return buildReciveMessage(
                                      HomeCubit.get(context)
                                          .messageModelList[index]
                                          .text);
                                }),
                                separatorBuilder: ((context, index) =>
                                    const SizedBox(
                                      height: 15,
                                    )),
                                itemCount: HomeCubit.get(context)
                                    .messageModelList
                                    .length
                                //  HomeCubit.get(context)
                                //     .messageModelList
                                //     .length,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                  condition: true,
                  // HomeCubit.get(context).messageModelList.isNotEmpty,
                  fallback: (BuildContext context) {
                    return Container();
                  },
                ),
              ),
              Container(
                // padding: EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.only(bottom: 15),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: messageController,
                          decoration: const InputDecoration(
                              hintText: 'Message..',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      color: Colors.blue,
                      child: MaterialButton(
                        onPressed: () {
                          if (messageController.text != '') {
                            HomeCubit.get(context).sendMessage(
                                otheruser: model.id,
                                message: messageController.text);
                            messageController.clear();
                          }
                        },
                        minWidth: 1,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildReciveMessage(String? text) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          // height: 50,

          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(12),
                  topEnd: Radius.circular(12),
                  topStart: Radius.circular(12))),
          child: Text(
            text!,
            // textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
          ),
        ),
      );
  buildMyMessage(String? text) => Align(
        alignment: Alignment.topRight,
        child: Container(
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          // height: 50,

          decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: const BorderRadiusDirectional.only(
                  // bottomEnd: Radius.circular(12),
                  bottomStart: Radius.circular(12),
                  topEnd: Radius.circular(12),
                  topStart: Radius.circular(12))),
          child: Text(
            text!,
            // textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
          ),
        ),
      );
}
