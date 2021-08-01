import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:muhmobil/controller/gdhaftacontroller.dart';
import 'package:muhmobil/controller/gdnuguncontroller.dart';
import 'package:muhmobil/controller/kasacontroller.dart';
import 'package:muhmobil/controller/satisfatcontroller.dart';
import 'package:muhmobil/model/gunceldurummod.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:flutter/material.dart';
import 'package:muhmobil/ui/giderler.dart';
import 'package:muhmobil/ui/home.dart';
import 'package:muhmobil/ui/kasalist.dart';
import 'package:muhmobil/ui/loginui.dart';
import 'package:muhmobil/ui/satislar.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alisfatcontroller.dart';

class Gunceldurumcontroller extends GetxController {
  var isLoading = true.obs;
  DateTime bugun;
  DateTime buay;
  DateTime buayson;
  var gecicisat = List<Gunceldurummod>().obs;
  var gecicigider = List<Gunceldurummod>().obs;
  num bakiye = 0.obs();

  @override
  void onInit() {
    fetchfinaltodo();
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      bugun = DateTime.now();
      bugun = DateTime(bugun.year, bugun.month, bugun.day);
      buay = DateTime(bugun.year, bugun.month, 1);
      buayson = (bugun.month < 12)
          ? new DateTime(bugun.year, bugun.month + 1, 0)
          : new DateTime(bugun.year + 1, 1, 0);
      var todos = await APIServices.callstp(buay, buayson);
      num x = await APIServices.kasabakiye();
      print(x.toString());
      print(bakiye.toString());
      bakiye = x;
      print(bakiye.toString());
      if (todos != null) {
        print(todos.length.toString());
        List v = todos.where((i) => i.tur == 1).toList();
        print(v.length.toString());
        v.length == 0
            ? gecicisat.value = [Gunceldurummod(0, 0, 0, 0, 1)]
            : gecicisat.value = todos.where((i) => i.tur == 1).toList();

        List y = todos.where((i) => i.tur == 0).toList();
        print(y.length.toString());
        y.length == 0
            ? gecicigider.value = [Gunceldurummod(0, 0, 0, 0, 0)]
            : gecicigider.value = todos.where((i) => i.tur == 0).toList();
      } else {}
    } finally {
      isLoading(false);
    }
  }

  void bakiyedeg(num deg) async {
    isLoading(true);

    try {
      print(bakiye.toString());
      bakiye = bakiye + deg;
      print(bakiye.toString());
    } finally {
      isLoading(false);
    }
  }

  void aysatguncelle(num deg) async {
    isLoading(true);

    try {
      gecicisat[0].toplammiktar = gecicisat[0].toplammiktar + deg;
      gecicisat[0].fatsayisi = gecicisat[0].fatsayisi + 1;
    } finally {
      isLoading(false);
    }
  }

  void ayalisguncelle(num deg) async {
    isLoading(true);

    try {
      gecicigider[0].toplammiktar = gecicigider[0].toplammiktar + deg;
      gecicigider[0].fatsayisi = gecicigider[0].fatsayisi + 1;
    } finally {
      isLoading(false);
    }
  }
}

class Gunceldur extends StatefulWidget {
  @override
  _GunceldurState createState() => _GunceldurState();
}

