import 'package:chat/shared/cubit/user/user_cubit.dart';
import 'package:chat/shared/cubit/user/user_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit,UserStates>(
      listener: (context,state){},
      builder: (context,state)=>Scaffold(
        appBar: AppBar(
          title: Text(
            UserCubit.get(context).titles[UserCubit.get(context).currentIndex],
          ),
        ),
        body: UserCubit.get(context).screens[UserCubit.get(context).currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            UserCubit.get(context).changeNavBar(index);
          },
          currentIndex: UserCubit.get(context).currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_outlined,
                ),
                label: 'Chats'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
