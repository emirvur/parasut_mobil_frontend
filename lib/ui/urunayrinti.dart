import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:muhmobil/model/dtokasahar.dart';
import 'package:muhmobil/model/dtostokdetay.dart';
import 'package:muhmobil/model/dtotahsharfat.dart';
import 'package:muhmobil/model/dtourun.dart';
import 'package:muhmobil/model/dtourungecmisi.dart';
import 'package:muhmobil/model/dtourunhareket.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/tahsput.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/utils/load.dart';

class Urunayrinti extends StatefulWidget {
  final Dtourun dt;
  Urunayrinti(this.dt);
  @override
  _UrunayrintiState createState() => _UrunayrintiState();
}

class _UrunayrintiState extends State<Urunayrinti>
    with TickerProviderStateMixin {
  TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  Cari cari;
  bool _isloading = true;
  bool tahsilform = false;
  bool acikfat = false;
  DateTime selectedDate = DateTime.now();
  TextEditingController contar;
  bool isexpa = false;
  List<String> kasalist = [
    "",
    "Satış Faturası oluştur",
    "Alış faturası oluştur"
  ];
  Kasa kas = Kasa(1, "", 1);
  String acikla = "";
  num deger;
  String v;
  TextEditingController conacik;
  TextEditingController condeg;
  List<Dtourungecmisi> lis = [];
  List<Dtostokdetay> satlist = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    contar = TextEditingController();
    conacik = TextEditingController();
    condeg = TextEditingController();

    Future.wait([
      APIServices.urungecmisial(widget.dt.barkodno),
    ]).then((value) {
      setState(() {
        _isloading = false;
        lis = value[0];
        //  lis = value[1];
      });
    });
  }

  @override
  Widget _dropdownbutton(List<Kasa> userlist) {
    return Container(
      padding: EdgeInsets.all(1),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
        //    borderRadius: BorderRadius.all(Radius.circular(15.0) //),
      ),
      child: DropdownButton<Kasa>(
        value: kas ?? Kasa(1, "", 1),
        underline: SizedBox(),
        isExpanded: true,
        icon: Icon(FontAwesomeIcons.arrowDown),
        //  hint: Text("  $dropdownvalue"),
        // value: selectedUser[index],
        onChanged: (Kasa value) {
          kas = value;
          setState(() {});
        },
        items: userlist.map((Kasa user) {
          return DropdownMenuItem<Kasa>(
            value: user,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  user.kasaAd,
                  style: Load.font(0),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Future buildsatisfattahs(BuildContext context, Size size, int tahsflag) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: size.height / 3,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                    child: Text(
                  "Satış Faturası İşlemleri",
                  style: Load.font(1),
                )),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //final dynamic _toolTip = _toolTipKey.currentState;
                        //_toolTip.ensureTooltipVisible();
                      },
                      child: Tooltip(
                        //  key: _toolTipKey,
                        message: "Pek yakında",
                        child: Text(
                          "Yazdır",
                          style: Load.font(3),
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    Text("Düzenle", style: Load.font(3)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        buildtahsekle(context, size);
                      },
                      child: Text("Tahsilat Ekle",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: tahsflag == 1
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("İptal", style: Load.font(2))),
                    Divider()
                  ],
                )
              ],
            ),
          );
        });
  }

  Future buildtahsekle(
    BuildContext context,
    Size size,
  ) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: (4 * size.height) / 10,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
                    Text("Tahsilat Ekle", style: Load.font(4)),
                    Spacer(),
                    Text("fss", style: Load.font(4)),
                    SizedBox(
                      width: 12,
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Icon(FontAwesomeIcons.moneyBill),
                          //     Expanded(child: _dropdownbutton(kasalist)),
                          SizedBox(
                            width: 12,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Icon(FontAwesomeIcons.moneyBill),
                          Expanded(
                              child: TextFormField(
                            decoration: new InputDecoration(hintText: 'Meblağ'),
                            validator: (value) {
                              print("uu");
                              var x = num.tryParse(value);
                              /*   if (x == null) {
                                return "Lütfen geçerli bir sayı giriniz";
                              }
                              if (x >
                                  (widget.dt.geneltoplam -
                                      widget.dt.alinmism)) {
                                return "Kalan miktardan daha büyük bir sayı giremezsiniz";
                              }*/
                              return null;

                              // validation logic
                            },
                            onSaved: (v) {
                              var x = num.tryParse(v);

                              deger = x;
                            },
                          )),
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Icon(FontAwesomeIcons.moneyBill),
                          Expanded(
                              child: TextFormField(
                            decoration:
                                new InputDecoration(hintText: 'Açıklama'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Açıklama kısmı boş olamaz";
                              }
                              return null;
                            },
                            onSaved: (v) {
                              acikla = v;
                            },
                          )),
                          SizedBox(
                            width: 12,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Vazgeç", style: Load.font(1))),
                          SizedBox(
                            width: 12,
                          ),
                          InkWell(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  print("ggg");
                                  _formKey.currentState.save();

                                  Tahsput
                                      tp/*= Tahsput(
                                      widget.dt.tahsid,
                                      deger,
                                      widget.dt.geneltoplam,
                                      selectedDate.toString(),
                                      kas.kasaid,
                                      conacik.text)*/
                                      ;
                                  bool b =
                                      await APIServices.tahsharguncelle(tp);
                                  print(b.toString());
                                  Navigator.of(context).pop();
                                } else {
                                  print("hfgf");
                                }
                              },
                              child:
                                  Text("Tahsilat Ekle", style: Load.font(3))),
                          SizedBox(
                            width: 12,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
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
          backgroundColor: Color.fromRGBO(252, 188, 25, 1),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.thLarge,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.dt.adi,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.comment_bank,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.dt.,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      widget.dt.durum == 1
                          ? Container(
                              padding: EdgeInsets.all(6.0),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                /* border: new Border(
                                      right: new BorderSide(
                                          width: 1.0, color: Colors.grey),
                                      left: new BorderSide(
                                          width: 1.0, color: Colors.grey),
                                      top: new BorderSide(
                                          width: 1.0, color: Colors.grey),
                                      bottom: new BorderSide(
                                          width: 1.0, color: Colors.grey))*/
                              ),
                              child: Text(
                                "Ödendi",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          : Text("")
                    ],
                  ),
                ),*/
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
                        text: "BİLGİLER",
                      ),
                    ),
                    Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "FATURALAR",
                      ),
                    ),
                    Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "HAREKETLER",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //   title: Text("Satışlar"),
          actions: [
            /*Container(
              padding: EdgeInsets.all(6.0),
              decoration: new BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(4),
                /* border: new Border(
                                      right: new BorderSide(
                                          width: 1.0, color: Colors.grey),
                                      left: new BorderSide(
                                          width: 1.0, color: Colors.grey),
                                      top: new BorderSide(
                                          width: 1.0, color: Colors.grey),
                                      bottom: new BorderSide(
                                          width: 1.0, color: Colors.grey))*/
              ),
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Text(
                    "Ekstre",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),*/
            /*   IconButton(
              icon: Icon(
                FontAwesomeIcons.ellipsisV, size: 18,
                // color: Colors.white,
              ),
              onPressed: () {
                buildsatisfattahs(context, size, 1);
              },
            )*/
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
                //  Align(alignment: Alignment.centerLeft, child: Text("Nisan 2021")),
                Expanded(
                  // child: Container(
                  //     color: Colors.grey[300],
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: <Widget>[
                      Tabbilgiurun(widget.dt),
                      Taburunfat(widget.dt.barkodno),
                      Taburunhareket(lis)
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

class Tabbilgiurun extends StatelessWidget {
  final Dtourun dt;

  Tabbilgiurun(
    this.dt,
  );

  @override
  Widget build(BuildContext context) {
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
                      EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      FontAwesomeIcons.th,
                      size: 18,
                    ),
                  ),
                  title: Text("${dt.adet} ${dt.birim}", style: Load.font(4))),
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
                    EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    FontAwesomeIcons.arrowUp,
                    size: 18,
                  ),
                ),
                title: Text("SATIŞ FİYATI", style: Load.font(1)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${Load.numfor.format(dt.verharsat.round())}",
                        style: Load.font(3)),
                    Icon(
                      FontAwesomeIcons.liraSign,
                      size: 12,
                      color: Colors.blue,
                    )
                  ],
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
                      EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      FontAwesomeIcons.arrowDown,
                      size: 18,
                    ),
                  ),
                  title: Text("ALIŞ FİYATI", style: Load.font(1)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${Load.numfor.format(dt.verharal.round())}",
                          style: Load.font(2)),
                      Icon(
                        FontAwesomeIcons.liraSign,
                        size: 12,
                        color: Colors.red,
                      )
                    ],
                  ),
                ))),
        Card(
            elevation: 0,
            margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      FontAwesomeIcons.barcode,
                      size: 18,
                    ),
                  ),
                  title: Text("${dt.barkodno}", style: Load.font(4))),
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
                      EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("KDV", style: Load.font(4)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.percentage,
                        size: 12,
                      ),
                      Text("${Load.numfor.format(dt.kdv.round())}",
                          style: Load.font(4)),
                    ],
                  )),
            )),
      ],
    );
    // );
  }
}

