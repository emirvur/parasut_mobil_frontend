import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/controller/gunceldurumcontroller.dart';
import 'package:muhmobil/controller/kasacontroller.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:muhmobil/model/dtokasahar.dart';
import 'package:muhmobil/model/dtotahsharfat.dart';
import 'package:muhmobil/model/dtourunhareket.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/kasahar.dart';
import 'package:muhmobil/model/tahsput.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/utils/load.dart';

class Kasaayrinti extends StatefulWidget {
  final Kasa dt;
  Kasaayrinti(this.dt);
  @override
  _KasaayrintiState createState() => _KasaayrintiState();
}

class _KasaayrintiState extends State<Kasaayrinti>
    with TickerProviderStateMixin {
  TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  List<Dtokasahar> lis = [];
  Cari cari;
  bool _isloading = true;
  bool tahsilform = false;
  bool acikfat = false;
  DateTime selectedDate = DateTime.now();
  TextEditingController contar;
  bool loadapi = false;
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
  DateTime pickedDate;
  num appbak = 0;
  final KasaController _kc = Get.put(KasaController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appbak = widget.dt.bakiye;
    pickedDate = DateTime.now();
    _tabController = TabController(vsync: this, length: 1);
    contar = TextEditingController();
    conacik = TextEditingController();
    condeg = TextEditingController();

    /*APIServices.kasalistal().then((value) {
      kasalist = value;
      kas = kasalist[0];
    });*/
    Future.wait([
      APIServices.kasahar(widget.dt.kasaid),
      //  APIServices.satcarifatal(widget.dt.cariId),
    ]).then((value) {
      setState(() {
        _isloading = false;
        lis = value[0];
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
        icon: Icon(Icons.arrow_drop_down),
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

  Future<void> buildkasaharekle(BuildContext context, Size size, int tahsflag) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          //    return StatefulBuilder(builder: (context, setState) {
          return Container(
            height: size.height > 750 ? size.height / 5 : size.height / 4,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                    child: Text(
                  "Hesap İşlemleri",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                )),
                Divider(),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        buildparaekle(context, size, true).then((value) {
                          setState(() {
                            print("oooo");
                          });
                        });
                      },
                      child: Text("Para Girişi Ekle",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          )),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        buildparaekle(context, size, false).then((value) {
                          setState(() {
                            print("oooo");
                          });
                        });
                      },
                      child: Text("Para Çıkışı Ekle",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          )),
                    ),
                    Divider(),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("İptal",
                            style: TextStyle(color: Colors.red, fontSize: 16))),
                  ],
                )
              ],
            ),
          );
          //   });
        });
  }

  Future<void> buildparaekle(BuildContext context, Size size, bool girismi) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            print("tt");

            return LoadingOverlay(
              isLoading: loadapi,
              opacity: Load.opacit,
              progressIndicator: Load.prog,
              child: Container(
                height: size.height > 750
                    ? (4 * size.height) / 12
                    : (4 * size.height) / 10,
                child: Column(
                  //   mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Text(girismi == true
                            ? "Para Girişi Ekle"
                            : "Para Çıkışı Ekle"),
                        Spacer(),
                        Text(
                            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}"),
                        IconButton(
                            icon: Icon(
                              FontAwesomeIcons.calendar,
                              size: 18,
                            ),
                            onPressed: () async {
                              _pickDate().then((value) {
                                setState(() {});
                              });

                              //    await _pickDate();
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
                              Icon(Icons.monetization_on),
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
                                  if (girismi == false
                                      ? x > (widget.dt.bakiye)
                                      : 1 == 2) {
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
                              //  Icon(Icons.monetization_on),
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
                                  child: Text("Vazgeç",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16))),
                              SizedBox(
                                width: 12,
                              ),
                              InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState.validate()) {
                                      print("ggg");
                                      _formKey.currentState.save();
                                      setState(() {
                                        print("www");
                                        loadapi = true;
                                      });
                                      Kasahar kh = Kasahar(
                                          -1,
                                          widget.dt.kasaid,
                                          null,
                                          null,
                                          0,
                                          2,
                                          girismi == true ? deger : -deger,
                                          acikla);
                                      await APIServices.kasaharekle(kh);
                                      _kc.guncelle(widget.dt.kasaid,
                                          girismi == true ? deger : -deger);
                                      Get.find<Gunceldurumcontroller>()
                                          .bakiyedeg(
                                              girismi == true ? deger : -deger);
                                      girismi == true
                                          ? appbak = appbak + deger
                                          : appbak = appbak - deger;
                                      setState(() {
                                        print("www");
                                        loadapi = false;
                                      });
                                      Navigator.of(context).pop();
                                      setState(() {
                                        print("adsadsdsa");
                                        lis.add(Dtokasahar(
                                            -1,
                                            2,
                                            girismi == true ? deger : -deger,
                                            acikla,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null,
                                            null));
                                      });
                                    } else {
                                      print("hfgf");
                                    }
                                  },
                                  child: Text("Ekle",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16))),
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
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(50, 237, 184, 1),
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
                        widget.dt.kasaAd,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Load.numfor.format(//widget.dt.bakiye
                                appbak.round()), //    "${widget.dt.bakiye}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 20),
                          ),
                          (Icon(FontAwesomeIcons.liraSign,
                              size: 18, color: Colors.white))
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
                    /*  Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "BİLGİLER",
                      ),
                    ),*/
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
            IconButton(
              icon: Icon(
                FontAwesomeIcons.ellipsisV, size: 18,
                // color: Colors.white,
              ),
              onPressed: () {
                buildkasaharekle(context, size, 1);
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
                    controller: _tabController,
                    children: <Widget>[
                      //      Tabbilgikasa(widget.dt),
                      Tabkasagecmis(lis),
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

class Tabbilgikasa extends StatelessWidget {
  final Kasa dt;

  Tabbilgikasa(
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
                  leading: Icon(Icons.ac_unit),
                  title: Text(dt.kasaAd, style: Load.font(5))),
            )),
      ],
    );
    // );
  }
}

