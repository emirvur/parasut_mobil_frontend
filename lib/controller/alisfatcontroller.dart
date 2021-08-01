import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/controller/tedarliscontroller.dart';
import 'package:muhmobil/model/dtofatode.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:muhmobil/model/dtoodeharfat.dart';
import 'package:muhmobil/model/dtotahsharfat.dart';
import 'package:muhmobil/model/dtourunhareket.dart';
import 'package:muhmobil/model/gunceldurummod.dart';
import 'package:muhmobil/model/gunceldurummod1.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/odeput.dart';
import 'package:muhmobil/model/tahsput.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:flutter/material.dart';
import 'package:muhmobil/ui/alisfatayrin.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/ui/yenialisfat.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:intl/intl.dart';

class Alisfatcontroller extends GetxController {
  var isLoading = true.obs;
  var listdtofatta = List<Dtofatode>().obs;
  var listgd = List<Gunceldurummod1>().obs;
  var lisbugun = List<Dtofatode>().obs;
  var lishafta = List<Dtofatode>().obs;
  var lisay = List<Dtofatode>().obs;
  num tahsmik = 0.obs();
  int sira = 0.obs();
  @override
  void onInit() {
    fetchfinaltodo();
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      var todos = await APIServices.odefatal();
      if (todos != null) {
        listdtofatta.value = todos;
      }
      var x = await APIServices.verial();
      if (x != null) {
        listgd.value = x.where((i) => i.tur == 0 && i.durum == 0).toList();
        tahsmik = listgd[0].toplammiktar - listgd[0].odenen;
        //    listgd.value = x;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> bugunfat() async {
    isLoading(true);
    try {
      siradegistir(1);
      var todos = await APIServices.alisgun();

      if (todos != null) {
        lisbugun.value = todos;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> haftafat() async {
    isLoading(true);
    try {
      siradegistir(2);
      var todos = await APIServices.alishafta();

      if (todos != null) {
        lishafta.value = todos;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> ayfat() async {
    isLoading(true);
    try {
      siradegistir(3);
      var todos = await APIServices.alisay();

      if (todos != null) {
        lisay.value = todos;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> siradegistir(int x) async {
    isLoading(true);

    try {
      await Future.delayed(Duration(milliseconds: 1));
      sira = x;
    } finally {
      isLoading(false);
    }
  }

  void guncelle(int index, num deg) async {
    isLoading(true);

    try {
      for (var i in listdtofatta) {
        if (i.fatid == index) {
          if (i.geneltoplam - i.odendimik == deg) {
            i.durum = 1;
            //sattahsta kaldır
            //   listdtofatta.removeWhere((item) => item.fatid == '001');
            // listdtofatta.remove(i);
          }
          i.odendimik = i.odendimik + deg;
        }
      }
      tahsmik = tahsmik - deg;
    } finally {
      isLoading(false);
    }
  }

  void alisffattumekleyeni(Dtofatode yeni) async {
    isLoading(true);

    try {
      listdtofatta.insert(0, yeni);
      tahsmik = tahsmik + yeni.geneltoplam;
    } finally {
      isLoading(false);
    }
  }

  void alisfftumkleyeni(Dtofatode yeni) async {
    isLoading(true);

    try {
      listdtofatta.add(yeni);
      tahsmik = tahsmik + yeni.geneltoplam;
    } finally {
      isLoading(false);
    }
  }
}

class Alisodenecekcontroller extends GetxController {
  var isLoading = true.obs;
  var listdtofatta = List<Dtofatode>().obs;
  var listgd = List<Gunceldurummod>().obs;
  num tahsmik = 0.obs();

  @override
  void onInit() {
    fetchfinaltodo();
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      var todos = await APIServices.odenecektumfatal();
      if (todos != null) {
        listdtofatta.value = todos;
      }
    } finally {
      isLoading(false);
    }
  }

  void guncelle(int index, num deg) async {
    isLoading(true);

    try {
      for (var i in listdtofatta) {
        if (i.fatid == index) {
          if (i.geneltoplam - i.odendimik == deg) {
            i.durum = 1;
            //sattahsta kaldır
            //   listdtofatta.removeWhere((item) => item.fatid == '001');
            listdtofatta.remove(i);
          }
          i.odendimik = i.odendimik + deg;
        }
      }
      tahsmik = tahsmik - deg;
    } finally {
      isLoading(false);
    }
  }

  void alisffodenekkleyeni(Dtofatode yeni) async {
    isLoading(true);

    try {
      listdtofatta.insert(0, yeni);
      tahsmik = tahsmik + yeni.geneltoplam;
    } finally {
      isLoading(false);
    }
  }
}

class Alisgecontroller extends GetxController {
  var isLoading = true.obs;
  var listdtofatta = List<Dtofatode>().obs;
  var listgd = List<Gunceldurummod>().obs;
  num tahsmik = 0.obs();

  @override
  void onInit() {
    fetchfinaltodo();
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      var todos = await APIServices.odemegecikal();
      if (todos != null) {
        listdtofatta.value = todos;
      }
    } finally {
      isLoading(false);
    }
  }

  void guncelle(int index, num deg) async {
    isLoading(true);

    try {
      for (var i in listdtofatta) {
        if (i.fatid == index) {
          if (i.geneltoplam - i.odendimik == deg) {
            i.durum = 1;

            listdtofatta.remove(i);
          }
          i.odendimik = i.odendimik + deg;
        }
      }
      tahsmik = tahsmik - deg;
    } finally {
      isLoading(false);
    }
  }

  void alisffgeckkleyeni(Dtofatode yeni) async {
    isLoading(true);

    try {
      if (DateTime.tryParse(yeni.odenecektar).isBefore(DateTime.now())) {
        listdtofatta.insert(0, yeni);
      }
    } finally {
      isLoading(false);
    }
  }
}

class Giderle extends StatefulWidget {
  @override
  _GiderleState createState() => _GiderleState();
}

class _GiderleState extends State<Giderle> with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    contara.dispose();
    //tab controller dispose yap
    _tabController.dispose();
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
          backgroundColor: Colors.brown,
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() {
                                if (Get.find<Alisfatcontroller>()
                                    .isLoading
                                    .value) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Text(
                                    Load.numfor
                                        .format(Get.find<Alisfatcontroller>()
                                            .tahsmik
                                            .round())
                                        .toString(),
                                    style: Load.font(4));
                              }),
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
                      : InkWell(onTap: () {
                          buildduztarModBottomSheet(context, size);
                        }, child: Obx(() {
                          if (Get.find<Alisfatcontroller>().isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Center(
                              child: Text(
                                  Get.find<Alisfatcontroller>().sira == 0
                                      ? "Tümü"
                                      : Get.find<Alisfatcontroller>().sira == 1
                                          ? "Bugün"
                                          : Get.find<Alisfatcontroller>()
                                                      .sira ==
                                                  2
                                              ? "Bu hafta"
                                              : "Bu ay",
                                  style: Load.font(4)));
                        }))
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
      body: Container(
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
                  Obx(() {
                    if (Get.find<Alisfatcontroller>().isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Get.find<Alisfatcontroller>().sira == 0
                        ? Alistu(Get.find<Alisfatcontroller>().listdtofatta,
                            lisara, isara)
                        : Get.find<Alisfatcontroller>().sira == 1
                            ? Alistu(Get.find<Alisfatcontroller>().lisbugun,
                                lisara, isara)
                            : Get.find<Alisfatcontroller>().sira == 2
                                ? Alistu(Get.find<Alisfatcontroller>().lishafta,
                                    lisara, isara)
                                : Alistu(Get.find<Alisfatcontroller>().lisay,
                                    lisara, isara);
                  }),
                  Alisodene(isara),
                  Alisge(isara),
                ],
              ),
              //    ),
            ),
          ],
        ),
      ),
    );
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
                          Get.find<Alisfatcontroller>()
                              .siradegistir(0)
                              .then((v) {
                            setState(() {
                              Navigator.of(context).pop();
                              //    lis = value;
                              isfiltre = true;
                              //    duztar = "TÜMÜ";
                            });
                          });
                        },
                        child: Text("Tümü")),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Get.find<Alisfatcontroller>().bugunfat().then((v) {
                            setState(() {
                              Navigator.of(context).pop();
                              //    lis = value;
                              isfiltre = true;
                              //  duztar = "BUGÜN";
                            });
                          });
                        },
                        child: Text("Bugün")),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Get.find<Alisfatcontroller>().haftafat().then((v) {
                            setState(() {
                              Navigator.of(context).pop();
                              //    lis = value;
                              isfiltre = true;
                              //  duztar = "BUGÜN";
                            });
                          });
                        },
                        child: Text("Bu hafta")),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Get.find<Alisfatcontroller>().ayfat().then((v) {
                            setState(() {
                              Navigator.of(context).pop();
                              //    lis = value;
                              isfiltre = true;
                              //  duztar = "BUGÜN";
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

class Alistu extends StatefulWidget {
  final List<Dtofatode> listdt;
  final List<Dtofatode> lisara;
  final bool isara;
  Alistu(this.listdt, this.lisara, this.isara);

  @override
  _AlistuState createState() => _AlistuState();
}

class _AlistuState extends State<Alistu> with AutomaticKeepAliveClientMixin {
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
        dt.duztarih = DateTime.tryParse(dt.duztarih) == null
            ? dt.duztarih
            : DateFormat.yMMMEd('tr_TR').format(DateTime.parse(dt.duztarih));
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
                    MaterialPageRoute(builder: (context) => Alisfatayrin(dt)),
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
                            : bugun.difference(far).inDays == 0
                                ? Text("Bugün")
                                : (bugun
                                            .difference(far)
                                            .inDays
                                            .toString()
                                            .substring(0, 1) !=
                                        "-")
                                    ? Text(
                                        " -${bugun.difference(far).inDays} gün",
                                        style: Load.font(2))
                                    : Text(
                                        " ${-1 * bugun.difference(far).inDays} gün",
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

class Alisodene extends StatefulWidget {
  final bool isara;
  Alisodene(this.isara);

  @override
  _AlisodeneState createState() => _AlisodeneState();
}

class _AlisodeneState extends State<Alisodene>
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
    /*   APIServices.callstp(DateTime(2005), DateTime(2035)).then((value) {
      paraode = value.where((i) => i.tur == 1 && i.durum == 0).toList();
      print(paraode[0].alinan.toString());
    });
    APIServices.odefatalacik().then((value) {
      setState(() {
        print(value.toString());
        listdtoden = value;
      });
    });*/

    /* Future.wait([
      APIServices.odenecekfatal(),
      // APIServices.verial(),
    ]).then((value) {
      setState(() {
        listdtoden = value[0];
        //      paraode = value[1].where((i) => i.tur == 1 && i.durum == 0).toList();
        //print(paraode[0].alinan.toString());
        // _isloading = false;
      });
    });*/
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<Alisodenecekcontroller>().isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return ListView.builder(
        //separatorBuilder: (context, index) => Divider(
        //    color: Colors.black,  ),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.isara == true
            ? lisaraoden.length
            : Get.find<Alisodenecekcontroller>().listdtofatta.length,
        itemBuilder: (context, index) {
          Dtofatode dt = widget.isara == true
              ? lisaraoden[index]
              : Get.find<Alisodenecekcontroller>().listdtofatta[index];
          dt.duztarih = DateTime.tryParse(dt.duztarih) == null
              ? dt.duztarih
              : DateFormat.yMMMEd('tr_TR').format(DateTime.parse(dt.duztarih));
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
                      MaterialPageRoute(builder: (context) => Alisfatayrin(dt)),
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
                    style: TextStyle(
                      color: Colors.black,
                    ),
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
                          : bugun.difference(far).inDays == 0
                              ? Text("Bugün")
                              : (bugun
                                          .difference(far)
                                          .inDays
                                          .toString()
                                          .substring(0, 1) !=
                                      "-")
                                  ? Text(
                                      " -${bugun.difference(far).inDays} gün",
                                      style: Load.font(2))
                                  : Text(
                                      " ${-1 * bugun.difference(far).inDays} gün",
                                      style: Load.font(4))
                    ],
                  ),
                ),
              ));
        },
        //  ),
      );
    });
  }
}

