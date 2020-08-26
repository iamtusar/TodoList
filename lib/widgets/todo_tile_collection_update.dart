import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoTileCollectionUpdate extends StatefulWidget {
  final bool isChecked;
  final String taskTitle;
  final DocumentReference firestoreInstance;

  TodoTileCollectionUpdate({
    this.firestoreInstance,
    this.isChecked,
    this.taskTitle,
  });

  @override
  _TodoTileCollectionUpdateState createState() =>
      _TodoTileCollectionUpdateState();
}

class _TodoTileCollectionUpdateState extends State<TodoTileCollectionUpdate> {
  bool _is = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _is = widget.isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        activeColor: Colors.lightBlueAccent,
//        value: widget.isChecked,
        value: _is,
        onChanged: (val) {
          if (val) {
            setState(() {
              _is = val;
              widget.firestoreInstance.updateData({
                "item_name": widget.taskTitle,
                "done": true,
              });
            });
          }
        },
      ),
      title: Text(
        widget.taskTitle,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: _is ? TextDecoration.lineThrough : null),
      ),
    );
  }
}
