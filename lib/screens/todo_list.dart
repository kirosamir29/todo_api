import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
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
        title: Text("Todo List"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text("Add Todo"),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == "edit") {
                      // open Edit Page
                      navigateToEditPage(item);
                    } else if (value == "delete") {
                      // delete item
                      deleteById(id);
                    }
                  }, itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: "edit",
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: "delete",
                      ),
                    ];
                  }),
                );
              }),
        ),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {});
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    // delete item
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    //remove item from list
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //show error
      showErrorMessage("Deletion Failed");
    }
  }

  Future<void> fetchTodo() async {
    // not a good logic
    // setState(() {
    //   isLoading = true;
    // });
    final url = "https://api.nstack.in/v1/todos?page=1&limit=20";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}