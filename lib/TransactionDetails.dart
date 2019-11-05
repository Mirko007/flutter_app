import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'global_variable.dart' as globals;
String token='';
var data;

final EmailText = TextEditingController();
final ImeText = TextEditingController();
final PrezimeText = TextEditingController();


class TransactionDetails extends StatefulWidget {
  String uuid;

  TransactionDetails({this.uuid});


  @override
  TransactionDetailsState createState() => TransactionDetailsState(uid: uuid);
}

class TransactionDetailsState extends State<TransactionDetails> {
  String uid;

  TransactionDetailsState({this.uid});

  @override
  void initState() {
    super.initState();
    _getPref();
  }

  _getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token')??"");
      this.getTransactionData();
    });
  }

  Future<String> getTransactionData() async {
    print("uid:UBIME:"+uid);
    String url = globals.base_url_novi + "/api/v1/transaction/"+uid;

    http.Response response = await http.get(url, headers: {"Accept": "application/json","content-type": "application/json","token": "$token"}).then((http.Response response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          var resBody = json.decode(response.body);

          data = resBody[""];
        });
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    }
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Transakcije detalji')),
      body: Container(
        color: Colors.grey,
        child: _buildContent(context),
      ),
    );
  }
}

Widget _buildContent(BuildContext context) {
  return Container(
    color: Colors.grey,
    padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
    child: Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Poslovnica",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Text(
                      data == null ? "AAAAAAAA" : data["locationName"],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Text(
                    "Datum",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    "22. veljače 2019.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ],
              )),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.all(5),
            color: Colors.lightBlueAccent,
            height: 5,
          ),
        ),
        Container(
            // margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            height: 25,
            color: Colors.white,
            child: Row(children: <Widget>[
              Expanded(
                child: Text(
                  "Naziv artikla",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
                  child: Text(
                    "Količina",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text("Cijena",
                      style: TextStyle(fontSize: 15, color: Colors.grey))),
            ])),
        Container(
          child: listview_artikli(),
          height: 200,
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                color: Colors.black,
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Račun ukupno:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )),
                  //todo kn fali
//                  Padding(
//                    padding: EdgeInsets.all(5),
//                    child: TextField(controller: EmailText,
//                        style: TextStyle(
//                            fontSize: 20, fontWeight: FontWeight.bold)),
//                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: <Widget>[Icon(Icons.message), Text("Bodovi")],
        ),
        Center(
          child: Text(
            "+25",
            style: TextStyle(
                fontSize: 100, color: Colors.blue,),
          ),
        )
      ],
    ),
  );
}

Widget listview_artikli() {
  return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext content, int index) {
        return Container(
          // margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            height: 50,
            color: Colors.white,
            child: Row(children: <Widget>[
              Expanded(
                child: Text(data[index]["itemName"], style: TextStyle(fontSize: 18)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
                  child: Text(
                    data[index]["quantity"],
                    style: TextStyle(fontSize: 18),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(data[index]["itemPrice"], style: TextStyle(fontSize: 18))),
            ]));
      });
}

