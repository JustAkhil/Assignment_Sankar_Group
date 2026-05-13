import 'package:assignment_sankar_group/constants/app_urls.dart';
import 'package:assignment_sankar_group/models/api_model.dart';
import 'package:assignment_sankar_group/services/api_service/api_bloc/api_event.dart';
import 'package:assignment_sankar_group/services/api_service/api_bloc/api_state.dart';
import 'package:assignment_sankar_group/services/api_service/api_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApiBloc extends Bloc<ApiEvent,ApiState>{
  ApiHelper apiHelper;
  ApiBloc({required this.apiHelper}):super(ApiInitialState()){
    on((event,emit)async{
      emit(ApiLoadingState());
      try{
        var data=await apiHelper.getApi(url: AppUrls.apiUrl);
        ApiModel apiModel=ApiModel.fromJson(data);
        emit(ApiSuccessState(apiModel: apiModel));
      }catch(e){
        emit(ApiErrorState(errMsg: e.toString()));
      }
    });
  }
}