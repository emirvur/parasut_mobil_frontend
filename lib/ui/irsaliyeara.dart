import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/controller/gdhaftacontroller.dart';
import 'package:muhmobil/controller/gdnuguncontroller.dart';
import 'package:muhmobil/controller/gunceldurumcontroller.dart';
import 'package:muhmobil/controller/mustliscontroller.dart';
import 'package:muhmobil/controller/satisfatcontroller.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:muhmobil/model/dtoirsaliye.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/labelcari.dart';
import 'package:muhmobil/model/labelkasa.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/irsaliyelist.dart';
import 'package:muhmobil/ui/irsayrinti.dart';
import 'package:textfield_search/textfield_search.dart';

import '../utils/load.dart';

class Irsaliyeara extends StatefulWidget {
  Irsaliyeara({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IrsaliyearaState createState() => _IrsaliyearaState();
}

class _IrsaliyearaState extends State<Irsaliyeara> {
  List<Dtoirsaliye> listir = [];
  num contara = 0;
  num contgen = 0;
  bool secmi = false;
  Labcari c;
  bool loadapi = false;

  TextEditingController myController;
  TextEditingController myController2;
  TextEditingController myController3;
  @override
  void initState() {
    super.initState();
    myController = TextEditingController();
    myController2 = TextEditingController();
    myController3 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List> fetchComplexData() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    List _list = new List();

    var q = await APIServices.searchmust(myController2.text);

    for (Labcari l in q) {
      var p = l.toMap(1);
      _list.add(Labcari.fromMap(p));
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: loadapi,
        opacity: Load.opacit,
        progressIndicator: Load.prog,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 16),
                TextFieldSearch(
                  label: 'Müşteri seçiniz',
                  controller: myController3,
                  future: () {
                    return fetchComplexData();
                  },
                  getSelectedValue: (item) {
                    print("ooo");
                    print(item.cariunvani);
                    print(item.cariId);
                    c = item;

                    APIServices.getcariris(item.cariId).then((value) {
                      listir = value;
                      secmi = true;

                      setState(() {});
                    });
                  },
                  minStringLength: 0,
                  textStyle: TextStyle(color: Colors.red),
                  decoration: InputDecoration(hintText: 'Müşteri seçiniz'),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    secmi == false
                        ? ""
                        : "Seçtiğiniz müşterinin irsaliye listesi",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        listir.length < 3 ? listir.length : 3, //listir.length,
                    itemBuilder: (context, index) {
                      Dtoirsaliye dt = listir[index];
                      return Card(
                          elevation: 0,
                          margin: new EdgeInsets.symmetric(
                              vertical: 1.0 //horizontal:10
                              ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors
                                    .white), //Color.fromRGBO(64, 75, 96, .9)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              leading: Container(
                                padding: EdgeInsets.all(6.0),
                                decoration: new BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0, color: Colors.grey),
                                        left: new BorderSide(
                                            width: 1.0, color: Colors.grey),
                                        top: new BorderSide(
                                            width: 1.0, color: Colors.grey),
                                        bottom: new BorderSide(
                                            width: 1.0, color: Colors.grey))),
                                child: Icon(FontAwesomeIcons.fileAlt,
                                    color: Colors.blue),
                              ),
                              title: Text(
                                dt.aciklama,
                                style: Load.font(0),
                              ),
                              subtitle: Row(
                                children: <Widget>[
                                  Text(
                                    "${dt.cariad} ,${dt.tarih}",
                                    style: Load.font(1),
                                  )
                                  //      Text(" Intermediate", style: TextStyle(color: Colors.black))
                                ],
                              ),
                            ),
                          ));
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    listir.length < 4
                        ? ""
                        : "${listir.length - 3} tane daha...",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: FlatButton(
                      child: Text('Irsaliyeleri tekli faturaya dönüştür',
                          style: TextStyle(fontSize: 16)),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () async {
                        setState(() {
                          loadapi = true;
                        });
                        List<int> h = await APIServices.irsifatyap(
                          c.cariId,
                        );
                        for (int i = 0; i < listir.length; i++) {
                          contara = contara + listir[i].aratop;
                          contgen = contgen + listir[i].geneltop;
                        }
                        Get.find<Satistahscontroller>().satffattahsekleyeni(
                            Dtofattahs(
                                h[0],
                                1,
                                0,
                                c.cariId,
                                c.cariunvani,
                                DateTime.now().toString(),
                                "",
                                "",
                                contara,
                                0,
                                contgen - contara,
                                contgen,
                                DateTime.now().toString(),
                                null,
                                0,
                                h[1]));
                        Get.find<Mustliscontroller>()
                            .mustbakguncel(c.cariId, -contgen);
                        Get.find<Satisfatcontroller>().satffattumekleyeni(
                            Dtofattahs(
                                h[0],
                                1,
                                0,
                                c.cariId,
                                c.cariunvani,
                                DateTime.now().toString(),
                                "",
                                "",
                                contara,
                                0,
                                contgen - contara,
                                contgen,
                                DateTime.now().toString(),
                                null,
                                0,
                                h[1]));
                        Get.find<Satisgecicontroller>().satffatgeciekleyeni(
                            Dtofattahs(
                                h[0],
                                1,
                                0,
                                c.cariId,
                                c.cariunvani,
                                DateTime.now().toString(),
                                "",
                                "",
                                contara,
                                0,
                                contgen - contara,
                                contgen,
                                DateTime.now().toString(),
                                null,
                                0,
                                h[1]));
                        Get.find<Satisfatcontroller>().siradegistir(0);

                        Get.find<Gunceldurumcontroller>()
                            .aysatguncelle(contgen);
                        Get.find<Gdhaftacontroller>().haftasatguncelle(contgen);
                        Get.find<Gdbuguncontroller>().gunsatguncelle(contgen);
                        Navigator.of(context).pop(1);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
