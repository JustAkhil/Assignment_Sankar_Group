import 'package:assignment_sankar_group/constants/routes/app_routes.dart';
import 'package:assignment_sankar_group/screens/authenticate_bloc/authenticate_bloc.dart';
import 'package:assignment_sankar_group/services/api_service/api_bloc/api_bloc.dart';
import 'package:assignment_sankar_group/services/api_service/api_helper.dart';
import 'package:assignment_sankar_group/services/firebase_repository/firebase_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ApiBloc(apiHelper: ApiHelper())),
      BlocProvider(create: (_)=>AuthenticateBloc(firebaseRepository: FirebaseRepository.getInstance()))],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.selectionPage,
      routes: AppRoutes.appRoutes(),
    );
  }
}
