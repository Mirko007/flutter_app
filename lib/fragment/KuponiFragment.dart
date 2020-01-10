import 'dart:math';

import 'package:Loyalty_client/AppTranslations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Loyalty_client/KuponiDetails.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import '../global_variable.dart' as globals;

String token = '';
List allCoupons = [];
bool pressed = true;
int allCouponsItemCount = 0;

var bodovi = "";
var height = AppBar().preferredSize.height;

List<bool> isSelected;

class KuponiFragment extends StatefulWidget {
  @override
  _KuponiState createState() => _KuponiState();
}

class _KuponiState extends State<KuponiFragment> {
  @override
  void initState() {
    super.initState();
    isSelected = [true, false];
    _getData();
    _getBodovi();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? "");
      if (pressed)
        this.getCouponsPonuda(token);
      else
        this.getCouponsOsobni(token);
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
          //bodovi = resBody["currentPoints"].toString();
          double cur = resBody["currentPoints"];
          int current = cur.toInt();
          bodovi = current.toString();
        });
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  Future<String> getCouponsPonuda(String token) async {
    String url;

    url = globals.base_url_novi + globals.getVoucher;

    http.Response response = await http.get(url, headers: {
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
        setState(() {
          var resBody = json.decode(response.body);
          allCoupons.clear();
          allCoupons = resBody;
          allCoupons == null
              ? allCouponsItemCount = 0
              : allCouponsItemCount = allCoupons.length;
        });
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  Future<String> getCouponsOsobni(String token) async {
    String url;

    url = globals.base_url_novi + globals.getCustomer;

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
        setState(() {
          var resBody = json.decode(response.body);
         // bodovi = resBody["currentPoints"].toString();
          double cur = resBody["currentPoints"];
          int current = cur.toInt();
          bodovi = current.toString();
          allCoupons.clear();
          allCoupons = resBody["voucherList"];
          allCoupons == null
              ? allCouponsItemCount = 0
              : allCouponsItemCount = allCoupons.length;
          print("allCoupons:");
          print(allCoupons);
        });
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            appBar: new AppBar(
              automaticallyImplyLeading: false,
              brightness: Brightness.dark,
             // backgroundColor: Colors.transparent,
              title: new Text(AppTranslations.of(context).text("kuponi"),style: TextStyle(color: Colors.white),),
              actions: <Widget>[
                Container(
                  height: height,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  //color: Color(0xff2274A9),
                  color: Colors.blueAccent[50],
                  //FF009AE2
                  child: new Text(AppTranslations.of(context).text("bodovi")+": " + bodovi,style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Center(
//                  child: ToggleButtons(
//                    borderColor: Colors.blue[800],
//                    fillColor: Colors.blue[700],
//                    borderWidth: 1,
//                    selectedBorderColor: Colors.black,
//                    selectedColor: Colors.white,
//                    borderRadius: BorderRadius.circular(20),
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(
//                          AppTranslations.of(context).text("ponuda"),
//                          style: TextStyle(fontSize: 16),
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(
//                          AppTranslations.of(context).text("osobni"),
//                          style: TextStyle(fontSize: 16),
//                        ),
//                      ),
//                    ],
//                    onPressed: (int index) {
//                      setState(() {
//                        for (int i = 0; i < isSelected.length; i++) {
//                          if (i == index) {
//                            isSelected[i] = true;
//                          } else {
//                            isSelected[i] = false;
//                          }
//                        }
//                      });
//                    },
//                    isSelected: isSelected,
//                  ),
//                ),
//              ),
                  //todo 23.12. 17.05 zamijenjeni
                  Row(
                    children: <Widget>[
                      Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            10.0,
                            10.0,
                            0.0,
                            5.0,
                          ),
                          child: RaisedButton(
                            color: Colors.white,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0))),
                            //color: pressed ? Colors.black12 : Colors.blue,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(0.0),
                            onPressed: () => setState(() {
                              pressed = true;
                              if (pressed)
                                this.getCouponsPonuda(token);
                              else
                                this.getCouponsOsobni(token);
                            }),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: pressed
                                      ? <Color>[
                                          Color(0xFF0D47A1),
                                          Color(0xFF1976D2),
                                          Color(0xFF42A5F5),
                                        ]
                                      : <Color>[
                                          Color(0xFF3C3C3D),
                                          Color(0xFF747272),
                                          Color(0xFFB4B3B3),
                                        ],
                                ),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0)),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Center(
                                  child: Text(
                                AppTranslations.of(context).text("ponuda"),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )),
                            ),
//                        Padding(
//                          padding: const EdgeInsets.all(5.0),
//                          child: Center(
//                              child: Text(
//                                AppTranslations.of(context).text("ponuda"),
//                                style: TextStyle(
//                                    fontSize: 15, color: Colors.white),
//                              )),
//                        ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            10.0,
                            10.0,
                            5.0,
                          ),
                          child: RaisedButton(
                            //color: pressed ? Colors.blue : Colors.black12,
                            color: Colors.white,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0))),
                            padding: EdgeInsets.all(0.0),
                            onPressed: () => setState(() {
                              pressed = false;
                              if (pressed)
                                this.getCouponsPonuda(token);
                              else
                                this.getCouponsOsobni(token);
                            }),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: pressed
                                      ? <Color>[
                                          Color(0xFF3C3C3D),
                                          Color(0xFF747272),
                                          Color(0xFFB4B3B3),
                                        ]
                                      : <Color>[
                                          Color(0xFF0D47A1),
                                          Color(0xFF1976D2),
                                          Color(0xFF42A5F5),
                                        ],
                                ),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: Text(
                                  AppTranslations.of(context).text("osobni"),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: getGridView(context))
                ]))
        //        ))

        );
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

