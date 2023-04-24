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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener

        // ! hadi bh yscroll lal end dima (mb3d n3awedha tban mch s7i7a 100% )
        if (state is GetMessageDataStateGood) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent,
              );
            }
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(model.image!),
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
                    // _scrollController
                    //     .jumpTo(_scrollController.position.maxScrollExtent);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                HomeCubit.get(context).messageModelList.length,
                            itemBuilder: (context, index) {
                              final message = HomeCubit.get(context)
                                  .messageModelList[index];
                              final isMe =
                                  message.resiverId == model.id ? true : false;

                              return MessageBubble(
                                message: message.text!,
                                isMe: isMe,
                                // model: model,
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    hintText: "Type a message...",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  if (messageController.text != '') {
                                    HomeCubit.get(context).sendMessage(
                                        otheruser: model.id,
                                        message: messageController.text);
                                    messageController.clear();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  condition: true,
                  // HomeCubit.get(context).messageModelList.isNotEmpty,
                  fallback: (BuildContext context) {
                    return Container();
                  },
                ),
              ),
              // Container(
              //   // padding: EdgeInsets.only(bottom: 10),
              //   margin: const EdgeInsets.only(bottom: 15),
              //   clipBehavior: Clip.antiAliasWithSaveLayer,
              //   decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey[300]!, width: 1),
              //       borderRadius: BorderRadius.circular(15)),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 15),
              //           child: TextFormField(
              //             controller: messageController,
              //             decoration: const InputDecoration(
              //                 hintText: 'Message..',
              //                 border: InputBorder.none,
              //                 hintStyle: TextStyle(
              //                     fontSize: 20, fontWeight: FontWeight.w400)),
              //           ),
              //         ),
              //       ),
              //       Container(
              //         height: 60,
              //         color: Colors.blue,
              //         child: MaterialButton(
              //           onPressed: () {
              //             if (messageController.text != '') {
              //               HomeCubit.get(context).sendMessage(
              //                   otheruser: model.id,
              //                   message: messageController.text);
              //               messageController.clear();
              //             }
              //           },
              //           minWidth: 1,
              //           child: const Icon(
              //             Icons.send,
              //             color: Colors.white,
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  // buildReciveMessage(String? text) => Align(
  //       alignment: Alignment.topLeft,
  //       child: Container(
  //         // clipBehavior: Clip.antiAliasWithSaveLayer,
  //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //         // height: 50,

  //         decoration: BoxDecoration(
  //             color: Colors.grey[200],
  //             borderRadius: const BorderRadiusDirectional.only(
  //                 bottomEnd: Radius.circular(12),
  //                 topEnd: Radius.circular(12),
  //                 topStart: Radius.circular(12))),
  //         child: Text(
  //           text!,
  //           // textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
  //         ),
  //       ),
  //     );
  // buildMyMessage(String? text) => Align(
  //       alignment: Alignment.topRight,
  //       child: Container(
  //         // clipBehavior: Clip.antiAliasWithSaveLayer,
  //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //         // height: 50,

  //         decoration: BoxDecoration(
  //             color: Colors.blue[200],
  //             borderRadius: const BorderRadiusDirectional.only(
  //                 // bottomEnd: Radius.circular(12),
  //                 bottomStart: Radius.circular(12),
  //                 topEnd: Radius.circular(12),
  //                 topStart: Radius.circular(12))),
  //         child: Text(
  //           text!,
  //           // textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
  //         ),
  //       ),
  //     );
}

class MessageBubble extends StatelessWidget {
  // final _scrollController = ScrollController();

  final String message;
  final bool isMe;
  // final model;
  MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    // required this.model
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) {
    //     _scrollController.jumpTo(
    //       _scrollController.position.maxScrollExtent,
    //     );
    //   }
    // });

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomLeft: isMe ? Radius.circular(16.0) : Radius.circular(0),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(16.0),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
