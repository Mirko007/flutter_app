import 'package:flutter/material.dart';
import 'package:flutter_app/TransactionDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
    this.getTransactionData();
  }

  _getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token')??"");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/transaction_details': (BuildContext context) =>
            new TransactionDetails(),
      },
      home: new ListPage(),
    );
  }

    Future<String> getTransactionData() async {
      String url = "http://165.227.137.83:9000/api/v1/transaction";

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
      appBar: AppBar(title: Text('Transakcije')),
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
              getTransactionDetails(data[index]["locationName"], content);
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

List<Transaction> allTransactions = [
  Transaction(
      date: '26.10.2018 05:57.11',
      spentPoints: '10',
      totalAmount: "50",
      locationName: "Zagreb - Žitnjak"),
  Transaction(
      date: '28.10.2018 10:55.41',
      spentPoints: '22',
      totalAmount: "120",
      locationName: "Zagreb - Jankomir"),
  Transaction(
      date: '06.11.2018 12:12.45',
      spentPoints: '30',
      totalAmount: "170",
      locationName: "Velesajam"),
  Transaction(
      date: '12.11.2018 15:34.37',
      spentPoints: '45',
      totalAmount: "200",
      locationName: "Osijek"),
];

void getTransactionDetails(String location_name, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TransactionDetails()),
  );
}
