import 'package:assignment_sankar_group/models/task_model.dart';
import 'package:assignment_sankar_group/services/firebase_repository/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/routes/app_routes.dart';

class TaskPage extends StatefulWidget {
   TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final FirebaseRepository repo = FirebaseRepository.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffF4F6FA),

      appBar: AppBar(
        title:  Text("My Tasks"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: ()async{
            SharedPreferences prefs=await SharedPreferences.getInstance();
            prefs.setString(FirebaseRepository.PREFS_USER_ID_KEY, "");
            Navigator.pushNamed(context,AppRoutes.selectionPage);
          }, icon: Icon(Icons.logout)),
          SizedBox(),
          IconButton(
            icon:  Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addTaskPage);
            },
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: repo.getAllTask(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return  Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return  Center(
              child: Text(
                "No Tasks Found",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          final tasks = snapshot.data!.docs;

          return ListView.separated(
            padding:  EdgeInsets.all(16),
            itemCount: tasks.length,
            separatorBuilder: (_, __) =>  SizedBox(height: 12),
            itemBuilder: (context, index) {

              TaskModel task = TaskModel.fromMap(tasks[index].data());

              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.updateTaskPage,
                    arguments: {
                      "task": task,
                      "taskId": tasks[index].id,
                    },
                  );
                },
                borderRadius: BorderRadius.circular(16),

                child: Container(
                  padding:  EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow:  [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      Checkbox(
                        value: task.check,
                        activeColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (value) async {
                          await repo.updateTask(
                            task: TaskModel(
                              title: task.title,
                              desc: task.desc,
                              date: task.date,
                              check: value ?? false,
                            ),
                            taskId: tasks[index].id,
                          );
                        },
                      ),

                       SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: task.check
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: task.check
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),

                             SizedBox(height: 6),

                            Text(
                              task.desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                decoration: task.check
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),

                             SizedBox(height: 8),

                            Container(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                task.date,
                                style:  TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        icon:  Icon(Icons.delete_outline),
                        color: Colors.red,
                        onPressed: () async {
                          await repo.deleteTask(taskId: tasks[index].id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}