import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtokasahar.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/kasahar.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/kasaayrinti.dart';
import 'package:muhmobil/ui/kasalist.dart';
import 'package:muhmobil/utils/load.dart';

import 'gunceldurumcontroller.dart';

class KasaayrintiController extends GetxController {
  final Kasa l;
  final num ba;

  KasaayrintiController(this.l, this.ba);
  var isLoading = true.obs;
  var todoList = List<Dtokasahar>().obs;
  num g = 0.obs();

  @override
  void onInit() {
    print("kasaatrinticontt");
    fetchfinaltodo(l.kasaid);
    g = ba;

    super.onInit();
  }

  void kasaarttir(num x) async {
    isLoading(true);
    try {
      print(g.toString());
      print("kasaarttrri");
      g = g + x;
      print(g.toString());
    } finally {
      isLoading(false);
    }
  }

  void fetchfinaltodo(int x) async {
    isLoading(true);
    try {
      var todos = await APIServices.kasahar(x);
      if (todos != null) {
        todoList.value = todos;
      }
    } finally {
      isLoading(false);
    }
  }

  void guncelle(Dtokasahar v) async {
    isLoading(true);
    print("trydan once");

    try {
      print("gueelel kasaaaa");
      todoList.add(v);
    } finally {
      isLoading(false);
    }
  }
}

class KasaController extends GetxController {
  var isLoading = true.obs;
  var todoList = List<Kasa>().obs;

  @override
  void onInit() {
    print("kasacontt");
    fetchfinaltodo();
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      var todos = await APIServices.kasaal();
      if (todos != null) {
        todoList.value = todos;
      }
    } finally {
      isLoading(false);
    }
  }

  void guncelle(int index, num bak) async {
    isLoading(true);
    print("trydan once");
    print(todoList[0].kasaAd);
    try {
      print("tryddadsad");
      for (var i in todoList) {
        print(i.kasaid.toString());
        print("fordaa");
        if (i.kasaid == index) {
          print("bakk");
          print(i.bakiye.toString());
          i.bakiye = i.bakiye + bak;
          print(i.bakiye.toString());
        }
        print("cıkrtııt");
      }
      /* todoList.map((element) {
        print(element.kasaid.toString());
        print("fordaa");
        if (element.kasaid == index) {
          element.bakiye = bak;
        }
        print("cıkrtııt");
      });*/
    } finally {
      isLoading(false);
    }
  }
}

class HomeScreen extends StatelessWidget {
  final KasaController _controller = Get.put(KasaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: _controller.todoList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => D(_controller.todoList[index])));
              },
              title: Text(_controller.todoList[index].bakiye.toString()),
            );
          },
        );
      }),
    );
  }
}

class D extends StatelessWidget {
  final Kasa x;
  D(this.x);
  final KasaController _controller = Get.put(KasaController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('dddd'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextButton(
              child: Text("arttır"),
              onPressed: () {
                _controller.guncelle(x.kasaid, 1233);
              },
            )
          ],
        ));
  }
}

class Kasalistesi extends StatefulWidget {
  @override
  _KasalistesiState createState() => _KasalistesiState();
}

class _KasalistesiState extends State<Kasalistesi>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<Kasa> lis = [];
  bool isara = false;
  final KasaController _controller = Get.put(KasaController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //tab controller dispose yap
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(50, 237, 184, 1),
        bottom:
            PreferredSize(preferredSize: Size.fromHeight(25), child: Text("")),
        title: Text("Kasa ve Bankalar", style: Load.font(5)),
        actions: [],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Obx(() {
                    if (_controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Kasali(_controller.todoList, false);
                  })
                  //  Satistahsedil(isara),
                  //    Satistum(lis, lisara, isara),
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

class Kasali extends StatefulWidget {
  final List<Kasa> listdt;
  final bool isara;
  Kasali(this.listdt, this.isara);

  @override
  _KasaliState createState() => _KasaliState();
}

class _KasaliState extends State<Kasali> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print("tab kasalis buildddee");
    return ListView.builder(
      //separatorBuilder: (context, index) => Divider(
      //    color: Colors.black,  ),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.listdt.length,
      //      widget.isara == true ? widget.lisara.length : widget.listdt.length,
      itemBuilder: (context, index) {
        return Buildkasa(dt: widget.listdt[index]);
        /*if (widget.isara == true) {
          dtc = widget.lisara[index];
          return Buildcari(dt: dtc);
        } else {
          dt = widget.listdt[index];
          return Buildcari(dt: dtc);
        }*/
      },
    );
  }
}

