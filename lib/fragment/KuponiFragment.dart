import 'dart:math';

import 'package:Loyalty_client/AppTranslations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Loyalty_client/KuponiDetails.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../global_variable.dart' as globals;

String token = '';
List allCoupons = [];
bool pressed = true;
int allCouponsItemCount = 0;

class KuponiFragment extends StatefulWidget {
  @override
  _KuponiState createState() => _KuponiState();
}

class _KuponiState extends State<KuponiFragment> {
  @override
  void initState() {
    super.initState();
    _getData();
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

  Future<String> getCouponsPonuda(String token) async {
    String url;

    url = globals.base_url_novi + "/api/v1/getVoucher";
//    String url = globals.base_url + "/api/v1/getVoucher";

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

    url = globals.base_url_novi + "/api/v1/getCustomer";
    // String url = globals.base_url + "/api/v1/getCustomer";

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
              title: new Text(AppTranslations.of(context).text("kuponi")),
            ),
            //body: _buildContent(context)
            body:
//          Container(
//              color: Colors.white,
//              child:
//              new SizedBox(
//    height: MediaQuery.of(context).size.height,
//    child: Image.asset(
//    "assets/images/nema_sadrzaja.PNG",
//    fit: BoxFit.fill,
//    ),
//    width: MediaQuery.of(context).size.width,
//    )
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        10.0,
                        10.0,
                        0.0,
                        10.0,
                      ),
                      child: RaisedButton(
                        color: pressed ? Colors.black12 : Colors.blue,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0))),
                        onPressed: () =>
                            setState(() {
                              pressed = true;
                              if (pressed)
                                this.getCouponsPonuda(token);
                              else
                                this.getCouponsOsobni(token);
                            }),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Text(
                                AppTranslations.of(context).text("ponuda"),
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60.0,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        0.0,
                        10.0,
                        10.0,
                        10.0,
                      ),
                      child: RaisedButton(
                        color: pressed ? Colors.blue : Colors.black12,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0))),
                        onPressed: () =>
                            setState(() {
                              pressed = false;
                              if (pressed)
                                this.getCouponsPonuda(token);
                              else
                                this.getCouponsOsobni(token);
                            }),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Text(
                                AppTranslations.of(context).text("osobni"),
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              )),
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
    ) ?? false;
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
            padding: EdgeInsets.all(10),
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
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0))),
                      child: Center(
                          child: Text(
                            getCustomerRequiredpoints(index) +
                                // allCoupons[index]["voucherType"]["customerPointsRequired"].toString() +
                                AppTranslations.of(context).text("bodova"),
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Center(
                            child: Text(
                              getVoucherName(index),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white),
                            )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: getImage(index),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(AppTranslations.of(context).text("vrijedi_do") + getValidto(index)))
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
  if (pressed) {
    if (allCoupons[index]["validTo"] == null)
      return "";
    else
      return allCoupons[index]["validTo"];
  } else {
    String ValidTo = "";
    try {
      ValidTo = allCoupons[index]["voucherType"]["validTo"].toString();
    } catch (error) {}
    if (ValidTo == "")
      return "";
    else
      return ValidTo;
  }
  // return pressed == true ? allCoupons[index]["validTo"] : "2";
}

class Coupon {
  Coupon({this.id,
    this.barcode,
    this.validTo,
    this.customerPointsRequired,
    this.image,
    this.locationName,
    this.voucherName,
    this.voucherOwner});

  final int id;
  final String barcode;
  final String validTo;
  final String customerPointsRequired;
  final String image;
  final String locationName;
  final String voucherName;
  final bool voucherOwner; //0-Ponuda,1-Osobni
}

void getKuponDetails(int index, BuildContext context) {
  if (pressed) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              KuponiDetails(
                coupon: Coupon(
                    id: allCoupons[index]["id"],
                    barcode: "",
                    validTo: allCoupons[index]["validTo"],
                    customerPointsRequired:
                    allCoupons[index]["customerPointsRequired"].toString(),
                    image: allCoupons[index]["image"],
                    locationName: allCoupons[index]["locationName"],
                    voucherName: allCoupons[index]["voucherName"],
                    voucherOwner: false),

              )),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              KuponiDetails(
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
