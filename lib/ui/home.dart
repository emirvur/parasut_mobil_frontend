import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muhmobil/controller/alisfatcontroller.dart';
import 'package:muhmobil/controller/gunceldurumcontroller.dart';
import 'package:muhmobil/controller/mustliscontroller.dart';
import 'package:muhmobil/controller/satisfatcontroller.dart';
import 'package:muhmobil/ui/carihesap.dart';
import 'package:muhmobil/ui/diger.dart';
import 'package:muhmobil/ui/giderler.dart';
import 'package:muhmobil/ui/gunceldurum.dart';
import 'package:muhmobil/ui/satislar.dart';
import 'package:muhmobil/utils/load.dart';

/*
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
 with AutomaticKeepAliveClientMixin
 */

class Home extends StatefulWidget {
//User user;

//Home({@required this.user});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;

  List<Widget> _widgets = <Widget>[
    Gunceldur(),
    Satisla(), //Satislar(),
    Giderle(), // Giderler(),
    Carihes(), // Carihesap(),
    Diger()
  ];

  static PageController pageController =
      PageController(); //initstate mi alsan vre dispose

  static void onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    debugPrint("1!!!!!!initstate");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("!!!!!!!rebuiltttt");
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: _widgets,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade300,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.receipt,
              size: 21,
              color: Colors.brown,
            ),
            label: "Güncel D.",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.arrowDown,
                size: 21,
                color: Colors.blueAccent,
              ),
              label: "Satışlar"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.arrowUp,
                size: 21,
                color: Colors.red,
              ),
              label: "Giderler"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.building,
                size: 21,
                color: Colors.amber,
              ),
              label: "Cari H."),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.ellipsisH,
                size: 21,
                color: Colors.greenAccent,
              ),
              label: "Diğer"),
        ],
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
