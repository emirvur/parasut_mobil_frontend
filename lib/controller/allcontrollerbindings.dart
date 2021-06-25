import 'package:get/get.dart';
import 'package:muhmobil/controller/gdhaftacontroller.dart';
import 'package:muhmobil/controller/gdnuguncontroller.dart';
import 'package:muhmobil/controller/gunceldurumcontroller.dart';
import 'package:muhmobil/controller/mustliscontroller.dart';
import 'package:muhmobil/controller/satisfatcontroller.dart';
import 'package:muhmobil/controller/tedarliscontroller.dart';
import 'package:muhmobil/model/dtofattahs.dart';

import 'alisfatcontroller.dart';

class AllControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Satisfatcontroller>(
      () => Satisfatcontroller(),
    );
    Get.lazyPut<Alisfatcontroller>(() => Alisfatcontroller());
    Get.lazyPut<Satistahscontroller>(() => Satistahscontroller());
    Get.lazyPut<Alisodenecekcontroller>(() => Alisodenecekcontroller());
    Get.lazyPut<Mustliscontroller>(() => Mustliscontroller());
    Get.lazyPut<Tedarliscontroller>(() => Tedarliscontroller());
    Get.lazyPut<Satisgecicontroller>(() => Satisgecicontroller());
    Get.lazyPut<Alisgecontroller>(() => Alisgecontroller());
    Get.lazyPut<Gunceldurumcontroller>(() => Gunceldurumcontroller());
    Get.lazyPut<Gdhaftacontroller>(() => Gdhaftacontroller());
    Get.lazyPut<Gdbuguncontroller>(() => Gdbuguncontroller());
  }
}
