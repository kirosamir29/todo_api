import 'package:flutter/material.dart';

class TodoCardWidget extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigationEditCallback;
  final Function(String) deleteById;

  const TodoCardWidget({
    super.key,
    required this.index,
    required this.item,
    required this.navigationEditCallback,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text("${index + 1}"),
        ),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(onSelected: (value) {
          if (value == "edit") {
            // open Edit Page
            navigationEditCallback(item);
          } else if (value == "delete") {
            // delete item
            deleteById(id);
          }
        }, itemBuilder: (context) {
          return const [
            PopupMenuItem(value: "edit", child: Text("Edit")),
            PopupMenuItem(value: "delete", child: Text("Delete"))
          ];
        }),
      ),
    );
  }
}
