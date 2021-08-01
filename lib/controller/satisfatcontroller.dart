import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/controller/mustliscontroller.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:muhmobil/model/dtotahsharfat.dart';
import 'package:muhmobil/model/dtourunhareket.dart';
import 'package:muhmobil/model/gunceldurummod.dart';
import 'package:muhmobil/model/gunceldurummod1.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/tahsput.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:flutter/material.dart';
import 'package:muhmobil/ui/satisfatayrin.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:intl/intl.dart';

class Satisfatcontroller extends GetxController {
  var isLoading = true.obs;
  var listdtofatta = List<Dtofattahs>().obs;
  var lisbugun = List<Dtofattahs>().obs;
  var lishafta = List<Dtofattahs>().obs;
  var lisay = List<Dtofattahs>().obs;
  var listgd = List<Gunceldurummod1>().obs;
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
      var todos = await APIServices.satfatal();
      if (todos != null) {
        listdtofatta.value = todos;
      }
      var x = await APIServices.verial();
      if (x != null) {
        listgd.value = x.where((i) => i.tur == 1 && i.durum == 0).toList();
        tahsmik = listgd[0].toplammiktar - listgd[0].alinan;
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
      var todos = await APIServices.satisgun();

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
      var todos = await APIServices.satishafta();

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
      var todos = await APIServices.satisay();

      if (todos != null) {
        lisay.value = todos;
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
          if (i.geneltoplam - i.alinmism == deg) {
            i.durum = 1;
          }
          i.alinmism = i.alinmism + deg;
        }
      }
      tahsmik = tahsmik - deg;
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

  void satffattumekleyeni(Dtofattahs yeni) async {
    isLoading(true);

    try {
      listdtofatta.insert(0, yeni);
      tahsmik = tahsmik + yeni.geneltoplam;
    } finally {
      isLoading(false);
    }
  }
}

class Satistahscontroller extends GetxController {
  var isLoading = true.obs;
  var listdtofatta = List<Dtofattahs>().obs;
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
      var todos = await APIServices.satfatalacikfat();
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
          if (i.geneltoplam - i.alinmism == deg) {
            i.durum = 1;
            //sattahsta kaldır
            //   listdtofatta.removeWhere((item) => item.fatid == '001');
            listdtofatta.remove(i);
          }
          i.alinmism = i.alinmism + deg;
        }
      }
      tahsmik = tahsmik - deg;
    } finally {
      isLoading(false);
    }
  }

  void satffattahsekleyeni(Dtofattahs yeni) async {
    isLoading(true);

    try {
      listdtofatta.insert(0, yeni);
    } finally {
      isLoading(false);
    }
  }
}

class Satisgecicontroller extends GetxController {
  var isLoading = true.obs;
  var listdtofatta = List<Dtofattahs>().obs;
  num tahsmik = 0.obs();

  @override
  void onInit() {
    fetchfinaltodo();
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      var todos = await APIServices.tahsgecikmisal();

      if (todos != null) {
        listdtofatta.value = todos;
        print(listdtofatta.length.toString());
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
          if (i.geneltoplam - i.alinmism == deg) {
            i.durum = 1;

            listdtofatta.remove(i);
          }
          i.alinmism = i.alinmism + deg;
        }
      }
      tahsmik = tahsmik - deg;
    } finally {
      isLoading(false);
    }
  }

  void satffatgeciekleyeni(Dtofattahs yeni) async {
    isLoading(true);

    try {
      if (DateTime.tryParse(yeni.vadta).isBefore(DateTime.now())) {
        listdtofatta.insert(0, yeni);
      }
    } finally {
      isLoading(false);
    }
  }
}

class Tabbilgiwdg extends StatelessWidget {
  final Dtofattahs dt;
  final List<Dtourunhareket> lisuh;
  final Size size;
  Tabbilgiwdg(this.dt, this.lisuh, this.size);
  // Satisfatayrinticontroller _sfcontroller;

