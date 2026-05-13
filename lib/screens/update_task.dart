import 'package:assignment_sankar_group/models/task_model.dart';
import 'package:assignment_sankar_group/services/firebase_repository/firebase_repository.dart';
import 'package:flutter/material.dart';

class UpdateTaskPage extends StatefulWidget {
   UpdateTaskPage({super.key});

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final FirebaseRepository repo = FirebaseRepository.getInstance();

  TaskModel? task;
  String? taskId;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DateTime? selectedDate;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map;

    task = args["task"];
    taskId = args["taskId"];

    titleController.text = task!.title;
    descController.text = task!.desc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffF4F6FA),

      appBar: AppBar(
        title:  Text("Update Task"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding:  EdgeInsets.all(16),
        child: Column(
          children: [

            // Card UI
            Container(
              padding:  EdgeInsets.all(16),
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
              child: Column(
                children: [

                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      prefixIcon:  Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                   SizedBox(height: 15),

                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      prefixIcon:  Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                   SizedBox(height: 15),

                  Container(
                    padding:  EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                         Icon(Icons.calendar_month,
                            color: Colors.blue),

                         SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? task!.date
                                : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                            style:  TextStyle(fontSize: 14),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                 Duration(days: 365),
                              ),
                              initialDate: DateTime.now(),
                            );

                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child:  Text("Change"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

             Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onPressed: isLoading
                    ? null
                    : () async {
                  setState(() => isLoading = true);

                  await repo.updateTask(
                    taskId: taskId!,
                    task: TaskModel(
                      title: titleController.text,
                      desc: descController.text,
                      date: selectedDate == null
                          ? task!.date
                          : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                      check: task!.check,
                    ),
                  );

                  setState(() => isLoading = false);

                  Navigator.pop(context);
                },

                child: isLoading
                    ?  SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    :  Text(
                  "Update Task",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}