getGridView(BuildContext context) {
  if (allCoupons == null || allCoupons == "")
    return Container();
  else
    return GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: allCouponsItemCount,
        itemBuilder: (BuildContext content, int index) {
          return Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                getKuponDetails(index, context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ]),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,3,0,3),
                        child: Center(
                            child: Text(
                          getCustomerRequiredpoints(index) +
                              // allCoupons[index]["voucherType"]["customerPointsRequired"].toString() +
                              AppTranslations.of(context).text("bodovi"),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                        child: Center(
                            child: Text(
                          getVoucherName(index),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: getImage(index),
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                            AppTranslations.of(context).text("vrijedi_do") +
                                getValidto(index)))
                  ],
                ),
              ),
            ),
          );
        });
}

int getCouponCount() {
  print("allCoupons.length");

  print(allCoupons.length);
  if (pressed)
    return allCoupons == null ? 0 : allCoupons.length;
  else
    allCoupons == null ? 0 : allCoupons.length;
}

String getCustomerRequiredpoints(int index) {
  if (pressed)
    return allCoupons[index]["customerPointsRequired"] == null
        ? "0"
        : allCoupons[index]["customerPointsRequired"].toString();
  else {
    return "0";
//    int customeReqPoints =allCoupons[index]["voucherType"]["customerPointsRequired"];
//    print("customeReqPoints");
//    print(customeReqPoints);
//    return customeReqPoints == null
//        ? "0"
//        //: "2";
//        : allCoupons[index]["voucherType"]["customerPointsRequired"].toString();
  }
}

String getVoucherName(int index) {
  if (pressed)
    return allCoupons[index]["voucherName"] == null
        ? ""
        : allCoupons[index]["voucherName"];
  else {
    String VoucherName = "";
    try {
      VoucherName = allCoupons[index]["voucherType"]["voucherName"].toString();
    } catch (error) {}

    return VoucherName;
  }
}

String getValidto(int index) {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  if (pressed) {
    if (allCoupons[index]["validTo"] == null)
      return "";
    else{
      String date_validTo ="";
      date_validTo =allCoupons[index]["validTo"];
      if(date_validTo!="") {
        DateTime date_ = dateFormat.parse(allCoupons[index]["validTo"]);
        date_validTo= dateFormat.format(date_);
      }
      return date_validTo;
    }
  } else {
    String ValidTo = "";
    try {
      ValidTo = allCoupons[index]["voucherType"]["validTo"].toString();
      if(ValidTo!=""){

      DateTime date_2 = dateFormat.parse(allCoupons[index]["voucherType"]["validTo"].toString());
      ValidTo = dateFormat.format(date_2);}

    } catch (error) {}
    if (ValidTo == "")
      return "";
    else
      return ValidTo;
  }

}

class Coupon {
  Coupon(
      {this.id,
      this.barcode,
      this.validTo,
      this.customerPointsRequired,
      this.image,
      this.locationName,
      this.voucherName,
      this.voucherDescription,
      this.voucherOwner});

  final int id;
  final String barcode;
  final String validTo;
  final String customerPointsRequired;
  final String image;
  final String locationName;
  final String voucherName;
  final String voucherDescription;
  final bool voucherOwner; //0-Ponuda,1-Osobni
}

void getKuponDetails(int index, BuildContext context) {
  if (pressed) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KuponiDetails(
                coupon: Coupon(
                    id: allCoupons[index]["id"],
                    barcode: "",
                    validTo: allCoupons[index]["validTo"],
                    customerPointsRequired:
                        allCoupons[index]["customerPointsRequired"].toString(),
                    image: allCoupons[index]["image"],
                    locationName: allCoupons[index]["locationName"],
                    voucherName: allCoupons[index]["voucherName"],
                    voucherDescription: allCoupons[index]["description"],
                    voucherOwner: false),
              )),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KuponiDetails(
                coupon: Coupon(
                    id: allCoupons[index]["voucherType"]["id"],
                    barcode: allCoupons[index]["voucher"],
                    validTo: allCoupons[index]["voucherType"]["validTo"],
                    customerPointsRequired: allCoupons[index]["voucherType"]
                            ["customerPointsRequired"]
                        .toString(),
                    image: allCoupons[index]["voucherType"]["image"],
                    locationName: allCoupons[index]["voucherType"]
                        ["locationName"],
                    voucherName: allCoupons[index]["voucherType"]
                        ["voucherName"],
                    voucherDescription: allCoupons[index]["voucherType"]
                ["description"],
                    voucherOwner: true),
              )),
    );
  }
}

getImage(int index) {
  if (pressed)
    return allCoupons[index]["image"] == null
        ? null
        : Image.memory(
            Base64Decoder().convert(allCoupons[index]["image"]),
            fit: BoxFit.scaleDown,
          );
  else {
    String VoucherImage = "";
    try {
      VoucherImage = allCoupons[index]["voucherType"]["image"].toString();
    } catch (errror) {}
    return VoucherImage == ""
        ? null
        : Image.memory(
            Base64Decoder().convert(VoucherImage),
            fit: BoxFit.scaleDown,
          );
  }
}
