import 'package:assignment_sankar_group/models/task_model.dart';
import 'package:assignment_sankar_group/services/firebase_repository/firebase_repository.dart';
import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
   AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final FirebaseRepository repo = FirebaseRepository.getInstance();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  DateTime? selectedDate;
  bool isLoading = false;

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add( Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffF4F6FA),

      appBar: AppBar(
        title:  Text("Add Task"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding:  EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [

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

                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Task Title",
                        prefixIcon:  Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) =>
                      v == null || v.isEmpty ? "Enter title" : null,
                    ),

                     SizedBox(height: 15),

                    TextFormField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Task Description",
                        prefixIcon:  Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) =>
                      v == null || v.isEmpty ? "Enter description" : null,
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
                                  ? "No date selected"
                                  : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                            ),
                          ),

                          ElevatedButton(
                            onPressed: pickDate,
                            child:  Text("Pick"),
                          ),
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

                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      TaskModel task = TaskModel(
                        title: titleController.text,
                        desc: descController.text,
                        date: selectedDate == null
                            ? ""
                            : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                        check: false,
                      );

                      if (task.date.isNotEmpty) {
                        await repo.addTask(task: task);
                        setState(() => isLoading = false);
                        Navigator.pop(context);
                      } else {
                        setState(() => isLoading = false);

                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text("Please select a date"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
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
                      :  Text("Add Task"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}