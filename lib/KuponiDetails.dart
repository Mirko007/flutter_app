import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:Loyalty_client/fragment/KuponiFragment.dart';

class KuponiDetails extends StatelessWidget {
  Coupon coupon;

  // In the constructor, require a Person
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
  return Padding(
    padding: EdgeInsets.all(10),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.black12,
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
                    data: _coupon.barcode,
                    //coupon.voucherName,
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
                  ),
                ),
              ),
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
          Expanded(
            child: Image.asset(
              "assets/images/kupon_fragment_slika.PNG",
              fit: BoxFit.fill,
            ),
            // width: MediaQuery.of(context).size.width,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text("Vrijedi do " + _coupon.validTo))
        ],
      ),
    ),
  );
}
