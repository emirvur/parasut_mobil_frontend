import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/controller/gdhaftacontroller.dart';
import 'package:muhmobil/controller/gdnuguncontroller.dart';
import 'package:muhmobil/controller/gunceldurumcontroller.dart';
import 'package:muhmobil/controller/mustliscontroller.dart';
import 'package:muhmobil/controller/satisfatcontroller.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:muhmobil/model/dtourun.dart';
import 'package:muhmobil/model/postfat.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/utils/load.dart';

class Yenisatisfat extends StatefulWidget {
  Yenisatisfat({this.cari});
  final Dtocarilist cari;

  @override
  _YenisatisfatState createState() => _YenisatisfatState();
}

class _YenisatisfatState extends State<Yenisatisfat> {
  int _currentStep = 0;
  StepperType _stepperType = StepperType.vertical;
  bool ids = false;
  TextEditingController conur;
  TextEditingController concari;
  TextEditingController conmik;
  TextEditingController conbrfiyat;
  TextEditingController contopl;
  TextEditingController conca;
  TextEditingController conacik;
  TextEditingController condtur;
  List<Cari> lis = [];
  List<Dtourun> lisurun = [];
  List<Dtourun> lisaraurun = [];
  List<String> liskd = ["18", "8", "1"];
  Cari ca;
  num miktar = 0;
  num brfiyat = 0;
  num toplamfi = 0;
  num aratop = 0;
  num kdvtop = 0;
  num gentop = 0;
  DateTime pickedDate;
  ValueNotifier<int> _counter;
  bool tarsecil = false;
  String kdvkac = "18";
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  Future cariara(String ar) async {
    lis = await APIServices.mustara(ar);
  }

