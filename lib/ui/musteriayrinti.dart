import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/controller/mustliscontroller.dart';
import 'package:muhmobil/controller/satisfatcontroller.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:muhmobil/model/dtotahsharfat.dart';
import 'package:muhmobil/model/dtourunhareket.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/tahsput.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/satisfatayrin.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:muhmobil/utils/colorloader.dart';
import 'package:muhmobil/utils/createpdf.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Musteriayrinti extends StatefulWidget {
  final Dtocarilist dt;
  Musteriayrinti(this.dt);
  @override
  _MusteriayrintiState createState() => _MusteriayrintiState();
}

class _MusteriayrintiState extends State<Musteriayrinti>
    with TickerProviderStateMixin {
  TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  List<Dtofattahs> lis = [];
  Cari cari = Cari(0, "", ",", 0, "", "", "", "", "", 0, "", 0);
  bool _isloading = true;
  bool tahsilform = false;
  bool acikfat = false;
  DateTime selectedDate = DateTime.now();
  TextEditingController contar;
  bool isexpa = false;
  List<String> kasalist = [
    "",
    "Satış Faturası oluştur",
    //  "Alış faturası oluştur"
  ];
  Kasa kas = Kasa(1, "", 1);
  String acikla = "";
  num deger;
  String v;
  TextEditingController conacik;
  TextEditingController condeg;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    contar = TextEditingController();
    conacik = TextEditingController();
    condeg = TextEditingController();

    /*APIServices.kasalistal().then((value) {
      kasalist = value;
      kas = kasalist[0];
    });*/
    Future.wait([
      APIServices.safcarial(widget.dt.cariId),
      //  APIServices.satcarifatal(widget.dt.cariId),
    ]).then((value) {
      setState(() {
        _isloading = false;
        cari = value[0];
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
        icon: Icon(FontAwesomeIcons.arrowDown, size: 18),
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
    print(size.height.toString());
    print("eee");
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
                                      Yenisatisfat(cari: widget.dt)));
                        },
                        child: Text("Satış Faturası oluştur",
                            style: Load.font(3))),
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
                    //   Divider(),
                    // Text("Sil", style: Load.font(3)),
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
                    Text("Tahsilat Ekle", style: Load.font(5)),
                    Spacer(),
                    Text("fss", style: Load.font(5)),
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
                          Icon(FontAwesomeIcons.moneyBill, size: 18),
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
                          Icon(FontAwesomeIcons.moneyBill, size: 18),
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
                          Icon(FontAwesomeIcons.moneyBill, size: 18),
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
                                      tp/*=Tahsput(
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
                      InkWell(
                          onTap: () async {
                            var y = await izlemepdf();
                            print(y.toString());
                            print("yyy");
                            PDFViewer(
                              document: y,
                              zoomSteps: 1,
                            );
                          },
                          child: Text(
                            widget.dt.cariunvani,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          )),
                      Row(
                        children: [
                          Text(
                            Load.numfor.format(widget.dt.bakiye
                                .round()), //    "${widget.dt.bakiye}",
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
                  //    isScrollable: true,
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
                  List<Dtofattahs> li =
                      await APIServices.carisatfatal(widget.dt.cariId);
                  print(li[0].fataciklama);
                  var sharePdf = await ekstrepdfmusteri("Büse Tekstil", li);
                  print("222");

                  await Share.file(
                    'Musteri ekstre',
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
                      Tabbilgimust(cari),
                      Tabmustacik(cari.cariId ?? -1),
                      Tabmustgecmis(cari.cariId ?? -1),
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

class Tabbilgimust extends StatelessWidget {
  final Cari dt;

  Tabbilgimust(
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
                    child: Icon(FontAwesomeIcons.building, size: 18),
                  ),
                  title: Text(dt.kisaisim ?? "")),
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
                  child: Icon(FontAwesomeIcons.envelope, size: 18),
                ),
                title: Text(dt.eposta),
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
                leading: Icon(FontAwesomeIcons.phoneAlt, size: 18),
                title: Text(dt.telno),
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
                    child: Icon(FontAwesomeIcons.mapMarkedAlt, size: 18),
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

class Tabmustacik extends StatefulWidget {
  final int cariId;

  Tabmustacik(this.cariId);
  @override
  _TabmustacikState createState() => _TabmustacikState();
}

class _TabmustacikState extends State<Tabmustacik>
    with AutomaticKeepAliveClientMixin {
  List<Dtofattahs> lis = [];
  bool _isloading = true;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    print("ilktee");
    APIServices.carisatfatal(widget.cariId).then((value) {
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
          /* RefreshIndicator(
        onRefresh: () {
          return APIServices.carisatfatal(widget.cariId).then((value) {
            setState(() {
              print(value.toString());
              lis = value;
              _isloading = false;
            });
          });
        },
        child: */
          ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: lis.length,
        itemBuilder: (context, index) {
          Dtofattahs th = lis[index];
          //    var v = Load.numfor.format(number);
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
                                builder: (context) => Satisfatayrin(th)));
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
                        child: Icon(Icons.upload_file, color: Colors.blue),
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
                            Load.numfor.format((th.geneltoplam - th.alinmism)
                                .round()), //{th.geneltoplam - th.alinmism}",
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

