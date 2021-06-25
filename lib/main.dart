import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:muhmobil/controller/alisfatcontroller.dart';
import 'package:muhmobil/controller/kasacontroller.dart';
import 'package:muhmobil/controller/satisfatcontroller.dart';
import 'package:muhmobil/ui/ders.dart';
import 'package:muhmobil/ui/gunceldurum.dart';
import 'package:muhmobil/ui/home.dart';
import 'package:muhmobil/ui/kasalist.dart';
import 'package:muhmobil/ui/loginui.dart';
import 'package:muhmobil/ui/onboarding.dart';
import 'package:muhmobil/ui/splashui.dart';
import 'package:muhmobil/ui/urunlist.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/allcontrollerbindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  var islog = sp.getBool("islogin" ?? false);
  HttpOverrides.global = new MyHttpOverrides();
  //irsaliye uida irsaliye ara api ekle++++
//kasalist ara+++++
//sign out++
//splash login pushandremoveuntil++
//must ayrinti tahsharguncelle tahsput+++
//tedar ayrinti odeput+++
//urunayrintdda tahshar ne alaka+++
//yeni alis be satta toplam fiyatlar hareket ile uyusuyor mu+++
//apide her requesti 401 ve 404 ile uyumlu yap
//syf getx guncelleme
//gecikmis satisfatta odendi nasıl oluyor+++
//satis subtitle tasma  --cari ayrınıtda tasma+++
//fat ayriti kalan genel toplam uyusuyoe mu+++
//pdf turkce karkter++++
//fat small phone iki tasma+++
//yenifatlarda buyuk telefonda test et textsizei
//yenifatlarda urun musteri controllerı aynı   -- ikonları degistirebilitsin ++++
//yeni fattaa --urun ekleyince genel toplam uyuusuyro mu+++
//cari hesaplar aradan sonra ayrıntıya gitmiyor++++
//cari hesap ayrıntı bottom sheet tasma++++
//barkod test et+++
//verileri tek tek kontrol et
//irsaliye toplu fatta cari sedicne hata veriyor+++
//fatlarda kaydet islevi yok+++
//fat ayrınıtda uurn coksa tasma oluyor mu
//irsaliye fatta liste uuzunsa tsama
//yeni fat controllerı temizle
//ekran rotate
//kasa id 9 olsun muhakkak
//gunceldurum bu hafta range
//acikaamda uzunkuk kontorlu sql icin
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode
  runApp(
      /*DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(islog), // Wrap your app
  ));*/
      MyApp(islog));
}

//https://stackoverflow.com/questions/14865568/currency-format-in-dart
//https://stackoverflow.com/questions/50654195/flutter-one-time-intro-screen
//https://rrtutors.com/tutorials/send-email-with-attachment-flutter
/*
        InkWell(
                          onTap: () async {
                            String barcodeScanRes =
                                await FlutterBarcodeScanner.scanBarcode(
                                    "", "", false, ScanMode.BARCODE);
                            print(barcodeScanRes);
                          },
                          child: InkWell(
                              onTap: () {
                                List x = [];
                                List y = [];
                                createPDF1("ww", "fdd", x, y).then((pdf) async {
                                  final file = File("example.pdf");
                                  await file.writeAsBytes(await pdf.save());
                                  PDFDocument document;
                                  document = await PDFDocument.fromAsset(
                                      'example.pdf');
                                  PDFViewer(
                                    document: document,
                                    zoomSteps: 1,
                                  );
                                });
                              },
                              child: Text("fatura acıkalamas")))

*/

class MyApp extends StatelessWidget {
  final bool islog;
  MyApp(this.islog);
  @override
  Widget build(BuildContext context) {
    // initializeDateFormatting('tr');
    return GetMaterialApp(
        initialBinding: AllControllerBinding(),
        locale: DevicePreview.locale(context), // Add the locale here
        builder: DevicePreview.appBuilder,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('tr'), // English, no country code
        ],
        //  locale: const Locale('tr'),
        title: 'Klon Muhasebe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: islog == true ? Splash() : Loginui());
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