  Widget _dropdownbutton(List<String> liskd) {
    return Container(
      height: 60,
      padding: EdgeInsets.all(1),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
        //    borderRadius: BorderRadius.all(Radius.circular(15.0) //),
      ),
      child: DropdownButton<String>(
        value: kdvkac ?? "18",
        underline: SizedBox(),
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down),
        onChanged: (String value) {
          kdvkac = value ?? "18";
          num x = num.tryParse(conbrfiyat.text);
          print("birr");
          print(x.toString());
          num m = num.tryParse(conmik.text);
          num bf = num.tryParse(conbrfiyat.text);
          print(bf.toString());
          num k = num.tryParse(kdvkac);
          print(k.toString());
          num ek = (bf * k) / 100;
          num to = m * (bf + ek);
          contopl.text = to.toString();
          /*  contopl.text = ((num.tryParse(conbrfiyat.text) +
                      (num.tryParse(conbrfiyat.text) *
                          num.tryParse(kdvkac) /
                          100)) *
                  num.tryParse(conmik.text))
              .toString();*/
          setState(() {
            _counter.value++;
          });
        },
        items: liskd.map((String user) {
          return DropdownMenuItem<String>(
            value: user ?? "",
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  user,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Future urunara(String ar) async {
    lisaraurun = await APIServices.urunara(ar);
  }

  Future buildcari(BuildContext context, Size size, int tahsflag) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: size.height / 3,
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  //   mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                        decoration: InputDecoration(
                            labelText: 'Müşterilerde ara...',
                            labelStyle: TextStyle(color: Colors.black)),
                        controller: concari,
                        onChanged: (v) async {
                          setState(() {
                            print("eee");
                            //_isloading = true;
                          });
                          await cariara(v);

                          setState(() {
                            print("uuu");
                            // _isloading = false;
                          });
                        }),
                    ListView.builder(
                        //  physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: lis == null ? 0 : lis.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              //  color: Colors.grey[200],
                              child: Column(
                            children: [
                              ListTile(
                                leading: Icon(FontAwesomeIcons.building),
                                onTap: () {
                                  ca = lis[index];
                                  conca.text = ca.cariunvani ?? "";
                                  conur.clear();
                                  lis = [];
                                  Navigator.of(context).pop();
                                  //   print(securun.birim);
                                },
                                title: Text(
                                  lis[index].cariunvani ?? "",
                                ),
                              ),
                              Divider()
                            ],
                          ));
                        }),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future buildurunsec(BuildContext context, Size size, int tahsflag) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: Container(
              height: size.height / 3,
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  //   mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                        decoration: InputDecoration(
                            labelText: 'Ürünlerde ara...',
                            labelStyle: TextStyle(color: Colors.black)),
                        controller: conur,
                        onChanged: (v) async {
                          setState(() {
                            print("eee");
                            //_isloading = true;
                          });
                          await urunara(v);

                          setState(() {
                            print("uuu");
                            // _isloading = false;
                          });
                        }),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: lisaraurun == null ? 0 : lisaraurun.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              //  color: Colors.grey[200],
                              child: Column(
                            children: [
                              ListTile(
                                leading: Icon(FontAwesomeIcons.thLarge),
                                onTap: () {
                                  //  lisurun.add(lisaraurun[index]);
                                  Dtourun d = lisaraurun[index];
                                  lisaraurun = [];
                                  Navigator.of(context).pop();
                                  conmik.text = 1.toString();
                                  // d.adet.toString();
                                  conbrfiyat.text = d.verharsat.toString();
                                  contopl.text = ((d.verharsat +
                                              (d.verharsat * d.kdv) / 100) *
                                          1)
                                      .toString();

                                  print(d.kdv.toInt().toString());
                                  kdvkac = d.kdv.toInt().toString();
                                  conur.clear();

                                  buildurunayrinti(context, size, d);
                                },
                                title: Text(
                                  "${lisaraurun[index].adi}",
                                ),
                              ),
                              Divider()
                            ],
                          ));
                        }),
                  ],
                ),
              ),
            ));
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _counter = ValueNotifier<int>(0);
    conur = TextEditingController();
    concari = TextEditingController();
    conacik = TextEditingController();
    conca = TextEditingController(
        text: widget.cari == null ? "" : widget.cari.cariunvani);
    condtur = TextEditingController();
    conmik = TextEditingController();
    conbrfiyat = TextEditingController();
    contopl = TextEditingController();
    pickedDate = DateTime.now();
    if (widget.cari != null) {
      ca = Cari(widget.cari.cariId, widget.cari.cariunvani, "", 1, "", "", "",
          "", "", 1, "", 0);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _counter = ValueNotifier<int>(0);
    conur.dispose();
    concari.dispose();
    conca.dispose();
    conacik.dispose();
    condtur.dispose();
    conmik.dispose();
    conbrfiyat.dispose();
    contopl.dispose();
    super.dispose();
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
        tarsecil = true;
        pickedDate = date;
      });
  }

  Future buildurunayrinti(BuildContext context, Size size, Dtourun d) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
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
                    // Column(
                    //     children: [
                    Text(d.adi, style: Load.font(4)), //       ),
                    Spacer(),
                    Text("Stokta:${d.adet} ${d.birim} kaldı",
                        style: Load.font(4)),
                    //       ],

                    //   Text("fss", style: Load.font(4)),
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
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              onChanged: (b) {
                                var y = num.tryParse(b);
                                if (y.toString() == "null") {
                                  conmik.text = "";
                                  contopl.text = "";
                                  //   (num.tryParse(conbrfiyat.text) *
                                  //         num.tryParse(conmik.text))
                                  //         .toString();
                                  setState(() {});
                                } else {
                                  int x = y;
                                  conmik.text = x.toString();

                                  //
                                  print("birr");
                                  print(x.toString());
                                  num m = num.tryParse(conmik.text);
                                  num bf = num.tryParse(conbrfiyat.text);
                                  print(bf.toString());
                                  num k = num.tryParse(kdvkac);
                                  print(k.toString());
                                  num ek = (bf * k) / 100;
                                  print(ek.toString());
                                  num to = m * (bf + ek);
                                  print(to.toString());
                                  contopl.text = to.toString();
                                  /*   contopl
                                      .text = ((num.tryParse(conbrfiyat.text) +
                                              (num.tryParse(conbrfiyat.text) *
                                                  num.tryParse(kdvkac) /
                                                  100)) *
                                          num.tryParse(conmik.text))
                                      .toString();*/

                                  setState(() {
                                    conmik.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: conmik.text.length));
                                  });
                                }
                              },
                              onSaved: (v) {
                                miktar = num.tryParse(v);
                              },
                              controller: conmik,
                              decoration: InputDecoration(
                                  labelText: 'Miktar',
                                  labelStyle: TextStyle(color: Colors.black)),
                              //   controller: conur,
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              onChanged: (b) {
                                var y = num.tryParse(b);
                                if (y.toString() == "null") {
                                  conbrfiyat.text = "";
                                  contopl.text = "";
                                  //          (num.tryParse(conbrfiyat.text) *
                                  //                    num.tryParse(conmik.text))
                                  //            .toString();
                                  setState(() {});
                                } else {
                                  int x = y;
                                  conbrfiyat.text = x.toString();
                                  print("birr");
                                  print(x.toString());
                                  num m = num.tryParse(conmik.text);
                                  num bf = num.tryParse(conbrfiyat.text);
                                  print(bf.toString());
                                  num k = num.tryParse(kdvkac);
                                  print(k.toString());
                                  num ek = (bf * k) / 100;
                                  num to = m * (bf + ek);
                                  contopl.text = to.toString();
                                  /*     contopl
                                      .text = ((num.tryParse(conbrfiyat.text) +
                                              (num.tryParse(conbrfiyat.text) *
                                                  num.tryParse(kdvkac) /
                                                  100)) *
                                          num.tryParse(conmik.text))
                                      .toString();*/
                                  setState(() {
                                    conbrfiyat.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: conbrfiyat.text.length));
                                  });
                                }
                              },
                              onSaved: (v) {
                                brfiyat = num.tryParse(v).toInt();
                              },
                              controller: conbrfiyat,
                              decoration: InputDecoration(
                                  labelText: 'Birim Fiyat',
                                  labelStyle: TextStyle(color: Colors.black)),
                              //   controller: conur,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("KDV")),
                                  ValueListenableBuilder(
                                      valueListenable: _counter,
                                      builder: (context, value, child) {
                                        return _dropdownbutton(liskd);
                                      }),
                                ],
                              )
                              /*TextFormField(
                              onSaved: (v) {},
                              decoration: InputDecoration(
                                  labelText: 'Kdv',
                                  labelStyle: TextStyle(color: Colors.black)),
                              //   controller: conur,
                            ),*/
                              ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              readOnly: true,
                              onSaved: (v) {
                                toplamfi = num.tryParse(v).toInt();
                              },
                              controller: contopl,
                              decoration: InputDecoration(
                                  labelText: 'Toplam Fiyat',
                                  labelStyle: TextStyle(color: Colors.black)),
                              //   controller: conur,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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

                                  lisurun.add(Dtourun(
                                      d.barkodno,
                                      d.adi,
                                      d.kategoriId,
                                      d.katad,
                                      d.birim,
                                      miktar,
                                      0,
                                      0,
                                      brfiyat,
                                      num.tryParse(kdvkac)));
                                  aratop = aratop + brfiyat * miktar;
                                  //   kdvtop = (kdvtop + brfiyat * 18) / 100;
                                  gentop = gentop + toplamfi;
                                  //           (aratop +
                                  //                 (aratop *   num.tryParse(kdvkac) /100));

                                  Navigator.of(context).pop();
                                } else {
                                  print("hfgf");
                                }
                              },
                              child: Text("Kaydet", style: Load.font(3))),
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
        }).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("qqq");
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: InkWell(
            onTap: () {
              _pickDate();
            },
            child: Text("Yeni Fatura", style: Load.font(4))),
      ),
      body: LoadingOverlay(
        isLoading: _isloading,
        opacity: Load.opacit,
        progressIndicator: Load.prog,
        child: Container(
          //  color: Colors.orangeAccent,
          child: Column(
            children: [
              Expanded(
                  child: Stepper(
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _currentStep != 0
                            ? RaisedButton(
                                onPressed: onStepCancel,
                                textColor: Colors.white,
                                color: Colors.blue,
                                child: Text('Önceki', style: Load.font(4)),
                              )
                            : Text(""),
                        RaisedButton(
                          onPressed: () {
                            _currentStep == 3 ? buildOnkaydet() : continued();
                          },
                          //    _currentStep == 3 ? buildOnkaydet() : continued,
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text(_currentStep == 3 ? "Kaydet" : 'Sonraki',
                              style: Load.font(4)),
                        ),
                      ],
                    ),
                  );
                },
                type: _stepperType,
                currentStep: _currentStep,
                physics: ScrollPhysics(),
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: canceled,
                steps: <Step>[
                  Step(
                      title: Text(
                        "Müşteri",
                        style: Load.font(0),
                      ),
                      content: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Hangi müşterinize satış yapıyorsunuz?",
                                style: Load.font(0),
                              )),
                          TextFormField(
                              onTap: () {
                                buildcari(context, size, 0);
                              },
                              readOnly: true,
                              controller: conca,
                              onChanged: (v) {
                                //   buildsatisfattahs(context, size, 0);
                              },
                              decoration: InputDecoration(
                                  hintText: 'Müşteri Ekle',
                                  hintStyle: TextStyle(color: Colors.black))),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled),
                  Step(
                      title: Text(
                        "Hizmet/Ürün",
                        style: Load.font(0),
                      ),
                      content: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Ne satıyorsunuz",
                              style: Load.font(0),
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              buildurunsec(context, size, 0);
                            },
                            decoration: InputDecoration(
                                hintText: 'Yeni ürün ekle...',
                                hintStyle: TextStyle(color: Colors.black)),
                          ),
                          Container(
                            height: 150,
                            //  color: Colors.yellow,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                //  physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: lisurun == null ? 0 : lisurun.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: ListTile(
                                      onTap: () {},
                                      title: Text(
                                          "${lisurun[index].adi} x ${lisurun[index].adet}",
                                          style: Load.font(4)),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled),
                  Step(
                      title: Row(
                        children: [
                          Text(
                            "Genel Toplam",
                            style: Load.font(0),
                          ),
                        ],
                      ),
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Ara Toplam", style: Load.font(4)),
                                Text(Load.numfor.format(aratop.round()),
                                    style: Load.font(4)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Kdv Toplam", style: Load.font(4)),
                                Text(
                                    Load.numfor
                                        .format((gentop - aratop).round()),
                                    style: Load.font(4)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Genel Toplam", style: Load.font(4)),
                                Text(Load.numfor.format(gentop.round()),
                                    style: Load.font(4)),
                              ],
                            ),
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 3
                          ? StepState.complete
                          : StepState.disabled),
                  Step(
                      title: Text(
                        "Açıklama",
                        style: Load.font(0),
                      ),
                      content: Column(
                        children: [
                          TextFormField(
                            controller: conacik,
                            decoration: InputDecoration(labelText: 'Açıklama'),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  _pickDate().then((value) {
                                    setState(() {
                                      tarsecil = true;
                                    });
                                  });
                                },
                                child: Text(tarsecil == false
                                    ? "Tahsilat tarihi ekle ${pickedDate.day}-${pickedDate.month}-${pickedDate.year}"
                                    : "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}"),
                              ),
                              IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.calendar,
                                  ),
                                  onPressed: () {
                                    _pickDate().then((value) {
                                      setState(() {
                                        tarsecil = true;
                                      });
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled),
                ],
              )),
            ],
          ),
        ),
      ),
      /*  floatingActionButton: FloatingActionButton(
        child: Icon(Icons.list),
        onPressed: () => tapped(_currentStep + 1),
      ),*/
    );
  }

  void buildOnkaydet() async {
    print("rr");
    setState(() {
      _isloading = true;
    });
    Postfatura1 p = Postfatura1(
        1,
        conacik.text ?? "",
        ca.cariId,
        DateTime.now().toString(),
        1,
        aratop,
        0,
        gentop - aratop,
        gentop,
        null,
        /*   tahsett ==
                                                                            true
                                                                        ? kas
                                                                            .kasaid
                                                                        : 9,*/
        9,
        0, //   tahsett == true ? 1 : 0,
        pickedDate.toString(), //  pickedDate.toString(),
        null,
        "", //tahsett == true ? tahsacik : "",
        0, //  tahsett == true ? aratop + topkdv : 0,
        gentop);
    List<Hareket> listur = [];
    for (int i = 0; i < lisurun.length; i++) {
      listur.add(Hareket(
          barkodno: lisurun[i].barkodno,
          miktar: lisurun[i].adet,
          brfiyat: lisurun[i].verharsat,
          vergi: lisurun[i].kdv));
    }
    Postfatura pf = Postfatura(p, listur);

    /*    Urunhareket ur1 =
                                                              Urunhareket(
                                                            -1,
                                                          );*/
    List<int> h = await APIServices.faturaekle(pf);

    print(h[0]);
    print("uuyytrgr");
    print(h[1]);
    Get.find<Satistahscontroller>().satffattahsekleyeni(Dtofattahs(
        h[0],
        1,
        0,
        ca.cariId,
        ca.cariunvani,
        DateTime.now().toString(),
        conacik.text,
        "",
        aratop,
        0,
        gentop - aratop,
        gentop,
        pickedDate.toString(),
        null,
        0,
        h[1]));
    Get.find<Mustliscontroller>().mustbakguncel(ca.cariId, -gentop);
    Get.find<Satisfatcontroller>().satffattumekleyeni(Dtofattahs(
        h[0],
        1,
        0,
        ca.cariId,
        ca.cariunvani,
        DateTime.now().toString(),
        conacik.text,
        "",
        aratop,
        0,
        gentop - aratop,
        gentop,
        pickedDate.toString(),
        null,
        0,
        h[1]));
    Get.find<Satisgecicontroller>().satffatgeciekleyeni(Dtofattahs(
        h[0],
        1,
        0,
        ca.cariId,
        ca.cariunvani,
        DateTime.now().toString(),
        conacik.text,
        "",
        aratop,
        0,
        gentop - aratop,
        gentop,
        pickedDate.toString(),
        null,
        0,
        h[1]));
    Get.find<Satisfatcontroller>().siradegistir(0);

    Get.find<Gunceldurumcontroller>().aysatguncelle(gentop);
    Get.find<Gdhaftacontroller>().haftasatguncelle(gentop);
    Get.find<Gdbuguncontroller>().gunsatguncelle(gentop);
    Navigator.of(context).pop();
  }

  tapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  void continued() {
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  void canceled() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
