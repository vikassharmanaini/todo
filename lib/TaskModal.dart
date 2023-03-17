import 'package:hive/hive.dart';
part 'TaskModal.g.dart';

@HiveType(typeId: 0)
class TaskModal {
  @HiveField(0)
  String? task;
  @HiveField(2)
  String? endtime;
  @HiveField(5)
  String? enddate;
  @HiveField(3) 
  String? id;
  @HiveField(4)
  bool isCompleted;
  TaskModal(
      {this.task, this.id, this.endtime, required this.isCompleted,this.enddate});
}
