import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:muhmobil/controller/tedarliscontroller.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/model/dtourun.dart';
import 'package:muhmobil/model/postfat.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/utils/load.dart';

class Yenitedarikci extends StatefulWidget {
  @override
  _YenitedarikciState createState() => _YenitedarikciState();
}

class _YenitedarikciState extends State<Yenitedarikci> {
  int _currentStep = 0;
  StepperType _stepperType = StepperType.vertical;
  bool ids = false;
  TextEditingController conmail;
  TextEditingController coniban;
  TextEditingController contc;
  TextEditingController contel;
  TextEditingController confirma;
  TextEditingController conkisaisim;
  TextEditingController conadres;
  List<Cari> lis = [];
  List<Dtourun> lisurun = [];
  List<Dtourun> lisaraurun = [];
  Cari ca;
  num miktar;
  num brfiyat;
  num toplamfi;
  num aratop = 0;
  num kdvtop = 0;
  num gentop = 0;
  DateTime pickedDate;
  bool _isloading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conadres = TextEditingController();
    coniban = TextEditingController();
    contc = TextEditingController();
    confirma = TextEditingController();
    conkisaisim = TextEditingController();
    contel = TextEditingController();
    conmail = TextEditingController();
    pickedDate = DateTime.now();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    conadres.dispose();
    coniban.dispose();
    contc.dispose();
    confirma.dispose();
    conkisaisim.dispose();
    contel.dispose();
    conmail.dispose();
    super.dispose();
  }

  _pickDate() async {
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
            child: Text("Yeni Tedarikçi", style: Load.font(4))),
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
                            _currentStep == 1 ? buildOnkaydet() : continued();
                          },
                          //    _currentStep == 3 ? buildOnkaydet() : continued,
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text(_currentStep == 1 ? "Kaydet" : 'Sonraki',
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
                        "Tedarikçi",
                        style: Load.font(0),
                      ),
                      content: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                                validator: (value) {
                                  print("uu");
                                  if (value.isEmpty) {
                                    return "Bu alan boş bırakılamaz";
                                  }

                                  return null;

                                  // validation logic
                                },
                                controller: confirma,
                                onChanged: (v) {
                                  //   buildsatisfattahs(context, size, 0);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Firma Unvanı',
                                    labelStyle:
                                        TextStyle(color: Colors.black))),
                            TextFormField(
                                validator: (value) {
                                  print("uu");
                                  if (value.isEmpty) {
                                    return "Bu alan boş bırakılamaz";
                                  }

                                  return null;

                                  // validation logic
                                },
                                controller: conkisaisim,
                                onChanged: (v) {
                                  //   buildsatisfattahs(context, size, 0);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Kısa isim',
                                    labelStyle:
                                        TextStyle(color: Colors.black))),
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Telefon Numarası",
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.black,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 5,
                                    minHeight: 5,
                                  )),

                              controller: contel,
                              onChanged: (v) {
                                //   buildsatisfattahs(context, size, 0);
                              },
                              //                 decoration: InputDecoration(
                              //                   labelText: 'Telefon Numarası',
                              //                 labelStyle: TextStyle(color: Colors.black))
                            ),
                            TextFormField(
                              controller: conmail,
                              onChanged: (v) {
                                //   buildsatisfattahs(context, size, 0);
                              },
                              decoration: InputDecoration(
                                  hintText: "E-posta",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 5,
                                    minHeight: 5,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled),
                  Step(
                      title: Text(
                        "",
                        style: Load.font(0),
                      ),
                      content: Column(
                        children: [
                          TextFormField(
                              controller: conadres,
                              onChanged: (v) {
                                //   buildsatisfattahs(context, size, 0);
                              },
                              decoration: InputDecoration(
                                  labelText: 'ADRES',
                                  labelStyle: TextStyle(color: Colors.black))),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: "TCKN-VERGİ NO",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.accusoft,
                                  color: Colors.black,
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 5,
                                  minHeight: 5,
                                )),

                            controller: contc,
                            onChanged: (v) {
                              //   buildsatisfattahs(context, size, 0);
                            },
                            //                 decoration: InputDecoration(
                            //                   labelText: 'Telefon Numarası',
                            //                 labelStyle: TextStyle(color: Colors.black))
                          ),
                          TextFormField(
                            controller: coniban,
                            onChanged: (v) {
                              //   buildsatisfattahs(context, size, 0);
                            },
                            decoration: InputDecoration(
                                hintText: "IBAN",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.piggyBank,
                                  color: Colors.black,
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 5,
                                  minHeight: 5,
                                )),
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
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
    if (_formKey.currentState.validate()) {
      setState(() {
        _isloading = true;
      });
      Cari car = Cari(
          -1,
          confirma.text,
          conkisaisim.text,
          1,
          conmail.text ?? "",
          contel.text ?? "",
          "",
          coniban.text ?? "",
          conadres.text ?? "",
          0, //     tuzelmi == true
          //           ? 0
          //             : 1,
          contc.text ?? "",
          0);
      int x = await APIServices.tedarekl(car);
      Get.find<Tedarliscontroller>()
          .yenitedar(Dtocarilist(x, confirma.text, "", 0));
      Navigator.of(context).pop();
    }
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
