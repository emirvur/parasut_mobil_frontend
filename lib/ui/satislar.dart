import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/gunceldurummod.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:muhmobil/utils/colorloader.dart';
import 'package:muhmobil/utils/load.dart';

import '../model/dtofattahs.dart';

class Satislar extends StatefulWidget {
  @override
  _SatislarState createState() => _SatislarState();
}

class _SatislarState extends State<Satislar> with TickerProviderStateMixin {
  TabController _tabController;
  List<Dtofattahs> lis = [];
  List<Dtofattahs> lisara = [];
  List<Dtofattahs> listahsedil = [];
  List<Dtofattahs> lisaratahsedil = [];
  List<Dtofattahs> listahsgecik = [];
  List<Dtofattahs> lisaratahsgecik = [];
  bool isara = false;
  bool isfiltre = false;
  bool _isloading = true;
  bool actgoster = true;
  String duztar = "";
  TextEditingController contara;
  DateTime today = DateTime.now();
  DateTime pickedDate;
  List<Gunceldurummod> gd;
  num tahsmik = 0;

  _pickDate() async {
    DateTime date = await showDatePicker(
      //  locale: Locale("tr"),
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      _handleTabSelection();
    });
    contara = TextEditingController();

    /*APIServices.callstp(DateTime(2005), DateTime(2035)).then((value) {
      gd = value.where((i) => i.tur == 1 && i.durum == 0).toList();
      print(gd[0].alinan.toString());
    });

    APIServices.satfatal().then((value) {
      setState(() {
        lis = value;
        _isloading = false;
      });
    });
    APIServices.verial().then((value) {
      setState(() {
        gd = value.where((i) => i.tur == 1 && i.durum == 0).toList();
        tahsmik = gd[0].toplammiktar - gd[0].alinan;
        _isloading = false;
      });
    });*/

    Future.wait([
      APIServices.satfatal(),
      APIServices.verial(),
      //  APIServices.satcarifatal(widget.dt.cariId),
    ]).then((value) {
      setState(() {
        lis = value[0];
        gd = value[1].where((i) => i.tur == 1 && i.durum == 0).toList();
        tahsmik = gd[0].toplammiktar - gd[0].alinan;
        _isloading = false;
        //    cari = value[0];
        //  lis = value[1];
      });
    });
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        if (_tabController.index == 1 || _tabController.index == 2) {
          print("1de");
          actgoster = false;
        } else if (_tabController.index == 0) {
          print("1de");
          actgoster = true;
        }
        print("setstewf");
      });
    }
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
    print("ana");
    final size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Yenisatisfat()));
            },
            child: Icon(FontAwesomeIcons.plus),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(52, 213, 235, 1),
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
                            Text("Toplam Tahsil edilecek", style: Load.font(4)),
                            _isloading == true
                                ? CircularProgressIndicator()
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          Load.numfor
                                              .format(tahsmik.round())
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
                  // isScrollable: true,
                  unselectedLabelColor: Colors.grey[300],
                  //         labelStyle: TextStyle(fontSize: 18.0),
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
                        text: "TAHSİL EDİLECEK",
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
              ? Text("Satışlar", style: Load.font(4))
              : TextField(
                  decoration: new InputDecoration(
                    hintText: 'Ara...',
                    // hintStyle: TextStyle(fontStyle: Load.font(4))
                  ),
                  onChanged: (v) {
                    APIServices.satfatalara(v).then((value) {
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
                      Satistum(lis, lisara, isara),
                      Satistahsedil(isara),
                      Satistum(lis, lisara, isara),
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
                    Text(
                      "Düzenleme Tarihini seçiniz",
                      style: Load.font(7),
                    ),
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
                          /*
                              APIServices.callstp(DateTime(2005), DateTime(2035)).then((value) {
      paratahs = value.where((i) => i.tur == 1 && i.durum == 0).toList();
      print(paratahs[0].alinan.toString());
    });
                          */

                          APIServices.satfatal().then((value) {
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
                          /*
                              APIServices.callstp(DateTime(2005), DateTime(2035)).then((value) {
      paratahs = value.where((i) => i.tur == 1 && i.durum == 0).toList();
      print(paratahs[0].alinan.toString());
    });
                          */
                          APIServices.satisgun().then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                              lis = value;
                              isfiltre = true;
                              duztar = "BUGÜN";
                            });
                          });
                        },
                        child: Text("Bugün", style: Load.font(4))),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          /*       APIServices.callstp(DateTime(2005), DateTime(2035)).then((value) {
      paratahs = value.where((i) => i.tur == 1 && i.durum == 0).toList();
      print(paratahs[0].alinan.toString());
    });*/
                          APIServices.satishafta().then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                              lis = value;
                              isfiltre = true;
                              duztar = "BU HAFTA";
                            });
                          });
                        },
                        child: Text("Bu hafta", style: Load.font(4))),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          /*
    APIServices.callstp(DateTime(2005), DateTime(2035)).then((value) {
      paratahs = value.where((i) => i.tur == 1 && i.durum == 0).toList();
      print(paratahs[0].alinan.toString());
    });
                          */
                          APIServices.satisay().then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                              lis = value;
                              isfiltre = true;
                              duztar = "BU AY";
                            });
                          });
                        },
                        child: Text("Bu ay", style: Load.font(4))),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class Satistum extends StatefulWidget {
  final List<Dtofattahs> listdt;
  final List<Dtofattahs> lisara;
  final bool isara;
  Satistum(this.listdt, this.lisara, this.isara);

  @override
  _SatistumState createState() => _SatistumState();
}

