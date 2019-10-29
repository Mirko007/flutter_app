library Loyalty_client.signup;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fragment/main_fragment.dart';
import 'global_variable.dart' as globals;

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
  bool terms_of_use = false;

  List _gender = ["Musko", "Zensko", "Ne želim se izjasniti"];

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



  List data_fitnessType;
  List data_sportType;
  List data_categoryType;

  Future<String> getPrefTypeData() async {

    String url = globals.base_url_novi + "/api/v1/getPrefTypes";
    var res = await http.get(Uri.parse(url));

//    if(json.decode(res.body)["fitnessTypeList"]==null)
//      {
//        String url = globals.base_url_novi + "/api/v1/getPrefTypes";
//        res = await http.get(Uri.parse(url));
//      }
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
                        children: <Widget>[
                          Text(
                            "Već imaš račun?",
                            style: TextStyle(fontSize: 16),
                          ),
                          InkWell(
                            child: new Text(
                              "Prijavi se",
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
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
                                  borderSide: BorderSide(color: Colors.blue))),
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
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: PrezimeText,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Mobitel (Opcionalno)',
                            hintText: "+385911234567",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
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
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: EmailText,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Kućna adresa (Opcionalno)',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: KucnaAdresaText,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Poštanski broj (Opcionalno)',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: PostanskiBrojText,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Grad (Opcionalno)',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        controller: GradText,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DateTimePickerFormField(
                        inputType: inputType,
                        format: formats[inputType],
                        editable: editable,
                        firstDate: DateTime(1940),
                        lastDate: DateTime.now().subtract(
                          Duration(days: 5840),
                        ),
                        initialDate: DateTime.now().subtract(
                          Duration(days: 5841),
                        ),
                        decoration: InputDecoration(
                            hintText: "Datum rođenja",
                            labelText: 'Datum rođenja (Opcionalno)',
                            hasFloatingPlaceholder: false,
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        onChanged: (dt) => setState(() => date = dt),
                        controller: datumRodenja,
                      ),
                      SizedBox(height: 20.0),
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
                          value: terms_of_use,
                          title: new Text(
                              "Prihvaćam i slažem se s Uvjetima korištenja"),
                          onChanged: (bool value) {
                            setState(() {
                              terms_of_use = value;
                            });
                          }),
                      RaisedButton(
                        onPressed: _launchURL,
                        padding: EdgeInsets.all(5),
                        child: new Text("Uvjeti korištenja"),
                      ),
                      CheckboxListTile(
                          value: gdpr_privola,
                          title: new Text(
                              "Dajem suglasnost da mi Polleo Adria d.o.o šalje obavijesti o Programu te ponude i pogodnosti putem mobitela, elektroničke pošte i pošte"),
                          onChanged: (bool value) {
                            setState(() {
                              gdpr_privola = value;
                            });
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (gdpr_privola &&
                              terms_of_use &&
                              !(ImeText.text == "") &&
                              !(EmailText.text == "") &&
                              !(PrezimeText.text == "")) {
                            fvoidServisEmail(EmailText.text);
                          } else {
                            print(
                                "gdpr_privola" + gdpr_privola.toString());
                            Fluttertoast.showToast(
                                msg:
                                "Molimo unesite sve obavezne podatke i omogućite privolu",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                // also possible "TOP" and "CENTER"
                                textColor: Colors.white);
                          }
                        },
                        child: Container(
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.blueAccent,
                              color: Colors.blue,
                              elevation: 7.0,
                              child: Center(
                                  child: Text(
                                    'Registriraj se',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                              ),
                            )),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  )),
            ],
          ),
        ),

      ])),
    );
  }

  @override
  void initState() {
    _dropDownMenuItemsGender = getDropDownMenuItems();
    _currentGender = _dropDownMenuItemsGender[2].value;
    this.getPrefTypeData();
    super.initState();
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
    items.add(new DropdownMenuItem(value: "", child: new Text("")));
    for (int index = 0; index < data_fitnessType.length; index++) {
      items.add(new DropdownMenuItem(
          value: data_fitnessType[index]["name"],
          child: new Text(data_fitnessType[index]["name"])));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsSportType() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(value: "", child: new Text("")));
    for (int index = 0; index < data_sportType.length; index++) {
      items.add(new DropdownMenuItem(
          value: data_sportType[index]["name"],
          child: new Text(data_sportType[index]["name"])));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsCategoryType() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(value: "", child: new Text("")));
    for (int index = 0; index < data_categoryType.length; index++) {
      items.add(new DropdownMenuItem(
          value: data_categoryType[index]["name"],
          child: new Text(data_categoryType[index]["name"])));
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
      for (int index = 0; index < data_fitnessType.length; index++) {
        if (data_fitnessType[index]["name"] == _currentfitnessType) {
          _currentfitnessTypeIndex = data_fitnessType[index]["id"];
        } else if (_currentfitnessType == "") {
          _currentfitnessTypeIndex = null;
        }
      }
    });
  }

  void changedDropDownItemSport(String selectedFitness) {
    setState(() {
      _currentsportType = selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
      for (int index = 0; index < data_sportType.length; index++) {
        if (data_sportType[index]["name"] == _currentsportType) {
          _currentsportTypeIndex = data_sportType[index]["id"];
        } else if (_currentsportType == "") {
          _currentsportTypeIndex = null;
        }
      }
    });
  }

  void changedDropDownItemCategory(String selectedFitness) {
    setState(() {
      _currentcategoryType = selectedFitness;
      print("Selected city $selectedFitness, we are going to refresh the UI");
      for (int index = 0; index < data_categoryType.length; index++) {
        if (data_categoryType[index]["name"] == _currentcategoryType) {
          _currentcategoryTypeIndex = data_categoryType[index]["id"];
        } else if (_currentcategoryType == "") {
          _currentcategoryTypeIndex = null;
        }
      }
    });
  }

  void fvoidServisEmail(String text) async {
    String url;
//    if (globals.which_url == 0)
//      url = globals.base_url + "/api/v1/requestOTP";
//    else
      url = globals.base_url_novi + "/api/v1/requestOTP";

    String json_body = '{"active" : false, "email" : "$text"}';

    await http.post(url, body: json_body, headers: {
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
        Fluttertoast.showToast(
            msg: "Neuspješna registracija, email se već koristi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // also possible "TOP" and "CENTER"
            textColor: Colors.white);
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
    String url;
//    if (globals.which_url == 0)
//      url = globals.base_url + "/api/v1/confirmOTP";
//    else
      url = globals.base_url_novi + "/api/v1/confirmOTP";

    String json_body = '{"otp" : "$dialogOTP", "email" : "$EmailTextConfirm"}';

    await http.post(url, body: json_body, headers: {
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
        Fluttertoast.showToast(
            msg: "Neuspješna registracija, kriva jednokratna lozinka",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // also possible "TOP" and "CENTER"
            textColor: Colors.white);
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  void fvoidCreateCustomer(String token, String emailTextConfirm) async {
    String url;

      url = globals.base_url_novi + "/api/v1/updateCustomer";

    String datum_rodenja = datumRodenja.text;
    final now = DateTime.now();
    final date_minus_year = new DateTime(now.year - 16, now.month, now.day);
    if (datumRodenja.text == "")
      datum_rodenja = DateFormat('dd/MM/yyyy').format(date_minus_year);

    String kucna_adresa = KucnaAdresaText.text;
    if (KucnaAdresaText.text == "") kucna_adresa = " ";

    String city = GradText.text;
    if (GradText.text == "") city = " ";

    String zipCode = PostanskiBrojText.text;
    if (PostanskiBrojText.text == "") zipCode = " ";

    String phoneNumber = MobitelText.text;
    if (MobitelText.text == "") phoneNumber = globals.phone_number_dummmy;

    String firstName = ImeText.text;
    String lastName = PrezimeText.text;
    String email = EmailText.text;

    String spol = "";
    if (_currentGender == "Musko") {
      spol = "1";
    } else if (_currentGender == "Zensko") {
      spol = "2";
    } else {
      spol = "3";
    }

    String json_body =
        '{"active" : "false", "dateOfBirth" : "$datum_rodenja","gender" : "$spol","address" : "$kucna_adresa", "city" : "$city","zipCode" : "$zipCode","phoneNumber" : "$phoneNumber",'
        '"firstName" : "$firstName","lastName" : "$lastName","email" : "$email","termsOfUse" : true,"gdpr_privola_email" : true,"gdpr_privola_mob" : true,"gdpr_privola_posta" : true,"categoryType" : $_currentcategoryTypeIndex,'
        '"fitnessType" : $_currentfitnessTypeIndex,"sportType" : $_currentsportTypeIndex}';

    await http.post(url, body: json_body, headers: {
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
        print(resBody["token"]);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('email', resBody["email"]);
        await prefs.setString('token', token);
        await prefs.setString('ime', resBody["firstName"]);
        await prefs.setString('prezime', resBody["lastName"]);
        await prefs.setString('referenceNumber', resBody["referenceNumber"]);
        await prefs.setBool('termsOfUse', resBody["termsOfUse"]);
        await prefs.setBool('gdpr_privola_mob', resBody["gdpr_privola_mob"]);
        await prefs.setBool(
            'gdpr_privola_email', resBody["gdpr_privola_email"]);
        await prefs.setBool(
            'gdpr_privola_posta', resBody["gdpr_privola_posta"]);

        String currentPoints = resBody["currentPoints"].toString();
        await prefs.setDouble('currentPoints', double.parse(currentPoints));

        await prefs.setString('dateOfBirth', resBody["dateOfBirth"]);
        await prefs.setString('gender', resBody["gender"]);

        if (resBody["address"] == " ")
          await prefs.setString('address', "");
        else
          await prefs.setString('address', resBody["address"]);

        if (resBody["city"] == " ")
          await prefs.setString('city', "");
        else
          await prefs.setString('city', resBody["city"]);

        if (resBody["zipCode"] == " ")
          await prefs.setString('zipCode', "");
        else
          await prefs.setString('zipCode', resBody["zipCode"]);

        if (resBody["phoneNumber"] == globals.phone_number_dummmy)
          await prefs.setString('phoneNumber', "");
        else
          await prefs.setString('phoneNumber', resBody["phoneNumber"]);

        await prefs.setString('categoryName', resBody["categoryName"]);
        await prefs.setString('fitnessName', resBody["fitnessName"]);
        await prefs.setString('sportName', resBody["sportName"]);
        await prefs.setString(
            'placeOfRegistration', resBody["placeOfRegistration"]);
        Fluttertoast.showToast(
            msg: "Uspješna registracija",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // also possible "TOP" and "CENTER"
            textColor: Colors.white);
        Navigator.of(context).pushNamed('/main');
      } else {
        Fluttertoast.showToast(
            msg: "Neuspješna registracija",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // also possible "TOP" and "CENTER"
            textColor: Colors.white);
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  _launchURL() async {
    const url = "https://leoclub.polleosport.hr/pravila-programa";
    print(url);
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
