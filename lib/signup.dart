library flutter_app.signup;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool spol = true; //1-muško,0 žensko
  final formats = {
    InputType.date: DateFormat('dd-MM-yyyy'),
  };

  InputType inputType = InputType.date;
  bool editable = true;
  DateTime date;

  List _gender =
  ["Musko", "Zensko", "Ostalo"];

  List<DropdownMenuItem<String>> _dropDownMenuItemsGender;
  String _currentGender;

  List<DropdownMenuItem<String>> _dropDownMenuItemsfitnessTypeList;
  String _currentfitnessType;

  List<DropdownMenuItem<String>> _dropDownMenuItemssportTypeList;
  String _currentsportType;

  List<DropdownMenuItem<String>> _dropDownMenuItemscategoryTypeList;
  String _currentcategoryType;

  final String url = "http://165.227.137.83:9000/api/v1/getPrefTypes";

  List data_fitnessType;
  List data_sportType;
  List data_categoryType;

  Future<String> getPrefTypeData() async {
    var res =
    await http.get(Uri.parse(url));

    setState(() {
      var resBody = json.decode(res.body);
      data_fitnessType = resBody["fitnessTypeList"];
      data_sportType = resBody["sportTypeList"];
      data_categoryType = resBody["categoryTypeList"];

      _dropDownMenuItemsfitnessTypeList = getDropDownMenuItemsFitnessType();
      _currentfitnessType = _dropDownMenuItemsfitnessTypeList[0].value;

      _dropDownMenuItemssportTypeList = getDropDownMenuItemsSportType();
      _currentsportType = _dropDownMenuItemssportTypeList[0].value;

      _dropDownMenuItemscategoryTypeList = getDropDownMenuItemsCategoryType();
      _currentcategoryType = _dropDownMenuItemscategoryTypeList[0].value;

    });

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,


      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
        Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 100.0,
                child: Image.asset(
                  "assets/images/registriraj_logo.png",
                  fit: BoxFit.fill,
                ),
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                  padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Dobro došao u LeoClub program nagrađivanja!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Upiši u svoje podatke, registriraj se i koristi članske pogodnosti već danas.",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[ Text(
                          "Već imaš račun?",style: TextStyle(fontSize: 16),),InkWell(
                          child: new Text("Prijavi se",style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline,fontWeight: FontWeight.bold,fontSize: 16),),
                          onTap: () {
                            Navigator.of(context).pop(true);
                          },
                        )],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:5,bottom: 5),
                        child: TextField(
                          decoration: InputDecoration(
                              labelText: 'Ime',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              // hintText: 'EMAIL',
                              // hintStyle: ,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue))),
                        ),
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
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Mobitel',
                            hintText: "+385911234567",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
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
                                borderSide: BorderSide(color: Colors.blue))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      new DropdownButton(
                        value: _currentGender,
                        items: _dropDownMenuItemsGender,
                        onChanged: changedDropDownItem,
                      ),

                      new DropdownButton(
                        value: _currentfitnessType,
                        items: _dropDownMenuItemsfitnessTypeList,
                        onChanged: changedDropDownItemFitness,
                      ),

                      new DropdownButton(
                        value: _currentsportType,
                        items: _dropDownMenuItemssportTypeList,
                        onChanged: changedDropDownItemSport,
                      ),

                      new DropdownButton(
                        value: _currentcategoryType,
                        items: _dropDownMenuItemscategoryTypeList,
                        onChanged: changedDropDownItemCategory,
                      ),

                      DateTimePickerFormField(
                        inputType: inputType,
                        format: formats[inputType],
                        editable: editable,
                        decoration: InputDecoration(
                          hintText: "Datum rođenja",
                            labelText: 'Datum rođenja', hasFloatingPlaceholder: false,
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        onChanged: (dt) => setState(() => date = dt),

                      ),

                      SizedBox(height: 20.0),
                      Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.blueAccent,
                            color: Colors.blue,
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () {},
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
                  )),
            ],
          ),
        ),

        // SizedBox(height: 15.0),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Text(
        //       'New to Spotify?',
        //       style: TextStyle(
        //         fontFamily: 'Montserrat',
        //       ),
        //     ),
        //     SizedBox(width: 5.0),
        //     InkWell(
        //       child: Text('Register',
        //           style: TextStyle(
        //               color: Colors.green,
        //               fontFamily: 'Montserrat',
        //               fontWeight: FontWeight.bold,
        //               decoration: TextDecoration.underline)),
        //     )
        //   ],
        // )
      ])),
    );
  }

  @override
  void initState() {
    _dropDownMenuItemsGender = getDropDownMenuItems();
    _currentGender = _dropDownMenuItemsGender[0].value;
    this.getPrefTypeData();
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String gender in _gender) {
      items.add(new DropdownMenuItem(
          value: gender,
          child: new Text(gender)
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsFitnessType() {
    List<DropdownMenuItem<String>> items = new List();
    for (int index=0; index<data_fitnessType.length;index++) {
      items.add(new DropdownMenuItem(
          value: data_fitnessType[index]["name"],
          child: new Text(data_fitnessType[index]["name"])
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsSportType() {
    List<DropdownMenuItem<String>> items = new List();
    for (int index=0; index<data_sportType.length;index++) {
      items.add(new DropdownMenuItem(
          value: data_sportType[index]["name"],
          child: new Text(data_sportType[index]["name"])
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsCategoryType() {
    List<DropdownMenuItem<String>> items = new List();
    for (int index=0; index<data_categoryType.length;index++) {
      items.add(new DropdownMenuItem(
          value: data_categoryType[index]["name"],
          child: new Text(data_categoryType[index]["name"])
      ));
    }
    return items;
  }

  void changedDropDownItem(String selectedGender) {
    setState(() {
      _currentGender = selectedGender;
      print("Selected city $selectedGender, we are going to refresh the UI");
    });
  }

  void changedDropDownItemFitness(String selectedFitness) {
    setState(() {
      _currentfitnessType = selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
    });
  }

  void changedDropDownItemSport(String selectedFitness) {
    setState(() {
      _currentsportType= selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
    });
  }

  void changedDropDownItemCategory(String selectedFitness) {
    setState(() {
      _currentcategoryType= selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
    });
  }


}


