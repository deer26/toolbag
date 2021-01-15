import 'package:flutter/material.dart';
import 'package:todo/models/db_helper.dart';
import 'package:todo/widgets/drawer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final dbHelper = DBHelper.instance;
  int listCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.lightGreenAccent,
      appBar: AppBar(),
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.lightGreenAccent,
          child: Icon(
            Icons.add,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: AddTaskScreen(),
                    )));
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'header'.tr().toString(),
                  style: TextStyle(
                    fontSize: 37.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                listCount != null
                    ? Text(
                        '$listCount ' + 'mission'.tr().toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    : Text(" "),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: FutureBuilder(
                  future: getAllList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                "${snapshot.data[index]["name"]}",
                                style: TextStyle(
                                  decoration: snapshot.data[index]["done"] == 1
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Checkbox(
                                activeColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.green
                                    : Colors.blueAccent,
                                value: snapshot.data[index]["done"] == 1
                                    ? true
                                    : false,
                                onChanged: (value) async {
                                  // row to update
                                  Map<String, dynamic> row = {
                                    DBHelper.columnId: snapshot.data[index]
                                        ["_id"],
                                    DBHelper.columnName: snapshot.data[index]
                                        ["name"],
                                    DBHelper.columnDone: value ? 1 : 0
                                  };
                                  await dbHelper.update(row);
                                },
                              ),
                              onLongPress: () async {
                                showDialog(
                                    context: context,
                                    // ignore: deprecated_member_use
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.9),
                                      title: Text(
                                        "del".tr().toString(),
                                        style: TextStyle(),
                                      ),
                                      content: Text("quest".tr().toString()),
                                      actions: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                            ),
                                            onPressed: () async {
                                              final id =
                                                  snapshot.data[index]["_id"];
                                              final rowsDeleted =
                                                  await dbHelper.delete(id);
                                              print(
                                                  'deleted $rowsDeleted row(s): row $id');
                                              Navigator.pop(context);
                                            }),
                                        IconButton(
                                            icon: Icon(
                                              Icons.cancel,
                                              size: 40,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    ));
                              },
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  getAllList() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      listCount = allRows.length;
    });
    return allRows;
  }
}