class Alisge extends StatefulWidget {
  final bool isara;
  Alisge(this.isara);

  @override
  _AlisgeState createState() => _AlisgeState();
}

class _AlisgeState extends State<Alisge> with AutomaticKeepAliveClientMixin {
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
    /*APIServices.callstp(DateTime(2005), DateTime(2035)).then((value) {
      paragec = value.where((i) => i.tur == 1 && i.durum == 0).toList();
      print(paragec[0].alinan.toString());
    });*/
    /* APIServices.odefatalkapali().then((value) {
      setState(() {
        print(value.toString());
        listdtodegecik = value;
        _isloading = false;
      });
    });*/
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<Alisgecontroller>().isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return ListView.builder(
        //separatorBuilder: (context, index) => Divider(
        //    color: Colors.black,  ),
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.isara == true
            ? lisaraodegecik.length
            : Get.find<Alisgecontroller>().listdtofatta.length,
        itemBuilder: (context, index) {
          Dtofatode dt = widget.isara == true
              ? lisaraodegecik[index]
              : Get.find<Alisgecontroller>().listdtofatta[index];
          dt.duztarih = DateTime.tryParse(dt.duztarih) == null
              ? dt.duztarih
              : DateFormat.yMMMEd('tr_TR').format(DateTime.parse(dt.duztarih));
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
                      MaterialPageRoute(builder: (context) => Alisfatayrin(dt)),
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
                          : bugun.difference(far).inDays == 0
                              ? Text("Bugün")
                              : (bugun
                                          .difference(far)
                                          .inDays
                                          .toString()
                                          .substring(0, 1) !=
                                      "-")
                                  ? Text(
                                      " -${bugun.difference(far).inDays} gün",
                                      style: Load.font(2))
                                  : Text(
                                      " ${-1 * bugun.difference(far).inDays} gün",
                                      style: Load.font(4))
                    ],
                  ),
                ),
              ));
        },
      );
    });
  }
}

