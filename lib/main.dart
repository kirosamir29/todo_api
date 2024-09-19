import 'package:flutter/material.dart';
import 'package:todo/screens/todo_list.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}