  @override
  Widget build(BuildContext context) {
    print("asd");
    print(dt.alinmism.toString());
    // _sfcontroller = Get.put(Satisfatayrinticontroller(dt));
    // var saat1 = DateFormat.jm('tr_TR').format(DateTime.parse(dt.vadta));
    var yil1 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(
        dt.vadta == "null" ? DateTime(2000).toString() : dt.vadta));
    var u = yil1; //+ "-" + saat1;
    var g = dt.vadta == "null" ? "s" : u;
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
                        text: "Tahsilat Tarihi  ",
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

                      title: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              style: Load.font(0),
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
                            Load.numfor.format(topl
                                .round()), //          "${topl}", //   " ${dt.geneltoplam - dt.alinmism}",
                            style: Load.font(0),
                          ),
                          Icon(FontAwesomeIcons.liraSign, size: 12)
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
                          Icon(FontAwesomeIcons.liraSign, size: 12)
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
                          Icon(FontAwesomeIcons.liraSign, size: 12)
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
                          Text(Load.numfor.format(dt.geneltoplam.round()),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          Icon(FontAwesomeIcons.liraSign, size: 12)
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
                              Load.numfor
                                  .format(dt.geneltoplam - dt.alinmism.round()),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                          Icon(FontAwesomeIcons.liraSign, size: 12),
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
    // );
  }
}

class Tabtahsilatwdg extends StatelessWidget {
  final List<Dtotahsharfat> dt;
  Tabtahsilatwdg(this.dt);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: dt.length,
      itemBuilder: (context, index) {
        Dtotahsharfat th = dt[index];
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
                          right: new BorderSide(width: 1.0, color: Colors.grey),
                          left: new BorderSide(width: 1.0, color: Colors.grey),
                          top: new BorderSide(width: 1.0, color: Colors.grey),
                          bottom:
                              new BorderSide(width: 1.0, color: Colors.grey))),
                  child: Icon(FontAwesomeIcons.fileAlt, color: Colors.blue),
                ),
                title: Text(
                  "${th.kasaad}",
                  style: Load.font(0),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Text(
                  " ${th.tediltar}",
                  style: Load.font(1),
                ),
                trailing: Text(
                  Load.numfor
                      .format(th.alinmismik.round()), //     "${th.alinmismik}",
                  style: Load.font(0),
                ),
              ),
            ));
      },
    );
    // );
  }
}

class Satisla extends StatefulWidget {
  @override
  _SatislaState createState() => _SatislaState();
}

