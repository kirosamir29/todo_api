import 'package:flutter/material.dart';

class TodoCardWidget extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map,int) navigationEditCallback;
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
    return GestureDetector(
      onTap: (){

      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text("${index + 1}"),
          ),
          title: Text(item['title']),
          subtitle: Text(item['description']),
          trailing: PopupMenuButton(onSelected: (value) {
            if (value == "edit") {
              navigationEditCallback(item,index);
            } else if (value == "delete") {
              deleteById(id);
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem(value: "edit", child: Text("Edit")),
              PopupMenuItem(value: "delete", child: Text("Delete"))
            ];
          }),
        ),
      ),
    );
  }
}
