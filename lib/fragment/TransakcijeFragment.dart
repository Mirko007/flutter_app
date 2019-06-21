import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Loyalty_client/TransactionDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variable.dart' as globals;
String token='';

List data;
class TransakcijeFragment extends StatefulWidget {
  @override
  _TransakcijeState createState() => _TransakcijeState();
}

class _TransakcijeState extends State<TransakcijeFragment> {

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

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(

      onWillPop: _onWillPop,
      child: new Scaffold(
        body: new ListPage(),
      ),
    );
    return  new ListPage();

  }
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Jeste li sigurni?'),
        content: new Text('Želite li izaći iz aplikacije'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Ne'),
          ),
          new FlatButton(
            onPressed: () =>  SystemNavigator.pop(),
            child: new Text('Da'),
          ),
        ],
      ),
    ) ?? false;
  }


    Future<String> getTransactionData() async {
      String url = globals.base_url+"/api/v1/transaction";

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
            data = resBody["transactionList"];
          });
        } else {
          // If that call was not successful, throw an error.
          throw Exception('Failed to load post');
        }
      });

    }
}

class Transaction {
  Transaction(
      {this.date, this.spentPoints, this.totalAmount, this.locationName});

  final String date;
  final String spentPoints;
  final String totalAmount;
  final String locationName;
}

class ListPage extends StatelessWidget {
  ListPage({Key key, this.onLayoutToggle}) : super(key: key);
  final VoidCallback onLayoutToggle;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Transakcije'),
        automaticallyImplyLeading: false,),
      body: Container(
        color: Colors.blueAccent,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext content, int index) {

          return GestureDetector(
            onTap: () {
              //getTransactionDetails(data[index]["uuid"], content);
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
                padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0),
                          child: Text(
                            data[index]["locationName"],
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                          alignment: Alignment(-1.0, 0.0),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              size: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                              child: Text(
                                data[index]["created"],
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                        Text(
                          data[index]["totalAmount"].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                    Expanded(
                        child: Column(
                          children: <Widget>[Text("BODOVI"),
                            Text(data[index]["spentPoints"].toString(),style: TextStyle(fontSize: 50,color: Colors.blue),)
                          ],
                        ))
                  ],
                )
            ),
          );
        });
  }

}

void getTransactionDetails(String uuid, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TransactionDetails(uuid: uuid)),
  );
}
