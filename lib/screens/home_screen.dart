import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_firebase/screens/add_task_screen.dart';
import 'package:todolist_firebase/widgets/general_card.dart';

import '../constants.dart';

final _fireStore = Firestore.instance;

class HomeScreen extends StatelessWidget {
  static const String id = "home_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              kDivider,
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Text(
                      "Todo ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      "List",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
              ),
              kDivider,
            ],
          ),
          Container(
            width: 55,
            height: 55,
            child: OutlineButton(
              onPressed: () {
                Navigator.pushNamed(context, AddTaskScreen.id);
              },
              child: Icon(
                Icons.add,
                color: Colors.green,
              ),
            ),
            padding: EdgeInsets.only(bottom: 6),
          ),
          Text(
            "Add List",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(top: 70),
          ),
          SizedBox(
            height: 256,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _fireStore.collection("tasklist").orderBy("time").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tasks = snapshot.data.documents;
                  List<GeneralCard> tasksList = [];
                  for (var task in tasks) {
                    final name = task.data["name"];
                    final colour = task.data["color"];
                    final completed = task.data["completed"];
                    final total = task.data["total"];
                    final remaining = task.data["remaining"];
                    final docId = task.documentID;
                    final taskList = GeneralCard(
                      name: name,
                      colour: colour,
                      completed: completed,
                      total: total,
                      remaining: remaining,
                      docId: docId,
                    );
                    tasksList.add(taskList);
                  }

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: tasksList,
                  );
                }
                return Text("No data");
              },
            ),
          ),
//          GeneralCard(),
        ],
      ),
    );
  }
}
