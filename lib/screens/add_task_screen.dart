import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _fireStore = Firestore.instance;

class AddTaskScreen extends StatefulWidget {
  static const String id = "add_task_screen";

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  Color _colour = Colors.green;
  String _task = "";

  Widget colorBox(Color colour) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 32,
        width: 32,
        child: RaisedButton(
          onPressed: () {
            setState(() {
              _colour = colour;
            });
          },
          color: colour,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white12,
          automaticallyImplyLeading: false,
          title: ListTile(
            trailing: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Todo List",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              onChanged: (value) {
                _task = value;
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              colorBox(Colors.green),
              colorBox(Colors.lightBlueAccent),
              colorBox(Colors.purple),
              colorBox(Colors.deepPurpleAccent),
              colorBox(Colors.pinkAccent),
              colorBox(Colors.red),
              colorBox(Colors.orangeAccent),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FlatButton(
                    color: _colour,
                    onPressed: () {
                      if (_task.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Please enter task name."),
                            actions: [
                              FlatButton(
                                child: Text("okay"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      } else {
                        _fireStore.collection("tasklist").add({
                          "color": _colour.toString(),
                          "completed": 0,
                          "total": 0,
                          "remaining": 0,
                          "name": _task,
                          "time": Timestamp.now().microsecondsSinceEpoch,
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
