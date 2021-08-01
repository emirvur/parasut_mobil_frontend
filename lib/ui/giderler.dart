import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/dtofatode.dart';
import 'package:muhmobil/model/gunceldurummod.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/alisfatayrinti.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/ui/yenialisfat.dart';
import 'package:muhmobil/utils/load.dart';

import '../model/dtofattahs.dart';

class Giderler extends StatefulWidget {
  @override
  _GiderlerState createState() => _GiderlerState();
}

class _GiderlerState extends State<Giderler> with TickerProviderStateMixin {
  TabController _tabController;
  List<Dtofatode> lis = [];
  List<Dtofatode> lisara = [];
  List<Dtofatode> lisodenecek = [];
  List<Dtofatode> lisaraodenecek = [];
  List<Dtofatode> lisodegecik = [];
  List<Dtofatode> lisaraodegecik = [];
  bool isara = false;
  bool isfiltre = false;
  bool _isloading = true;
  String duztar = "";
  TextEditingController contara;
  DateTime today = DateTime.now();
  bool actgoster = true;
  List<Gunceldurummod> paragid;
  num odmik = 0;

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        if (_tabController.index == 1 || _tabController.index == 2) {
          actgoster = false;
        } else if (_tabController.index == 0) {
          actgoster = true;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      _handleTabSelection();
    });
    contara = TextEditingController();

    Future.wait([
      APIServices.odefatal(),
      APIServices.verial(),
    ]).then((value) {
      setState(() {
        lis = value[0];
        paragid = value[1].where((i) => i.tur == 1 && i.durum == 0).toList();
        odmik = paragid[0].toplammiktar - paragid[0].alinan;
        _isloading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    contara.dispose();
    //tab controller dispose yap
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Yenialisfat()));
            },
            child: Icon(FontAwesomeIcons.plus),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.brown, //.fromRGBO(52, 213, 235, 1),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: actgoster == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Toplam Ödenecek"),
                            _isloading == true
                                ? CircularProgressIndicator()
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          Load.numfor
                                              .format(odmik.round())
                                              .toString(),
                                          style: Load.font(4)),
                                      Icon(
                                        FontAwesomeIcons.liraSign,
                                        size: 12,
                                      )
                                    ],
                                  )
                          ],
                        )
                      : Text(""),
                ),
                TabBar(
                  //  isScrollable: true,
                  unselectedLabelColor: Colors.grey[300],
                  labelColor: Colors.white,
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 8.0),
                    insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                  ),
                  tabs: <Widget>[
                    Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "TÜMÜ",
                      ),
                    ),
                    Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "ÖDENECEK",
                      ),
                    ),
                    Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "GECİKMİŞ",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          title: isara == false
              ? Text("Giderler")
              : TextField(
                  decoration: new InputDecoration(hintText: 'Ara...'),
                  onChanged: (v) {
                    APIServices.alisfatara(v).then((value) {
                      setState(() {
                        lisara = value;
                        _isloading = false;
                      });
                    });
                  },
                ),
          actions: [
            actgoster == false
                ? Text("")
                : isara == false
                    ? isfiltre == false
                        ? IconButton(
                            icon: Icon(FontAwesomeIcons.calendar
                                // color: Colors.white,
                                ),
                            onPressed: () {
                              buildduztarModBottomSheet(context, size);
                            },
                          )
                        : InkWell(
                            onTap: () {
                              buildduztarModBottomSheet(context, size);
                            },
                            child: Center(
                                child: Text(duztar, style: Load.font(4))))
                    : Text(""),
            actgoster == false
                ? Text("")
                : isara == false
                    ? IconButton(
                        icon: Icon(
                          FontAwesomeIcons.search, size: 18,
                          // color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isara = !isara;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.cancel,
                          // color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isara = !isara;
                          });
                        },
                      )
          ],
        ),
        body: LoadingOverlay(
          isLoading: _isloading,
          opacity: Load.opacit,
          progressIndicator: Load.prog,
          child: Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                //   Align(alignment: Alignment.centerLeft, child: Text("Nisan 2021")),
                Expanded(
                  // child: Container(
                  //     color: Colors.grey[300],
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: <Widget>[
                      Alistum(lis, lisara, isara),
                      Alisodenecek(isara),
                      Alisgecik(isara),
                    ],
                  ),
                  //    ),
                ),
              ],
            ),
          ),
        ));
  }

  Future buildduztarModBottomSheet(BuildContext context, Size size) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: size.height / 4,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "İptal",
                          style: Load.font(6),
                        )),
                    Text("Düzenleme Tarihini seçiniz", style: Load.font(7)),
                    TextButton(onPressed: () {}, child: Text(""))
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Divider(
                  color: Colors.black,
                  height: 10,
                ),
                Column(
                  children: [
                    InkWell(
                        onTap: () {
                          APIServices.odefatal().then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                              lis = value;
                              isfiltre = true;
                              duztar = "TÜMÜ";
                            });
                          });
                        },
                        child: Text("Tümü")),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          APIServices.alisgun().then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                              lis = value;
                              isfiltre = true;
                              duztar = "BUGÜN";
                            });
                          });
                        },
                        child: Text("Bugün")),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          APIServices.alishafta().then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                              lis = value;
                              isfiltre = true;
                              duztar = "BU HAFTA";
                            });
                          });
                        },
                        child: Text("Bu hafta")),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          APIServices.alisay().then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                              lis = value;
                              isfiltre = true;
                              duztar = "BU AY";
                            });
                          });
                        },
                        child: Text("Bu ay")),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class Alistum extends StatefulWidget {
  final List<Dtofatode> listdt;
  final List<Dtofatode> lisara;
  final bool isara;
  Alistum(this.listdt, this.lisara, this.isara);

  @override
  _AlistumState createState() => _AlistumState();
}

