import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/KuponiDetails.dart';

class KuponiFragment extends StatefulWidget {
  @override
  _KuponiState createState() => _KuponiState();
}

class _KuponiState extends State<KuponiFragment> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,  DeviceOrientation.portraitDown,
    ]);
    return new WillPopScope(

      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: new Text("Kuponi"),
        ),
        body: new SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            "assets/images/nema_sadrzaja.PNG",
            fit: BoxFit.fill,
          ),
          width: MediaQuery.of(context).size.width,
        )
      ),
    );
//    return  new ListKuponiPage();
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
            onPressed: () =>  SystemNavigator.pop(),
            child: new Text('Da'),
          ),
        ],
      ),
    ) ?? false;
  }
}


class Coupons {
  Coupons({this.date, this.spentPoints, this.totalAmount, this.locationName});

  final String date;
  final String spentPoints;
  final String totalAmount;
  final String locationName;
}

class ListKuponiPage extends StatelessWidget {
  ListKuponiPage({Key key, this.onLayoutToggle}) : super(key: key);
  final VoidCallback onLayoutToggle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kuponi')),
      body: Container(
        color: Colors.white,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this would produce 2 rows.
      crossAxisCount: 2,
      // Generate 100 Widgets that display their index in the List
      children: List.generate(allCoupons.length, (index) {
        return getCouponItem(allCoupons[index], context,index);
      }),
    );
  }

  List<Coupons> allCoupons = [
    Coupons(
        date: '26.10.2018',
        spentPoints: '10',
        totalAmount: "50",
        locationName: "Zagreb - Žitnjak"),
    Coupons(
        date: '28.10.2018',
        spentPoints: '22',
        totalAmount: "120",
        locationName: "Zagreb - Jankomir"),
    Coupons(
        date: '06.11.2018',
        spentPoints: '30',
        totalAmount: "170",
        locationName: "Velesajam"),
    Coupons(
        date: '12.11.2018',
        spentPoints: '45',
        totalAmount: "200",
        locationName: "Osijek"),
  ];

  Widget getCouponItem(Coupons coupon, BuildContext context,int index) {
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
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0))),
                  child: Center(
                      child: Text(
                    coupon.spentPoints + " bodova",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  )),
                ),
              ),
              SizedBox(
                height: 100.0,
                child: Image.asset(
                  "assets/images/kupon_fragment_slika.PNG",
                  fit: BoxFit.fill,
                ),
                width: MediaQuery.of(context).size.width,
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text("Vrijedi do " + coupon.date)))
            ],
          ),
        ),
      ),
    );
  }
  void getKuponDetails(int index, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KuponiDetails(
            coupon: allCoupons[index],
          )),
    );
  }
}


