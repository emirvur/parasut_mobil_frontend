import 'package:get/get.dart';
import 'package:muhmobil/model/gunceldurummod.dart';
import 'package:muhmobil/services/apiservices.dart';

class Gdhaftacontroller extends GetxController {
  var isLoading = true.obs;
  DateTime bugun;
  DateTime buhaftabas;
  DateTime buhaftason;
  var gecicisat = List<Gunceldurummod>().obs;
  var gecicigider = List<Gunceldurummod>().obs;
  num bakiye = 0.obs();

  @override
  void onInit() {
    print("satistahscontt init");
    fetchfinaltodo();
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      bugun = DateTime.now();
      bugun = DateTime(bugun.year, bugun.month, bugun.day);
      buhaftabas =
          DateTime(bugun.year, bugun.month, bugun.day - bugun.weekday + 1);
      buhaftason =
          bugun.add(Duration(days: DateTime.daysPerWeek - bugun.weekday));
      var todos = await APIServices.callstp(buhaftabas, buhaftason);
      bakiye = await APIServices.kasabakiye();
      if (todos != null) {
        List v = todos.where((i) => i.tur == 1).toList();
        print(v.length.toString());
        v.length == 0
            ? gecicisat.value = [Gunceldurummod(0, 0, 0, 0, 1)]
            : gecicisat.value = todos.where((i) => i.tur == 1).toList();

        List y = todos.where((i) => i.tur == 0).toList();
        print(y.length.toString());
        y.length == 0
            ? gecicigider.value = [Gunceldurummod(0, 0, 0, 0, 0)]
            : gecicigider.value = todos.where((i) => i.tur == 0).toList();
      }
    } finally {
      isLoading(false);
    }
  }

  void haftasatguncelle(num deg) async {
    isLoading(true);
    print("trydan once");

    try {
      print("tryddadsad");
      gecicisat[0].toplammiktar = gecicisat[0].toplammiktar + deg;
      gecicisat[0].fatsayisi = gecicisat[0].fatsayisi + 1;
    } finally {
      isLoading(false);
    }
  }

  void haftaalisguncelle(num deg) async {
    isLoading(true);
    print("trydan once");

    try {
      print("tryddadsad");
      gecicigider[0].toplammiktar = gecicigider[0].toplammiktar + deg;
      gecicigider[0].fatsayisi = gecicigider[0].fatsayisi + 1;
    } finally {
      isLoading(false);
    }
  }
  /*void guncelle(int index, num deg) async {
    isLoading(true);
    print("trydan once");

    try {
      print("tryddadsad");
      for (var i in listdtofatta) {
        print("fordaa");
        if (i.fatid == index) {
          if (i.geneltoplam - i.alinmism == deg) {
            i.durum = 1;
            //sattahsta kaldır
            //   listdtofatta.removeWhere((item) => item.fatid == '001');
            listdtofatta.remove(i);
          }
          i.alinmism = i.alinmism + deg;
        }

        print("cıkrtııt");
      }
      tahsmik = tahsmik - deg;
    } finally {
      isLoading(false);
    }
  }

  void satffatgeciekleyeni(Dtofattahs yeni) async {
    isLoading(true);
    print("trydan once");

    try {
      print("tryddadsad");
      if (DateTime.tryParse(yeni.vadta).isBefore(DateTime.now())) {
        print("ifteee");
        listdtofatta.add(yeni);
      }
    } finally {
      isLoading(false);
    }
  }*/
}
