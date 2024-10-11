import 'package:flutter/material.dart';
import 'package:todo/localization/localization_keys.dart';
import 'package:todo/screens/add_todo_screen.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/utils/app_localization_class.dart';
import 'package:todo/widgets/todo_list_widget.dart';
import 'package:todo/utils/snack_helper.dart';
import 'package:todo/widgets/nothing_widget.dart';

class TodoListScreen extends StatefulWidget {
  final Function changeLangCallback;

  const TodoListScreen({super.key, required this.changeLangCallback});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      fetchTodo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationKeys.todoList.tr(context)),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                widget.changeLangCallback();
              },
              child: Text(LocalizationKeys.language.tr(context)))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text(LocalizationKeys.addTodo.tr(context)),
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
          child: const Center(child: CircularProgressIndicator())),
    );
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
      if (mounted) {
        showErrorMessage(context, message: LocalizationKeys.deleteFailed.tr(context));
      }
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      if (mounted) {
        showErrorMessage(context, message: "Something went wrong");
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
