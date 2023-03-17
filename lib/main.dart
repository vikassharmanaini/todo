import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/MyHome.dart';
import 'package:todo/TaskModal.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = await getApplicationSupportDirectory();
  Hive
    ..init(path.path)
    ..registerAdapter(TaskModalAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(brightness: Brightness.light, primarySwatch: Colors.brown),
      home: MyHome(),
    );
  }
}
