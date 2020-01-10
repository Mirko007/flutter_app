import 'dart:async';
import 'dart:ui' as prefix0;

import 'package:Loyalty_client/AppTranslations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../global_variable.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:shared_preferences/shared_preferences.dart';

final Set<Factory> gestureRecognizers = [
  Factory(() => EagerGestureRecognizer()),
].toSet();

class AkcijeFragment extends StatefulWidget {
  @override
  _AkcijeState createState() => _AkcijeState();
}

class _AkcijeState extends State<AkcijeFragment> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: AppBar(
          title: Text(AppTranslations.of(context).text("akcije"),style: TextStyle(color: Colors.white),),
          automaticallyImplyLeading: false,
            brightness: Brightness.dark
        ),
        backgroundColor: Colors.white,
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return new StuffInTiles(listOfTiles[index]);
          },
          itemCount: listOfTiles.length,
        ),

        //buildContent(),
      ),
    );
    //  );
//    return Scaffold(
//      appBar: AppBar(title: Text('Akcije')),
//      backgroundColor: Colors.blue,
//      body: Container(
//        color: Colors.blue,
//        child: buildContent(),
//      ),
//    );
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

  Widget buildContent() {
    return Container(
      color: Colors.grey,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: <Widget>[
                Text(
                  "Akcijska ponuda, ožujak 2019.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            height: 3,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              children: <Widget>[
                Text(
                  "Mjesečne akcije",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                Center(
                  child: Image.asset(
                    "assets/images/akcije.png",
                    height: 150,
                    width: 150,
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey,
            height: 3,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              children: <Widget>[
                Text(
                  "Izdvojene akcije za članove kluba",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                Center(
                  child: Image.asset(
                    "assets/images/akcije.png",
                    height: 150,
                    width: 150,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getAkcije();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _getAkcije() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = globals.base_url_novi + globals.getCatalog;
    String token = (prefs.getString('token') ?? "");

    await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "token": "$token"
    }).then((http.Response response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.contentLength}");
      print(response.headers);
      print(response.request);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        List data = json.decode(response.body);

        setState(() {
          listOfTiles.clear();
          for (int i = 0; i < data.length; i++) {
            if (data[i]["catalogList"] != "") {
              List dataKatalog = data[i]["catalogList"];
              List<MyTile> listMiniKatalog = List<MyTile>();
              int vint_validan_katalog = 0;
              for (int j = 0; j < dataKatalog.length; j++) {
                DateFormat dateFormat = DateFormat('dd/MM/yyyy hh:mm');
                String now = dateFormat.format(DateTime.now());
                DateTime now_dateTime = dateFormat.parse(now);

                DateTime date_katalog_datetime = dateFormat.parse(dataKatalog[j]["validTo"]);

                print("validan");
                print(now_dateTime.isBefore(date_katalog_datetime));
                print(dataKatalog[j]["name"]);
                if (now_dateTime.isBefore(date_katalog_datetime)) {
                  listMiniKatalog.add(new MyTile(dataKatalog[j]["name"],
                      <MyTile>[new MyTile(dataKatalog[j]["link"])]));
                  vint_validan_katalog++;
                }
              }
              if (vint_validan_katalog > 0)
                listOfTiles.add(new MyTile(data[i]["name"], listMiniKatalog));
            }
          }
        });
      }
    });
  }
}

class StuffInTiles extends StatelessWidget {
  final MyTile myTile;

  Completer<WebViewController> _controller = Completer<WebViewController>();

  StuffInTiles(this.myTile);

  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
      return SizedBox(
        height: 500,
//        width: MediaQuery.of(context).size.width,
        width: 400,
        child: new WebView(
          gestureRecognizers: gestureRecognizers,
          initialUrl: t.title,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      );

//      ListTile(
//          dense: true,
//          enabled: true,
//          isThreeLine: false,
//          onLongPress: () => print("long press"),
//          onTap: () => print("tap"),
//          selected: true,
//          title: new Text(t.title));
    else
      return new ExpansionTile(
       // key: new PageStorageKey<int>(4),
        title: new Text(t.title),
        children: t.children.map(_buildTiles).toList(),
      );
  }
}

class MyTile {
  String title;
  List<MyTile> children;

  MyTile(this.title, [this.children = const <MyTile>[]]);
}

List<MyTile> listOfTiles = <MyTile>[];
