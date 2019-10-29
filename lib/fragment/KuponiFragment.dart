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
            title: new Text("Kuponi"),
          ),
          //body: _buildContent(context)
          body:
          Container(
              color: Colors.white,
              child:
              new SizedBox(
    height: MediaQuery.of(context).size.height,
    child: Image.asset(
    "assets/images/nema_sadrzaja.PNG",
    fit: BoxFit.fill,
    ),
    width: MediaQuery.of(context).size.width,
    )
//              Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Container(
//                          height: 60.0,
//                          width: MediaQuery.of(context).size.width / 2,
//                          child: Padding(
//                            padding: const EdgeInsets.fromLTRB(
//                              10.0,
//                              10.0,
//                              0.0,
//                              10.0,
//                            ),
//                            child: RaisedButton(
//                              color: pressed ? Colors.red : Colors.blue,
//                              shape: OutlineInputBorder(
//                                  borderRadius: BorderRadius.only(
//                                      topLeft: Radius.circular(15.0),
//                                      bottomLeft: Radius.circular(15.0))),
//                              onPressed: () => setState(() {
//                                    pressed = true;
//                                    if (pressed)
//                                      this.getCouponsPonuda(token);
//                                    else
//                                      this.getCouponsOsobni(token);
//                                  }),
//                              child: Padding(
//                                padding: const EdgeInsets.all(5.0),
//                                child: Center(
//                                    child: Text(
//                                  "PONUDA",
//                                  style: TextStyle(
//                                      fontSize: 25, color: Colors.white),
//                                )),
//                              ),
//                            ),
//                          ),
//                        ),
//                        Container(
//                          height: 60.0,
//                          width: MediaQuery.of(context).size.width / 2,
//                          child: Padding(
//                            padding: const EdgeInsets.fromLTRB(
//                              0.0,
//                              10.0,
//                              10.0,
//                              10.0,
//                            ),
//                            child: RaisedButton(
//                              color: pressed ? Colors.blue : Colors.red,
//                              shape: OutlineInputBorder(
//                                  borderRadius: BorderRadius.only(
//                                      topRight: Radius.circular(15.0),
//                                      bottomRight: Radius.circular(15.0))),
//                              onPressed: () => setState(() {
//                                    pressed = false;
//                                    if (pressed)
//                                      this.getCouponsPonuda(token);
//                                    else
//                                      this.getCouponsOsobni(token);
//                                  }),
//                              child: Padding(
//                                padding: const EdgeInsets.all(5.0),
//                                child: Center(
//                                    child: Text(
//                                  "OSOBNI",
//                                  style: TextStyle(
//                                      fontSize: 25, color: Colors.white),
//                                )),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                    Expanded(
//                      child: GridView.builder(
//                          gridDelegate:
//                              new SliverGridDelegateWithFixedCrossAxisCount(
//                            crossAxisCount: 2,
//                          ),
//                          scrollDirection: Axis.vertical,
//                          shrinkWrap: true,
//                          itemCount: allCoupons == null ? 0 : allCoupons.length,
//                          itemBuilder: (BuildContext content, int index) {
//                            return GestureDetector(
//                              onTap: () {
//                                //getTransactionDetails(data[index]["uuid"], content);
//                              },
//                              child: Padding(
//                                padding: EdgeInsets.all(10),
//                                child: InkWell(
//                                  onTap: () {
//                                    getKuponDetails(index, context);
//                                  },
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        color: Colors.black12,
//                                        borderRadius: BorderRadius.all(
//                                            Radius.circular(15.0))),
//                                    child: Column(
//                                      children: <Widget>[
//                                        Expanded(
//                                          child: Container(
//                                            decoration: BoxDecoration(
//                                                color: Colors.blue,
//                                                borderRadius: BorderRadius.only(
//                                                    topLeft:
//                                                        Radius.circular(15.0),
//                                                    topRight:
//                                                        Radius.circular(15.0))),
//                                            child: Center(
//                                                child: Text(
//                                              getCustomerRequiredpoints(index) +
//                                                  // allCoupons[index]["voucherType"]["customerPointsRequired"].toString() +
//                                                  " bodova",
//                                              style: TextStyle(
//                                                  fontSize: 25,
//                                                  color: Colors.white),
//                                            )),
//                                          ),
//                                        ),
//                                        Expanded(
//                                          child: Container(
//                                            decoration: BoxDecoration(
//                                              color: Colors.blue,
//                                            ),
//                                            child: Center(
//                                                child: Text(
//                                              allCoupons[index]
//                                                          ["voucherName"] ==
//                                                      null
//                                                  ? ""
//                                                  : allCoupons[index]
//                                                      ["voucherName"],
//                                              maxLines: 2,
//                                              overflow: TextOverflow.ellipsis,
//                                              style: TextStyle(
//                                                  fontSize: 15,
//                                                  color: Colors.white),
//                                            )),
//                                          ),
//                                        ),
//                                        Container(
//                                          height: 80.0,
//                                          color: Colors.white,
//                                          child: getImage(index),
//                                          width:
//                                              MediaQuery.of(context).size.width,
//                                        ),
//                                        Expanded(
//                                            child: Padding(
//                                                padding: EdgeInsets.fromLTRB(
//                                                    10, 5, 10, 5),
//                                                child: Text("Vrijedi do " + getValidto(index))))
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            );
//                          }),
//                    )
//                  ]))
          ))

    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Jeste li sigurni?'),
                content: new Text('Želite li izaći iz aplikacije'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('Ne'),
                  ),
                  new FlatButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: new Text('Da'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}

String getCustomerRequiredpoints(int index) {
  if (pressed)
    return allCoupons[index]["customerPointsRequired"] == null
        ? "0"
        : allCoupons[index]["customerPointsRequired"].toString();
  else
    return allCoupons[index]["customerPointsRequired"] == null
        ? "0"
        : "2";
        //: allCoupons[index]["voucherType"]["customerPointsRequired"].toString();
}

String getValidto(int index) {
  //return pressed ==true ? allCoupons[index]["validTo"]: allCoupons[index]["voucherType"]["validTo"];
  return pressed == true ? allCoupons[index]["validTo"] : "2";
}

class Coupon {
  Coupon(
      {this.id,
      this.barcode,
      this.validTo,
      this.customerPointsRequired,
      this.image,
      this.locationName,
      this.voucherName});

  final int id;
  final String barcode;
  final String validTo;
  final String customerPointsRequired;
  final String image;
  final String locationName;
  final String voucherName;
}

void getKuponDetails(int index, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => KuponiDetails(
              coupon: Coupon(
                  id: allCoupons[index]["id"],
                  barcode: allCoupons[index]["barcode"],
                  validTo: allCoupons[index]["validTo"],
                  customerPointsRequired:
                      allCoupons[index]["customerPointsRequired"].toString(),
                  image: allCoupons[index]["image"],
                  locationName: allCoupons[index]["locationName"],
                  voucherName: allCoupons[index]["voucherName"]),
            )),
  );
}

getImage(int index) {
  return allCoupons[index]["image"] == null
      ? null
      : Image.memory(
          Base64Decoder().convert(allCoupons[index]["image"]),
          fit: BoxFit.fill,
        );
}
