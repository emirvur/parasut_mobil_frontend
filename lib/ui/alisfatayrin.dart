import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/controller/alisfatcontroller.dart';
import 'package:muhmobil/controller/gunceldurumcontroller.dart';
import 'package:muhmobil/controller/kasacontroller.dart';
import 'package:muhmobil/controller/tedarliscontroller.dart';
import 'package:muhmobil/model/dtofatode.dart';
import 'package:muhmobil/model/dtokasahar.dart';
import 'package:muhmobil/model/dtoodeharfat.dart';
import 'package:muhmobil/model/dtourunhareket.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/odeput.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/utils/createpdf.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:intl/intl.dart';

class Alisfatayrin extends StatefulWidget {
  final Dtofatode dte;
  Alisfatayrin(this.dte);
  @override
  _AlisfatayrinState createState() => _AlisfatayrinState();
}

class _AlisfatayrinState extends State<Alisfatayrin>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TabController _tabController;
  List<Dtourunhareket> lis = [];
  List<Dtoodeharfat> ltah = [];
  bool _isloading = true;
  bool loadapi = false;
  ValueNotifier<int> _counter;
  // bool tahsilform = false;
  DateTime selectedDate = DateTime.now();
  TextEditingController contar;
  GlobalKey _toolTipKey = GlobalKey();
  //List<Kasa> kasalist = [];
  //Kasa kas = Kasa(1, "", 1);
  String acikla = "";
  num deger = 0;
  TextEditingController conacik;
  TextEditingController condeg;
  List<Kasa> kasalist = [];
  Kasa kas = Kasa(1, "", 1);
  DateTime pickedDate;
  // Alisfatayrinticontroller _sfcontroller;
  num alin;
  int durum;
  final KasaController _kc = Get.put(KasaController());
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
        icon: Icon(FontAwesomeIcons.arrowUp),
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
                  style: Load.font(4),
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
    //_sfcontroller = Get.put(Alisfatayrinticontroller(widget.dt));
    pickedDate = DateTime.now();
    _counter = ValueNotifier<int>(0);
    _tabController = TabController(vsync: this, length: 2);
    contar = TextEditingController();
    conacik = TextEditingController();
    condeg = TextEditingController(
        text: (Load.numfor.format(
                widget.dte.geneltoplam.round() - widget.dte.odendimik.round()))
            .toString());
    alin = widget.dte.odendimik;
    durum = widget.dte.durum;
    Future.wait([
      APIServices.odeharfaticin(widget.dte.odeid),
      APIServices.kasalistal(),
      APIServices.fatuurundetay(widget.dte.fatid)
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

  Future buildalisode(BuildContext context, Size size, int tahsflag) {
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
                  "Alış Faturası İşlemleri",
                  style: Load.font(4),
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
                        child: Text("Düzenle", style: Load.font(3)),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        if (tahsflag == 1) {
                        } else {
                          Navigator.of(context).pop();
                          buildodesekle(context, size).then((value) {
                            //   Navigator.of(context).pop();
                            setState(() {
                              print("sertttee");
                              print(deger.toString());
                              print(widget.dte.odendimik.toString());
                              //      widget.dt.alinmism = widget.dt.alinmism + deger;
                              /*   if (widget.dt.geneltoplam - widget.dt.alinmism ==
                                  0) {
                                widget.dt.durum = 1;
                              }*/
                              print(widget.dte.odendimik.toString());
                            });
                          });
                        }
                      },
                      child: Text("Ödeme Ekle",
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

  Future buildodesekle(
    BuildContext context,
    Size size,
  ) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return LoadingOverlay(
              isLoading: loadapi,
              opacity: Load.opacit,
              progressIndicator: Load.prog,
              child: Container(
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
                        Text("Ödeme Ekle", style: Load.font(4)),
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
                              /*  Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  FontAwesomeIcons.moneyBill,
                                  size: 18,
                                ),
                              ),*/
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
                                decoration: new InputDecoration(
                                    hintText: 'Meblağ',
                                    hintStyle: Load.font(4)),
                                validator: (value) {
                                  print("uu");
                                  var x = num.tryParse(value);
                                  if (x == null) {
                                    return "Lütfen geçerli bir sayı giriniz";
                                  }
                                  if (x >
                                      (widget.dte.geneltoplam -
                                          widget.dte.odendimik)) {
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
                                  FontAwesomeIcons.moneyBill,
                                  size: 18,
                                ),
                              ),*/
                              Expanded(
                                  child: TextFormField(
                                decoration: new InputDecoration(
                                    hintText: 'Açıklama',
                                    hintStyle: Load.font(4)),
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
                                  child: Text("Vazgeç", style: Load.font(2))),
                              SizedBox(
                                width: 12,
                              ),
                              InkWell(
                                  onTap: () async {
                                    try{
         if (_formKey.currentState.validate()) {
                                      print("ggg");
                                      _formKey.currentState.save();
                                      setState(() {
                                        print("www");
                                        loadapi = true;
                                      });
                                      Odeput tp = Odeput(
                                          widget.dte.odeid,
                                          deger,
                                          widget.dte.geneltoplam,
                                          pickedDate.toString(),
                                          kas.kasaid,
                                          acikla);
                                      bool b =
                                          await APIServices.odeharguncelle(tp);
                                      //        _sfcontroller.guncelle(deger);
                                      Get.find<Alisfatcontroller>()
                                          .guncelle(widget.dte.fatid, deger);
                                      Get.find<Alisgecontroller>()
                                          .guncelle(widget.dte.fatid, deger);
                                      Get.find<Alisodenecekcontroller>()
                                          .guncelle(widget.dte.fatid, deger);
                                      print(b.toString());
                                      /*   _sfcontroller.tahsharekle(Dtoodeharfat(
                                          -1,
                                          widget.dt.odeid,
                                          pickedDate.toString(),
                                          9,
                                          "q",
                                          acikla,
                                          deger,
                                          widget.dt.cariad));*/
                                      ltah.add(Dtoodeharfat(
                                          -1,
                                          widget.dte.odeid,
                                          DateFormat.yMMMEd('tr_TR').format(
                                              DateTime.parse(pickedDate
                                                  .toString())), //         pickedDate.toString(),
                                          kas.kasaid,
                                          kas.kasaAd,
                                          acikla,
                                          deger,
                                          widget.dte.cariad));
                                      Get.find<Tedarliscontroller>()
                                          .tedarbakguncel(
                                              widget.dte.cariId, deger);
                                      print(b.toString());
                                      alin = alin + deger;
                                      widget.dte.geneltoplam - alin == 0
                                          ? durum = 1
                                          : durum = durum;
                                      Get.find<Gunceldurumcontroller>()
                                          .bakiyedeg(-deger);
                                      _kc.guncelle(kas.kasaid, -deger);
                                      deger = 0;
                                      Get.find<Alisfatcontroller>()
                                          .siradegistir(0);
                                      /*  Get.find<KasaayrintiController>().guncelle(
                                          Dtokasahar(
                                              -1,
                                              0,
                                              -deger,
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
                                      Get.find<KasaayrintiController>()
                                          .kasaarttir(-deger);*/
                                      Get.find<KasaController>()
                                          .guncelle(kas.kasaid, -deger);
                                      print("uuu");
                                      setState(() {
                                        print("www");
                                        loadapi = false;
                                      });
                                      Navigator.of(context).pop();
                                           Get.bottomSheet(
                                            ListTile(
                                              title: Text(
                                                "Ödeme başarıyla eklendi",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              trailing: Icon(Icons.coronavirus),
                                            ),
                                            backgroundColor: Colors.black26);
                                    } else {
                                      print("hfgf");
                                    }
                                    }catch(e){
  setState(() {
                                        print("xxx");
                                        loadapi = false;
                                      });
                                      Navigator.of(context).pop();
                                      Get.bottomSheet(
                                          ListTile(
                                            title: Text(
                                              "Bir hata oluştu",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            trailing: Icon(Icons.coronavirus),
                                          ),
                                          backgroundColor: Colors.black26);
                                    }
                           
                                  },
                                  child:
                                      Text("Ödeme Ekle", style: Load.font(3))),
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
        backgroundColor: Colors.brown, //Color.fromRGBO(52, 213, 235, 1),
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
                      widget.dte.fataciklama,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Row(
                      children: [
                        Text(
                          Load.numfor.format(widget.dte.geneltoplam
                              .round()), //    "${widget.dt.geneltoplam}",
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
                        Icon(
                          FontAwesomeIcons.building,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.dte.cariad,
                          style: Load.font(5),
                        ),
                      ],
                    ),
                    durum == null
                        ? CircularProgressIndicator()
                        : durum == 1 //    widget.dte.durum == 1
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
                                  style: Load.font(3),
                                ),
                              )
                            : Text("")
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
                      text: "ÖDEMELER",
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
                var sharePdf = await pdfpaylas(
                    widget.dte.cariad, widget.dte.duztarih, widget.dte, lis);
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
              buildalisode(context, size, durum == null ? 0 : durum);
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _isloading == true
                      ? Center(child: CircularProgressIndicator())
                      : Tabbilgiodewdg(
                          Dtofatode(
                              widget.dte.fatid,
                              widget.dte.fatTur,
                              durum == null ? 0 : durum,
                              widget.dte.cariId,
                              widget.dte.cariad,
                              widget.dte.duztarih,
                              widget.dte.fataciklama,
                              widget.dte.katad,
                              widget.dte.aratop,
                              widget.dte.araind,
                              widget.dte.kdv,
                              widget.dte.geneltoplam,
                              widget.dte.odenecektar,
                              widget.dte.odenmistar,
                              alin,
                              widget.dte.odeid),
                          lis,
                          size),
                  _isloading == true
                      ? Center(child: CircularProgressIndicator())
                      : Tabodemewdg(ltah)
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