class Buildkasa extends StatelessWidget {
  const Buildkasa({
    Key key,
    @required this.dt,
  }) : super(key: key);

  final Kasa dt;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
            ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
              onTap: () {
                print("ttt");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Kasaayrinti(dt)),
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
                child: Icon(FontAwesomeIcons.moneyBill,
                    size: 18, color: Colors.blue),
              ),
              title: Text(
                dt.kasaAd,
                style: Load.font(0),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Load.numfor.format(dt.bakiye.round()),
                      style: Load.font(0)),
                  Icon(
                    FontAwesomeIcons.liraSign,
                    size: 12,
                  )
                ],
              )),
        ));
  }
}

class Kasaayrin extends StatefulWidget {
  final Kasa dt;
  Kasaayrin(this.dt);
  @override
  _KasaayrinState createState() => _KasaayrinState();
}

class _KasaayrinState extends State<Kasaayrin> with TickerProviderStateMixin {
  TabController _tabController;
  KasaayrintiController _ayrcontroller;
  final _formKey = GlobalKey<FormState>();
  List<Dtokasahar> lis = [];
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
  DateTime pickedDate;
  final KasaController _kc = Get.put(KasaController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickedDate = DateTime.now();
    _tabController = TabController(vsync: this, length: 1);
    contar = TextEditingController();
    conacik = TextEditingController();
    condeg = TextEditingController();
    _ayrcontroller =
        Get.put(KasaayrintiController(widget.dt, widget.dt.bakiye));

    /* Future.wait([
      APIServices.kasahar(widget.dt.kasaid),
    ]).then((value) {
      setState(() {
        _isloading = false;
        lis = value[0];
     
      });
    });*/
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
                        buildparaekle(context, size, true);
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
                        buildparaekle(context, size, false);
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
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            print("tt");

            return Container(
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
                                  try {
                                    if (_formKey.currentState.validate()) {
                                      print("ggg");
                                      _formKey.currentState.save();

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
                                      _ayrcontroller.guncelle(Dtokasahar(
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
                                      print("rrr");
                                      _ayrcontroller.kasaarttir(
                                          girismi == true ? deger : -deger);
                                      _kc.guncelle(widget.dt.kasaid,
                                          girismi == true ? deger : -deger);
                                      print("uuu");
                                      Get.find<Gunceldurumcontroller>()
                                          .bakiyedeg(
                                              girismi == true ? deger : -deger);

                                      Navigator.of(context).pop();
                                    } else {
                                      print("hfgf");
                                    }
                                  } catch (e) {}
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
                        Obx(() {
                          if (_ayrcontroller.isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            Load.numfor.format(_ayrcontroller.g
                                .round()), //    "${widget.dt.bakiye}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 20),
                          );
                        }),
                        (Icon(FontAwesomeIcons.liraSign,
                            size: 18, color: Colors.white))
                      ],
                    )
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
                  //      Tabbilgikasa(widget.dt),
                  Obx(() {
                    if (_ayrcontroller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Tabkasagecmis(_ayrcontroller.todoList);
                  })
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
        print(th.durum.toString());
        print("yy");
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
                          color: th.durum == 1 ? Colors.blue : Colors.red),
                    ),
                    title: Text(
                      th.durum == 1 ? "Tahsilat" : "Ödeme",
                      style: Load.font(0),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: [
                        Text(
                          " ${th.miktaraciklamasi},",
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
                          th.durum == 2
                              ? Load.numfor.format(th.miktar.round())
                              : th.durum == 1
                                  ? Load.numfor.format(th.alinmismik.round())
                                  : Load.numfor.format(th.odendimik
                                      .round()), //   "${th.alinmismik}",
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
