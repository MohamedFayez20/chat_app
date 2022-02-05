import 'package:buildcondition/buildcondition.dart';
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
          condition: UserCubit.get(context).users.length > 0,
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
                          UserCubit.get(context).users[index], context),
                      separatorBuilder: (context, index) => Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: EdgeInsets.only(top: 20, left: 10),
                          ),
                      itemCount: UserCubit.get(context).users.length),
                ),
              ],
            ),
          ),
          fallback: (context) => Center(
            child: IconButton(
              onPressed: (){
                UserCubit.get(context).getUsers();
              },
              icon: Icon(Icons.refresh,size: 40,color: Colors.teal,),
            ),
          ),
        ));
      },
    );
  }

  Widget chatItem(UserModel model, context) => Container(
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
                        )));
          },
          child: Row(
            children: [
              CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage('${model.image}')),
              SizedBox(
                width: 20,
              ),
              Text(
                '${model.name}',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              )
            ],
          ),
        ),
      );
}
