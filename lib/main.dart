import 'dart:ui';

import 'package:Loyalty_client/AppTranslations.dart';
import 'package:Loyalty_client/MessageActivity.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppTranslationsDelegate.dart';
import 'Application.dart';



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

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

final dbHelperHeadless = DatabaseHelper.instance;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  _firebaseMessaging.requestNotificationPermissions();

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      String title = message['notification']['title'];
      String tekst = message['notification']['body'];

      //_showNotification("VANJA", "SE ZOVEM on message");
      _showNotification(title, tekst);

    },
    onBackgroundMessage: myBackgroundMessageHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      String title = message['data']['messageTitle'];
      String tekst = message['data']['messageText'];


      _showNotificationNotInForeground(title,tekst);
      //_showNotification(title, tekst);

    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      String title = message['data']['messageTitle'];
      String tekst = message['data']['messageText'];

      _showNotificationNotInForeground(title,tekst);
     // _showNotification(title, tekst);

    },
  );

  //_firebaseMessaging.subscribeToTopic("polleonewsslo");
  debugPaintSizeEnabled = false;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xff00ACF0), // navigation bar color
 //   statusBarColor: Colors.transparent, // status bar color
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark
  ));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // reference to our single class that manages the database
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: colorCustom,
        primarySwatch: Colors.lightBlue,
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
          debugPrint("supportedLocale*language locale is null!!!");
          return supportedLocales.first;
        }

        for (var supportedLocale in supportedLocales) {
          print("supportedLocale" + supportedLocale.toString());
          print("supportedLocalelanguageCode" + supportedLocale.languageCode);
          print("supportedLocalecountryCode" + supportedLocale.countryCode);
          print("locale_countryCode" + locale.languageCode);
          print("locale_countryCode" + locale.countryCode);

          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        // Locale('sl', 'SL'),
        return supportedLocales.first;
      },
      supportedLocales: [
        Locale('hr', 'HR'),
        Locale('en', 'US'),
        Locale('en', 'UK'),
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
                //todo
                //hr
                //"assets/images/prijava_logo.png",
                //slo
                "assets/images/prijava_logo_slo.png",
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
                  //todo
                  //hr
                  //"assets/images/prijava_logo_polleo.png",
                  //slo
                  "assets/images/prijava_logo_polleo_slo.png",
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

    _getPref();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _callServisEmail(String EmailText) async {
    String url = globals.base_url_novi + globals.requestOTP;
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
        /************************************************/
        /************************************************/
        /************************************************/
        /************************************************/
        /************************************************/
        await http.post(globals.base_url_novi + globals.requestOTP,
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

    url = globals.base_url_novi + globals.confirmOTP;
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

    url = globals.base_url_novi + globals.getCustomer;

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
    ProgressDialog pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pr.style(
        message: AppTranslations.of(context).text("provjera_korisnika"),
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    if(TargetPlatform.android == Theme.of(context).platform )
    pr.show();

    String url = globals.base_url_novi + globals.getCustomer;

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
        pr.hide().whenComplete(() {
          _firebaseMessaging.subscribeToTopic("polleonewsslo");
          Navigator.of(context).pushNamed('/main');
        });
      } else {
        pr.dismiss();
        pr.hide().then((isHidden) {
          print(isHidden);
          print("Vanja");
        });

      }
    });
  }
}

Future<void> _showNotification(String title, String message) async {

  int broj_novih_poruka = await DatabaseHelper.instance.queryRowCountRead();

    Map<String, dynamic> row = {
    DatabaseHelper.columnIdMessage: "22",
    DatabaseHelper.columnCreated: "",
    DatabaseHelper.columnTitle: title,
    DatabaseHelper.columnMessage: message,
    DatabaseHelper.columnReadStatus: 0,
    DatabaseHelper.columnDeleted: "",
  };
  DatabaseHelper.instance.insert(row);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var android = new AndroidInitializationSettings('@mipmap/launcher_icon');
  var iOS = new IOSInitializationSettings();
  var initSetttings = new InitializationSettings(android, iOS);
  flutterLocalNotificationsPlugin.initialize(initSetttings,
      onSelectNotification: onSelectNotification);

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "Polleo", 'Polleo', 'channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOS1 = new IOSNotificationDetails();
  var platform = new NotificationDetails(androidPlatformChannelSpecifics, iOS1);
  if (broj_novih_poruka > 0) {
    ++broj_novih_poruka;
    await flutterLocalNotificationsPlugin.show(
        0,
        AppTranslations.of(navigatorKey.currentContext)
            .text("imate_nove_poruke"),
        broj_novih_poruka.toString() +
            AppTranslations.of(navigatorKey.currentContext)
                .text("novih_poruka"),
        platform,
       );
  } else {
    await flutterLocalNotificationsPlugin.show(0, title, message, platform,
        );
   }
}

Future<void> _showNotificationNotInForeground(String title, String message) async {

  int broj_novih_poruka = await DatabaseHelper.instance.queryRowCountRead();

  Map<String, dynamic> row = {
    DatabaseHelper.columnIdMessage: "22",
    DatabaseHelper.columnCreated: "",
    DatabaseHelper.columnTitle: title,
    DatabaseHelper.columnMessage: message,
    DatabaseHelper.columnReadStatus: 0,
    DatabaseHelper.columnDeleted: "",
  };
  DatabaseHelper.instance.insert(row);

  navigatorKey.currentState.pushNamed('/messages');

}
Future<void> onSelectNotification(String payload) async {
  //Postaviti na poruke
  print("Test ulaz");
//  print(payload);
//  String title =  payload.substring(0, payload.indexOf("|"));
//  String message =  payload.substring( payload.indexOf("|")+1,payload.length);

//  Map<String, dynamic> row = {
//    DatabaseHelper.columnIdMessage: "22",
//    DatabaseHelper.columnCreated: "",
//    DatabaseHelper.columnTitle: title,
//    DatabaseHelper.columnMessage: message,
//    DatabaseHelper.columnReadStatus: 0,
//    DatabaseHelper.columnDeleted: "",
//  };
//  DatabaseHelper.instance.insert(row);

  navigatorKey.currentState.pushNamed('/messages');
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    print(message.containsKey('data'));
    final dynamic data = message['data'];
    print("data:" + data);
    _showNotificationNotInForeground(message['data']['messageTitle'], message['data']['messageText']);
//    _showNotification(
//        message['data']['messageTitle'], message['data']['messageText']);
  }

  if (message.containsKey('notification')) {

//    Map<String, dynamic> row = {
//      DatabaseHelper.columnIdMessage: "22",
//      DatabaseHelper.columnCreated: "",
//      DatabaseHelper.columnTitle: message['data']['messageTitle'],
//      DatabaseHelper.columnMessage: message['data']['messageText'],
//      DatabaseHelper.columnReadStatus: 0,
//      DatabaseHelper.columnDeleted: "",
//    };
//    DatabaseHelper.instance.insert(row);
//    _showNotification(
//        message['data']['messageTitle'], message['data']['messageText']);
    //_showNotification("VANJA", "SE ZOVEM");
    // Handle notification message
    final dynamic notification = message['notification'];
    print("notification:" + notification);
  }
}
