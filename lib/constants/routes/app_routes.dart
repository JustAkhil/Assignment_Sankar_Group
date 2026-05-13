import 'package:assignment_sankar_group/screens/api_screen.dart';
import 'package:flutter/cupertino.dart';

import '../../screens/add_task_page.dart';
import '../../screens/login_page.dart';
import '../../screens/selection_page.dart';
import '../../screens/signup_page.dart';
import '../../screens/task_screen.dart';
import '../../screens/update_task.dart';

class AppRoutes {
  static const String addTaskPage = "add_task_page";
  static const String apiPage = "api_page";
  static const String loginPage = "login_page";
  static const String signupPage = "signup_page";
  static const String taskPage = "task_page";
  static const String updateTaskPage = "update_task_page";
  static const String selectionPage = "selection_page";



  static Map<String, WidgetBuilder> appRoutes() {
    return {
      apiPage: (_) => ApiScreen(),
      loginPage: (_) => LoginPage(),
      signupPage: (_) => SignUpPage(),
      taskPage: (_) => TaskPage(),
      addTaskPage: (_) => AddTaskPage(),
      updateTaskPage: (_) => UpdateTaskPage(),
      selectionPage: (_) => SelectionPage(),
    };
  }
}
