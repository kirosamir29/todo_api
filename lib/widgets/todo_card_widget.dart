import 'package:flutter/material.dart';
import 'package:todo/localization/localization_keys.dart';
import 'package:todo/utils/app_localization_class.dart';

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
    return GestureDetector(
      onTap: () {
        navigationEditCallback(item);
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
              navigationEditCallback(item);
            } else if (value == "delete") {
              deleteById(id);
            }
          }, itemBuilder: (context) {
            return [
              PopupMenuItem(value: "edit", child: Text(LocalizationKeys.edit.tr(context))),
              PopupMenuItem(value: "delete", child: Text(LocalizationKeys.delete.tr(context)))
            ];
          }),
        ),
      ),
    );
  }
}