class _GunceldurState extends State<Gunceldur> with TickerProviderStateMixin {
  num kasabakiye = 0;
  TabController _tabController;
  DateTime bugun;
  bool _isloading = true;
  List<Gunceldurummod> gunceld = [];
  DateTime buay;
  DateTime buhafta;
  DateTime buaysonu;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);

    //   _tabController.animateTo(1);
  }

  Future buildcikis(BuildContext context, Size size, int tahsflag) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: size.height / 6,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                    child: Text(
                  "deneme@gmail.com",
                  style: Load.font(8),
                )),
                Divider(),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        var islog = sp.setBool("islogin", false);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Loginui()),
                            (Route<dynamic> route) => false);
                      },
                      child: Text("Çıkış", style: Load.font(3)),
                    ),
                    Divider(),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("İptal", style: Load.font(2))),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[100], elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Buse Tekstil",
                style: Load.font(0),
              ),
            ],
          ),
        ),
        bottom: TabBar(
          //  isScrollable: true,
          unselectedLabelColor: Colors.grey[300],
          labelColor: Colors.black,
          controller: _tabController,
          tabs: <Widget>[
            Container(
              width: size.width / 3,
              child: Tab(
                text: "BU AY",
              ),
            ),
            Container(
              width: size.width / 3,
              child: Tab(
                text: "BU HAFTA",
              ),
            ),
            Container(
              width: size.width / 3,
              child: Tab(
                text: "BUGÜN",
              ),
            ),
          ],
        ),
        //   title: Text("Satışlar"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.tealAccent,
            ),
            onPressed: () {
              buildcikis(context, size, 0);
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            //  Align(alignment: Alignment.centerLeft, child: Text("Nisan 2021")),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Obx(() {
                    if (Get.find<Gunceldurumcontroller>().isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Tabbilgiwdg1(
                        Get.find<Gunceldurumcontroller>().gecicisat,
                        Get.find<Gunceldurumcontroller>().gecicigider,
                        Get.find<Gunceldurumcontroller>().bakiye);
                  }),
                  Obx(() {
                    if (Get.find<Gdhaftacontroller>().isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Tabbuhafta(Get.find<Gdhaftacontroller>().gecicisat,
                        Get.find<Gdhaftacontroller>().bakiye);
                  }),
                  Obx(() {
                    if (Get.find<Gdbuguncontroller>().isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Tabbugun(Get.find<Gdbuguncontroller>().gecicisat,
                        Get.find<Gdbuguncontroller>().bakiye);
                  }),
                ],
              ),
              //    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<Gunceldurumcontroller>().isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        children: [
          Text(Get.find<Gunceldurumcontroller>()
              .gecicisat[0]
              .toplammiktar
              .toString()),
          Text(Get.find<Gunceldurumcontroller>()
              .gecicigider[0]
              .odenen
              .toString()),
          Text(Get.find<Gunceldurumcontroller>().gecicisat.length.toString()),
          Text(Get.find<Gunceldurumcontroller>().gecicigider.length.toString()),
          Buildsatbil(
              gecicisat: Get.find<Gunceldurumcontroller>().gecicisat,
              context: context)
        ],
      );
    });
  }
}

class Buildsatbil extends StatelessWidget {
  Buildsatbil({
    Key key,
    @required this.gecicisat,
    @required this.context,
  }) : super(key: key);

  final List<Gunceldurummod> gecicisat;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    print("13");
    return Container(
      color: Colors.grey[100],
      child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Card(
              elevation: 0,
              margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                  ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100]), //Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  onTap: () {
                    /*    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Satisla()),
                    );*/
                    HomeState.onItemTapped(1);
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.arrowDown,
                      size: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                  title: Text("SATIŞLAR", style: Load.font(3)),
                  subtitle: Text(gecicisat.length == 0
                      ? "0 FATURA"
                      : "${gecicisat[0].fatsayisi} FATURA"),

                  //  subtitle: ,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        gecicisat.length == 0
                            ? "0"
                            : Load.numfor.format((gecicisat[0].toplammiktar
                                //+ gecicisat[1].toplammiktar
                                )
                                .round()), //"${gecicisat[0].toplammiktar + gecicisat[1].toplammiktar}",
                        style: Load.font(3),
                      ),
                      Icon(FontAwesomeIcons.liraSign,
                          size: 12, color: Colors.blue)
                    ],
                  ),
                ),
              ))),
    );
  }
}

class Tabbilgiwdg1 extends StatefulWidget {
  final List<Gunceldurummod> gecicisat;
  final List<Gunceldurummod> gecicigider;
  final num bak;
  Tabbilgiwdg1(this.gecicisat, this.gecicigider, this.bak);

