import 'package:flutter/material.dart';
import 'package:todo/widgets/todo_card_widget.dart';

class TodoListWidget extends StatelessWidget {
  final List items;
  final Function(Map,int) navigationEditCallback;
  final Function(String) deleteById;

  const TodoListWidget({
    super.key,
    required this.items,
    required this.navigationEditCallback,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map;
          return TodoCardWidget(
            index: index,
            item: item,
            navigationEditCallback: navigationEditCallback,
            deleteById: deleteById,
          );
        });
  }
}
