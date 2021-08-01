import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/controller/alisfatcontroller.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/model/dtofatode.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:muhmobil/model/dtotahsharfat.dart';
import 'package:muhmobil/model/dtourunhareket.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/odeput.dart';
import 'package:muhmobil/model/tahsput.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/ui/yenialisfat.dart';
import 'package:muhmobil/utils/colorloader.dart';
import 'package:muhmobil/utils/createpdf.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:url_launcher/url_launcher.dart';

import 'alisfatayrin.dart';

class Tedarayrinti extends StatefulWidget {
  final Dtocarilist dt;
  Tedarayrinti(this.dt);
  @override
  _TedarayrintiState createState() => _TedarayrintiState();
}

class _TedarayrintiState extends State<Tedarayrinti>
    with TickerProviderStateMixin {
  TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  List<Dtofatode> lis = [];
  Cari cari = Cari(0, "", ",", 0, "", "", "", "", "", 0, "", 0);
  bool _isloading = true;
  bool tahsilform = false;
  bool acikfat = false;
  DateTime selectedDate = DateTime.now();
  TextEditingController contar;
  bool isexpa = false;
  List<String> kasalist = [
    "",
    // "Satış Faturası oluştur",
    "Alış faturası oluştur"
  ];
  Kasa kas = Kasa(1, "", 1);
  String acikla = "";
  num deger;
  String v;
  TextEditingController conacik;
  TextEditingController condeg;
  DateTime pickedDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickedDate = DateTime.now();
    _tabController = TabController(vsync: this, length: 3);
    contar = TextEditingController();
    conacik = TextEditingController();
    condeg = TextEditingController();

    Future.wait([
      APIServices.safcarial(widget.dt.cariId),
    ]).then((value) {
      setState(() {
        _isloading = false;
        cari = value[0];
        //  lis = value[1];
      });
    });
  }

  Future<void> _pickDate() async {
    DateTime date = await showDatePicker(
      locale: Locale("tr"),
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      pickedDate = date;
      setState(() {});
    }
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
                  style: TextStyle(color: Colors.black),
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
            height: size.height > 750 ? size.height / 5 : size.height / 4,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                    child: Text(
                  "Cari Hesap İşlemleri",
                  style: Load.font(8),
                )),
                Divider(),
                Column(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Yenialisfat(cari: widget.dt)));
                        },
                        child:
                            Text("Alış Faturası oluştur", style: Load.font(3))),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        //final dynamic _toolTip = _toolTipKey.currentState;
                        //_toolTip.ensureTooltipVisible();
                      },
                      child: Tooltip(
                        //  key: _toolTipKey,
                        message: "Pek yakında",
                        child: Text(
                          "Düzenle",
                          style: Load.font(3),
                        ),
                      ),
                    ),
                    Divider(),
                    /*   Tooltip(
                        message: "Pek yakında",
                        child: Text("Sil", style: Load.font(3))),
                    Divider(),*/
                    /*  Divider(),
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
                    ),*/

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
                    Text("Ödeme Ekle", style: Load.font(4)),
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
                          Icon(
                            FontAwesomeIcons.moneyBill,
                            size: 18,
                          ),
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
                          Icon(
                            FontAwesomeIcons.moneyBill,
                            size: 18,
                          ),
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
                          Icon(
                            FontAwesomeIcons.moneyBill,
                            size: 18,
                          ),
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

                                  Odeput
                                      tp/*= Tahsput(
                                      widget.dt.tahsid,
                                      deger,
                                      widget.dt.geneltoplam,
                                      selectedDate.toString(),
                                      kas.kasaid,
                                      conacik.text)*/
                                      ;
                                  bool b = await APIServices.odeharguncelle(tp);
                                  print(b.toString());
                                  Navigator.of(context).pop();
                                } else {
                                  print("hfgf");
                                }
                              },
                              child: Text("Ödeme Ekle", style: Load.font(3))),
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
          backgroundColor: Color.fromRGBO(105, 110, 135, 1),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.dt.cariunvani,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Row(
                        children: [
                          Text(
                            Load.numfor.format(widget.dt.bakiye
                                .round()), //         "${widget.dt.bakiye}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 20),
                          ),
                          Icon(FontAwesomeIcons.liraSign,
                              size: 18, color: Colors.white),
                        ],
                      )
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
                        text: "AÇIK İŞLEMLER",
                      ),
                    ),
                    Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "GEÇMİŞ",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //   title: Text("Satışlar"),
          actions: [
            Container(
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
                onTap: () async {
                  print("11");
                  List<Dtofatode> li =
                      await APIServices.carialfatal(widget.dt.cariId);
                  print(li[0].fataciklama);
                  var sharePdf = await ekstrepdftedar("Buse Tekstil", []);

                  await Share.file(
                    'Tedarikci Ekstre',
                    'ekstre.pdf',
                    sharePdf,
                    '*/*',
                  );
                },
                child: Center(
                  child: Text(
                    "Ekstre",
                    style: Load.font(5),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.ellipsisV, size: 18,
                // color: Colors.white,
              ),
              onPressed: () {
                buildsatisfattahs(context, size, 1);
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
                //  Align(alignment: Alignment.centerLeft, child: Text("Nisan 2021")),
                Expanded(
                  // child: Container(
                  //     color: Colors.grey[300],
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: <Widget>[
                      Tabbilgitedar(cari),
                      Tabtedaracik(cari.cariId),
                      Tabtedargecmis(cari.cariId),
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

class Tabbilgitedar extends StatelessWidget {
  final Cari dt;

  Tabbilgitedar(
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
                      FontAwesomeIcons.building,
                      size: 18,
                    ),
                  ),
                  title: Text(dt.kisaisim ?? "", style: Load.font(4))),
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
                    FontAwesomeIcons.envelope,
                    size: 18,
                  ),
                ),
                title: Text(dt.eposta, style: Load.font(4)),
                trailing: IconButton(
                    icon: Icon(Icons.forward),
                    onPressed: () {
                      launchEmailSubmission(dt.eposta);
                    }),
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
                    FontAwesomeIcons.phoneAlt,
                    size: 18,
                  ),
                ),
                title: Text(dt.telno, style: Load.font(4)),
                trailing: IconButton(
                    icon: Icon(Icons.forward),
                    onPressed: () {
                      _callNumber(dt.telno);
                    }),
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
                      FontAwesomeIcons.mapMarkedAlt,
                      size: 18,
                    ),
                  ),
                  title: Text(dt.adres, style: Load.font(4))),
            )),
      ],
    );
    // );
  }
}

