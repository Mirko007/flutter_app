import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool gdpr_privola_mob = false;
  bool gdpr_privola_email = false;
  bool gdpr_privola_posta = false;

  String token = '';
  String ime = '';
  String prezime = '';
  String datum_rodenja = '';
  TextEditingController _controller_ime;
  TextEditingController _controller_prezime;
  TextEditingController _controller_mobitel;
  TextEditingController _controller_grad;
  TextEditingController _controller_adresa;
  TextEditingController _controller_pos_broj;
  TextEditingController _controller_mail;

  List _gender = ["Musko", "Zensko", "Ostalo"];

  List<DropdownMenuItem<String>> _dropDownMenuItemsGender;
  String _currentGender;

  List<DropdownMenuItem<String>> _dropDownMenuItemsfitnessTypeList;
  String _currentfitnessType;
  int _currentfitnessTypeIndex;

  List<DropdownMenuItem<String>> _dropDownMenuItemssportTypeList;
  String _currentsportType;
  int _currentsportTypeIndex;

  List<DropdownMenuItem<String>> _dropDownMenuItemscategoryTypeList;
  String _currentcategoryType;
  int _currentcategoryTypeIndex;

  final String url = "http://165.227.137.83:9000/api/v1/getPrefTypes";

  List data_fitnessType;
  List data_sportType;
  List data_categoryType;

  @override
  void initState() {
    super.initState();

    getPrefTypeData();
    _getPref();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String gender in _gender) {
      items.add(new DropdownMenuItem(value: gender, child: new Text(gender)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsFitnessType() {
    List<DropdownMenuItem<String>> items = new List();
    for (int index = 0; index < data_fitnessType.length; index++) {
      items.add(new DropdownMenuItem(
          value: data_fitnessType[index]["name"],
          child: new Text(data_fitnessType[index]["name"])));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsSportType() {
    List<DropdownMenuItem<String>> items = new List();
    for (int index = 0; index < data_sportType.length; index++) {
      items.add(new DropdownMenuItem(
          value: data_sportType[index]["name"],
          child: new Text(data_sportType[index]["name"])));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsCategoryType() {
    List<DropdownMenuItem<String>> items = new List();
    for (int index = 0; index < data_categoryType.length; index++) {
      items.add(new DropdownMenuItem(
          value: data_categoryType[index]["name"],
          child: new Text(data_categoryType[index]["name"])));
    }
    return items;
  }

  Future<String> getPrefTypeData() async {
    var res = await http.get(Uri.parse(url));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var resBody = json.decode(res.body);
      data_fitnessType = resBody["fitnessTypeList"];
      data_sportType = resBody["sportTypeList"];
      data_categoryType = resBody["categoryTypeList"];

      for (int index = 0; index < data_fitnessType.length; index++) {
        if (data_fitnessType[index]["name"] == prefs.getString('fitnessName')) {
          _currentfitnessTypeIndex = data_fitnessType[index]["id"];
          _currentfitnessType = data_fitnessType[index]["name"];
        }
      }
      _dropDownMenuItemsfitnessTypeList = getDropDownMenuItemsFitnessType();

      for (int index = 0; index < data_sportType.length; index++) {
        if (data_sportType[index]["name"] == prefs.getString('sportName')) {
          _currentsportTypeIndex = data_sportType[index]["id"];
          _currentsportType = data_sportType[index]["name"];
        }
      }
      _dropDownMenuItemssportTypeList = getDropDownMenuItemsSportType();

      for (int index = 0; index < data_categoryType.length; index++) {
        if (data_categoryType[index]["name"] ==
            prefs.getString('categoryName')) {
          _currentcategoryTypeIndex = data_categoryType[index]["id"];
          _currentcategoryType = data_categoryType[index]["name"];
        }
      }
      _dropDownMenuItemscategoryTypeList = getDropDownMenuItemsCategoryType();
      print(
          "Selected categoryName $_currentcategoryType, we are going to refresh the UI");
      print(prefs.getString('categoryName'));
    });

    return "Success!";
  }

  _getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ime = (prefs.getString('ime') ?? "");
      prezime = (prefs.getString('prezime') ?? "");
      token = (prefs.getString('token') ?? "");
      datum_rodenja = (prefs.getString('dateOfBirth') ?? "");

      _controller_ime = new TextEditingController(text: ime);
      _controller_prezime = new TextEditingController(text: prezime);
      _controller_mobitel = new TextEditingController(
          text: (prefs.getString('phoneNumber') ?? ""));
      _controller_grad =
          new TextEditingController(text: (prefs.getString('city') ?? ""));
      _controller_adresa =
          new TextEditingController(text: (prefs.getString('address') ?? ""));
      _controller_pos_broj =
          new TextEditingController(text: (prefs.getString('zipCode') ?? ""));
      _controller_mail =
          new TextEditingController(text: (prefs.getString('email') ?? ""));

      gdpr_privola_email = prefs.getBool('gdpr_privola_email') ?? false;
      gdpr_privola_mob = prefs.getBool('gdpr_privola_mob') ?? false;
      gdpr_privola_posta = prefs.getBool('gdpr_privola_posta') ?? false;

      if (prefs.getString('gender') == "Male") {
        _currentGender = "Musko";
      } else if (prefs.getString('gender') == "Female") {
        _currentGender = "Zensko";
      } else {
        _currentGender = "Ostalo";
      }
      print(_currentGender);
      print("_currentGender");
      _dropDownMenuItemsGender = getDropDownMenuItems();
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
                    onPressed: () => SystemNavigator.pop(),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Widget buildContent(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Moj profil'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
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
                                borderSide: BorderSide(color: Colors.blue))),
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
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: _controller_prezime,
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
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: _controller_mobitel,
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
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: _controller_mail,
                        enabled: false,
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
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: _controller_adresa,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Poštanski broj',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: _controller_pos_broj,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Grad',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: _controller_grad,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Spol",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      new DropdownButton(
                        isExpanded: true,
                        value: _currentGender,
                        items: _dropDownMenuItemsGender,
                        onChanged: changedDropDownItem,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Fitness Type",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      new DropdownButton(
                        isExpanded: true,
                        value: _currentfitnessType,
                        items: _dropDownMenuItemsfitnessTypeList,
                        onChanged: changedDropDownItemFitness,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Sport Type",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      new DropdownButton(
                        isExpanded: true,
                        value: _currentsportType,
                        items: _dropDownMenuItemssportTypeList,
                        onChanged: changedDropDownItemSport,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Category Type",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      new DropdownButton(
                        isExpanded: true,
                        value: _currentcategoryType,
                        items: _dropDownMenuItemscategoryTypeList,
                        onChanged: changedDropDownItemCategory,
                      ),
                      CheckboxListTile(
                          value: gdpr_privola_posta,
                          title: new Text(
                              "Želim primati obavijesti putem pošte"),
                          onChanged: (bool value) {
                            setState(() {
                              gdpr_privola_posta = value;
                            });
                          }),
                      CheckboxListTile(
                          value: gdpr_privola_mob,
                          title: new Text(
                              "Želim primati obavijesti putem mobitela"),
                          onChanged: (bool value) {
                            setState(() {
                              gdpr_privola_mob = value;
                            });
                          }),
                      CheckboxListTile(
                          value: gdpr_privola_email,
                          title: new Text(
                              "Želim primati obavijesti putem maila"),
                          onChanged: (bool value) {
                            setState(() {
                              gdpr_privola_email = value;
                            });
                          }),
                      Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.blueAccent,
                            color: Colors.blue,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () {
                                  fvoidUpdateCustomer();
                              },
                              child: Center(
                                child: Text(
                                  'Registriraj se',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(height: 20.0),
                    ],
                  )
                : SizedBox(),
//            RaisedButton(
//              child: Text("Poruke (2)"),
//              onPressed: () {
//                setState(() {
//                  pressedPoruke = !pressedPoruke;
//                });
//              },
//            ),
//            pressedPoruke
//                ? Column(
//              children: <Widget>[
//                Text("Nove ponude za ožujak"),
//                Text(" Povoljniji uvjeti za korisnike ")
//              ],
//            )
//                : SizedBox(),
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
            pressedPoslovnice
                ?
//                WebView(
//                  initialUrl:
//                  'https://polleosport.hr/poslovnice-i-kontakti',
//                  javascriptMode: JavascriptMode.unrestricted,
//                )
                SizedBox()
                : SizedBox(),
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

  void changedDropDownItem(String selectedGender) {
    setState(() {
      _currentGender = selectedGender;
    });
  }

  void changedDropDownItemFitness(String selectedFitness) {
    setState(() {
      _currentfitnessType = selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
      for (int index = 0; index < data_fitnessType.length; index++) {
        if (data_fitnessType[index]["name"] == _currentfitnessType)
          _currentfitnessTypeIndex = data_fitnessType[index]["id"];
      }
    });
  }

  void changedDropDownItemSport(String selectedFitness) {
    setState(() {
      _currentsportType = selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
      for (int index = 0; index < data_sportType.length; index++) {
        if (data_sportType[index]["name"] == _currentsportType)
          _currentsportTypeIndex = data_sportType[index]["id"];
      }
    });
  }

  void changedDropDownItemCategory(String selectedFitness) {
    setState(() {
      _currentcategoryType = selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
      for (int index = 0; index < data_categoryType.length; index++) {
        if (data_categoryType[index]["name"] == _currentcategoryType)
          _currentcategoryTypeIndex = data_categoryType[index]["id"];
      }
    });
  }

  void fvoidUpdateCustomer() async {
    String url = "http://165.227.137.83:9000/api/v1/updateCustomer";

    //String datum_rodenja = datumRodenja.text;
    String kucna_adresa = _controller_adresa.text;
    String city = _controller_grad.text;
    String zipCode = _controller_pos_broj.text;
    String phoneNumber = _controller_mobitel.text;
    String firstName = _controller_ime.text;
    String lastName = _controller_prezime.text;
    String email = _controller_mail.text;


    String spol = "";
    if (_currentGender == "Musko") {
      spol = "1";
    } else if (_currentGender == "Zensko") {
      spol = "2";
    } else {
      spol = "3";
    }

    String json_body =
        '{"active" : "true", "dateOfBirth" : "$datum_rodenja","gender" : "$spol","address" : "$kucna_adresa", "city" : "$city","zipCode" : "$zipCode","phoneNumber" : "$phoneNumber",'
        '"firstName" : "$firstName","lastName" : "$lastName","email" : "$email","termsOfUse" : true,"gdpr_privola_email" : $gdpr_privola_email,"gdpr_privola_mob" : $gdpr_privola_mob,"gdpr_privola_posta" : $gdpr_privola_posta,"categoryType" : $_currentcategoryTypeIndex,'
        '"fitnessType" : $_currentfitnessTypeIndex,"sportType" : $_currentsportTypeIndex}';

    http.Response response = await http.post(url, body: json_body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "req_type": "mob",
      "token": "$token",
      "app_version": "ios",
    }).then((http.Response response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print("response.header ");
      print(response.headers);
      print("response.request ");
      print(response.request);
      print(response.statusCode);
      print(json_body);
      print(response.body);

      if (response.statusCode == 200) {
        var resBody = json.decode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('email', resBody["email"]);
        //await prefs.setString('token', resBody["token"]);
        await prefs.setString('ime', resBody["firstName"]);
        await prefs.setString('prezime', resBody["lastName"]);
        await prefs.setString('referenceNumber', resBody["referenceNumber"]);
        await prefs.setBool('termsOfUse', resBody["termsOfUse"]);
        await prefs.setBool('gdpr_privola_mob', resBody["gdpr_privola_mob"]);
        await prefs.setBool('gdpr_privola_email', resBody["gdpr_privola_email"]);
        await prefs.setBool('gdpr_privola_posta', resBody["gdpr_privola_posta"]);
        await prefs.setDouble('currentPoints', resBody["currentPoints"]);
        await prefs.setString('dateOfBirth', resBody["dateOfBirth"]);
        await prefs.setString('gender', resBody["gender"]);
        await prefs.setString('address', resBody["address"]);
        await prefs.setString('city', resBody["city"]);
        await prefs.setString('zipCode', resBody["zipCode"]);
        await prefs.setString('phoneNumber', resBody["phoneNumber"]);
        await prefs.setString('categoryName', resBody["categoryName"]);
        await prefs.setString('fitnessName', resBody["fitnessName"]);
        await prefs.setString('sportName', resBody["sportName"]);
        await prefs.setString('placeOfRegistration', resBody["placeOfRegistration"]);
        Fluttertoast.showToast(
            msg:
            "Uspješno ažurirani podatci",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // also possible "TOP" and "CENTER"
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg:
            "Neuspješno ažurirani podatci",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // also possible "TOP" and "CENTER"
            textColor: Colors.white);
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }
}
