import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/DoneList.dart';
import 'package:todo/TaskList.dart';
import 'package:todo/TaskModal.dart';

class MyHome extends StatefulWidget {
  MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  TextEditingController taskname = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  List<Widget> pageList = [
    TaskList(),
    DoneList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: pageList[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text('Welcome'),
              content: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: taskname,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), hintText: 'Task'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Select DeadLine',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(right: 5, top: 10),
                            child: DateTimePicker(
                              decoration: InputDecoration(
                                  hintText: 'Date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              initialValue: '',
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025),
                              dateLabelText: 'Date',
                              onChanged: (val) => date.text=val,
                              validator: (val) {
                                print(val);
                                return null;  
                              },
                              onFieldSubmitted: (value) => date.text=value,
                            ),
                          )),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, top: 10),
                              child: TextField(
                                controller: time,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: " Time"),
                                readOnly: true,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );

                                  if (pickedTime != null) {
                                    print(pickedTime.format(context));
                                    setState(() {
                                      time.text = pickedTime.format(context);
                                    });
                                  } else {
                                    print("Time is not selected");
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.all(30),
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                              setdata();
                            },
                            label: Text('Submit'),
                            heroTag: 'submit',
                          ))
                    ],
                  ))),
        ),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF5A2715),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: .3,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        elevation: 78,
        tilesPadding: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            backgroundColor: Color(0xFF5A2715),
            icon: Icon(
              Icons.dashboard,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.dashboard,
              color: Color(0xFF5A2715),
            ),
            title: Text("My Task"),
          ),
          BubbleBottomBarItem(
              backgroundColor: Color(0xFF5A2715),
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.menu,
                color: Color(0xFF5A2715),
              ),
              title: Text("Completed"))
        ],
      ),
    );
  }

  Future setdata() async {
   if (validate()) {
      final String id = DateTime.now().toString();
    var box = await Hive.openBox('task');
    if (box.isOpen) {
      box.put(
          id,
          TaskModal(
              id: id,
              task: taskname.text,
              enddate: date.text,
              endtime: time.text,
              isCompleted: false));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHome()));
    }
   }
  }

  bool validate() {
    if (taskname.text != null ||
        date.text != null ||
        time.text != null ||
        taskname.text != '' ||
        date.text != '' ||
        time.text != '') {
      return true;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill valid data')));
      return false;
    }
  }
}