class _AlistumState extends State<Alistum> with AutomaticKeepAliveClientMixin {
  //bool isrefresh = false;
  // List<Dtofattahs> lisrefresh;
  DateTime bugun;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bugun = DateTime.now();
    bugun = DateTime(bugun.year, bugun.month, bugun.day);
  }

  @override
  Widget build(BuildContext context) {
    return /*RefreshIndicator(
      onRefresh: () {
        return APIServices.odefatal().then((value) {
          setState(() {
            print(value.toString());
            lisrefresh = value;

            isrefresh = true;
            //     _isloading = false;
          });
        });
      },
      child:*/
        ListView.builder(
      //separatorBuilder: (context, index) => Divider(
      //    color: Colors.black,  ),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount:
          widget.isara == true ? widget.lisara.length : widget.listdt.length,
      itemBuilder: (context, index) {
        Dtofatode dt =
            widget.isara == true ? widget.lisara[index] : widget.listdt[index];
        DateTime far;
        if (dt.odenecektar != "null") {
          print("yyy");
          print(dt.odenecektar);
          print("ooo");
          print(dt.odenecektar);
          int yil = int.tryParse(dt.odenecektar.substring(0, 4));
          print(yil.toString());
          int ay = int.tryParse(dt.odenecektar.substring(5, 7));
          print(ay.toString());
          int gun = int.tryParse(dt.odenecektar.substring(8, 10));
          print(gun.toString());

          far = DateTime(yil, ay, gun);
        } else {
          far = DateTime(2000, 1, 1);
        }
        return Card(
            elevation: 0,
            margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Alisfatayrinti(dt)),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                leading: Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: new BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                      border: new Border(
                          right: new BorderSide(width: 1.0, color: Colors.grey),
                          left: new BorderSide(width: 1.0, color: Colors.grey),
                          top: new BorderSide(width: 1.0, color: Colors.grey),
                          bottom:
                              new BorderSide(width: 1.0, color: Colors.grey))),
                  child: Icon(FontAwesomeIcons.fileAlt, color: Colors.blue),
                ),
                title: Text(
                  dt.fataciklama,
                  style: Load.font(0),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    dt.duztarih == null
                        ? Text("nu")
                        : Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text("${dt.cariad},${dt.duztarih}",
                                    style: Load.font(4)),
                              ),
                            ),
                          ),
                    //      Text(" Intermediate", style: TextStyle(color: Colors.black))
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dt.geneltoplam - dt.odendimik != 0
                        ? Text(
                            Load.numfor.format(
                                (dt.geneltoplam - dt.odendimik).round()),
                            style: Load.font(4),
                          )
                        : Text(
                            "Ödendi",
                            style: Load.font(0),
                          ),
                    dt.odenecektar == null
                        ? Text("nu", style: Load.font(4))
                        : dt.geneltoplam - dt.odendimik == 0
                            ? Text(
                                "",
                                style: Load.font(0),
                              )
                            : (bugun
                                        .difference(far)
                                        .inDays
                                        .toString()
                                        .substring(0, 1) !=
                                    "-")
                                ? Text(" -${bugun.difference(far).inDays} gün",
                                    style: Load.font(2))
                                : Text(" ${bugun.difference(far).inDays} gün",
                                    style: Load.font(4))
                  ],
                ),
              ),
            ));
      },
    );
    //   );
  }
}

