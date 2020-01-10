import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppTranslations.dart';
import 'database_helper.dart';
import 'global_variable.dart' as globals;
String token='';
List data;
const EMPTY_TEXT = Center(child: Text('Waiting for messages.'));
//
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
      appBar: AppBar( iconTheme: IconThemeData(color: Colors.white),title: Text(AppTranslations.of(context).text("poruke"),style: TextStyle(color: Colors.white),),brightness: Brightness.dark,),
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
            String message = data[index]["message"];
            return GestureDetector(
              onTap: () => onTapped(index,data[index]["_id"],context),
//                            Scaffold
//                            .of(context)
//                            .showSnackBar(SnackBar(content: Text(data[index]["title"]))),
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    data[index]["read_status"]== 1? Container():
                    new Text(AppTranslations.of(context).text("nova_poruka"),
                        style: TextStyle(
                            color: Colors.blue, fontSize: 16.0,fontWeight: FontWeight.bold)),

                    InputDecorator(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 5.0, top: 5.0, bottom: 5.0),
                        labelStyle: TextStyle(
                            color: Colors.blue, fontSize: 20.0),
                        labelText: data[index]["title"]),
                    child: new Text(message,
                        style: TextStyle(
                            color: Colors.black, fontSize: 16.0))),
              ],)
            );
          }),
    ));

}

void onTapped(int index,int message_id,BuildContext context) {

  showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text(data[index]["title"]),
      content: new Linkify(
        text: data[index]["message"],
        humanize: true,onOpen: (link) async {
        if (await canLaunch(link.url)) {
          await launch(link.url);
        } else {
          throw 'Could not launch $link';
        }
      },
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => showtoast(index, 1, context,message_id),
          child: new Text(AppTranslations.of(context).text("delete")),
        ),
        new FlatButton(
          onPressed: () => showtoast(index, 2, context,message_id),
          child: new Text(AppTranslations.of(context).text("da")),
        ),
      ],
    ),
  );
}

void showtoast(int index, int i, BuildContext context,int message_id) {
  //test

  String msg = "";
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String getCurrentDateTime = dateFormat.format(DateTime.now());
  if (i == 1) {
    print(message_id);
    print("message_id");
    print(message_id);
    dbHelper.updateReadStatus(data[index]["_id"],1);
    dbHelper.delete(message_id);
    //dbHelper.updateDeleted(data[index]["id_message"],getCurrentDateTime);
    msg = AppTranslations.of(context).text("message_delete");
  } else {
    dbHelper.updateReadStatus(data[index]["_id"],1);
    msg = AppTranslations.of(context).text("message_read");
  }
  Fluttertoast.showToast(
      msg: data[index]["title"]+ " " + msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      // also possible "TOP" and "CENTER"
      textColor: Colors.white);
  Navigator.of(context).pop();
  Navigator.of(context).popAndPushNamed('/messages');


}

