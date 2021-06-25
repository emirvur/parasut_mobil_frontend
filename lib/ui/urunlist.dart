import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/model/dtourun.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/urunayrinti.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:muhmobil/utils/load.dart';

class Urunlist extends StatefulWidget {
  @override
  _UrunlistState createState() => _UrunlistState();
}

class _UrunlistState extends State<Urunlist> with TickerProviderStateMixin {
  TabController _tabController;
  List<Dtourun> lis = [];
  List<Dtourun> lisara = [];
  bool _isloading = true;
  bool isara = false;
  TextEditingController contara;
  bool isfiltre = false;
  bool artan;
  String barcode;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ewfsdds");
    contara = TextEditingController();
    _tabController = TabController(vsync: this, length: 1);
    APIServices.urunal().then((value) {
      setState(() {
        lis = value;
        _isloading = false;
      });
    });
  }

  Future<String> scanbarcode() async {
    barcode = await FlutterBarcodeScanner.scanBarcode(
        "", "İptal", false, ScanMode.BARCODE);
    return barcode;
    // var x= await APIServices.urunara(ara)
    //x==null?bottomsheet: setstat...
  }

  @override
  void dispose() {
    // TODO: implement dispose
    contara.dispose();
    super.dispose();
  }

  Future<void> builduyari(String ba, BuildContext context, Size size) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            print("tt");

            return Container(
              height: (4 * size.height) / 30,
              child: Column(
                //   mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                      "Tarattığınız barkod numarası-${ba}- ile eşleşen ürün bulunamadı.Yeni ürün eklemek için web sitesini ziyaret edebilirsiniz")
                  /*      Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: <Widget>[
                          Text(
                              "Tarattığınız barkod numarası ile eşleşen ürün bulunamadı.Yeni ürün eklemek için web sitesini ziyaret edebilirsiniz"),
                        ],
                        //       Text(
                        //              "Tarattığınız barkod numarası ile eşleşen ürün bulunamadı.Yeni ürün eklemek için web sitesini ziyaret edebilirsiniz"),
                      ),
                    ],
                  ),*/
                ],
              ),
            );
          });
        });
  }

  Future<void> buildurunekle(BuildContext context, Size size) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            print("tt");

            return Container(
              height: (4 * size.height) / 10,
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
                      Text("Ürün Ekle"),
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
                            Icon(Icons.money),
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

                                return null;

                                // validation logic
                              },
                              onSaved: (v) {
                                var x = num.tryParse(v);

                                //     deger = x;
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
                            Icon(Icons.monetization_on),
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
                                //    acikla = v;
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

                                    Navigator.of(context).pop();
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
            );
          });
        });
  }

  Future buildurunfiltre(BuildContext context, Size size) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: size.height / 4,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sırala",
                      style: Load.font(1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          APIServices.urunalcoktanaza().then((value) {
                            setState(() {
                              artan = false;
                              lis = value;
                              _isloading = false;
                              isfiltre = true;
                            });
                          });
                        },
                        child: Container(
                          height: size.height / 20,
                          width: size.width / 2,
                          color: Colors.grey,
                          child: Center(
                            child:
                                Text("Adede göre azalan", style: Load.font(5)),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          APIServices.urunalazdancoga().then((value) {
                            setState(() {
                              artan = true;
                              lis = value;
                              _isloading = false;
                              isfiltre = true;
                            });
                          });
                        },
                        child: Container(
                          height: size.height / 20,
                          width: size.width / 2,
                          color: Colors.grey,
                          child: Center(
                            child:
                                Text("Adede göre artan", style: Load.font(5)),
                          ),
                        )),
                    Divider()
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton(
            onPressed: () {
              scanbarcode().then((value) async {
                print(value);
                print("oo");
                // builduyari(value??"",context, size);
                bool x = await APIServices.urunbarkodara(value);
                if (x == true) {
                  APIServices.barkodluurun(value).then((v) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Urunayrinti(v)),
                    );
                  });
                } else {
                  builduyari(value ?? "", context, size);
                }
              });
            },
            child: Icon(FontAwesomeIcons.barcode),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(252, 188, 25, 1),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(25), child: Text("")),
          title: isara == false
              ? Text("Hizmet ve Ürünler", style: Load.font(4))
              : TextField(
                  decoration: new InputDecoration(hintText: 'Ara...'),
                  onChanged: (v) {
                    APIServices.urunara(v).then((value) {
                      setState(() {
                        lisara = value;
                        _isloading = false;
                      });
                    });
                  },
                ),
          actions: [
            isara == false
                ? isfiltre == false
                    ? IconButton(
                        icon: Icon(
                          FontAwesomeIcons.filter, size: 18,
                          // color: Colors.white,
                        ),
                        onPressed: () {
                          buildurunfiltre(context, size);
                        },
                      )
                    : IconButton(
                        icon: artan == true
                            ? Icon(
                                FontAwesomeIcons.sortAmountUp, size: 18,
                                // color: Colors.white,
                              )
                            : Icon(
                                FontAwesomeIcons.sortAmountDown, size: 18,
                                // color: Colors.white,
                              ),
                        onPressed: () {
                          buildurunfiltre(context, size);
                        },
                      )
                : Text(""),
            isara == false
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
                    controller: _tabController,
                    children: <Widget>[
                      Urunlis(lis, lisara, isara),
                      //  Satistahsedil(isara),
                      //    Satistum(lis, lisara, isara),
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

class Urunlis extends StatefulWidget {
  final List<Dtourun> listdt;
  final List<Dtourun> lisara;
  final bool isara;
  Urunlis(this.listdt, this.lisara, this.isara);

  @override
  _UrunlisState createState() => _UrunlisState();
}

class _UrunlisState extends State<Urunlis> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //separatorBuilder: (context, index) => Divider(
      //    color: Colors.black,  ),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: //widget.listdt.length,
          widget.isara == true ? widget.lisara.length : widget.listdt.length,
      itemBuilder: (context, index) {
        //  return //Buildurun(dt: widget.listdt[index]);
        Dtourun dt;
        if (widget.isara == true) {
          dt = widget.lisara[index];
          return Buildurun(dt: dt);
        } else {
          dt = widget.listdt[index];
          return Buildurun(dt: dt);
        }
      },
    );
  }
}

class Buildurun extends StatelessWidget {
  const Buildurun({
    Key key,
    @required this.dt,
  }) : super(key: key);

  final Dtourun dt;

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Urunayrinti(dt)),
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
                child: Icon(FontAwesomeIcons.thLarge, color: Colors.blue),
              ),
              title: Text(
                dt.adi,
                style: Load.font(0),
              ),
              subtitle: Text(
                "A:${Load.numfor.format(dt.verharal.round())}  S:${Load.numfor.format(dt.verharsat.round())}",
                style: Load.font(1),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${dt.adet}", style: Load.font(4)),
                  Text("${dt.birim}", style: Load.font(1))
                ],
              )),
        ));
  }
}
