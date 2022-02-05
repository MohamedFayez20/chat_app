import 'package:chat/shared/cubit/sign_in/signin_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit() : super(SignInInitialState());
  static SignInCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  Icon suffix = Icon(Icons.visibility);
  void changeVisibility() {
    isPassword = !isPassword;
    if (isPassword == false) {
      suffix = Icon(Icons.visibility_off_outlined);
    } else {
      suffix = Icon(Icons.visibility);
    }
    emit(VisibilityState());
  }

  void userSignIn({
    required String email,
    required String password,
  }) {
    emit(SignInLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {

          emit(SignInSuccessState(value.user!.uid));
    })
        .catchError((error) {
          emit(SignInErrorState(error.toString()));
    });
  }
}
