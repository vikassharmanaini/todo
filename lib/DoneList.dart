import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/MyHome.dart';
import 'package:todo/TaskModal.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<TaskModal>? response;
  List<TaskModal> response2 = [];
  @override
  Widget build(BuildContext context) {
    if (response != null) {
      response2 = [];
      for (var element in response!) {
        if (!element.isCompleted) {
          response2.add(element);
        }
      }
    }
    return (response == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (response2.length == 0)
            ? Center(
                child: Text('Please Create New Task'),
              )
            : Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: response2.length,
                        itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 3,
                                        blurStyle: BlurStyle.outer)
                                  ]),
                              child: Draggable(
                                data: response2[index].id,
                                child: ListTile(
                                  leading: Text('${index + 1}'), 
                                  trailing: Icon(Icons.arrow_right_rounded),
                                  subtitle: Text(
                                      'Deadline : ${response2[index].enddate} ${response2[index].endtime}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  title: Text(
                                    response2[index].task.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                feedback: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: Image.asset(
                                      'assets/Screenshot_from_2023-02-22_00-40-37-removebg-preview.png',
                                    )),
                                childWhenDragging: Container(),
                              ),
                            )),
                  ),
                  Positioned(
                      bottom: 10,
                      left: -10,
                      child: DragTarget<String>(builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                      ) {
                        return Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(59, 255, 255, 255),
                                shape: BoxShape.circle),
                            child: Image.asset(
                              'assets/done.png',
                              width: 70,
                              height: 70,
                            ));
                      }, onWillAccept: (data) {
                        return true;
                      }, onAccept: (data) {
                        completedlocal(data);
                      }))
                ],
              );
  }

  Future getData() async {
    var box = await Hive.openBox('task');
    if (box.isOpen) {
      setState(() {
        if (box.isNotEmpty) {
          response = box.values.cast<TaskModal>().toList();
        } else {
          response = [];
        }
      });
    }
    box.close();
  }

  Future completedlocal(String param) async {
    var box = await Hive.openBox('task');
    if (box.isOpen) {
      TaskModal t = await box.get(param);
      t.isCompleted = true;
      box.put(param, t);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHome()));
    }
  }
}
