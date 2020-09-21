import 'dart:convert';

import 'package:Loyalty_client/presentation/my_barcode_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppTranslations.dart';
import '../TransactionDetails.dart';

import '../global_variable.dart' as globals;
import 'package:http/http.dart' as http;

String ime_prezime = '';
String current_points = '';
String referenceNumber = '';

class UserInfoFragment extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfoFragment> {
  @override
  void initState() {
    super.initState();
    _loadCounter();
    _getBodovi();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ime_prezime = (prefs.getString('ime') ?? '') +
          " " +
          (prefs.getString('prezime') ?? '');
      double cur = (prefs.getDouble('currentPoints') ?? 0.0);
      int current = cur.toInt();
      current_points = current.toString();

      referenceNumber = (prefs.getString('referenceNumber') ?? "");
    });
  }

  _getBodovi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url;
    token = (prefs.getString('token') ?? "");
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
        setState(() {
          var resBody = json.decode(response.body);
          double cur = resBody["currentPoints"];
          int current = cur.toInt();
          current_points = current.toString();
        });
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Scaffold(
          resizeToAvoidBottomPadding: false,

          backgroundColor: Colors.white, //00ACF0
          body: Column(
              children: <Widget>[
                SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      MyBarcode.rotate,
                      color: Colors.black,
                      size: 35.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                                child: new BarCodeImage(
                                  data: referenceNumber,
                                  // Code string. (required)
                                  codeType: BarCodeType.Code128,
                                  // Code type (required)
                                  lineWidth: 3.0,
                                  // width for a single black/white bar (default: 2.0)
                                  barHeight: 150.0,
                                  // height for the entire widget (default: 100.0)
                                  hasText: true,
                                  // Render with text label or not (default: false)
                                  onError: (error) {
                                    // Error handler
                                    print('error = $error');
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
    } else {
// is potrait
      return new WillPopScope(
          onWillPop: _onWillPop,
          child: new Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: AppBar(
                  automaticallyImplyLeading: false, brightness: Brightness.dark,),
            ),
            body: Container(
              color: Color(0xff00ACF0),
              child: buildContent(context),
            ),
          ));
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(AppTranslations.of(context).text("exit_app")),
            content: new Text(AppTranslations.of(context).text("click_yes")),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(AppTranslations.of(context).text("ne")),
              ),
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text(AppTranslations.of(context).text("da")),
              ),
            ],
          ),
        ) ??
        false;
  }
}

Widget buildContent(BuildContext context) {
  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        SizedBox(
          height: 84.0,
          child: Image.asset(
            //todo
            //hr
            //"assets/images/registriraj_logo.png",
            //slo
            "assets/images/registriraj_logo_slo.png",
            fit: BoxFit.fill,
          ),
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Row(
            children: <Widget>[
              Icon(
                MyBarcode.user,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                child: Text(
                  AppTranslations.of(context).text("ime_prezime"),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            color: Colors.grey,
            height: 3,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Text(
            ime_prezime,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Row(
            children: <Widget>[
              Icon(
                MyBarcode.wallet,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                child: Text(
                  AppTranslations.of(context).text("stanje_bodova"),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            color: Colors.grey,
            height: 3,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Text(
            current_points,
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.credit_card,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                child: Text(
                  AppTranslations.of(context).text("loyalty_kartica"),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            color: Colors.grey,
            height: 3,
          ),
        ),
        //todo Test
//        Align(
//          alignment: Alignment.center,
//          child: Padding(
//            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
//            child: Text(
//              "TEST TEST TEST TEST",
//              style: TextStyle(
//                  fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
//            ),
//         ),
//        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        ime_prezime,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Expanded(
                        child: Image.asset(
                      //todo
                      //hr
                      //"assets/images/polleo.jpeg",
                      //slo
                      "assets/images/polleo_slo.jpeg",

                      height: 50,
                      width: 100,
                    ))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                        child: new BarCodeImage(
//                          data: referenceNumber,
                          params: Code128BarCodeParams(referenceNumber,
                              lineWidth: 2.0, barHeight: 86.0, withText: false),
//                          // Code string. (required)
//                          codeType: BarCodeType.Code128,
//                          // Code type (required)
//                          lineWidth: 2.0,
//                          // width for a single black/white bar (default: 2.0)
//                          barHeight: 90.0,
//                          // height for the entire widget (default: 100.0)
//                          hasText: false,
                          // Render with text label or not (default: false)
                          onError: (error) {
                            // Error handler
                            print('error = $error');
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Align(
          alignment: Alignment.center,
          child: Icon(
            MyBarcode.rotate,
            color: Colors.black,
            size: 50.0,
          ),
        ),
      ],
    ),
  );
}
