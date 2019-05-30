import 'package:flutter/material.dart';
import 'package:flutter_app/TransactionDetails.dart';
import 'package:flutter_app/fragment/AkcijeFragment.dart';
import 'package:flutter_app/fragment/KuponiFragment.dart';
import 'package:flutter_app/fragment/MojProfil_Fragment.dart';
import 'package:flutter_app/fragment/TransakcijeFragment.dart';
import 'package:flutter_app/fragment/UserInfoFragment.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter_app/./presentation/my_flutter_app_icons.dart' as customIcon;


class Main_Fragment extends StatefulWidget {
  @override
  _Main_FragmentState createState() => _Main_FragmentState();
}

class _Main_FragmentState extends State<Main_Fragment> {
  int _selectedTab = 2;
  final _pageOptions = [
    UserInfoFragment(),
    UserInfoFragment(),
    UserInfoFragment(),
    UserInfoFragment(),
    UserInfoFragment(),
  ];

  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return TransakcijeFragment();
        
//      case 1:
//        return AkcijeFragment();
      case 2:
        return UserInfoFragment();
//      case 3:
//        return KuponiFragment();
      case 4:
        return MojProfil_Fragment();
        break;
      default:
        return UserInfoFragment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              index: 2,
              height: 75.0,
              items: <Widget>[
                Icon(Icons.transform, size: 30),
                Icon(Icons.accessibility_new, size: 30),
                Icon(Icons.adb, size: 30),
                Icon(Icons.redeem, size: 30),
                Icon(customIcon.MyFlutterApp.user_plus,size:30),
              ],
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: Colors.blue,
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
        );
  }


}