class Alisodenecek extends StatefulWidget {
  final bool isara;
  Alisodenecek(this.isara);

  @override
  _AlisodenecekState createState() => _AlisodenecekState();
}

class _AlisodenecekState extends State<Alisodenecek>
    with AutomaticKeepAliveClientMixin {
  List<Dtofatode> listdtoden = [];
  List<Dtofatode> lisaraoden = [];
  List<Gunceldurummod> paraode;
  DateTime bugun;
  @override
  void initState() {
    super.initState();
    print("ilktee");
    bugun = DateTime.now();
    bugun = DateTime(bugun.year, bugun.month, bugun.day);

    Future.wait([
      APIServices.odenecekfatal(),
      // APIServices.verial(),
    ]).then((value) {
      setState(() {
        listdtoden = value[0];
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return /*RefreshIndicator(
      onRefresh: () {
        return APIServices.odefatalacik().then((value) {
          setState(() {
            print(value.toString());
            listdtoden = value;

            //  isrefresh = true;
            //     _isloading = false;
          });
        });
      },
      child: */
        ListView.builder(
      //separatorBuilder: (context, index) => Divider(
      //    color: Colors.black,  ),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.isara == true ? lisaraoden.length : lisaraoden.length,
      itemBuilder: (context, index) {
        Dtofatode dt =
            widget.isara == true ? lisaraoden[index] : lisaraoden[index];
        DateTime far;
        if (dt.odenecektar != "null") {
          print("yyy");
          print(dt.odenecektar);
          print("ooo");
          print(dt.odenecektar);
          int yil = int.tryParse(dt.odenecektar.substring(0, 4));
          print(yil.toString());
          int ay = int.tryParse(dt.odenecektar.substring(5, 7));
          print(ay.toString());
          int gun = int.tryParse(dt.odenecektar.substring(8, 10));
          print(gun.toString());

          far = DateTime(yil, ay, gun);
        } else {
          far = DateTime(2000, 1, 1);
        }
        return Card(
            elevation: 0,
            margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Alisfatayrinti(dt)),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                leading: Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: new BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                      border: new Border(
                          right: new BorderSide(width: 1.0, color: Colors.grey),
                          left: new BorderSide(width: 1.0, color: Colors.grey),
                          top: new BorderSide(width: 1.0, color: Colors.grey),
                          bottom:
                              new BorderSide(width: 1.0, color: Colors.grey))),
                  child: Icon(FontAwesomeIcons.fileAlt, color: Colors.blue),
                ),
                title: Text(
                  dt.fataciklama,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    dt.duztarih == null
                        ? Text("nu")
                        : Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text("${dt.cariad},${dt.duztarih}",
                                    style: Load.font(4)),
                              ),
                            ),
                          ),
                    //      Text(" Intermediate", style: TextStyle(color: Colors.black))
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Load.numfor
                          .format((dt.geneltoplam - dt.odendimik).round())
                          .toString(), //" ${dt.geneltoplam - dt.odendimik}",
                      style: Load.font(4),
                    ),
                    dt.odenecektar == null
                        ? Text("nu", style: Load.font(4))
                        : (bugun
                                    .difference(far)
                                    .inDays
                                    .toString()
                                    .substring(0, 1) !=
                                "-")
                            ? Text(" -${bugun.difference(far).inDays} gün",
                                style: Load.font(2))
                            : Text(" ${bugun.difference(far).inDays} gün",
                                style: Load.font(4))
                  ],
                ),
              ),
            ));
      },
      //  ),
    );
  }
}