  @override
  _Tabbilgiwdg1State createState() => _Tabbilgiwdg1State();
}

class _Tabbilgiwdg1State extends State<Tabbilgiwdg1>
    with AutomaticKeepAliveClientMixin {
  List<Gunceldurummod> gecicisat1 = [];
  List<Gunceldurummod> gecicigider1 = [];
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.guncel.toString());
    /*  gecicisat = widget.guncel.length == 0
        ? []
        : widget.guncel.where((i) => i.tur == 1).toList();
    gecicigider = widget.guncel.length == 0
        ? []
        : widget.guncel.where((i) => i.tur == 0).toList();*/
    gecicisat1 = Get.find<Gunceldurumcontroller>().gecicisat;
    gecicigider1 = Get.find<Gunceldurumcontroller>().gecicigider;
  }

  @override
  Widget build(BuildContext context) {
    print("12");
    gecicisat1 = Get.find<Gunceldurumcontroller>().gecicisat;
    gecicigider1 = Get.find<Gunceldurumcontroller>().gecicigider;

    return Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 5,
      ),
      Obx(() {
        if (Get.find<Gunceldurumcontroller>().isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Buildsatbilgi(
            gecicisat: Get.find<Gunceldurumcontroller>().gecicisat,
            context: context);
      }),

      Obx(() {
        if (Get.find<Gunceldurumcontroller>().isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Buildgiderbilgi(
            gecicigider: Get.find<Gunceldurumcontroller>().gecicigider,
            context: context);
      }),
      Obx(() {
        if (Get.find<Gunceldurumcontroller>().isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Buildbakiye(
            bak: Get.find<Gunceldurumcontroller>().bakiye, context: context);
      }),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info,
              color: Colors.grey,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Düzenleme tarihi baz alınmıştır",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
      // buildsatiscont(context),
    ]);
    // );
  }
}

class Tabbuhafta extends StatefulWidget {
  final List<Gunceldurummod> guncel;
  final num bak;
  Tabbuhafta(this.guncel, this.bak);

  @override
  _TabbuhaftaState createState() => _TabbuhaftaState();
}

class _TabbuhaftaState extends State<Tabbuhafta>
    with AutomaticKeepAliveClientMixin {
  List<Gunceldurummod> gecicisat = [];
  List<Gunceldurummod> gecicigider = [];
  DateTime bugun;
  DateTime buhaftabas;
  DateTime buhaftason;
  bool _isloading = true;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 5,
      ),
      Buildsatbilgi(
          gecicisat: Get.find<Gdhaftacontroller>().gecicisat, context: context),
      Buildgiderbilgi(
          gecicigider: Get.find<Gdhaftacontroller>().gecicigider,
          context: context),
      Obx(() {
        if (Get.find<Gunceldurumcontroller>().isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Buildbakiye(
            bak: Get.find<Gunceldurumcontroller>().bakiye, context: context);
      }),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info,
              color: Colors.grey,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Düzenleme tarihi baz alınmıştır",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
      // buildsatiscont(context),
    ]);

    // );
  }
}

class Tabbugun extends StatefulWidget {
  final List<Gunceldurummod> guncel;
  final num bak;
  Tabbugun(this.guncel, this.bak);

  @override
  _TabbugunState createState() => _TabbugunState();
}

class _TabbugunState extends State<Tabbugun>
    with AutomaticKeepAliveClientMixin {
  List<Gunceldurummod> gecicisat = [];
  List<Gunceldurummod> gecicigider = [];
  DateTime bugun;
  DateTime bugece;
  DateTime busabah;
  bool _isloading = true;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 5,
      ),
      Buildsatbilgi(
          gecicisat: Get.find<Gdbuguncontroller>().gecicisat, context: context),
      Buildgiderbilgi(
          gecicigider: Get.find<Gdbuguncontroller>().gecicigider,
          context: context),
      Obx(() {
        if (Get.find<Gunceldurumcontroller>().isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Buildbakiye(
            bak: Get.find<Gunceldurumcontroller>().bakiye, context: context);
      }),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info,
              color: Colors.grey,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Düzenleme tarihi baz alınmıştır",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
      // buildsatiscont(context),
    ]);

    // );
  }
}

