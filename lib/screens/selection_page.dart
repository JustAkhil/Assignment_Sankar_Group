import 'package:assignment_sankar_group/services/firebase_repository/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/routes/app_routes.dart';

class SelectionPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, AppRoutes.apiPage);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: Center(child: Text("Api Assignment")),
                ),
              ),
            ),
            SizedBox(width: 50,),
            InkWell(
              onTap: ()async{
                SharedPreferences prefs=await SharedPreferences.getInstance();
                var id=prefs.getString(FirebaseRepository.PREFS_USER_ID_KEY);
                if(id!=""){
                  Navigator.pushNamed(context, AppRoutes.taskPage);
                }else{
                  Navigator.pushNamed(context, AppRoutes.loginPage);
                }
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: Center(child: Text("Task Assignment")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}