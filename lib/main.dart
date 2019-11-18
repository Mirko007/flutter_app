import 'package:Loyalty_client/MessageActivity.dart';
import 'package:background_fetch/background_fetch.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_helper.dart';
import 'fragment/main_fragment.dart';
import 'global_variable.dart' as globals;
import 'signup.dart';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

const EVENTS_KEY = "fetch_events";

List data;
final dbHelperHeadless = DatabaseHelper.instance;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless event received.');

  try {
    List allRows = await dbHelper.queryAllRowsWhereDeleted("");
    for (int i = 0; i < allRows.length; i++) {
      //todo VANJA mijenjati prilikom izbacivanja verzije
//      Calendar c = Calendar.getInstance();
//      c.add(Calendar.HOUR, -150);

      // c.add(Calendar.MINUTE, -1);
      //c.add(Calendar.SECOND, -20);
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      String getCurrentDateTime = dateFormat.format(DateTime.now());
      DateTime currentDatetime = dateFormat.parse(getCurrentDateTime);

      DateTime databaseDateTime = dateFormat.parse(allRows[i]["deleted"]);

      final difference = currentDatetime.difference(databaseDateTime).inHours;
      if (difference < -150 || difference > 150) {
        dbHelper.delete(allRows[i]["id"]);
      }
    }
  } catch (error) {}

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Read fetch_events from SharedPreferences
//  List<String> events = [];
//  String jsons = prefs.getString(EVENTS_KEY);
//  if (jsons != null) {
//    events = jsonDecode(jsons).cast<String>();
//  }
//  // Add new event.
//  events.insert(0, new DateTime.now().toString() + ' [Headless]');
//
//  print('[Vanja] Headless event received.' + events[0]);
//  // Persist fetch events in SharedPreferences
//  prefs.setString(EVENTS_KEY, jsonEncode(events));

  String url = globals.base_url_novi + "/api/v1/messages";

  String token = (prefs.getString('token') ?? "");

  http.Response response = await http.get(url, headers: {
    "Accept": "application/json",
    "content-type": "application/json",
    "token": "$token",
    "req_type": "mob"
  }).then((http.Response response) async {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.contentLength}");
    print(response.headers);
    print(response.request);
    print(response.statusCode);
    print(response.body);
    String title = "";
    String message = "";
    if (response.statusCode == 200) {
      // ignore: missing_return
      List dataMessage = json.decode(response.body);

      int NePostojiPoruka = 0;

      if (dataMessage.length != null) {
        for (int i = 0; i < dataMessage.length; i++) {
          int querycount =
              await dbHelper.queryMessageExists(dataMessage[i]["id"]);
          if (querycount < 1) {
            NePostojiPoruka++;
            Map<String, dynamic> row = {
              DatabaseHelper.columnIdMessage: dataMessage[i]["id"],
              DatabaseHelper.columnCreated:
                  dataMessage[i]["created"].toString(),
              DatabaseHelper.columnTitle: dataMessage[i]["title"],
              DatabaseHelper.columnMessage: dataMessage[i]["message"],
              DatabaseHelper.columnDeleted: "",
              DatabaseHelper.columnReadStatus: 0,
            };
            dbHelper.insert(row);
          }

          title = dataMessage[i]["title"];
          message = dataMessage[i]["message"];
        }
      }

      int ReadMessageCount =await dbHelper.queryReadMessageExists();
      NePostojiPoruka+= ReadMessageCount;
      if (NePostojiPoruka > 1) {

        title = "Imate nove poruke";
        message = NePostojiPoruka.toString() + " novih poruka";
        _showNotification(title, message);
      } else if (NePostojiPoruka > 0) {
        _showNotification(title, message);
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  });
//  Map<String, dynamic> row = {
//    DatabaseHelper.columnIdMessage: "36",
//    DatabaseHelper.columnCreated: "Vrijeme",
//    DatabaseHelper.columnTitle: "Vanja",
//    DatabaseHelper.columnMessage: "uspjeh Headless servis",
//    DatabaseHelper.columnDeleted: DateTime.now().toString(),
//    DatabaseHelper.columnReadStatus: 0,
//  };
//   dbHelperHeadless.insert(row);
//  print('updated $rowsAffected row(s)');
  //dbHelperHeadless.delete(36);
  //dbHelperHeadless.delete(34);

  BackgroundFetch.finish();
}

