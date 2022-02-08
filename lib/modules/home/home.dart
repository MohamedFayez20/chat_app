import 'package:buildcondition/buildcondition.dart';
import 'package:chat/models/message_model/message_model.dart';
import 'package:chat/modules/chat_details/chat_details.dart';
import 'package:chat/shared/cubit/user/user_cubit.dart';
import 'package:chat/shared/cubit/user/user_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model/user_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            body: BuildCondition(
          condition: !UserCubit.get(context).users.isEmpty,
          builder: (context) => Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => chatItem(
                            UserCubit.get(context).users[index],
                            context,
                            index,
                          ),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      itemCount: UserCubit.get(context).users.length),
                ),
              ],
            ),
          ),
          fallback: (context) => Center(
            child: IconButton(
              onPressed: () {
                UserCubit.get(context).getUsers();
              },
              icon: Icon(
                Icons.refresh,
                size: 40,
                color: Colors.teal,
              ),
            ),
          ),
        ));
      },
    );
  }

  Widget chatItem(UserModel model, context, index) => Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
        ),
        child: InkWell(
          highlightColor: Colors.teal.shade200,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), bottomLeft: Radius.circular(40)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(
                  model: model,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage('${model.image}')),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        !UserCubit.get(context).messages.isEmpty
                            ? Text(
                                '${UserCubit.get(context).messages.last.dateTime}',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade700),
                              )
                            : SizedBox(width: 0)
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                        UserCubit
                            .get(context)
                            .messages
                            .isEmpty
                            ? SizedBox(
                          width: 1,
                        )
                            : Text(
                          '${UserCubit
                              .get(context)
                              .messages
                              .last
                              .text}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey.shade600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
