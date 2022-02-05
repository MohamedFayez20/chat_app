import 'package:chat/layout/layout.dart';
import 'package:chat/shared/cubit/user/user_cubit.dart';
import 'package:chat/shared/network/local/cache_helper.dart';
import 'package:chat/shared/network/remote/dio_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/welcome/welcome.dart';
import 'shared/component/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  DioHelper.init();
  uId=CacheHelper.getData(key: 'uId');
  Widget widget;
    if (uId != null) {
      widget = Layout();
    } else {
    widget = WelcomeScreen();
  }
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  late Widget startWidget;
  MyApp({required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>UserCubit()..getUserData()..getUsers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.teal,
          primarySwatch: Colors.teal
        ),
        home: startWidget,
      ),
    );
  }
}