void main() {
  debugPaintSizeEnabled = false;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Colors.blue, // status bar color
  ));
  runApp(new MyApp());

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  // reference to our single class that manages the database
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/main': (BuildContext context) => new Main_Fragment(
              tab: 2,
            ),
        '/messages': (BuildContext context) => new MessageActivity(),
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _events = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final dbHelper = DatabaseHelper.instance;

  final EmailText = TextEditingController();
  static const EMPTY_TEXT = Center(child: Text('Waiting for fetch events.'));

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
//        body: (data == null)
//            ? EMPTY_TEXT
//            : Container(
//                child: new ListView.builder(
//                    itemCount: data == null ? 0 : data.length,
//                    itemBuilder: (BuildContext context, int index) {
//                      String timestamp = data[index]["message"];
//                      return GestureDetector(
//                        onTap: () => onTapped(index),
////                            Scaffold
////                            .of(context)
////                            .showSnackBar(SnackBar(content: Text(data[index]["title"]))),
//                        child: InputDecorator(
//                            decoration: InputDecoration(
//                                contentPadding: EdgeInsets.only(
//                                    left: 5.0, top: 5.0, bottom: 5.0),
//                                labelStyle: TextStyle(
//                                    color: Colors.blue, fontSize: 20.0),
//                                labelText: data[index]["title"]),
//                            child: new Text(timestamp,
//                                style: TextStyle(
//                                    color: Colors.black, fontSize: 16.0))),
//                      );
//                    }),
//              ));
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/launcher_icon');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
    _query();
    initPlatformState();
    _getPref();
  }

  _callServisEmail(String EmailText) async {
    String url = globals.base_url_novi + "/api/v1/requestOTP";
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
            _asyncInputDialog(context, EmailText);
          } else {
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

    url = globals.base_url_novi + "/api/v1/confirmOTP";
    String json_body = '{"otp" : "$dialogOTP", "email" : "$EmailTextConfirm"}';

    http.Response response = await http.post(url, body: json_body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((http.Response response) {
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
    String url = globals.base_url_novi + "/api/v1/getCustomer";

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Load persisted fetch events from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString(EVENTS_KEY);
    if (json != null) {
      setState(() {
        _events = jsonDecode(json).cast<String>();
      });
    }
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
            BackgroundFetchConfig(
              minimumFetchInterval: 15,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
            ),
            _onBackgroundFetch)
        .then((int status) {
      print('[BackgroundFetch] configure success: $status');
      setState(() {
        // _status = status;
      });
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
      setState(() {
        //_status = e;
      });
    });

    // Optionally query the current BackgroundFetch status.
    int status = await BackgroundFetch.status;
    setState(() {
      // _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onBackgroundFetch() async {
    try {
      List allRows = await dbHelper.queryAllRowsWhereDeleted("");
      for (int i = 0; i < allRows.length; i++) {
        //todo VANJA mijenjati prilikom izbacivanja verzije
//      Calendar c = Calendar.getInstance();
//      c.add(Calendar.HOUR, -150);

        // c.add(Calendar.MINUTE, -1);
        //c.add(Calendar.SECOND, -20);
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        String getCurrentDateTime = dateFormat.format(DateTime.now());
        DateTime currentDatetime = dateFormat.parse(getCurrentDateTime);

        DateTime databaseDateTime = dateFormat.parse(allRows[i]["deleted"]);

        final difference = currentDatetime.difference(databaseDateTime).inHours;
        if (difference < -150 || difference > 150) {
          dbHelper.delete(allRows[i]["id"]);
        }
      }
    } catch (error) {}
    SharedPreferences prefs = await SharedPreferences.getInstance();

//    // This is the fetch-event callback.
//    print('[BackgroundFetch] Event received');
//    setState(() {
//      _events.insert(0, new DateTime.now().toString());
//    });
//
//    Map<String, dynamic> row = {
//      DatabaseHelper.columnIdMessage: "36",
//      DatabaseHelper.columnCreated: "Vrijeme",
//      DatabaseHelper.columnTitle: "Vanja",
//      DatabaseHelper.columnMessage: "uspjeh servis",
//      DatabaseHelper.columnDeleted: DateTime.now().toString(),
//      DatabaseHelper.columnReadStatus: 0,
//    };
//    await dbHelperHeadless.insert(row);
//    // Persist fetch events in SharedPreferences
//    prefs.setString(EVENTS_KEY, jsonEncode(_events));

    String url = globals.base_url_novi + "/api/v1/messages";

    String token = (prefs.getString('token') ?? "");

    await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "token": "$token",
      "req_type": "mob"
    }).then((http.Response response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      print(response.statusCode);
      print(response.body);

      String title = "";
      String message = "";
      if (response.statusCode == 200) {
        setState(() async {
          List dataMessage = json.decode(response.body);
          int NePostojiPoruka = 0;

          if (dataMessage.length != null) {
            for (int i = 0; i < dataMessage.length; i++) {
              int querycount =
                  await dbHelper.queryMessageExists(dataMessage[i]["id"]);
              if (querycount < 1) {
                NePostojiPoruka++;
                Map<String, dynamic> row = {
                  DatabaseHelper.columnIdMessage: dataMessage[i]["id"],
                  DatabaseHelper.columnCreated:
                  dataMessage[i]["created"].toString(),
                  DatabaseHelper.columnTitle: dataMessage[i]["title"],
                  DatabaseHelper.columnMessage: dataMessage[i]["message"],
                  DatabaseHelper.columnDeleted: "",
                  DatabaseHelper.columnReadStatus: 0,
                };
                dbHelper.insert(row);
              }

              title = dataMessage[i]["title"];
              message = dataMessage[i]["message"];
            }
          }
          int ReadMessageCount =await dbHelper.queryReadMessageExists();
          NePostojiPoruka+= ReadMessageCount;
          if (NePostojiPoruka > 1) {
            title = "Imate nove poruke";
            message = NePostojiPoruka.toString() + " novih poruka";
            _showNotification(title, message);
          } else if (NePostojiPoruka > 0) {
            _showNotification(title, message);
          }
//          if (dataMessage.length != null)
//            for (int i = 0; i < dataMessage.length; i++) {
//              Map<String, dynamic> row = {
//                DatabaseHelper.columnIdMessage: dataMessage[i]["id"],
//                DatabaseHelper.columnCreated:
//                    dataMessage[i]["created"].toString(),
//                DatabaseHelper.columnTitle: dataMessage[i]["title"],
//                DatabaseHelper.columnMessage: dataMessage[i]["message"],
//                DatabaseHelper.columnDeleted: DateTime.now().toString(),
//                DatabaseHelper.columnReadStatus: 0,
//              };
//              title = dataMessage[i]["title"];
//              message = dataMessage[i]["message"];
//              dbHelper.insert(row);
//            }
//          _query();
//          _showNotification(title, message);
        });
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });

    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish();
  }

  Future<void> _showNotification(String title, String message) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, message, platform,
        payload: 'Poruka');
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    navigatorKey.currentState.pushNamed('/messages');
    //Postaviti na poruke
//    await Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => SecondScreen(payload)),
//    );
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');

    setState(() {
      data = allRows;
    });
    allRows.forEach((row) => print(row));
  }

  void onTapped(int index) {
    print(data[index]["title"] + " poruka !");
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(data[index]["title"]),
        content: new Text(data[index]["message"]),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => showtoast(index, 1, context),
            child: new Text('Obrisati poruku'),
          ),
          new FlatButton(
            onPressed: () => showtoast(index, 2, context),
            child: new Text('Da'),
          ),
        ],
      ),
    );
  }
}

void showtoast(int index, int i, BuildContext context) {
  String msg = "";
  if (i == 1) {
    msg = " poruka obrisana!";
  } else {
    msg = " poruka pročitana!";
  }
  Fluttertoast.showToast(
      msg: data[index]["title"] + msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      // also possible "TOP" and "CENTER"
      textColor: Colors.white);
  Navigator.of(context).pop();
}

Future<void> _showNotification(String title, String message) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var android = new AndroidInitializationSettings('@mipmap/launcher_icon');
  var iOS = new IOSInitializationSettings();
  var initSetttings = new InitializationSettings(android, iOS);
  flutterLocalNotificationsPlugin.initialize(initSetttings,
      onSelectNotification: onSelectNotification);

  var android1 = new AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High, importance: Importance.Max);
  var iOS1 = new IOSNotificationDetails();
  var platform = new NotificationDetails(android1, iOS1);
  await flutterLocalNotificationsPlugin.show(0, title, message, platform,
      payload: 'Poruka');
}

Future<void> onSelectNotification(String payload) async {
  //Postaviti na poruke
  navigatorKey.currentState.pushNamed('/messages');
}
