abstract class AuthenticateState {}
class AuthenticateInitialState extends AuthenticateState{}
class AuthenticateLoadingState extends AuthenticateState{}
class AuthenticateLoginSuccessState extends AuthenticateState{}
class AuthenticateSignupSuccessState extends AuthenticateState{}
class AuthenticateFailureState extends AuthenticateState{
  String errMsg;
  AuthenticateFailureState({required this.errMsg});
}