class Buildgiderbilgi extends StatelessWidget {
  Buildgiderbilgi({
    Key key,
    @required this.gecicigider,
    @required this.context,
  }) : super(key: key);

  final List<Gunceldurummod> gecicigider;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    print("14");
    return Container(
      color: Colors.grey[100],
      child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Card(
              elevation: 0,
              margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                  ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100]), //Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  onTap: () {
                    /*    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Giderle()),
                    );*/
                    HomeState.onItemTapped(2);
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.arrowUp,
                      size: 18,
                      color: Colors.red,
                    ),
                  ),
                  title: Text("GİDERLER", style: Load.font(2)),
                  subtitle: Text(gecicigider.length == 0
                      ? "0 FATURA"
                      : "${gecicigider[0].fatsayisi} FATURA"),

                  //  subtitle: ,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          gecicigider.length == 0
                              ? "0"
                              : Load.numfor.format((gecicigider[0].toplammiktar
                                  //+      gecicigider[1].toplammiktar
                                  )
                                  .round()), //"${gecicigider[0].toplammiktar + gecicigider[1].toplammiktar}",
                          style: Load.font(2)),
                      Icon(FontAwesomeIcons.liraSign,
                          size: 12, color: Colors.red)
                    ],
                  ),
                ),
              ))),
    );
  }
}

class Buildsatbilgi extends StatelessWidget {
  Buildsatbilgi({
    Key key,
    @required this.gecicisat,
    @required this.context,
  }) : super(key: key);

  final List<Gunceldurummod> gecicisat;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    print("13");
    return Container(
      color: Colors.grey[100],
      child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Card(
              elevation: 0,
              margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                  ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100]), //Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  onTap: () {
                    /*  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Satisla()),
                    );*/
                    HomeState.onItemTapped(1);
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.arrowDown,
                      size: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                  title: Text("SATIŞLAR", style: Load.font(3)),
                  subtitle: Text(gecicisat.length == 0
                      ? "0 FATURA"
                      : "${gecicisat[0].fatsayisi} FATURA"),

                  //  subtitle: ,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        gecicisat.length == 0
                            ? "0"
                            : Load.numfor.format((gecicisat[0].toplammiktar
                                //+gecicisat[1].toplammiktar
                                )
                                .round()), //"${gecicisat[0].toplammiktar + gecicisat[1].toplammiktar}",
                        style: Load.font(3),
                      ),
                      Icon(FontAwesomeIcons.liraSign,
                          size: 12, color: Colors.blue)
                    ],
                  ),
                ),
              ))),
    );
  }
}

class Buildbakiye extends StatelessWidget {
  const Buildbakiye({
    Key key,
    @required this.context,
    @required this.bak,
  }) : super(key: key);

  final BuildContext context;

  final num bak;

  @override
  Widget build(BuildContext context) {
    print("15");
    return Container(
      color: Colors.grey[100],
      child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Card(
              elevation: 0,
              margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                  ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100]), //Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  onTap: () {
                    /*     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Kasalistesi()),
                    );*/
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.moneyBill,
                      size: 18,
                      color: Colors.green,
                    ),
                  ),
                  title: Text("GÜNCEL BAKİYE",
                      style: TextStyle(color: Colors.green)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() {
                        if (Get.find<Gunceldurumcontroller>().isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Text(
                            Get.find<Gunceldurumcontroller>().bakiye.toString(),
                            style: TextStyle(color: Colors.green));
                      }),
                      Icon(FontAwesomeIcons.liraSign,
                          size: 12, color: Colors.green)
                    ],
                  ),
                ),
              ))),
    );
  }
}
