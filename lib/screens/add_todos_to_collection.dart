import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist_firebase/widgets/todo_tile_collection_update.dart';

final _fireStore = Firestore.instance;

class AddTodosToCollectionScreen extends StatefulWidget {
  final String name;
  final Color colour;
  final String docId;

  AddTodosToCollectionScreen({this.name, this.colour, this.docId});
  static const String id = "add_todos_to_collection_screen";

  @override
  _AddTodosToCollectionScreenState createState() =>
      _AddTodosToCollectionScreenState();
}

class _AddTodosToCollectionScreenState
    extends State<AddTodosToCollectionScreen> {
  String _itemString = "";
  int _total = 0;
  int _completed = 0;
  TextEditingController _controller = TextEditingController();

  void totalStream() async {
    await for (var snapshot in _fireStore
        .collection("tasklist")
        .document(widget.docId)
        .snapshots()) {
      setState(() {
        _total = snapshot.data["total"];
        _completed = snapshot.data["completed"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    totalStream();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 36,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, top: 8.0),
                      child: Text(_completed.toString() +
                          " of " +
                          _total.toString() +
                          " task"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Divider(
                    color: widget.colour,
                    thickness: 2.0,
                  ),
                ),
//              ListView(),
                Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _fireStore
                          .collection("tasklist")
                          .document(widget.docId)
                          .collection("todos")
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<TodoTileCollectionUpdate> itemsList = [];
                        if (snapshot.hasData) {
                          final items = snapshot.data.documents;
                          final total = items.length;
                          int remaining = 0;
                          int completed = 0;

                          for (var item in items) {
                            final name = item.data["item_name"];
                            final isDone = item.data["done"];
                            if (isDone)
                              completed++;
                            else
                              remaining++;
                            final temp = TodoTileCollectionUpdate(
                              isChecked: isDone,
                              taskTitle: name,
                              firestoreInstance: _fireStore
                                  .collection("tasklist")
                                  .document(widget.docId)
                                  .collection("todos")
                                  .document(item.documentID),
                            );
                            itemsList.add(temp);
                          }
                          _fireStore
                              .collection("tasklist")
                              .document(widget.docId)
                              // .collection("states")
                              // .document("all_states")
                              .updateData(
                            {
                              "total": items.length,
                              "remaining": remaining,
                              "completed": completed,
                            },
                          );
                        }
                        return ListView(
                          shrinkWrap: true,
                          children: itemsList,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, bottom: 28.0, right: 8.0),
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        _itemString = value;
                      },
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: widget.colour),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: widget.colour),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0, bottom: 28.0),
                  child: Container(
                    width: 55,
                    height: 55,
                    color: widget.colour,
                    child: OutlineButton(
                      onPressed: () {
//                    Navigator.pushNamed(context, AddTaskScreen.id);
                        if (_itemString.isEmpty) {
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
                          _fireStore
                              .collection("tasklist")
                              .document(widget.docId)
                              .collection("todos")
                              .add(
                            {
                              "item_name": _itemString,
                              "done": false,
                            },
                          );
                          _controller.clear();
                          totalStream();
                        }
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
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

//_fireStore
//    .collection("tasklist")
//.document(docId)
//.updateData({
//"items": {"item_name": _itemString, "done": false}
//});
