import 'package:flutter/material.dart';
import 'package:todo/models/db_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String newTaskTitle;

    return Container(
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'newtask'.tr().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            FlatButton(
              child: Text(
                'add'.tr().toString(),
                style: TextStyle(),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(
                    20.0,
                  ),
                ),
              ),
              onPressed: () {
                if (newTaskTitle != null && newTaskTitle != "") {
                  insertDB(newTaskTitle);
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void insertDB(String newTaskTitle) async {
    final dbHelper = DBHelper.instance;
    
    Map<String, dynamic> row = {
      DBHelper.columnName: newTaskTitle,
      DBHelper.columnDone: 0
    };

    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }
}
