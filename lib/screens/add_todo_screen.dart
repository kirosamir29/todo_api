import 'package:flutter/material.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/utils/snack_helper.dart';

class AddTodoScreen extends StatefulWidget {
  final Map? todo;
  final bool isLandscape;

  const AddTodoScreen({
    super.key,
    this.todo,
    required this.isLandscape,
  });

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isLandscape
          ? null
          : AppBar(
              title: Text(isEdit ? "Edit Todo" : "Add Todo"),
              centerTitle: true,
            ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Title",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: "Description",
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? "Update" : "Submit"),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo["_id"];
    final isSuccess = await TodoService.updateTodo(id, body);
    if (isSuccess) {
      if (mounted) {
        showSuccessMessage(context, message: "Update Success");
      }
    } else {
      if (mounted) {
        showErrorMessage(context, message: "Update Failed");
      }
    }
  }

  Future<void> submitData() async {
    final isSuccess = await TodoService.addTodo(body);

    if (mounted) {
      if (isSuccess) {
        titleController.text = "";
        descriptionController.text = "";
        showSuccessMessage(context, message: "Creation Success");
      } else {
        showErrorMessage(context, message: "Creation Failed");
      }
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