class _SatistumState extends State<Satistum>
    with AutomaticKeepAliveClientMixin {
  DateTime bugun;
  //bool isrefresh = false;
  // List<Dtofattahs> lisrefresh;
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
    print("tumm");
    return /*RefreshIndicator(
      onRefresh: () {
        return APIServices.satfatal().then((value) {
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
      itemCount: //isrefresh == true
          //      ? lisrefresh.length:
          widget.isara == true ? widget.lisara.length : widget.listdt.length,
      itemBuilder: (context, index) {
        Dtofattahs dt = //isrefresh == true
            //    ? lisrefresh[index]:
            widget.isara == true ? widget.lisara[index] : widget.listdt[index];
        DateTime far;
        if (dt.vadta != "null") {
          print("yyy");
          print(dt.vadta);
          print("ooo");
          print(dt.vadta);
          int yil = int.tryParse(dt.vadta.substring(0, 4));
          print(yil.toString());
          int ay = int.tryParse(dt.vadta.substring(5, 7));
          print(ay.toString());
          int gun = int.tryParse(dt.vadta.substring(8, 10));
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
                        builder: (context) => Satisfatayrinti(dt)),
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
                title: Text(dt.fataciklama, style: Load.font(4)),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    dt.duztarih == null
                        ? Text("nu", style: Load.font(4))
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
                  ],
                ),

                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dt.geneltoplam - dt.alinmism != 0
                        ? Text(
                            Load.numfor
                                .format((dt.geneltoplam - dt.alinmism).round()),
                            style: Load.font(4),
                          )
                        : Text(
                            "Tahsil edildi",
                            style: Load.font(0),
                          ),
                    dt.vadta == null
                        ? Text("nu", style: Load.font(4))
                        : dt.geneltoplam - dt.alinmism == 0
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
    //);
  }
}

class Satistahsedil extends StatefulWidget {
  final bool isara;
  Satistahsedil(this.isara);

  @override
  _SatistahsedilState createState() => _SatistahsedilState();
}

class _SatistahsedilState extends State<Satistahsedil>
    with AutomaticKeepAliveClientMixin {
  List<Dtofattahs> listdttahsedil = [];
  List<Dtofattahs> lisaratahsedil = [];
  List<Gunceldurummod> paratahs = [];
  bool _isloading = true;
  DateTime bugun;
  @override
  void initState() {
    super.initState();
    bugun = DateTime.now();
    bugun = DateTime(bugun.year, bugun.month, bugun.day);
    print("ilktee");

    /* APIServices.callstp(DateTime(2005), DateTime(2035)).then((value) {
      paratahs = value.where((i) => i.tur == 1 && i.durum == 0).toList();
      print(paratahs[0].alinan.toString());
    });*/
    APIServices.satfatalacikfat().then((value) {
      setState(() {
        print(value.toString());
        listdttahsedil = value;
        _isloading = false;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print("tahs");
    return LoadingOverlay(
      isLoading: _isloading,
      opacity: Load.opacit,
      progressIndicator: Load.prog,
      child:
          /* RefreshIndicator(
        onRefresh: () {
          return APIServices.satfatalacikfat().then((value) {
            setState(() {
              print(value.toString());
              listdttahsedil = value;
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
            ? lisaratahsedil.length
            : listdttahsedil.length,
        itemBuilder: (context, index) {
          Dtofattahs dt = widget.isara == true
              ? lisaratahsedil[index]
              : listdttahsedil[index];
          DateTime far;
          if (dt.vadta != "null") {
            print("yyy");
            print(dt.vadta);
            print("ooo");
            print(dt.vadta);
            int yil = int.tryParse(dt.vadta.substring(0, 4));
            print(yil.toString());
            int ay = int.tryParse(dt.vadta.substring(5, 7));
            print(ay.toString());
            int gun = int.tryParse(dt.vadta.substring(8, 10));
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
                          builder: (context) => Satisfatayrinti(dt)),
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
                  title: Text(
                    dt.fataciklama,
                    style: Load.font(4),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: Row(
                    children: <Widget>[
                      dt.duztarih == null
                          ? Text("nu", style: Load.font(4))
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
                            .format((dt.geneltoplam - dt.alinmism).round()),
                        style: Load.font(4),
                      ),
                      dt.vadta == null
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
      //   ),
    );
  }
}

class Satistahsgecik extends StatefulWidget {
  final bool isara;
  Satistahsgecik(this.isara);

  @override
  _SatistahsgecikState createState() => _SatistahsgecikState();
}

class _SatistahsgecikState extends State<Satistahsgecik>
    with AutomaticKeepAliveClientMixin {
  List<Dtofattahs> listdttahsgecik = [];
  List<Dtofattahs> lisaratahsgecik = [];
  List<Gunceldurummod> paragec;
  bool _isloading = true;
  DateTime bugun;
  @override
  void initState() {
    super.initState();
    bugun = DateTime.now();
    bugun = DateTime(bugun.year, bugun.month, bugun.day);
    print("ilktee");
    /* APIServices.callstp(DateTime(2005), DateTime(2035)).then((value) {
      paragec = value.where((i) => i.tur == 1 && i.durum == 0).toList();
      print(paragec[0].alinan.toString());
    });*/
    APIServices.tahsgecikmisal().then((value) {
      setState(() {
        print(value.toString());
        listdttahsgecik = value;
        _isloading = false;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print("geci");
    return LoadingOverlay(
      isLoading: _isloading,
      opacity: Load.opacit,
      progressIndicator: Load.prog,
      child:
          /* RefreshIndicator(
        onRefresh: () {
          return APIServices.satfatalkapali().then((value) {
            setState(() {
              print(value.toString());
              listdttahsgecik = value;
              _isloading = false;
            });
          });
        },
        child: */
          ListView.builder(
        //separatorBuilder: (context, index) => Divider(
        //    color: Colors.black,  ),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.isara == true
            ? lisaratahsgecik.length
            : listdttahsgecik.length,
        itemBuilder: (context, index) {
          Dtofattahs dt = widget.isara == true
              ? lisaratahsgecik[index]
              : listdttahsgecik[index];
          DateTime far;
          if (dt.vadta != "null") {
            print("yyy");
            print(dt.vadta);
            print("ooo");
            print(dt.vadta);
            int yil = int.tryParse(dt.vadta.substring(0, 4));
            print(yil.toString());
            int ay = int.tryParse(dt.vadta.substring(5, 7));
            print(ay.toString());
            int gun = int.tryParse(dt.vadta.substring(8, 10));
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
                          builder: (context) => Satisfatayrinti(dt)),
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
                  title: Text(
                    dt.fataciklama,
                    style: Load.font(4),
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  subtitle: Row(
                    children: <Widget>[
                      dt.duztarih == null
                          ? Text("nu", style: Load.font(4))
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
                            .format((dt.geneltoplam - dt.alinmism).round()),
                        style: Load.font(4),
                      ),
                      dt.vadta == "null"
                          ? Text("null", style: Load.font(4))
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
