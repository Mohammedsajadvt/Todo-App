import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 1)
class TodoModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  bool activity;
  @HiveField(3)
  DateTime createdAt;

  TodoModel(
      {required this.title,
      required this.description,
      required this.activity,
      required this.createdAt});
}
