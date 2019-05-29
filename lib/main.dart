import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/fragment/main_fragment.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'signup.dart';

import './presentation/my_flutter_app_icons.dart' as customIcon;

void main() {
 debugPaintSizeEnabled = false;
 SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
   systemNavigationBarColor: Colors.blue, // navigation bar color
   statusBarColor: Colors.blue, // status bar color
 ));
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/main': (BuildContext context) => new Main_Fragment(),
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = "https://swapi.co/api/starships";
  List data;

  Future<String> getSWData() async {
    var res =
    await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody["results"];
    });

    return "Success!";
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 300.0,
              child: Image.asset(
                "assets/images/prijava_logo.png",
                fit: BoxFit.fill,
              ),
              width: MediaQuery.of(context).size.width,
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 36.0, right: 36.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                    SizedBox(height: 20.0),

                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            shadowColor: Colors.blueAccent,
                            color: Colors.blue,
                            elevation: 7.0,
                            child: RaisedButton(
                              padding: const EdgeInsets.all(8.0),
                              splashColor: Colors.blueAccent,
                              textColor: Colors.white,
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.of(context).pushNamed('/main');
                              },
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          )),

                  ],
                )),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Nisi član LeoCluba?',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text(
                    'Registriraj se ovdje.',
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Card(
                            child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  children: <Widget>[
                                    Text("Name: "),
                                    Text(data[index]["name"],
                                        style: TextStyle(
                                            fontSize: 18.0, color: Colors.black87)),
                                  ],
                                )),
                          ),
                          Card(
                            child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  children: <Widget>[
                                    Text("Model: "),
                                    Text(data[index]["model"],
                                        style: TextStyle(
                                            fontSize: 18.0, color: Colors.red)),
                                  ],
                                )),
                          ),
                          Card(
                            child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  children: <Widget>[
                                    Text("Cargo Capacity: "),
                                    Text(data[index]["cargo_capacity"],
                                        style: TextStyle(
                                            fontSize: 18.0, color: Colors.black87)),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
//              Align(
//                alignment: FractionalOffset.bottomCenter,
//                child: Image.asset(
//                  "assets/images/prijava_logo_polleo.png",
//                ),
//              ),
            )
          ],
        ));
  }
  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

}