class _SatislaState extends State<Satisla> with TickerProviderStateMixin {
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
  // final Satisfatcontroller _controller = Get.put(Satisfatcontroller());
  // final Satistahscontroller _tahscontroller = Get.put(Satistahscontroller());

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
    _tabController.dispose();
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
            /*      .then((value) {
              setState(() {
                duztar = "Tümü";
              });
            });*/
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() {
                                if (Get.find<Satisfatcontroller>()
                                    .isLoading
                                    .value) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Text(
                                    Load.numfor
                                        .format(Get.find<Satisfatcontroller>()
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
                      : InkWell(onTap: () {
                          buildduztarModBottomSheet(context, size);
                        }, child: Obx(() {
                          if (Get.find<Satisfatcontroller>().isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Center(
                              child: Text(
                                  Get.find<Satisfatcontroller>().sira == 0
                                      ? "Tümü"
                                      : Get.find<Satisfatcontroller>().sira == 1
                                          ? "Bugün"
                                          : Get.find<Satisfatcontroller>()
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
                    if (Get.find<Satisfatcontroller>().isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Get.find<Satisfatcontroller>().sira == 0
                        ? Satistu(Get.find<Satisfatcontroller>().listdtofatta,
                            lisara, isara)
                        : Get.find<Satisfatcontroller>().sira == 1
                            ? Satistu(Get.find<Satisfatcontroller>().lisbugun,
                                lisara, isara)
                            : Get.find<Satisfatcontroller>().sira == 2
                                ? Satistu(
                                    Get.find<Satisfatcontroller>().lishafta,
                                    lisara,
                                    isara)
                                : Satistu(Get.find<Satisfatcontroller>().lisay,
                                    lisara, isara);
                  }),
                  Satistahsed(isara),
                  Satistahsge(isara),
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
                          Get.find<Satisfatcontroller>()
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
                          Get.find<Satisfatcontroller>().bugunfat().then((v) {
                            setState(() {
                              Navigator.of(context).pop();
                              //    lis = value;
                              isfiltre = true;
                              //  duztar = "BUGÜN";
                            });
                          });
                        },
                        child: Text("Bugün", style: Load.font(4))),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Get.find<Satisfatcontroller>().haftafat().then((v) {
                            setState(() {
                              Navigator.of(context).pop();
                              //    lis = value;
                              isfiltre = true;
                              //  duztar = "BUGÜN";
                            });
                          });
                        },
                        child: Text("Bu hafta", style: Load.font(4))),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Get.find<Satisfatcontroller>().ayfat().then((v) {
                            setState(() {
                              Navigator.of(context).pop();
                              //    lis = value;
                              isfiltre = true;
                              //  duztar = "BUGÜN";
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

class Satistu extends StatefulWidget {
  final List<Dtofattahs> listdt;
  final List<Dtofattahs> lisara;
  final bool isara;
  Satistu(this.listdt, this.lisara, this.isara);

  @override
  _SatistuState createState() => _SatistuState();
}

class _SatistuState extends State<Satistu> with AutomaticKeepAliveClientMixin {
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
        dt.duztarih = DateTime.tryParse(dt.duztarih) == null
            ? dt.duztarih
            : DateFormat.yMMMEd('tr_TR').format(DateTime.parse(dt.duztarih));
        DateTime far;
        if (dt.vadta != "null") {
          print("yyy");
          //     print(dt.vadta);
          print("ooo");
          //       print(dt.vadta);
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
                    MaterialPageRoute(builder: (context) => Satisfatayrin(dt)),
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
    //);
  }
}

class Satistahsed extends StatefulWidget {
  final bool isara;
  Satistahsed(this.isara);

  @override
  _SatistahsedState createState() => _SatistahsedState();
}

class _SatistahsedState extends State<Satistahsed>
    with AutomaticKeepAliveClientMixin {
  List<Dtofattahs> listdttahsedil = [];
  List<Dtofattahs> lisaratahsedil = [];
  List<Gunceldurummod> paratahs = [];
  bool _isloading = true;
  DateTime bugun;
  //Satistahscontroller _controller = Satistahscontroller();
  @override
  void initState() {
    super.initState();
    bugun = DateTime.now();
    bugun = DateTime(bugun.year, bugun.month, bugun.day);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print("tahs");
    return Obx(() {
      if (Get.find<Satistahscontroller>().isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.isara == true
            ? lisaratahsedil.length
            : Get.find<Satistahscontroller>().listdtofatta.length,
        itemBuilder: (context, index) {
          Dtofattahs dt = widget.isara == true
              ? lisaratahsedil[index]
              : Get.find<Satistahscontroller>().listdtofatta[index];
          dt.duztarih = DateTime.tryParse(dt.duztarih) == null
              ? dt.duztarih
              : DateFormat.yMMMEd('tr_TR').format(DateTime.parse(dt.duztarih));
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
                          builder: (context) => Satisfatayrin(dt)),
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

class Satistahsge extends StatefulWidget {
  final bool isara;
  Satistahsge(this.isara);

  @override
  _SatistahsgeState createState() => _SatistahsgeState();
}

class _SatistahsgeState extends State<Satistahsge>
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
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print("geci");
    return Obx(() {
      if (Get.find<Satisgecicontroller>().isLoading.value) {
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
            ? lisaratahsgecik.length
            : Get.find<Satisgecicontroller>().listdtofatta.length,
        itemBuilder: (context, index) {
          Dtofattahs dt = widget.isara == true
              ? lisaratahsgecik[index]
              : Get.find<Satisgecicontroller>().listdtofatta[index];
          dt.duztarih = DateTime.tryParse(dt.duztarih) == null
              ? dt.duztarih
              : DateFormat.yMMMEd('tr_TR').format(DateTime.parse(dt.duztarih));
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
                          builder: (context) => Satisfatayrin(dt)),
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
