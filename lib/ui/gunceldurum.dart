import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/gunceldurummod.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/kasalist.dart';
import 'package:muhmobil/ui/loginui.dart';
import 'package:muhmobil/ui/satislar.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:muhmobil/utils/createpdf.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'giderler.dart';

class Gunceldurum extends StatefulWidget {
  @override
  _GunceldurumState createState() => _GunceldurumState();
}

String _scanBarcode = 'Unknown';

class _GunceldurumState extends State<Gunceldurum>
    with TickerProviderStateMixin {
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
    bugun = DateTime.now();
    bugun = DateTime(bugun.year, bugun.month, bugun.day);
    buay = DateTime(bugun.year, bugun.month, 1);
    buaysonu = (bugun.month < 12)
        ? new DateTime(bugun.year, bugun.month + 1, 0)
        : new DateTime(bugun.year + 1, 1, 0);
    //buaysonu=DateTime(bugun.year, bugun.month, 30);
    buhafta = DateTime(bugun.year, bugun.month, bugun.day - bugun.weekday + 1);
    Future.wait([
      APIServices.callstp(buay, buaysonu),
      APIServices.kasabakiye(),
    ]).then((value) {
      setState(() {
        print("bb");
        print(value[0].toString());
        gunceld = value[0];
        print(gunceld.length.toString());
        kasabakiye = value[1];
        _isloading = false;
      });
    });

    //   _tabController.animateTo(1);
  }

  /*Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }*/

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
        appBar: AppBar(
          backgroundColor: Colors.grey[100], elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                 //   var z = await izlemepdf();
                    //var sharePdf = await ekstrepdf();
                    //  await Share.file(
                    //      'PDF Document',
                    //      'project.pdf',
                    //        sharePdf,
                    //          '*/*',
                    //    );
                    //PDFViewer(
                     // document: z,
                      //zoomSteps: 1,
                    //);
                  },
                  child: Text(
                    "Buse Tekstil",
                    style: Load.font(0),
                  ),
                )
              ],
            ),
          ),
          bottom: TabBar(
            //  isScrollable: true,
            unselectedLabelColor: Colors.grey[300],
            labelColor: Colors.black,
            controller: _tabController,
            //indicator: UnderlineTabIndicator(
            //    borderSide: BorderSide(color: Colors.white, width: 8.0),
            //      insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0), ),
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
        body: LoadingOverlay(
          isLoading: _isloading,
          opacity: Load.opacit,
          progressIndicator: Load.prog,
          child: Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                //  Align(alignment: Alignment.centerLeft, child: Text("Nisan 2021")),
                Expanded(
                  // child: Container(
                  //     color: Colors.grey[300],
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      Tabbilgiwdg(gunceld, kasabakiye),
                      Tabbuhafta(gunceld, kasabakiye),
                      Tabbugun(gunceld, kasabakiye),
                    ],
                  ),
                  //    ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Tabbilgiwdg extends StatefulWidget {
  final List<Gunceldurummod> guncel;
  final num bak;
  Tabbilgiwdg(this.guncel, this.bak);

  @override
  _TabbilgiwdgState createState() => _TabbilgiwdgState();
}

class _TabbilgiwdgState extends State<Tabbilgiwdg>
    with AutomaticKeepAliveClientMixin {
  List<Gunceldurummod> gecicisat = [];
  List<Gunceldurummod> gecicigider = [];
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ccv");
    print(widget.guncel.length.toString());
    gecicisat = widget.guncel.length == 0
        ? [Gunceldurummod(22, 2, 2, 2, 1)]
        : widget.guncel.where((i) => i.tur == 1).toList();
    // print(gecicisat[0].fatsayisi);
    gecicigider = widget.guncel.length == 0
        ? [Gunceldurummod(22, 2, 2, 2, 1)]
        : widget.guncel.where((i) => i.tur == 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    gecicisat = widget.guncel.length == 0
        ? [Gunceldurummod(22, 2, 2, 2, 1)]
        : widget.guncel.where((i) => i.tur == 1).toList();
    // print(gecicisat[0].fatsayisi);
    gecicigider = widget.guncel.length == 0
        ? [Gunceldurummod(22, 2, 2, 2, 1)]
        : widget.guncel.where((i) => i.tur == 0).toList();
    return Column(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 5,
      ),
      Buildsatbilgi(gecicisat: gecicisat, context: context),
      Buildgiderbilgi(gecicigider: gecicigider, context: context),
      Buildbakiye(context: context, bak: widget.bak),
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
    bugun = DateTime.now();
    bugun = DateTime(bugun.year, bugun.month, bugun.day);
    buhaftabas =
        DateTime(bugun.year, bugun.month, bugun.day - bugun.weekday + 1);
    buhaftason =
        bugun.add(Duration(days: DateTime.daysPerWeek - bugun.weekday));
    print("haftadaa");
    APIServices.callstp(buhaftabas, buhaftason).then((value) {
      setState(() {
        gecicisat = widget.guncel.length == 0
            ? [Gunceldurummod(22, 2, 2, 2, 1)]
            : value.where((i) => i.tur == 1).toList();
        gecicigider = widget.guncel.length == 0
            ? [Gunceldurummod(22, 2, 2, 2, 1)]
            : value.where((i) => i.tur == 0).toList();
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isloading,
      opacity: Load.opacit,
      progressIndicator: Load.prog,
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 5,
        ),
        Buildsatbilgi(gecicisat: gecicisat, context: context),
        Buildgiderbilgi(gecicigider: gecicigider, context: context),
        Buildbakiye(
          context: context,
          bak: widget.bak,
        ),
        // buildsatiscont(context),
      ]),
    );
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
    bugun = DateTime.now();
    bugun = DateTime(bugun.year, bugun.month, bugun.day);
    bugece = DateTime(bugun.year, bugun.month, bugun.day + 1);
    busabah = DateTime(bugun.year, bugun.month, bugun.day, 0, 0, 0);
    print(busabah.toString());
    print(bugece.toString());
    APIServices.callstp(busabah, bugece).then((value) {
      setState(() {
        gecicisat = widget.guncel.length == 0
            ? [Gunceldurummod(22, 2, 2, 2, 1)]
            : value.where((i) => i.tur == 1).toList();
        gecicigider = widget.guncel.length == 0
            ? [Gunceldurummod(22, 2, 2, 2, 1)]
            : value.where((i) => i.tur == 0).toList();
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isloading,
      opacity: Load.opacit,
      progressIndicator: Load.prog,
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 5,
        ),
        Buildsatbilgi(gecicisat: gecicisat, context: context),
        Buildgiderbilgi(gecicigider: gecicigider, context: context),
        Buildbakiye(
          context: context,
          bak: widget.bak,
        ),
        // buildsatiscont(context),
      ]),
    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Giderler()),
                    );
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
                                  //+ gecicigider[1].toplammiktar
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Satislar()),
                    );
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
                                // +    gecicisat[1].toplammiktar
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Kasalist()),
                    );
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
                      Text(
                        "$bak",
                        style: TextStyle(color: Colors.green),
                      ),
                      Icon(FontAwesomeIcons.liraSign,
                          size: 12, color: Colors.green)
                    ],
                  ),
                ),
              ))),
    );
  }
}
