import 'package:Loyalty_client/fragment/AkcijeFragment.dart';
import 'package:Loyalty_client/fragment/KuponiFragment.dart';
import 'package:Loyalty_client/fragment/MojProfil_Fragment.dart';
import 'package:Loyalty_client/fragment/TransakcijeFragment.dart';
import 'package:Loyalty_client/fragment/UserInfoFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../firebase_messaging.dart';


class Main_Fragment extends StatefulWidget {
 int tab;

  Main_Fragment({this.tab});
  @override
  _Main_FragmentState createState() => _Main_FragmentState(selectedTab : tab);
}

class _Main_FragmentState extends State<Main_Fragment> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int selectedTab;

  _Main_FragmentState({this.selectedTab});


  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return TransakcijeFragment();
      case 1:
        return AkcijeFragment();
      case 2:
        return UserInfoFragment();
      case 3:
        return KuponiFragment();
      case 4:
        return MojProfil_Fragment();
        break;
      default:
        return UserInfoFragment();
    }
  }

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.subscribeToTopic("news");
    return Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              index: 2,
              height: 75.0,
              items: <Widget>[
                Icon(Icons.compare_arrows, size: 30,color: Colors.white,),
                Icon(Icons.local_offer, size: 30,color: Colors.white),
                Icon(Icons.person_outline, size: 30,color: Colors.white),
                Icon(Icons.local_atm, size: 30,color: Colors.white),
                Icon(Icons.info,color: Colors.white,size:30),
              ],
              color: Colors.blue,
              buttonBackgroundColor: Colors.blue,
              backgroundColor: Colors.white,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 600),
              onTap: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
            ),
            body: callPage(selectedTab))

//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Loopt In'),
//        ),
//        body: callPage(_selectedTab),
//        bottomNavigationBar: BottomNavigationBar(
//          currentIndex: _selectedTab,
//          onTap: (int index) {
//            setState(() {
//              _selectedTab = index;
//            });
//          },
//          items: [
//            BottomNavigationBarItem(
//              icon: Icon(Icons.home),
//              title: Text('Transakcije'),
//              backgroundColor: Colors.lightBlueAccent
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.category),
//              title: Text('Akcije'),
//                backgroundColor: Colors.lightBlueAccent
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.search),
//              title: Text(''),
//                backgroundColor: Colors.lightBlueAccent
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.search),
//              title: Text('Kuponi'),
//                backgroundColor: Colors.lightBlueAccent
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.search),
//              title: Text('Moj profil'),
//                backgroundColor: Colors.lightBlueAccent
//            ),
//          ],fixedColor:Colors.lightBlueAccent
//          ,
//        ),
//      ),
        ;
  }




}
