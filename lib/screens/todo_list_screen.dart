import 'package:flutter/material.dart';
import 'package:todo/screens/add_todo_screen.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/widgets/todo_list_widget.dart';
import 'package:todo/utils/snack_helper.dart';
import 'package:todo/widgets/nothing_widget.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Todo List"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage,
          label: const Text("Add Todo"),
        ),
        body: Visibility(
            visible: isLoading,
            replacement: RefreshIndicator(
                onRefresh: fetchTodo,
                child: Visibility(
                    visible: items.isNotEmpty,
                    replacement: const NothingWidget(),
                    child: TodoListWidget(
                      items: items,
                      deleteById: deleteById,
                      navigationEditCallback: navigateToEditPage,
                    ))),
            child: const Center(child: CircularProgressIndicator())));
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoScreen(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoScreen(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {});
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    // delete item
    final isSuccess = await TodoService.deleteById(id);
    //remove item from list
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //show error
      if(mounted){
      showErrorMessage(context, message: "Deletion Failed");
    }}
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      if(mounted){
      showErrorMessage(context, message: "Something went wrong");
    }}
    setState(() {
      isLoading = false;
    });
  }
}
