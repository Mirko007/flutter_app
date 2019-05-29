import 'package:flutter/material.dart';

class AkcijeFragment extends StatefulWidget {
  @override
  _AkcijeState createState() => _AkcijeState();
}

class _AkcijeState extends State<AkcijeFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Akcije')),
      backgroundColor: Colors.blue,
      body: Container(
        color: Colors.blue,
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    return Container(
      color: Colors.grey,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Text(
                  "Akcijska ponuda, ožujak 2019.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            height: 3,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              children: <Widget>[
                Text("Mjesečne akcije",style: TextStyle(fontSize:16 ,color: Colors.blue),),
                Center(child: Image.asset(
                  "assets/images/akcije.png",height: 150,width: 150,
                ),)
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            height: 3,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              children: <Widget>[
                Text("Izdvojene akcije za članove kluba",style: TextStyle(fontSize:16 ,color: Colors.blue),),
                Center(child: Image.asset(
                  "assets/images/akcije.png",height: 150,width: 150,
                ),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
