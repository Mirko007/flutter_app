import 'package:Loyalty_client/fragment/AkcijeFragment.dart';
import 'package:Loyalty_client/fragment/KuponiFragment.dart';
import 'package:Loyalty_client/fragment/MojProfil_Fragment.dart';
import 'package:Loyalty_client/fragment/TransakcijeFragment.dart';
import 'package:Loyalty_client/fragment/UserInfoFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class Main_Fragment extends StatefulWidget {
  @override
  _Main_FragmentState createState() => _Main_FragmentState();
}

class _Main_FragmentState extends State<Main_Fragment> {
  int _selectedTab = 2;

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
                  _selectedTab = index;
                });
              },
            ),
            body: callPage(_selectedTab))

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
