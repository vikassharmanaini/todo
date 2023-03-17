import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/MyHome.dart';
import 'package:todo/TaskModal.dart';

class DoneList extends StatefulWidget {
  const DoneList({super.key});

  @override
  State<DoneList> createState() => _DoneListState();
}

class _DoneListState extends State<DoneList> {
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
        if (element.isCompleted) {
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
                child: Text('Please Complete Some New Task'),
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
                                        blurRadius: 5,
                                        blurStyle: BlurStyle.outer)
                                  ]),
                              child: Draggable(
                                data: response2[index].id,
                                child: ListTile(
                                  leading: Text('${index + 1}'),
                                  trailing: Icon(Icons.delete),
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
                                      'assets/Screenshot_from_2023-02-22_00-26-58-removebg-preview.png',
                                    )),
                                childWhenDragging: Container(),
                              ),
                            )),
                  ),
                  Positioned(
                      bottom: 10,
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
                              'assets/Screenshot_from_2023-02-22_00-06-38-removebg-preview.png',
                              width: 100,
                              height: 100,
                            ));
                      }, onWillAccept: (data) {
                        return true;
                      }, onAccept: (data) {
                        deletelocal(data);
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

  Future deletelocal(String param) async {
    var box = await Hive.openBox('task');
    if (box.isOpen) {
      print(param);
      box.delete(param);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHome()));
    }
  }
}
