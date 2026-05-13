import 'dart:async';

import 'package:assignment_sankar_group/services/firebase_repository/firebase_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authenticate_event.dart';
import 'authenticate_state.dart';

class AuthenticateBloc extends Bloc<AuthenticateEvent,AuthenticateState>{
  FirebaseRepository firebaseRepository;
  AuthenticateBloc({required this.firebaseRepository}):super(AuthenticateInitialState()){
    on<CreateUserEvent>((event,emit)async{
      emit(AuthenticateLoadingState());
      try{
        await firebaseRepository.createUser(user: event.userModel,pass: event.pass);
        emit(AuthenticateSignupSuccessState());
      }catch(e){
        emit(AuthenticateFailureState(errMsg: e.toString()));
      }
    });
    on<LoginUserEvent>((event,emit)async{
      emit(AuthenticateLoadingState());
      try{
        await firebaseRepository.loginUser(email:event.email, pass: event.pass);
        emit(AuthenticateLoginSuccessState());
      }catch(e){
        emit(AuthenticateFailureState(errMsg: e.toString()));
      }
    });
  }

}