class Tabbilgiodewdg extends StatelessWidget {
  final Dtofatode dt;
  final List<Dtourunhareket> lisuh;
  final Size size;
  Tabbilgiodewdg(this.dt, this.lisuh, this.size);
  //Alisfatayrinticontroller _sfcontroller;

  @override
  Widget build(BuildContext context) {
    //  _sfcontroller = Get.put(Alisfatayrinticontroller(dt));
    //   var saat1 = DateFormat.jm('tr_TR').format(DateTime.parse(dt.odenecektar));
    var yil1 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(
        dt.odenecektar == "null" ? DateTime(2000).toString() : dt.odenecektar));
    var u = yil1; // + "-" + saat1;
    var g = dt.odenecektar == "null" ? "s" : u;
    return //SingleChildScrollView(
        //  physics: ScrollPhysics(),
        // child:
        Column(
      children: [
        Card(
            elevation: 0,
            margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
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
                  child: Icon(FontAwesomeIcons.exclamation, color: Colors.blue),
                ),
                title: Text.rich(
                  TextSpan(
                    //   style: TextStyle(
                    //       fontSize: 17,
                    //       ),
                    children: [
                      TextSpan(
                        style: Load.font(2),
                        text: "Ödeme Tarihi  ",
                      ),
                      TextSpan(
                        style: Load.font(1),
                        text: g,
                      )
                    ],
                  ),
                ),
              ),
            )),
        Card(
            elevation: 0,
            margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
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
                  child: Icon(FontAwesomeIcons.calendar, color: Colors.blue),
                ),
                title: Text.rich(
                  TextSpan(
                    //   style: TextStyle(
                    //       fontSize: 17,
                    //       ),
                    children: [
                      TextSpan(
                        style: Load.font(1),
                        text: dt.duztarih,
                      )
                    ],
                  ),
                ),
              ),
            )),
        Expanded(
          child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: lisuh.length,
            itemBuilder: (context, index) {
              Dtourunhareket urha = lisuh[index];
              num topl = urha.brfiyat + ((urha.brfiyat * urha.vergi) / 100);
              return Card(
                  elevation: 0,
                  margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                      /* leading: Container(
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
                      child: Icon(Icons.upload_file, color: Colors.blue),
                    ),*/
                      title: Text.rich(
                        TextSpan(
                          //   style: TextStyle(
                          //       fontSize: 17,
                          //       ),
                          children: [
                            TextSpan(
                              style: TextStyle(color: Colors.black87),
                              text: urha.ad,
                            ),
                            TextSpan(
                              // style: TextStyle(color: Colors.black87),
                              text: " x ",
                            ),
                            TextSpan(
                              style: Load.font(1),
                              text: urha.miktar.toString(),
                            )
                          ],
                        ),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Load.numfor.format(topl.round()), //    "${topl}",
                            style: Load.font(0),
                          ),
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ),
        //  Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: (size.width) / 5,
              height: size.height / 4,
              color: Colors.grey[200],
            ),
            Container(
              width: (4 * size.width) / 5,
              height: size.height / 4,
              //     color: Colors.green,
              child: ListView(
                children: [
                  Divider(),
                  Row(
                    children: [
                      Text(
                        "Ara Toplam",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(Load.numfor.format(dt.aratop.round()),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Icon(FontAwesomeIcons.liraSign, size: 18),
                        ],
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text("Toplam Kdv ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      Row(
                        children: [
                          Text(Load.numfor.format(dt.kdv.round()),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 18,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text("Genel Toplam",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                              Load.numfor.format(dt.geneltoplam
                                  .round()), //dt.geneltoplam.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 18,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ],
                  ),
                  //   Spacer(),
                  Divider(),
                  Row(
                    children: [
                      Text("Kalan",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                              Load.numfor.format(
                                  dt.geneltoplam - dt.odendimik.round()),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 18,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class Tabodemewdg extends StatelessWidget {
  final List<Dtoodeharfat> dt;
  Tabodemewdg(this.dt);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: dt.length,
      itemBuilder: (context, index) {
        Dtoodeharfat th = dt[index];
        return Card(
                elevation: 0,
                margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                    ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
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
                      child:
                          Icon(FontAwesomeIcons.arrowDown, color: Colors.red),
                    ),
                    title: Text(
                      "${th.kasaad}",
                      style: Load.font(0),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Text(
                      " ${th.odenmistar}",
                      style: Load.font(1),
                    ),
                    trailing: Text(
                      Load.numfor.format(
                          th.odendimik.round()), //     "${th.odendimik}",
                      style: Load.font(0),
                    ),
                  ),
                ))
            /*Container(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.download_done_outlined,
                  color: Colors.grey,
                ),
                title: Text('${th.kasaid} kasa ad'),
                subtitle: Text(
                  "${th.tediltar}",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  "${th.alinmismik} TL",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: Colors.black,
              )
            ],
          ),
        )*/
            ;
      },
    );
    // );
  }
}
