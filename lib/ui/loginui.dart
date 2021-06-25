import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muhmobil/ui/home.dart';
import 'package:muhmobil/ui/splashui.dart';
import 'package:muhmobil/utils/createpdf.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginui extends StatefulWidget {
  @override
  _LoginuiState createState() => _LoginuiState();
}

class _LoginuiState extends State<Loginui> {
  final _formKey = GlobalKey<FormState>();

  Future<bool> sharprefset() async {
    print("ee");
    SharedPreferences sp = await SharedPreferences.getInstance();
    var islogin = sp.setBool("islogin", true);
    print("uu");
    return islogin;
  }

  Future<bool> sharprefsifirla() async {
    print("ee");
    SharedPreferences sp = await SharedPreferences.getInstance();
    var islogin = sp.setBool("islogin", false);
    print("uu");
    return islogin;
  }

  @override
  Widget build(BuildContext context) {
    print("login uida");
    final size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: FlutterLogo(
                  size: 64,
                ),
              ),
              SizedBox(
                height: size.height / 10,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Bu uygulama hiçbir şekilde ticari amaç için kullanılamaz.Eğitim amacıyla yapılmıştır.Öneri ve şikayetlerinizi emirvur97@gmail.com adresine iletebilirsiniz.Ticari amaçlı ön muhasebe programı için Paraşüt uygulamasına göz atabilirsiniz",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Giriş yapmak için e-posta: deneme@gmail.com parola: deneme olmalıdır",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    height: size.height / 3,
                    //  color: Colors.white,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Lütfen E-posta adresi giriniz";
                                }
                                if (value != "deneme@gmail.com") {
                                  return "Lütfen geçerli bir mail adresi giriniz";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                //      hintText: "E-posta adresiniz",
                                // helperText: "helerp",
                                labelText: "E-posta adresiniz",
                                prefixIcon: Icon(FontAwesomeIcons.envelope),
                              )),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Lütfen şifrenizi giriniz";
                              }
                              if (value != "deneme") {
                                return "Lütfen geçerli bir şifre giriniz";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                // hintText: "Parola",
                                //  helperText: "helerp",
                                labelText: "Parola",
                                prefixIcon: Icon(FontAwesomeIcons.key)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    await sharprefset();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Splash()),
                                    );
                                  }
                                  /*       var z = await izlemepdf();
                                  PDFViewer(
                                    document: z,
                                    zoomSteps: 1,
                                  );
                                  var sharePdf = await ekstrepdf();
                                  await Share.file(
                                    'PDF Document',
                                    'project.pdf',
                                    sharePdf,
                                    ',  //bu satiri sildim
                              //    );*/
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                child: Text(
                                  "Oturum aç",
                                  style: Load.font(0),
                                )),
                          )
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: 48,
              )
            ],
          ),
        )));
  }
}
