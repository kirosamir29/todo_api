import 'package:flutter/material.dart';
import 'package:todo/services/todo_service.dart';
import '../utils/snack_helper.dart';

class AddTodoScreen extends StatefulWidget {
  final Map? todo;


  const AddTodoScreen({
    super.key,
    this.todo,
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
    final todo = widget.todo;            //
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
      appBar: AppBar(
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
    // submit updated data
    final isSuccess = await TodoService.updateTodo(id, body);
    //show success message
    if (isSuccess) {
      if(context.mounted){
        showSuccessMessage(context,message:"Update Success");
    }} else {
      showErrorMessage(context,message:"Update Failed");
    }
  }

  Future<void> submitData() async {
    //submit data to server
    final isSuccess = await TodoService.addTodo(body);
    //show success or fail message
    if (isSuccess) {
      titleController.text = "";
      descriptionController.text = "";
      showSuccessMessage(context,message:"Creation Success");
    } else {
      showErrorMessage(context,message:"Creation Failed");
    }
  }

  // get data from form
  Map get body {final title = titleController.text;
  final description = descriptionController.text;
  return {
    "title": title,
    "description": description,
    "is_completed": false,
  };
  }

}