class Tabmustgecmis extends StatefulWidget {
  final int cariId;

  Tabmustgecmis(this.cariId);
  @override
  _TabmustgecmisState createState() => _TabmustgecmisState();
}

class _TabmustgecmisState extends State<Tabmustgecmis>
    with AutomaticKeepAliveClientMixin {
  List<Dtofattahs> lis = [];
  bool _isloading = true;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    print("ilktee");
    APIServices.mustgecmis(widget.cariId).then((value) {
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
          return APIServices.satcarifatal(widget.cariId).then((value) {
            setState(() {
              print(value.toString());
              lis = value;
              _isloading = false;
            });
          });
        },
        child: */
          ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: lis.length,
        itemBuilder: (context, index) {
          Dtofattahs th = lis[index];
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
                                builder: (context) => Satisfatayrin(th)));
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
                        child: Icon(Icons.upload_file, color: Colors.blue),
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
                          /*    Text(
                            "${th.duztarih}",
                            style: Load.font(0),
                          ),*/
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Load.numfor.format((th.geneltoplam - th.alinmism)
                                .round()), //     "${th.alinmism}",
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

class Satisfatayrinmust extends StatefulWidget {
  Dtofattahs dt;
  Satisfatayrinmust(this.dt);
  @override
  _SatisfatayrinmustState createState() => _SatisfatayrinmustState();
}

class _SatisfatayrinmustState extends State<Satisfatayrinmust>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TabController _tabController;
  List<Dtourunhareket> lis = [];
  List<Dtotahsharfat> ltah = [];
  bool _isloading = true;
  bool tahsilform = false;
  DateTime selectedDate = DateTime.now();
  TextEditingController contar;
  GlobalKey _toolTipKey = GlobalKey();
  //GlobalKey _toolTipKey1 = GlobalKey();
  //List<Kasa> kasalist = [];
  //Kasa kas = Kasa(1, "", 1);
  String acikla = "";
  num deger = 0;
  ValueNotifier<int> _counter;
  TextEditingController conacik;
  TextEditingController condeg;
  List<Kasa> kasalist = [];
  Kasa kas = Kasa(1, "", 1);
  DateTime pickedDate;
  // Satisfatayrinticontroller _sfcontroller;

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
          setState(() {
            _counter.value++;
            print("kasaa");
          });
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

  @override
  void initState() {
    super.initState();
    print("ayrinti intitee");
    //_sfcontroller = Get.put(Satisfatayrinticontroller(widget.dt));
    //  _sfcontroller.fetchfinaltodo(widget.dt);
    print("ooo");
    print("${widget.dt.geneltoplam}---${widget.dt.alinmism}");
    // _sfcontroller.inittekalan(widget.dt.geneltoplam - widget.dt.alinmism);
    pickedDate = DateTime.now();
    _counter = ValueNotifier<int>(0);
    _tabController = TabController(vsync: this, length: 2);
    contar = TextEditingController();
    conacik = TextEditingController();
    condeg = TextEditingController(
        text: (widget.dt.geneltoplam - widget.dt.alinmism).toString());
    Future.wait([
      APIServices.tahsharfaticin(widget.dt.tahsid),
      APIServices.kasalistal(),
      APIServices.fatuurundetay(widget.dt.fatid)
    ]).then((value) {
      setState(() {
        _isloading = false;
        ltah = value[0];
        kasalist = value[1];
        kas = kasalist[0];
        lis = value[2];
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
    if (date != null)
      setState(() {
        pickedDate = date;
      });
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
                  "Satış Faturası İşlemleri",
                  style: Load.font(8),
                )),
                Divider(),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final dynamic _toolTip = _toolTipKey.currentState;
                        _toolTip.ensureTooltipVisible();
                      },
                      child: Tooltip(
                          key: _toolTipKey,
                          message: "Pek yakında",
                          child: Text("Düzenle", style: Load.font(3))),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        if (tahsflag == 1) {
                        } else {
                          Navigator.of(context).pop();
                          buildtahsekle(context, size).then((value) {
                            //   Navigator.of(context).pop();
                            setState(() {
                              print("sertttee");
                              print(deger.toString());
                              print(widget.dt.alinmism.toString());
                              widget.dt.alinmism = widget.dt.alinmism + deger;
                              if (widget.dt.geneltoplam - widget.dt.alinmism ==
                                  0) {
                                widget.dt.durum = 1;
                              }
                              print("fff");
                              print(widget.dt.alinmism.toString());
                            });
                          });
                        }
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

  Future buildtahsekle(
    BuildContext context,
    Size size,
  ) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: size.height > 750
                  ? (4 * size.height) / 10
                  : (4 * size.height) / 8,
              child: Column(
                //   mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back), onPressed: () {}),
                      Text("Tahsilat Ekle", style: Load.font(4)),
                      Spacer(),
                      Text(
                          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}"),
                      IconButton(
                          icon: Icon(
                            FontAwesomeIcons.calendar,
                            size: 18,
                          ),
                          onPressed: () {
                            _pickDate().then((value) {
                              setState(() {});
                            });
                          }),
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
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                FontAwesomeIcons.moneyCheck,
                                size: 18,
                              ),
                            ),
                            Expanded(
                                child: ValueListenableBuilder(
                                    valueListenable: _counter,
                                    builder: (context, value, child) {
                                      return _dropdownbutton(kasalist);
                                    })),
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
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                FontAwesomeIcons.moneyBill,
                                size: 18,
                              ),
                            ),
                            Expanded(
                                child: TextFormField(
                              decoration:
                                  new InputDecoration(hintText: 'Meblağ'),
                              validator: (value) {
                                print("uu");
                                var x = num.tryParse(value);
                                if (x == null) {
                                  return "Lütfen geçerli bir sayı giriniz";
                                }
                                if (x >
                                    (widget.dt.geneltoplam -
                                        widget.dt.alinmism)) {
                                  return "Kalan miktardan daha büyük bir sayı giremezsiniz";
                                }
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
                            /*   Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                FontAwesomeIcons.exp,
                                size: 18,
                              ),
                            ),*/
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

                                    Tahsput tp = Tahsput(
                                        widget.dt.tahsid,
                                        deger,
                                        widget.dt.geneltoplam,
                                        pickedDate.toString(),
                                        9, //    kas.kasaid,
                                        acikla);

                                    bool b =
                                        await APIServices.tahsharguncelle(tp);
                                    //    _sfcontroller.guncelle(deger);
                                    Get.find<Satisfatcontroller>()
                                        .guncelle(widget.dt.fatid, deger);
                                    Get.find<Satistahscontroller>()
                                        .guncelle(widget.dt.fatid, deger);
                                    Get.find<Satisgecicontroller>()
                                        .guncelle(widget.dt.fatid, deger);
                                    print(b.toString());
                                    /*    _sfcontroller.tahsharekle(Dtotahsharfat(
                                        -1,
                                        widget.dt.tahsid,
                                        pickedDate.toString(),
                                        9,
                                        "q",
                                        acikla,
                                        deger,
                                        widget.dt.cariad));*/
                                    ltah.add(Dtotahsharfat(
                                        -1,
                                        widget.dt.tahsid,
                                        DateFormat.yMMMEd('tr_TR').format(
                                            DateTime.parse(pickedDate
                                                .toString())), //         pickedDate.toString(),
                                        9,
                                        "kasaad",
                                        acikla,
                                        deger,
                                        widget.dt.cariad));

                                    Get.find<Mustliscontroller>()
                                        .mustbakguncel(widget.dt.cariId, deger);
                                    deger = 0;
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
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("satayrinti disposda");
    //_sfcontroller.dispose();
    print("contt disposda");
    _counter.dispose();
    _tabController.dispose();
    contar.dispose();
    conacik.dispose();
    condeg.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("qq");
    print(widget.dt.alinmism);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(52, 213, 235, 1),
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
                      widget.dt.fataciklama,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Row(
                      children: [
                        Text(
                          Load.numfor.format(widget.dt.geneltoplam
                              .round()), //      "${widget.dt.geneltoplam}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                        Icon(
                          FontAwesomeIcons.liraSign,
                          color: Colors.white,
                          size: 18,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.building,
                            color: Colors.white, size: 18),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.dt.cariad,
                          style: Load.font(5),
                        ),
                      ],
                    ),
                    widget.dt.durum == 1
                        ? Container(
                            padding: EdgeInsets.all(6.0),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Ödendi",
                              style: Load.font(3),
                            ),
                          )
                        : Text(""),
                  ],
                ),
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
                      text: "BİLGİLER",
                    ),
                  ),
                  Container(
                    width: size.width / 3,
                    child: Tab(
                      text: "TAHSİLATLAR",
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
              onTap: () {},
              child: Center(
                child: Text(
                  "Paylaş",
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
              buildsatisfattahs(context, size, widget.dt.durum);
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            //  Align(alignment: Alignment.centerLeft, child: Text("Nisan 2021")),
            Expanded(
              // child: Container(
              //     color: Colors.grey[300],
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _isloading == true
                      ? Center(child: CircularProgressIndicator())
                      : Tabbilgiwdgmust(widget.dt, lis, size),
                  _isloading == true
                      ? Center(child: CircularProgressIndicator())
                      : Tabtahsilatwdgmust(ltah),
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

class Tabtahsilatwdgmust extends StatelessWidget {
  final List<Dtotahsharfat> dt;
  Tabtahsilatwdgmust(this.dt);
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

class Tabbilgiwdgmust extends StatelessWidget {
  final Dtofattahs dt;
  final List<Dtourunhareket> lisuh;
  final Size size;
  Tabbilgiwdgmust(this.dt, this.lisuh, this.size);
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
                  Spacer(),
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
