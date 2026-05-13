class TaskModel {
  String title;
  String desc;
  String date;
  bool check;

  TaskModel({
    required this.title,
    required this.desc,
    required this.date,
    required this.check,
  });

  factory TaskModel.fromMap(Map<String, dynamic> data) {
    return TaskModel(
      title: data["title"],
      desc: data["desc"],
      date: data["date"],
      check: data["check"]??false,
    );
  }
  Map<String, dynamic> toDoc() {
    return {
      "title": title,
      "desc": desc,
      "date": date,
      "check": check,
    };
  }
}