class Taburunfat extends StatefulWidget {
  final String barkod;
  Taburunfat(this.barkod);

  @override
  _TaburunfatState createState() => _TaburunfatState();
}

class _TaburunfatState extends State<Taburunfat>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Dtostokdetay> lis = [];
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    print("ilktee");
    APIServices.stokdetayfatsatis(widget.barkod).then((value) {
      setState(() {
        print(value.toString());
        lis = value;
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
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: lis.length,
        itemBuilder: (context, index) {
          Dtostokdetay th = lis[index];
          return Card(
              elevation: 0,
              margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                  ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  onTap: () {
                    /*    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Satisfatayrinti(th)));*/
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
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
                    th.ad,
                    style: Load.font(0),
                  ),
                  subtitle: Text(
                    th.fatacik,
                    style: Load.font(1),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${Load.numfor.format(th.brfiyat.round())}",
                            style: Load.font(0),
                          ),
                          Icon(FontAwesomeIcons.liraSign, size: 12),
                        ],
                      ),
                      Text(
                        "${th.duzt}",
                        style: Load.font(1),
                      ),
                    ],
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                  /*    subtitle: Row(
                        children: [
                          Text(
                            " ${th.miktaraciklamasi},",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            th.durum == 1
                                ? "${th.tediltar}"
                                : th.durum == 2
                                    ? "${th.odenmistar}"
                                    : "bos", //   " ${dt.geneltoplam - dt.alinmism}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      trailing: Text(
                        "${th.alinmismik}", //   " ${dt.geneltoplam - dt.alinmism}",
                        style: TextStyle(color: Colors.black),
                      ),*/
                ),
              ));
        },
      ),
    );
  }
}

