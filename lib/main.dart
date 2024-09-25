import 'package:flutter/material.dart';
import 'package:todo/screens/todo_list_screen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TodoListScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}
