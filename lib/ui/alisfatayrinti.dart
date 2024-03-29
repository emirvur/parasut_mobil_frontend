import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/dtofatode.dart';
import 'package:muhmobil/model/dtoodeharfat.dart';
import 'package:muhmobil/model/dtourunhareket.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/odeput.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:intl/intl.dart';

class Alisfatayrinti extends StatefulWidget {
  final Dtofatode dt;
  Alisfatayrinti(this.dt);
  @override
  _AlisfatayrintiState createState() => _AlisfatayrintiState();
}

class _AlisfatayrintiState extends State<Alisfatayrinti>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TabController _tabController;
  List<Dtourunhareket> lis = [];
  List<Dtoodeharfat> ltah = [];
  bool _isloading = true;
  ValueNotifier<int> _counter;
  // bool tahsilform = false;
  DateTime selectedDate = DateTime.now();
  TextEditingController contar;
  GlobalKey _toolTipKey = GlobalKey();
  //List<Kasa> kasalist = [];
  //Kasa kas = Kasa(1, "", 1);
  String acikla = "";
  num deger;
  TextEditingController conacik;
  TextEditingController condeg;
  List<Kasa> kasalist = [];
  Kasa kas = Kasa(1, "", 1);
  DateTime pickedDate;

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
    pickedDate = DateTime.now();
    _counter = ValueNotifier<int>(0);
    _tabController = TabController(vsync: this, length: 2);
    contar = TextEditingController();
    conacik = TextEditingController();
    condeg = TextEditingController(
        text: (Load.numfor.format(
                widget.dt.geneltoplam.round() - widget.dt.odendimik.round()))
            .toString());
    Future.wait([
      APIServices.odeharfaticin(widget.dt.odeid),
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
                        Navigator.of(context).pop();
                        buildodesekle(context, size);
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
                                  hintText: 'Meblağ', hintStyle: Load.font(4)),
                              validator: (value) {
                                print("uu");
                                var x = num.tryParse(value);
                                if (x == null) {
                                  return "Lütfen geçerli bir sayı giriniz";
                                }
                                if (x >
                                    (widget.dt.geneltoplam -
                                        widget.dt.odendimik)) {
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
                                  if (_formKey.currentState.validate()) {
                                    print("ggg");
                                    _formKey.currentState.save();
                                    Odeput tp = Odeput(
                                        widget.dt.odeid,
                                        deger,
                                        widget.dt.geneltoplam,
                                        pickedDate.toString(),
                                        kas.kasaid,
                                        acikla);
                                    bool b =
                                        await APIServices.odeharguncelle(tp);
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
        });
  }

  @override
  Widget build(BuildContext context) {
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
                buildalisode(context, size, widget.dt.durum);
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
                      Tabbilgiodewdg(widget.dt, lis, size),
                      Tabodemewdg(ltah),
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

class Tabbilgiodewdg extends StatelessWidget {
  final Dtofatode dt;
  final List<Dtourunhareket> lisuh;
  final Size size;
  Tabbilgiodewdg(this.dt, this.lisuh, this.size);

  @override
  Widget build(BuildContext context) {
    //   var saat1 = DateFormat.jm('tr_TR').format(DateTime.parse(dt.odenecektar));
    var yil1 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(
        dt.odenecektar == "null" ? DateTime(2000).toString() : dt.odenecektar));
    var u = yil1; // + "-" + saat1;
    var g = dt.odenecektar == "null" ? "s" : u;
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
                        text: "Ödeme Tarihi  ",
                      ),
                      TextSpan(
                        style: Load.font(2),
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
                        style: Load.font(2),
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
                      /* leading: Container(
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
                    ),*/
                      title: Text.rich(
                        TextSpan(
                          //   style: TextStyle(
                          //       fontSize: 17,
                          //       ),
                          children: [
                            TextSpan(
                              style: TextStyle(color: Colors.black87),
                              text: urha.ad,
                            ),
                            TextSpan(
                              // style: TextStyle(color: Colors.black87),
                              text: " x ",
                            ),
                            TextSpan(
                              style: Load.font(2),
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
                            Load.numfor.format(topl.round()), //    "${topl}",
                            style: Load.font(0),
                          ),
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 12,
                          )
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
                          Icon(FontAwesomeIcons.liraSign, size: 18),
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
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 18,
                          )
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
                          Text(
                              Load.numfor.format(dt.geneltoplam
                                  .round()), //dt.geneltoplam.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 18,
                          )
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
                              Load.numfor.format(dt.geneltoplam.round() -
                                  dt.odendimik.round()),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            FontAwesomeIcons.liraSign,
                            size: 18,
                          )
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
  }
}

class Tabodemewdg extends StatelessWidget {
  final List<Dtoodeharfat> dt;
  Tabodemewdg(this.dt);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: dt.length,
      itemBuilder: (context, index) {
        Dtoodeharfat th = dt[index];
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
                  child: Icon(FontAwesomeIcons.arrowUp, color: Colors.blue),
                ),
                title: Text(
                  "${th.kasaad}",
                  style: Load.font(0),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Text(
                  " ${th.odenmistar}",
                  style: Load.font(1),
                ),
                trailing: Text(
                  Load.numfor
                      .format(th.odendimik.round()), //     "${th.odendimik}",
                  style: Load.font(0),
                ),
              ),
            ));
      },
    );
    // );
  }
}
