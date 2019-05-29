import 'package:flutter/material.dart';
import 'package:flutter_app/TransactionDetails.dart';

class TransakcijeFragment extends StatefulWidget {
  @override
  _TransakcijeState createState() => _TransakcijeState();
}

class _TransakcijeState extends State<TransakcijeFragment> {
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
        itemCount: allTransactions.length,
        itemBuilder: (BuildContext content, int index) {
          Transaction transaction = allTransactions[index];
          return getTransactionItem(transaction, content);
        });
  }

  Widget getTransactionItem(Transaction contact, BuildContext context) {
    return GestureDetector(
      onTap: () {
        getTransactionDetails(contact.locationName, context);
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
                      contact.locationName,
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
                          contact.date,
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  Text(
                    contact.totalAmount,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
              Expanded(
                  child: Column(
                    children: <Widget>[Text("BODOVI"),
                    Text(contact.spentPoints,style: TextStyle(fontSize: 50,color: Colors.blue),)
                    ],
                  ))
            ],
          )
      ),
    );
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
