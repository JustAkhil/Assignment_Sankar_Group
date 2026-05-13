import '../../../models/api_model.dart';

abstract class ApiState {}
class ApiLoadingState extends ApiState{

}
class ApiErrorState extends ApiState{
  String errMsg;
  ApiErrorState({required this.errMsg});
}
class ApiSuccessState extends ApiState{
  ApiModel apiModel;
  ApiSuccessState({required this.apiModel});
}
class ApiInitialState extends ApiState{

}