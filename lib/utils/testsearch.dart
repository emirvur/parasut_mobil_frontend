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

import 'load.dart';

class Search extends StatefulWidget {
  Search({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
    //myController.addListener(_printLatestValue);
    // myController2.addListener(_printLatestValue);
    //myController3.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    //myController.dispose();
    //myController2.dispose();
    // myController3.dispose();
    super.dispose();
  }

  // mocking a future
  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(milliseconds: 2000));
    List _list = new List();
    // create a list from the text input of three items
    // to mock a list of items from an http call
    Kasal x = Kasal("d", 1, "dd", 12);
    Kasal u = Kasal("u", 2, "uu", 12);
    _list.add(x);
    _list.add(u);

    return _list;
  }

  // mocking a future that returns List of Objects
  Future<List> fetchComplexData() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    List _list = new List();
    List li = new List();
    List _jsonList = [
      {'label': 'Text' + ' Item 1', 'value': 30},
      {'label': 'Text' + ' Item 2', 'value': 31},
      {'label': 'Text' + ' Item 3', 'value': 32},
    ];
    Kasal x = Kasal("dd", 1, "ddd", 12);
    Kasal u = Kasal("uu", 2, "ddd", 12);
    var y = x.toMap();
    var m = u.toMap();
    li.add(new Kasal.fromMap(y));
    //  _list.add(new Kasal.fromMap(m));

    var q = await APIServices.searchmust(myController2.text);

    for (Labcari l in q) {
      var p = l.toMap(1);
      _list.add(Labcari.fromMap(p));
    }
    return _list;
    // create a list from the text input of three items
    // to mock a list of items from an http call where
    // the label is what is seen in the textfield and something like an
    // ID is the selected value

    // _list.add(new TestItem.fromJson(_jsonList[1]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),*/
      body: LoadingOverlay(
        isLoading: loadapi,
        opacity: Load.opacit,
        progressIndicator: Load.prog,
        child: Padding(
          padding: EdgeInsets.all(20),
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Form(
            child: ListView(
              children: <Widget>[
                /* SizedBox(height: 16),
                TextFieldSearch(
                    label: 'Simple Future List',
                    controller: myController2,
                    future: () {
                      return fetchSimpleData();
                    }),*/
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
                /*    SizedBox(height: 16),
                TextFieldSearch(
                    initialList: _testList,
                    label: 'Simple List',
                    controller: myController),*/
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
                              /*onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Irsayrinti(dt)),
                                );
                              },*/
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
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                              subtitle: Row(
                                children: <Widget>[
                                  Text(
                                    "${dt.cariad} ,${dt.tarih}",
                                    style: Load.font(1),
                                  )
                                  //      Text(" Intermediate", style: TextStyle(color: Colors.black))
                                ],
                              ),
                              /*    trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "3 gün", //   " ${dt.geneltoplam - dt.alinmism}",
                        style: TextStyle(color: Colors.black),
                      ),
                      dt.vadta == null
                          ? Text("nu")
                          : Text(" ${dt.vadta.substring(0, 4)}",
                              style: TextStyle(color: Colors.grey))
                    ],
                  ),*/
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
                            DateTime(2015).toString(),
                            DateTime(2025).toString());
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
