import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
String ime_prezime='';
String current_points='';
String referenceNumber='';
class UserInfoFragment extends StatefulWidget {

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfoFragment> {
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ime_prezime = (prefs.getString('ime')??'')+" "+ (prefs.getString('prezime')??'');
      double cur=(prefs.getDouble('currentPoints')??0.0);
      current_points = cur.toString();

      referenceNumber = (prefs.getString('referenceNumber')??"");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.blue,
        body: Container(
          color: Colors.blue,
          child: buildContent(context),
        ));
  }
}

Widget buildContent(BuildContext context) {

  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 24.0,
        ),
        SizedBox(
          height: 100.0,
          child: Image.asset(
            "assets/images/registriraj_logo.png",
            fit: BoxFit.fill,
          ),
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.supervised_user_circle,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                child: Text(
                  "Ime i prezime",
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
                Icons.card_travel,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                child: Text(
                  "Stanje bodova",
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
                  "Moja loyalty kartica",
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
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
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
                      "assets/images/polleo.jpeg",
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
                          data: referenceNumber,
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
                )
              ],
            ),
          ),
        )
      ],
    ),
  );

}


