import 'package:Loyalty_client/AppTranslations.dart';
import 'package:Loyalty_client/fragment/AkcijeFragment.dart';
import 'package:Loyalty_client/fragment/KuponiFragment.dart';
import 'package:Loyalty_client/fragment/MojProfil_Fragment.dart';
import 'package:Loyalty_client/fragment/TransakcijeFragment.dart';
import 'package:Loyalty_client/fragment/UserInfoFragment.dart';

import 'package:Loyalty_client/presentation/my_barcode_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../firebase_messaging.dart';
import '../global_variable.dart' as globals;


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
    _firebaseMessaging.subscribeToTopic(globals.notification_topic);

     return  Scaffold(
        body: callPage(selectedTab),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Container(height: 58.0,
            width: MediaQuery.of(context).size.width,
            child: (MediaQuery.of(context).orientation == Orientation.portrait)?
          BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: selectedTab,
            onTap: (int index) {
              setState(() {
                selectedTab = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(MyBarcode.transaction),
                title: Text(AppTranslations.of(context).text("transakcije"),style: TextStyle(fontSize: 10),),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyBarcode.offers),
                title: Text(AppTranslations.of(context).text("akcije"),style: TextStyle(fontSize: 10),),

              ),
              BottomNavigationBarItem(
                icon: Icon(MyBarcode.barcode,size: 40,),
                title: Container(height: 0.0),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyBarcode.voucher),
                title: Text(AppTranslations.of(context).text("kuponi"),style: TextStyle(fontSize: 10),),
              ),
              BottomNavigationBarItem(
                icon: Icon(MyBarcode.user),
                title: Text(AppTranslations.of(context).text("moj_profil"),style: TextStyle(fontSize: 10),),
              ),
            ],
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black45,
            backgroundColor: Colors.white,

          ):
            Container(
              color: Colors.white,
              height: 1,
              width: MediaQuery.of(context).size.width,
            )
          ),
        )
      );

  }




}
