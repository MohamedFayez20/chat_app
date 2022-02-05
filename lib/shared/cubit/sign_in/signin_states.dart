abstract class SignInStates {}

class SignInInitialState extends SignInStates {}

class VisibilityState extends SignInStates {}

class SignInLoadingState extends SignInStates {}

class SignInSuccessState extends SignInStates {
  final String uId;

  SignInSuccessState(this.uId);
}

class SignInErrorState extends SignInStates {
  final String error;

  SignInErrorState(this.error);
}
