import 'dart:convert';

import 'package:Loyalty_client/fragment/main_fragment.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Loyalty_client/fragment/KuponiFragment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'database_helper.dart';
import 'global_variable.dart' as globals;

class KuponiDetails extends StatelessWidget {
  Coupon coupon;

  // In the constructor, require a coupon
  KuponiDetails({Key key, @required this.coupon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuponi detalji'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildContent(context, coupon),
      ),
    );
  }
}

Widget _buildContent(BuildContext context, Coupon _coupon) {
  print("_coupon.barcode");
  print(_coupon.barcode);
  return Padding(
    padding: EdgeInsets.all(10),
    child: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: SingleChildScrollView(
        child: Column(

          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: _coupon.voucherOwner
                    ? Container(
                  height: 100,
                  color: Colors.white,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                      child:
                              new BarCodeImage(

                              data: _coupon.barcode== null ? "1111":_coupon.barcode,
                              // Code string. (required)
                              codeType: BarCodeType.Code128,
                              // Code type (required)
                              lineWidth: 2.0,
                              // width for a single black/white bar (default: 2.0)
                              barHeight: 90.0,
                              // height for the entire widget (default: 100.0)
                              hasText: true,
                              // Render with text label or not (default: false)
                              onError: (error) {
                                // Error handler
                                print('error = $error');
                              },
                            )
                          ),
                ):Container()
              ),
            ),
            Container(
              height: 40,
              color: Colors.blue,
              child: Center(
                  child: Text(
                _coupon.customerPointsRequired + " bodova",
                style: TextStyle(fontSize: 30, color: Colors.white),
              )),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                  child: Text(
                _coupon.voucherName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, color: Colors.white),
              )),
            ),
            _coupon.image == null
                  ? Container()
                  : Image.memory(
                      Base64Decoder().convert(_coupon.image),
                      fit: BoxFit.fitWidth,
                    ),
              // width: MediaQuery.of(context).size.width,

            Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text("Vrijedi do " + _coupon.validTo)),
            !_coupon.voucherOwner
                ?RaisedButton(
              child: Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.blueAccent,
                    color: Colors.blue,
                    elevation: 7.0,
                    child: Center(
                      child: Text(
                        'KUPI',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  )),
              onPressed: () {
                _dialogBuyVoucher(_coupon,context);
              },
            )
//          GestureDetector(
//            onTap: () {
//              _dialogBuyVoucher(_coupon,context);
//            },
//            child: Container(
//                height: 40.0,
//                child: Material(
//                  borderRadius: BorderRadius.circular(20.0),
//                  shadowColor: Colors.blueAccent,
//                  color: Colors.blue,
//                  elevation: 7.0,
//                  child: Center(
//                    child: Text(
//                      'KUPI2',
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold,
//                          fontFamily: 'Montserrat'),
//                    ),
//                  ),
//                )),
//          )
                :Container()
          ],
        ),
      ),
    ),
  );
}

getBarcodeImage() {

}

_dialogBuyVoucher(Coupon coupon,BuildContext context) {
  print("ASdadsadasdsafd");
  showDialog(
      context: context,
      builder: (context) => new AlertDialog(
    title: new Text('Jeste li sigurni?'),
    content: new Text('Želite li kupiti kupon: '+coupon.voucherName),
    actions: <Widget>[
      new FlatButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: new Text('Ne'),
      ),
      new FlatButton(
        onPressed: () => _buyVoucher(coupon,context),
        child: new Text('Da'),
      ),
    ],
  ));

}

_buyVoucher(Coupon coupon,BuildContext context) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String url = globals.base_url_novi + "/api/v1/getVoucher/"+ coupon.id.toString();

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

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Uspješno kupljen kupon",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.blue,
          gravity: ToastGravity.CENTER,
          // also possible "TOP" and "CENTER"
          textColor: Colors.white);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Main_Fragment(tab: 3)),
      );

    } else {
      Fluttertoast.showToast(
          msg: "Neuspješno kupljen kupon",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.blue,
          // also possible "TOP" and "CENTER"
          textColor: Colors.white);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Main_Fragment(tab: 3)),
      );
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  });
}