class Alisgecik extends StatefulWidget {
  final bool isara;
  Alisgecik(this.isara);

  @override
  _AlisgecikState createState() => _AlisgecikState();
}

class _AlisgecikState extends State<Alisgecik>
    with AutomaticKeepAliveClientMixin {
  List<Dtofatode> listdtodegecik = [];
  List<Dtofatode> lisaraodegecik = [];
  bool _isloading = true;
  List<Gunceldurummod> paragec;
  DateTime bugun;
  @override
  void initState() {
    super.initState();
    bugun = DateTime.now();
    bugun = DateTime(bugun.year, bugun.month, bugun.day);
    print("ilktee");

    APIServices.odefatalkapali().then((value) {
      setState(() {
        print(value.toString());
        listdtodegecik = value;
        _isloading = false;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isloading,
      opacity: Load.opacit,
      progressIndicator: Load.prog,
      child:
          /* RefreshIndicator(
        onRefresh: () {
          return APIServices.odefatalkapali().then((value) {
            setState(() {
              print(value.toString());
              listdtodegecik = value;
              _isloading = false;
            });
          });
        },
        child:*/
          ListView.builder(
        //separatorBuilder: (context, index) => Divider(
        //    color: Colors.black,  ),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.isara == true
            ? lisaraodegecik.length
            : listdtodegecik.length,
        itemBuilder: (context, index) {
          Dtofatode dt = widget.isara == true
              ? lisaraodegecik[index]
              : listdtodegecik[index];
          DateTime far;
          if (dt.odenecektar != "null") {
            print("yyy");
            print(dt.odenecektar);
            print("ooo");
            print(dt.odenecektar);
            int yil = int.tryParse(dt.odenecektar.substring(0, 4));
            print(yil.toString());
            int ay = int.tryParse(dt.odenecektar.substring(5, 7));
            print(ay.toString());
            int gun = int.tryParse(dt.odenecektar.substring(8, 10));
            print(gun.toString());

            far = DateTime(yil, ay, gun);
          } else {
            far = DateTime(2000, 1, 1);
          }
          return Card(
              elevation: 0,
              margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                  ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Alisfatayrinti(dt)),
                    );
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  leading: Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: new BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                        border: new Border(
                            right:
                                new BorderSide(width: 1.0, color: Colors.grey),
                            left:
                                new BorderSide(width: 1.0, color: Colors.grey),
                            top: new BorderSide(width: 1.0, color: Colors.grey),
                            bottom: new BorderSide(
                                width: 1.0, color: Colors.grey))),
                    child: Icon(FontAwesomeIcons.fileAlt, color: Colors.blue),
                  ),
                  title: Text(dt.fataciklama, style: Load.font(0)),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: Row(
                    children: <Widget>[
                      dt.duztarih == null
                          ? Text("nu")
                          : Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text("${dt.cariad},${dt.duztarih}",
                                      style: Load.font(4)),
                                ),
                              ),
                            ),
                      //      Text(" Intermediate", style: TextStyle(color: Colors.black))
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Load.numfor
                            .format((dt.geneltoplam - dt.odendimik).round())
                            .toString(), //               " ${dt.geneltoplam - dt.odendimik}",
                        style: Load.font(4),
                      ),
                      dt.odenecektar == null
                          ? Text("nu", style: Load.font(4))
                          : (bugun
                                      .difference(far)
                                      .inDays
                                      .toString()
                                      .substring(0, 1) !=
                                  "-")
                              ? Text(" -${bugun.difference(far).inDays} gün",
                                  style: Load.font(2))
                              : Text(" ${bugun.difference(far).inDays} gün",
                                  style: Load.font(4))
                    ],
                  ),
                ),
              ));
        },
      ),
      //     ),
    );
  }
}
