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
  Map? selectedItem;
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
      body:isPortraitMode() ? _buildPortraitWidget() : _buildLandscapeWidget(),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoScreen(
        isLandscape: false,
      ),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoScreen(isLandscape: false, todo: item),
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

  Widget _buildPortraitWidget() {
    return Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: Visibility(
                visible: items.isNotEmpty,
                replacement: const NothingWidget(),
                child: TodoListWidget(
                  items: items,
                  deleteById: (id) {
                    deleteById(id);
                  },
                  navigationEditCallback: navigateToEditPage,
                ))),
        child: const Center(child: CircularProgressIndicator()));
  }

  Widget _buildLandscapeWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 300,
          child: TodoListWidget(
            items: items,
            navigationEditCallback: (map) {
              setState(() {
                selectedItem = map;
              });
            },
            deleteById: deleteById,
          ),
        ),
        _noSelectedItem(),
        _selectedItem()
      ],
    );
  }

  Widget _noSelectedItem() {
    if (selectedItem == null) {
      return const Expanded(
        child: Center(
          child: Text("No selected item"),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _selectedItem() {
    if (selectedItem != null) {
      return Expanded(
        child: AddTodoScreen(
          isLandscape: true,
          todo: selectedItem,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  bool isPortraitMode() {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
}
