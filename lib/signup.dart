library flutter_app.signup;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool spol = true; //1-muško,0 žensko
  final formats = {
    InputType.date: DateFormat('dd/MM/yyyy'),
  };

  InputType inputType = InputType.date;
  bool editable = true;
  DateTime date;

  final EmailText = TextEditingController();
  final ImeText = TextEditingController();
  final PrezimeText = TextEditingController();
  final MobitelText = TextEditingController();
  final KucnaAdresaText = TextEditingController();
  final PostanskiBrojText = TextEditingController();
  final GradText = TextEditingController();
  final datumRodenja = TextEditingController();
  bool gdpr_privola = false;

  List _gender =
  ["Musko", "Zensko", "Ostalo"];

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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0),
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
                              "Već imaš račun?",
                              style: TextStyle(fontSize: 16),), InkWell(
                              child: new Text("Prijavi se", style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),),
                              onTap: () {
                                Navigator.of(context).pop(true);
                              },
                            )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: TextField(
                              decoration: InputDecoration(
                                  labelText: 'Ime',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  // hintText: 'EMAIL',
                                  // hintStyle: ,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue))),
                              controller: ImeText,
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
                                    borderSide: BorderSide(
                                        color: Colors.blue))),
                            controller: PrezimeText,
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
                                    borderSide: BorderSide(
                                        color: Colors.blue))),
                            controller: MobitelText,
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
                                    borderSide: BorderSide(
                                        color: Colors.blue))),
                            controller: EmailText,
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
                                    borderSide: BorderSide(
                                        color: Colors.blue))),
                            controller: KucnaAdresaText,
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
                                    borderSide: BorderSide(
                                        color: Colors.blue))),
                            controller: PostanskiBrojText,
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
                                    borderSide: BorderSide(
                                        color: Colors.blue))),
                            controller: GradText,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DateTimePickerFormField(
                            inputType: inputType,
                            format: formats[inputType],
                            editable: editable,
                            decoration: InputDecoration(
                                hintText: "Datum rođenja",
                                labelText: 'Datum rođenja',
                                hasFloatingPlaceholder: false,
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            onChanged: (dt) => setState(() => date = dt),
                            controller: datumRodenja,

                          ),

                          SizedBox(height: 20.0),

                          Text(
                            "Spol",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14,
                                color: Colors.grey),
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

                          CheckboxListTile(value: gdpr_privola,
                              title: new Text(
                                  "Dajem suglasnost da mi Polleo Adria d.o.o šalje obavijesti o Programu te ponude i pogodnosti putem mobitela, elektroničke pošte i pošte"),
                              onChanged: (bool value) {
                                setState(() {
                                  gdpr_privola = value;
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
                                    if (gdpr_privola) {
                                      fvoidServisEmail(EmailText.text);
                                    } else {
                                      print("gdpr_privola" +
                                          gdpr_privola.toString());
                                      Fluttertoast.showToast(
                                          msg: "Molimo unesite sve podatke i omogućite privolu",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          // also possible "TOP" and "CENTER"
                                          textColor: Colors.white);
                                    }
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
    for (int index = 0; index < data_fitnessType.length; index++) {
      items.add(new DropdownMenuItem(
          value: data_fitnessType[index]["name"],
          child: new Text(data_fitnessType[index]["name"])
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsSportType() {
    List<DropdownMenuItem<String>> items = new List();
    for (int index = 0; index < data_sportType.length; index++) {
      items.add(new DropdownMenuItem(
          value: data_sportType[index]["name"],
          child: new Text(data_sportType[index]["name"])
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsCategoryType() {
    List<DropdownMenuItem<String>> items = new List();
    for (int index = 0; index < data_categoryType.length; index++) {
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
      _currentsportType = selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
    });
  }

  void changedDropDownItemCategory(String selectedFitness) {
    setState(() {
      _currentcategoryType = selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
    });
  }

  void fvoidServisEmail(String text) async {
    String url = "http://165.227.137.83:9000/api/v1/requestOTP";
    String json_body = '{"isActive" : true, "email" : "$text"}';

    http.Response response = await http.post(url, body: json_body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((http.Response response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      print(response.statusCode);
      print(json_body);
      print(response.body);

      if (response.statusCode == 200) {
        _asyncInputDialog(context, text);
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  _asyncInputDialog(BuildContext context, String EmailText) async {
    String dialogOTP = "";
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Na mail smo vam poslali kod koji je potrebno ovdje unijeti'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: new InputDecoration(),
                    onChanged: (value) {
                      dialogOTP = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                fvoidServisEmailOTP(dialogOTP, EmailText);
              },
            ),
          ],
        );
      },
    );
  }

  void fvoidServisEmailOTP(String dialogOTP, String EmailTextConfirm) async {
    String url = "http://165.227.137.83:9000/api/v1/confirmOTP";
    String json_body = '{"otp" : "$dialogOTP", "email" : "$EmailTextConfirm"}';

    http.Response response = await http.post(url, body: json_body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((http.Response response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      print(response.statusCode);
      print(json_body);
      print(response.body);

      if (response.statusCode == 200) {
        var resBody = json.decode(response.body);
        print(resBody["token"]);
        fvoidCreateCustomer(resBody["token"], EmailTextConfirm);
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  void fvoidCreateCustomer(String token, String emailTextConfirm) async {
    String url = "http://165.227.137.83:9000/api/v1/updateCustomer";

    String datum_rodenja = datumRodenja.text;
    String kucna_adresa = KucnaAdresaText.text;
    String city = GradText.text;
    String zipCode = PostanskiBrojText.text;
    String phoneNumber = MobitelText.text;
    String firstName = ImeText.text;
    String lastName = PrezimeText.text;
    String email = EmailText.text;

    String spol = "";
    if (_currentGender == "Musko") {
      spol = "Male";
    } else if (_currentGender == "Zensko") {spol = "Female";} else {spol = "Other";}

    //active inace false, sada za test true
    String json_body = '{"active" : "true", "dateOfBirth" : "$datum_rodenja","gender" : "$spol","address" : "$kucna_adresa", "city" : "$city","zipCode" : "$zipCode","phoneNumber" : "$phoneNumber",''"firstName" : "$firstName","lastName" : "$lastName","email" : "$email","termsOfUse" : true,"gdpr_privola_email" : true,"gdpr_privola_mob" : true,"gdpr_privola_posta" : true,"categoryType" : "$_currentcategoryType",''"fitnessType" : "$_currentfitnessType","sportType" : "$_currentsportType",}';
//    this.active = active;
//    this.dateOfBirth = dateOfBirth;
//    this.gender = gender;
//    this.address = address;
//    this.city = city;
//    this.zipCode = zipCode;
//    this.phoneNumber = phoneNumber;
//    this.firstName = firstName;
//    this.lastName = lastName;
//    this.email = email;
//    this.termsOfUse = termsOfUse;
//    this.gdpr_privola_email = gdpr_privola_email;
//    this.gdpr_privola_mob = gdpr_privola_mob;
//    this.gdpr_privola_posta = gdpr_privola_posta;
//    false",
//    et_datum_rodenja.getText().toString(),
//    vstr_gender_type,
//    et_kucna_adresa.getText().toString(),
//    et_grad.getText().toString(),//city
//    et_post_broj_i_grad.getText().toString(),
//    et_mobitel.getText().toString(),
//    et_ime.getText().toString(),
//    et_prezime.getText().toString(),
//    et_email.getText().toString(),
//    vstr_category_type,
//    vstr_fitness_type,
//    vstr_sport_type,
//    true,
//    true,
//    true,
//    true

    http.Response response = await http.post(url, body: json_body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "req_type": "mob",
      "token": "$token",
      "app_version": "ios",
    }).then((http.Response response) {
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
        print(resBody["token"]);
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }


}


