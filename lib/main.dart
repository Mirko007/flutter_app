import 'dart:ui';

import 'package:Loyalty_client/AppTranslations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppTranslationsDelegate.dart';
import 'Application.dart';

import 'package:Loyalty_client/MessageActivity.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_helper.dart';
import 'firebase_messaging.dart';
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

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
              await dbHelper.queryMessageExists(dataMessage[i]["id"].toString());
          if (querycount < 1) {
            NePostojiPoruka++;
            Map<String, dynamic> row = {
              DatabaseHelper.columnIdMessage: dataMessage[i]["id"].toString(),
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

      int ReadMessageCount = await dbHelper.queryReadMessageExists();
      NePostojiPoruka += ReadMessageCount;
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
  //_firebaseMessaging.requestNotificationPermissions();
  _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
    print("onMessage: $message");
    String title = message['notification']['title'];
    String tekst = message['notification']['body'];

    _showNotification(title, tekst);
    //_showItemDialog(message);
  },
    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      String title = message['notification']['title'];
      String tekst = message['notification']['body'];

      _showNotification(title, tekst);
     // _navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      String title = message['notification']['title'];
      String tekst = message['notification']['body'];

      _showNotification(title, tekst);
      //_navigateToItemDetail(message);
    },);
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
      localizationsDelegates: [
        AppLocalizations.delegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        if (locale == null) {
          debugPrint("*language locale is null!!!");
          return supportedLocales.first;
        }

        for (var supportedLocale in supportedLocales) {

          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      supportedLocales: [
        Locale('en', 'EN'),
        Locale('hr', 'HR'),
        Locale('sl', 'SI'),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppTranslationsDelegate _newLocaleDelegate;
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
                              AppTranslations.of(context).text("enter"),
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
                  // 'Nisi član LeoCluba?',
                  AppTranslations.of(context).text("registriraj_se_member"),
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text(
                    AppTranslations.of(context).text("registriraj_se"),
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

  void onLocaleChange(Locale locale) {
//    setState(() {
//      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
//    });
  }

  @override
  void initState() {
    super.initState();
    // _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
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
            AppTranslations.of(context).text("activation_code_token"),
          ),
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
              child: Text(AppTranslations.of(context).text("ok")),
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
            msg: AppTranslations.of(context).text("error_register"),
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
        List dataMessage = json.decode(response.body);
        int NePostojiPoruka = 0;

        if (dataMessage.length != null) {
          for (int i = 0; i < dataMessage.length; i++) {
            int querycount =
                await dbHelper.queryMessageExists(dataMessage[i]["id"].toString());
            if (querycount < 1) {
              NePostojiPoruka++;
              Map<String, dynamic> row = {
                DatabaseHelper.columnIdMessage: dataMessage[i]["id"].toString(),
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
        int ReadMessageCount = await dbHelper.queryReadMessageExists();
        NePostojiPoruka += ReadMessageCount;
        if (NePostojiPoruka > 1) {
          title = AppTranslations.of(context).text("imate_nove_poruke");
          message = NePostojiPoruka.toString() +
              AppTranslations.of(context).text("poruka");
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
            child: new Text(AppTranslations.of(context).text("delete")),
          ),
          new FlatButton(
            onPressed: () => showtoast(index, 2, context),
            child: new Text(AppTranslations.of(context).text("da")),
          ),
        ],
      ),
    );
  }
}

void showtoast(int index, int i, BuildContext context) {
  String msg = "";
  if (i == 1) {
    msg = AppTranslations.of(context).text("message_delete");
  } else {
    msg = AppTranslations.of(context).text("message_read");
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

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    print(message.containsKey('data'));
    final dynamic data = message['data'];
    print("data:"+ data);
  }

  if (message.containsKey('notification')) {

    // Handle notification message
    final dynamic notification = message['notification'];
    print("notification:"+ notification);
  }

  // Or do other work.
}