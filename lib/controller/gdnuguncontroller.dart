import 'package:get/get.dart';
import 'package:muhmobil/model/gunceldurummod.dart';
import 'package:muhmobil/services/apiservices.dart';

class Gdbuguncontroller extends GetxController {
  var isLoading = true.obs;
  DateTime bugun;
  DateTime bugece;
  DateTime busabah;
  var gecicisat = List<Gunceldurummod>().obs;
  var gecicigider = List<Gunceldurummod>().obs;
  num bakiye = 0.obs();

  @override
  void onInit() {
    fetchfinaltodo();
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      bugun = DateTime.now();
      bugun = DateTime(bugun.year, bugun.month, bugun.day);
      bugece = DateTime(bugun.year, bugun.month, bugun.day + 1);
      busabah = DateTime(bugun.year, bugun.month, bugun.day, 0, 0, 0);
      var todos = await APIServices.callstp(busabah, bugece);
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

  void gunsatguncelle(num deg) async {
    isLoading(true);

    try {
      gecicisat[0].toplammiktar = gecicisat[0].toplammiktar + deg;
      gecicisat[0].fatsayisi = gecicisat[0].fatsayisi + 1;
    } finally {
      isLoading(false);
    }
  }

  void gunalisguncelle(num deg) async {
    isLoading(true);

    try {
      gecicigider[0].toplammiktar = gecicigider[0].toplammiktar + deg;
      gecicigider[0].fatsayisi = gecicigider[0].fatsayisi + 1;
    } finally {
      isLoading(false);
    }
  }
}
