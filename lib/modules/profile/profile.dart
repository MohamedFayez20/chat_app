import 'package:buildcondition/buildcondition.dart';
import 'package:chat/shared/cubit/user/user_cubit.dart';
import 'package:chat/shared/cubit/user/user_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: UserCubit.get(context).image==null?NetworkImage(
                          '${UserCubit.get(context).model!.image}')
                    :FileImage(UserCubit.get(context).image!)as ImageProvider),
                    CircleAvatar(
                        radius: 25,
                        child: IconButton(
                            onPressed: () {
                              UserCubit.get(context).getImage();
                            },
                            icon: Icon(Icons.camera_alt_outlined)))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '${UserCubit.get(context).model!.name}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '${UserCubit.get(context).model!.name}',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: '${UserCubit.get(context).model!.phone}',
                    prefixIcon: Icon(Icons.phone),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '${UserCubit.get(context).model!.email}',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                BuildCondition(
                  condition: state is! UpdateImageLoadingState,
                  builder: (context) => Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        UserCubit.get(context).uploadImage();
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(
                            color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                  fallback: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
