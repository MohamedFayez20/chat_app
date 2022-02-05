import 'package:chat/models/message_model/message_model.dart';
import 'package:chat/models/user_model/user_model.dart';
import 'package:chat/shared/cubit/user/user_cubit.dart';
import 'package:chat/shared/cubit/user/user_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chat extends StatelessWidget {
  UserModel model;
  Chat({required this.model});
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        UserCubit.get(context).getMessages(receiverId: model.uId);
        return BlocConsumer<UserCubit, UserStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: UserCubit.get(context).image==null?NetworkImage(
                          '${UserCubit.get(context).model!.image}')
                          :FileImage(UserCubit.get(context).image!)as ImageProvider),
                    SizedBox(
                      width: 15,
                    ),
                    Text('${model.name}'),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 17,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if(UserCubit.get(context).model!.uId==UserCubit.get(context).messages[index].senderId)
                              return myMessageItem(UserCubit.get(context).messages[index]);
                            else
                              return messageItem(UserCubit.get(context).messages[index]);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                          itemCount: UserCubit.get(context).messages.length),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1.0),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                  hintText: 'type your message here ...',
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            color: Colors.teal,
                            height: 50.0,
                            child: MaterialButton(
                              onPressed: () {
                                UserCubit.get(context).sendMessage(
                                    receiverId: model.uId!,
                                    dateTime: DateTime.now().toString(),
                                    text: messageController.text);
                              },
                              minWidth: 1.0,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget myMessageItem(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Text(
            '${model.text}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
  Widget messageItem(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Text(
            '${model.text}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
}
