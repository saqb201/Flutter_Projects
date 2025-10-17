class TodoModel {
  final String id;
  final String title;
  bool isDone;

  TodoModel({required this.id, required this.title, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}
