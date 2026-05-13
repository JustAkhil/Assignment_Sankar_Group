import 'package:assignment_sankar_group/models/user_model.dart';

abstract class AuthenticateEvent{}
class CreateUserEvent extends AuthenticateEvent{
  UserModel userModel;
  String pass;
  CreateUserEvent({required this.userModel,required this.pass});
}
class LoginUserEvent extends AuthenticateEvent{
  String email;
  String pass;
  LoginUserEvent({required this.email,required this.pass});
}