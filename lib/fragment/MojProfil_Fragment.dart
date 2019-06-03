import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class MojProfil_Fragment extends StatefulWidget {
  @override
  _MojProfil_State createState() => _MojProfil_State();
}

class _MojProfil_State extends State<MojProfil_Fragment> {
  bool pressedOsnovni = false;
  bool pressedPoruke = false;
  bool pressedPitanja = true;
  bool pressedPoslovnice = true;
  bool pressedOpci = true;
  bool pressedZastita = true;

  String ime = '';
  String prezime = '';
  TextEditingController _controller_ime;

  @override
  void initState() {
    super.initState();
    _getPref();
  }

  _getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ime = (prefs.getString('ime') ?? "");
      prezime = (prefs.getString('prezime') ?? "");

      _controller_ime = new TextEditingController(text: ime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(

        onWillPop: _onWillPop,
        child: new Scaffold(
          body: Container(
            color: Colors.blue,
            child: buildContent(context),
          ),
        ));
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () =>  SystemNavigator.pop(),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  Widget buildContent(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Moj profil'),
        automaticallyImplyLeading: false,
        actions: <Widget>[  IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),],

      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: ListView(
          children: <Widget>[
            RaisedButton(
              child: Text("Osnovni podaci"),
              onPressed: () {
                setState(() {
                  pressedOsnovni = !pressedOsnovni;
                });
              },
            ),
            pressedOsnovni
                ? Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Ime',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      // hintText: 'EMAIL',
                      // hintStyle: ,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blue))),
                  controller: _controller_ime,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Prezime',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      // hintText: 'EMAIL',
                      // hintStyle: ,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blue))),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Mobitel',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      // hintText: 'EMAIL',
                      // hintStyle: ,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blue))),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'E-mail adresa',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      // hintText: 'EMAIL',
                      // hintStyle: ,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blue))),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Kućna adresa',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      // hintText: 'EMAIL',
                      // hintStyle: ,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blue))),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Poštanski broj i grad',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      // hintText: 'EMAIL',
                      // hintStyle: ,
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blue))),
                ),
              ],
            )
                : SizedBox(),
            RaisedButton(
              child: Text("Poruke (2)"),
              onPressed: () {
                setState(() {
                  pressedPoruke = !pressedPoruke;
                });
              },
            ),
            pressedPoruke
                ? Column(
              children: <Widget>[
                Text("Nove ponude za ožujak"),
                Text(" Povoljniji uvjeti za korisnike ")
              ],
            )
                : SizedBox(),
            RaisedButton(
              child: Text("Česta pitanja"),
              onPressed: () {
                setState(() {
                  pressedPitanja = !pressedPitanja;
                });
              },
            ),
            pressedPitanja
                ? SizedBox():SizedBox()
            ,
            RaisedButton(
              child: Text("Poslovnice i kontakti"),
              onPressed: () {
                setState(() {
                  pressedPoslovnice = !pressedPoslovnice;
                });
              },
            ),
            pressedPoslovnice ?
//                WebView(
//                  initialUrl:
//                  'https://polleosport.hr/poslovnice-i-kontakti',
//                  javascriptMode: JavascriptMode.unrestricted,
//                )
            SizedBox(): SizedBox(),
            RaisedButton(
              child: Text("Opći uvjeti korištenja"),
              onPressed: () {
                setState(() {
                  pressedOpci = !pressedOpci;
                });
              },
            ),
            pressedOpci ? SizedBox() : SizedBox(),
            RaisedButton(
              child: Text("Zaštita podataka"),
              onPressed: () {
                setState(() {
                  pressedZastita = !pressedZastita;
                });
              },
            ),
            pressedZastita ? SizedBox() : SizedBox(),
          ],
        ),
      ),
    );
  }
}
