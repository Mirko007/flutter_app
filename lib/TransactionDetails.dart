import 'package:flutter/material.dart';

class TransactionDetails extends StatefulWidget {
  @override
  TransactionDetailsState createState() => TransactionDetailsState();
}

class TransactionDetailsState extends State<TransactionDetails> {
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
                      "Arena Centar, Zagreb",
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
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("799,00 kn",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
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
      itemCount: _artikli.length,
      itemBuilder: (BuildContext content, int index) {
        Artikli artikli = _artikli[index];
        return getArtiklItem(artikli);
      });
}

List<Artikli> _artikli = [
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
  Artikli(naziv: 'UA Womans Graphic Capri', kolicina: '10', cijena: "50.0"),
];

class Artikli {
  Artikli({this.naziv, this.kolicina, this.cijena});

  final String naziv;
  final String kolicina;
  final String cijena;
}

Widget getArtiklItem(Artikli artikli) {
  return Container(
      // margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      height: 50,
      color: Colors.white,
      child: Row(children: <Widget>[
        Expanded(
          child: Text(artikli.naziv, style: TextStyle(fontSize: 18)),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 40, 0),
            child: Text(
              artikli.kolicina,
              style: TextStyle(fontSize: 18),
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(artikli.cijena, style: TextStyle(fontSize: 18))),
      ]));
}
