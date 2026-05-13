import 'package:assignment_sankar_group/models/api_model.dart';
import 'package:assignment_sankar_group/services/api_service/api_bloc/api_bloc.dart';
import 'package:assignment_sankar_group/services/api_service/api_bloc/api_event.dart';
import 'package:assignment_sankar_group/services/api_service/api_bloc/api_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApiScreen extends StatefulWidget {
  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ApiBloc>().add(FetchDataApiEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Api Screen"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<ApiBloc,ApiState>(builder: (_,state){
                if(state is ApiLoadingState){
                  return CircularProgressIndicator();
                }
                if(state is ApiSuccessState){
                  ApiModel data= state.apiModel;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.format_quote, size: 40),
                      SizedBox(height: 12),
                      Text(
                        data.content??"Quote not found",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          data.author??"Unknown Author",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: data.tags!.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(tag),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Added on: ${data.dateAdded??"Unknown"}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                }
                if(state is ApiErrorState){
                  return Text(state.errMsg);
                }
                return Container();
              })
            ),
          ),
        ),
      ),
    );
  }
}