class Taburunhareket extends StatefulWidget {
  final List<Dtourungecmisi> liskh;

  Taburunhareket(this.liskh);
  @override
  _TaburunhareketState createState() => _TaburunhareketState();
}

class _TaburunhareketState extends State<Taburunhareket>
    with AutomaticKeepAliveClientMixin {
  /* List<Dtofattahs> lis = [];
  @override
  void initState() {
    super.initState();
    print("ilktee");
    APIServices.satcarifatal(widget.cariId).then((value) {
      setState(() {
        print(value.toString());
        lis = value;
      });
    });
  }*/
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.liskh.length,
      itemBuilder: (context, index) {
        Dtourungecmisi th = widget.liskh[index];
        return Card(
            elevation: 0,
            margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                onTap: () {
                  /*    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Satisfatayrinti(th)));*/
                },
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
                  child: Icon(
                    th.fattur == "Stok Giriş"
                        ? FontAwesomeIcons.truck
                        : FontAwesomeIcons.truckLoading,
                    color: Colors.blue,
                    size: 18,
                  ),
                ),
                title: Text(
                  th.cariad,
                  style: Load.font(0),
                ),
                subtitle: Text(
                  th.fattur,
                  style: Load.font(1),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${th.miktar} Adet",
                      style: Load.font(0),
                    ),
                    Text(
                      "${th.duzenlemetarih}",
                      style: Load.font(1),
                    ),
                  ],
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                /*    subtitle: Row(
                      children: [
                        Text(
                          " ${th.miktaraciklamasi},",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          th.durum == 1
                              ? "${th.tediltar}"
                              : th.durum == 2
                                  ? "${th.odenmistar}"
                                  : "bos", //   " ${dt.geneltoplam - dt.alinmism}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "${th.alinmismik}", //   " ${dt.geneltoplam - dt.alinmism}",
                      style: TextStyle(color: Colors.black),
                    ),*/
              ),
            ));
      },
    );
  }
}
