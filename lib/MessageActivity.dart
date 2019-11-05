import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_helper.dart';
import 'global_variable.dart' as globals;
String token='';
List data;
const EMPTY_TEXT = Center(child: Text('Waiting for messages.'));

final dbHelper = DatabaseHelper.instance;


class MessageActivity extends StatefulWidget {


  MessageActivity();


  @override
  MessageActivityState createState() => MessageActivityState();
}

class MessageActivityState extends State<MessageActivity> {
  String uid;

  MessageActivityState();

  @override
  void initState() {
    super.initState();
    _query();
  }

  _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');

    setState(() {
      data = allRows;
    });
    allRows.forEach((row) => print(row));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Poruke')),
      body: Container(
        color: Colors.grey,
        child: _buildContent(context),
      ),
    );
  }
}


Widget _buildContent(BuildContext context) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
    child:  (data == null)
        ? EMPTY_TEXT
        : Container(
      child: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            String timestamp = data[index]["message"];
            return GestureDetector(
              onTap: () => onTapped(index),
//                            Scaffold
//                            .of(context)
//                            .showSnackBar(SnackBar(content: Text(data[index]["title"]))),
              child: InputDecorator(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 5.0, top: 5.0, bottom: 5.0),
                      labelStyle: TextStyle(
                          color: Colors.blue, fontSize: 20.0),
                      labelText: data[index]["title"]),
                  child: new Text(timestamp,
                      style: TextStyle(
                          color: Colors.black, fontSize: 16.0))),
            );
          }),
    ));

}

void onTapped(int index) {
  print(data[index]["title"] + " poruka !");
  print(data[index]["title"] + " poruka !");

}