void _callNumber(String tel) async {
  String url = "tel://" + tel;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not call $tel';
  }
}

void launchEmailSubmission(String x) async {
  final Uri params = Uri(scheme: 'mailto', path: x, queryParameters: {
    'subject': 'Ön Muhasebe uygulaması bilgilendirme',
    'body': ''
  });
  String url = params.toString();
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

class Tabtedaracik extends StatefulWidget {
  final int cariId;

  Tabtedaracik(this.cariId);
  @override
  _TabtedaracikState createState() => _TabtedaracikState();
}

class _TabtedaracikState extends State<Tabtedaracik>
    with AutomaticKeepAliveClientMixin {
  List<Dtofatode> lis = [];
  bool _isloading = true;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    print("ilktee");
    APIServices.carialfatal(widget.cariId).then((value) {
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
      child:
          /*RefreshIndicator(
        onRefresh: () {
          return APIServices.carialfatal(widget.cariId).then((value) {
            setState(() {
              print(value.toString());
              lis = value;
              _isloading = false;
            });
          });
        },
        child:*/
          ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: lis.length,
        itemBuilder: (context, index) {
          Dtofatode th = lis[index];
          return Card(
                  elevation: 0,
                  margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Alisfatayrin(th)));
                      },
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
                            Icon(FontAwesomeIcons.fileAlt, color: Colors.blue),
                      ),
                      title: Text(
                        "${th.fataciklama},",
                        style: Load.font(0),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      subtitle: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text("${th.cariad},${th.duztarih}",
                                    style: Load.font(4)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Load.numfor.format((th.geneltoplam - th.odendimik)
                                .round()), //            "${th.geneltoplam - th.odendimik}",
                            style: Load.font(0),
                          ),
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 12,
                          )
                        ],
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
      ),
      //   ),
    );
    // );
  }
}

class Tabtedargecmis extends StatefulWidget {
  final int cariId;

  Tabtedargecmis(this.cariId);
  @override
  _TabtedargecmisState createState() => _TabtedargecmisState();
}

class _TabtedargecmisState extends State<Tabtedargecmis>
    with AutomaticKeepAliveClientMixin {
  List<Dtofatode> lis = [];
  bool _isloading = true;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    print("ilktee");
    APIServices.tedargecmis(widget.cariId).then((value) {
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
          Dtofatode th = lis[index];
          return Card(
                  elevation: 0,
                  margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Alisfatayrin(th)));
                      },
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
                            Icon(FontAwesomeIcons.fileAlt, color: Colors.blue),
                      ),
                      title: Text(
                        "${th.fataciklama},",
                        style: Load.font(0),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      subtitle: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text("${th.cariad},${th.duztarih}",
                                    style: Load.font(4)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Load.numfor.format((th.geneltoplam - th.odendimik)
                                .round()), //       "${th.geneltoplam - th.odendimik}",
                            style: Load.font(0),
                          ),
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 12,
                          )
                        ],
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
      ),
      //  ),
    );
    // );
  }
}