class Tabkasagecmis extends StatefulWidget {
  final List<Dtokasahar> liskh;

  Tabkasagecmis(this.liskh);
  @override
  _TabkasagecmisState createState() => _TabkasagecmisState();
}

class _TabkasagecmisState extends State<Tabkasagecmis> {
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
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.liskh.length,
      itemBuilder: (context, index) {
        Dtokasahar th = widget.liskh[index];
        print("ppp");
        print(th.durum.toString());
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
                              right: new BorderSide(
                                  width: 1.0, color: Colors.grey),
                              left: new BorderSide(
                                  width: 1.0, color: Colors.grey),
                              top: new BorderSide(
                                  width: 1.0, color: Colors.grey),
                              bottom: new BorderSide(
                                  width: 1.0, color: Colors.grey))),
                      child: Icon(FontAwesomeIcons.fileAlt,
                          color: th.durum == 1
                              ? Colors.blue
                              : th.durum == 0
                                  ? Colors.red
                                  : Colors.green),
                    ),
                    title: Text(
                      th.durum == 1
                          ? "Tahsilat"
                          : th.durum == 0
                              ? "Ödeme"
                              : "",
                      style: Load.font(0),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: [
                        Text(
                          th.durum == 1
                              ? "${th.tahsaciklama}"
                              : th.durum == 0
                                  ? "${th.odaciklama},"
                                  : "${th.miktaraciklamasi}",
                          style: Load.font(1),
                        ),
                        Text(
                          th.durum == 1
                              ? "${th.tediltar}"
                              : th.durum == 0
                                  ? "${th.odenmistar}"
                                  : "",
                          style: Load.font(1),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Load.numfor.format(th.durum == 1
                              ? th.alinmismik.round()
                              : th.durum == 0
                                  ? th.odendimik.round()
                                  : th.miktar.round()), //   "${th.alinmismik}",
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
    );
    // );
  }
}
