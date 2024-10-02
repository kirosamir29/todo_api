import 'package:flutter/material.dart';
import 'package:todo/screens/add_todo_screen.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/widgets/loading_widget.dart';
import 'package:todo/widgets/todo_card_widget.dart';
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
  Map? selectedItem;
  int selectedIndex=0;
  bool isPortrait = true;
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
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: const Text("Todo List"),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: navigateToAddPage,
              label: const Text("Add Todo"),
            ),
            body:
                isPortrait ? _buildPortraitWidget() : _buildLandscapeWidget()),
        isLoading ? const LoadingWidget() : const SizedBox.shrink()
      ],
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
        showErrorMessage(context, message: "Deletion Failed");
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
                  deleteById: deleteById,
                  navigationEditCallback: (map,index){
                    navigateToEditPage(map);
                  },
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
            navigationEditCallback: (map,index) {
              setState(() {
                selectedItem = map;
                selectedIndex=index;
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
      return SizedBox.shrink();
    }
  }

  Widget _selectedItem() {
    if (selectedItem != null) {
      return Expanded(
        child: AddTodoScreen(todo: selectedItem,),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
