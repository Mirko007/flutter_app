import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AkcijeFragment extends StatefulWidget {
  @override
  _AkcijeState createState() => _AkcijeState();
}

class _AkcijeState extends State<AkcijeFragment> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,  DeviceOrientation.portraitDown,
    ]);
    return new WillPopScope(

      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: new Text("Akcije"),
        ),
        body: new SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            "assets/images/nema_sadrzaja.PNG",
            fit: BoxFit.fill,
          ),
          width: MediaQuery.of(context).size.width,
        )
      ),
    );
//    return Scaffold(
//      appBar: AppBar(title: Text('Akcije')),
//      backgroundColor: Colors.blue,
//      body: Container(
//        color: Colors.blue,
//        child: buildContent(),
//      ),
//    );


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
