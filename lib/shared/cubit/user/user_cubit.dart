import 'dart:io';

import 'package:chat/modules/home/home.dart';
import 'package:chat/models/message_model/message_model.dart';
import 'package:chat/models/user_model/user_model.dart';
import 'package:chat/modules/profile/profile.dart';
import 'package:chat/shared/cubit/user/user_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../component/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());
  static UserCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    Profile(),
  ];
  List<String> titles = ['Chats', 'Profile'];
  void changeNavBar(index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  UserModel? model;
  void getUserData() {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId!).get().then((value) {
      model = UserModel.fromJson(value.data()!);
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState());
    });
  }

  List<UserModel> users = [];
  void getUsers() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          print('hello');
          print(model!.uId);
          if (element.data()['uId'] != model!.uId)
            users.add(UserModel.fromJson(element.data()));
        });
        emit(GetUserSuccessState());
      }).catchError((error) {
        emit(GetUserErrorState());
      });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel messageModel = MessageModel(
      text: text,
      dateTime: dateTime,
      senderId: model!.uId,
      receiverId: receiverId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(model!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  void getMessages({required receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }

  File? image;
  var picker = ImagePicker();
  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(ProfileImageSuccessState());
    } else {
      print('No image selected');
      emit(ProfileImageErrorState());
    }
  }

  void uploadImage() {
    emit(UpdateImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(image!.path).pathSegments.last}')
        .putFile(image!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        updateUser(image:value,);
      }).catchError((error) {
        emit(UploadImageErrorState());
      });
    }).catchError((error) {
      emit(UploadImageErrorState());
    });
  }



  void updateUser({String? image}) {
    emit(UpdateImageLoadingState());
    UserModel userModel = UserModel(
      name: model!.name,
      image: image??model!.image,
      email: model!.email,
      phone: model!.phone,
      uId: model!.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .update(userModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateImageErrorState());
    });
  }

}
