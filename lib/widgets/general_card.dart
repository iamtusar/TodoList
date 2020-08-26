import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_firebase/screens/add_todos_to_collection.dart';

import '../constants.dart';

final _fireStore = Firestore.instance;

class GeneralCard extends StatelessWidget {
  final String name;
  final String colour;
  final int completed;
  final int total;
  final int remaining;
  final String docId;
  GeneralCard(
      {this.name,
      this.colour,
      this.completed,
      this.total,
      this.remaining,
      this.docId});

  @override
  Widget build(BuildContext context) {
//    _fireStore.collection("tasklist").document(docId).updateData(
//        {"total": total, "remaining": remaining, "completed": completed});
    Color _originalColor =
        Color(int.parse(colour.split('(0x')[1].split(')')[0], radix: 16));
    return Card(
      color: _originalColor,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTodosToCollectionScreen(
                  colour: _originalColor, name: name, docId: docId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                width: 170,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 18.0,
                    left: 6.0,
                    right: 6.0,
                  ),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Text(remaining.toString(), style: kNumberTextStyle),
              Text("Remaining", style: kStatusTextStyle),
              Text(completed.toString(), style: kNumberTextStyle),
              Text("Completed", style: kStatusTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}
