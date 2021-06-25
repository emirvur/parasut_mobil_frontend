import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muhmobil/controller/kasacontroller.dart';
import 'package:muhmobil/controller/tedarliscontroller.dart';
import 'package:muhmobil/ui/irsaliyelist.dart';
import 'package:muhmobil/ui/kasalist.dart';
import 'package:muhmobil/ui/tedarikcilist.dart';
import 'package:muhmobil/ui/urunlist.dart';
import 'package:muhmobil/utils/load.dart';

class Diger extends StatefulWidget {
  @override
  _DigerState createState() => _DigerState();
}

class _DigerState extends State<Diger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      reverse: true,
      children: [
        ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Irsaliyelist()),
              );
            },
            leading: Icon(
              FontAwesomeIcons.truckLoading,
              size: 21,
            ),
            title: Text("İrsaliyeler", style: Load.font(0))),
        Divider(color: Colors.grey),
        ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Kasalistesi()),
              );
            },
            leading: Icon(
              FontAwesomeIcons.moneyBill,
              size: 21,
              color: Colors.green,
            ),
            title: Text("Kasa ve Bankalar", style: Load.font(0))),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Urunlist()),
              );
            },
            leading: Icon(
              FontAwesomeIcons.th,
              size: 21,
              color: Colors.orange,
            ),
            title: Text("Ürün ve Hizmetler", style: Load.font(0))),
        Divider(color: Colors.grey),
        ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Tedarikcili()),
              );
            },
            leading: Icon(
              FontAwesomeIcons.truck,
              size: 21,
              color: Colors.brown,
            ),
            title: Text("Cari Hesaplar (Tedarikçi)", style: Load.font(0))),
        Divider(
          color: Colors.grey,
        ),
      ],
    ));
  }
}
