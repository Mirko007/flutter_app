import 'dart:async';

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text('Moj profil')),
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
                pressedPitanja ? SizedBox() : SizedBox(),

                RaisedButton(
                  child: Text("Poslovnice i kontakti"),
                  onPressed: () {
                    setState(() {
                      pressedPoslovnice = !pressedPoslovnice;
                    });
                  },
                ),
                pressedPoslovnice ? SizedBox() : SizedBox(),

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
        ));
  }
}
