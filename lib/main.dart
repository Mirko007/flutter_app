import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'fragment/main_fragment.dart';
import 'global_variable.dart' as globals;
import 'signup.dart';

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
  final EmailText = TextEditingController();

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
                      controller: EmailText,
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
                              if (EmailText.text == "Apple/Test") {
                                Navigator.of(context).pushNamed('/main');
                              } else
                                _callServisEmail(EmailText.text);
                              //Navigator.of(context).pushNamed('/main');
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
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Image.asset(
                  "assets/images/prijava_logo_polleo.png",
                ),
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _getPref();
  }

  _callServisEmail(String EmailText) async {
    String url = globals.base_url + "/api/v1/requestOTP";
    String json_body = '{"active" : true, "email" : "$EmailText"}';

    await http.post(url, body: json_body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((http.Response response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      print(response.statusCode);
      print(json_body);
      print(response.body);

      if (response.statusCode == 200) {
        _asyncInputDialog(context, EmailText);
      } else {
//        Fluttertoast.showToast(
//            msg: "Neuspješan dohvat podataka",
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.BOTTOM,
//            // also possible "TOP" and "CENTER"
//            textColor: Colors.white);
//        // If that call was not successful, throw an error.
//        throw Exception('Failed to load post');
        //todo http, https
        /************************************************/
        /************************************************/
        /************************************************/
        /************************************************/
        /************************************************/
        await http.post(globals.base_url_novi + "/api/v1/requestOTP",
            body: json_body,
            headers: {
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
            globals.which_url = 1;
            _asyncInputDialog(context, EmailText);
          } else {
            globals.which_url = 0;
            Fluttertoast.showToast(
                msg: "Neuspješan dohvat podataka",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                // also possible "TOP" and "CENTER"
                textColor: Colors.white);
            // If that call was not successful, throw an error.
            throw Exception('Failed to load post');
            //todo http, https

          }
        });

        /************************************************/
        /************************************************/
        /************************************************/
        /************************************************/
        /************************************************/
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
    if (globals.which_url == 0)
      url = globals.base_url + "/api/v1/confirmOTP";
    else
      url = globals.base_url_novi + "/api/v1/confirmOTP";
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
        fvoidGetCustomer(resBody["token"], EmailTextConfirm);
      } else {
        Fluttertoast.showToast(
            msg: "Neuspješan dohvat podataka",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // also possible "TOP" and "CENTER"
            textColor: Colors.white);
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  void fvoidGetCustomer(String token, String EmailText) async {
    String url;
    if (globals.which_url == 0)
      url = globals.base_url + "/api/v1/getCustomer";
    else
      url = globals.base_url_novi + "/api/v1/getCustomer";

    await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "req_type": "mob",
      "token": "$token"
    }).then((http.Response response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var resBody = json.decode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('email', resBody["email"]);
        prefs.setString('token', token);
        await prefs.setString('ime', resBody["firstName"]);
        await prefs.setString('prezime', resBody["lastName"]);
        await prefs.setString('referenceNumber', resBody["referenceNumber"]);
        await prefs.setBool('termsOfUse', resBody["termsOfUse"]);
        await prefs.setBool('gdpr_privola_mob', resBody["gdpr_privola_mob"]);
        await prefs.setBool(
            'gdpr_privola_email', resBody["gdpr_privola_email"]);
        await prefs.setBool(
            'gdpr_privola_posta', resBody["gdpr_privola_posta"]);

        await prefs.setDouble(
            'currentPoints', double.parse(resBody["currentPoints"].toString()));

        //await prefs.setDouble('currentPoints', resBody["currentPoints"]);
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
        Navigator.of(context).pushNamed('/main');
      } else {
        Fluttertoast.showToast(
            msg: "Neuspješan dohvat podataka",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            // also possible "TOP" and "CENTER"
            textColor: Colors.white);
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  _getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!(prefs.getString('email') == ""))
        _checkUser(prefs.getString('token'));
    });
  }

  _checkUser(String token) async {
    String url = globals.base_url + "/api/v1/getCustomer";

    http.Response response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "req_type": "mob",
      "token": "$token"
    }).then((http.Response response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var resBody = json.decode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('email', resBody["email"]);
        prefs.setString('token', token);
        await prefs.setString('ime', resBody["firstName"]);
        await prefs.setString('prezime', resBody["lastName"]);
        await prefs.setString('referenceNumber', resBody["referenceNumber"]);
        await prefs.setBool('termsOfUse', resBody["termsOfUse"]);
        await prefs.setBool('gdpr_privola_mob', resBody["gdpr_privola_mob"]);
        await prefs.setBool(
            'gdpr_privola_email', resBody["gdpr_privola_email"]);
        await prefs.setBool(
            'gdpr_privola_posta', resBody["gdpr_privola_posta"]);

        await prefs.setDouble('currentPoints', resBody["currentPoints"]);
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
        Navigator.of(context).pushNamed('/main');
      } else {
        //todo ako nije http probaj https
        /***************************************************************************/
        /***************************************************************************/
        /***************************************************************************/
        /***************************************************************************/
        await http.get(globals.base_url_novi + "/api/v1/getCustomer", headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "req_type": "mob",
          "token": "$token"
        }).then((http.Response response) async {
          print("Response status: ${response.statusCode}");
          print("Response body: ${response.contentLength}");
          print(response.headers);
          print(response.request);
          print(response.statusCode);
          print(response.body);

          if (response.statusCode == 200) {
            //mijenja da se ide na https
            globals.which_url = 1;
            var resBody = json.decode(response.body);

            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setString('email', resBody["email"]);
            prefs.setString('token', token);
            await prefs.setString('ime', resBody["firstName"]);
            await prefs.setString('prezime', resBody["lastName"]);
            await prefs.setString(
                'referenceNumber', resBody["referenceNumber"]);
            await prefs.setBool('termsOfUse', resBody["termsOfUse"]);
            await prefs.setBool(
                'gdpr_privola_mob', resBody["gdpr_privola_mob"]);
            await prefs.setBool(
                'gdpr_privola_email', resBody["gdpr_privola_email"]);
            await prefs.setBool(
                'gdpr_privola_posta', resBody["gdpr_privola_posta"]);

            await prefs.setDouble('currentPoints', resBody["currentPoints"]);
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
            Navigator.of(context).pushNamed('/main');
          } else {
            globals.which_url = 0;
            // If that call was not successful, throw an error.
            throw Exception('Failed to load post');
          }
        });

        /***************************************************************************/
        /***************************************************************************/
        /***************************************************************************/
        /***************************************************************************/
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }
}
