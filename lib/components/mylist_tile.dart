import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MylistTile extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEditing;
  final void Function(BuildContext)? onDeleting;

  const MylistTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.onEditing,
    required this.onDeleting,
    });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          //setting option
          SlidableAction(
            onPressed: onEditing,
            icon: Icons.settings,
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          

          //delete Option 
          SlidableAction(
            onPressed: onDeleting,
            icon: Icons.delete,
            backgroundColor: const Color.fromARGB(255, 241, 4, 4),
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4),
            ),

        ]
        ),
      child: ListTile(
        title: Text(title),
        trailing: Text(trailing),
      ),
    );
  }
}
