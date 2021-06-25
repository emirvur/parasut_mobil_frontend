import 'package:intl/intl.dart';

class Dtourungecmisi {
  int fatid;
  String fattur;
  String duzenlemetarih;
  num miktar;
  String cariad;

  Dtourungecmisi(
      this.fatid, this.fattur, this.duzenlemetarih, this.miktar, this.cariad);
  Dtourungecmisi.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.fatid = map['fatid'] ?? -1;
    this.fattur = map['fatTur'] == 0 ? "Stok Giriş" : "Stok Çıkış";
    this.duzenlemetarih = map['duzenlemetarih'];
    if (this.duzenlemetarih != "null") {
      //var saat2 = DateFormat.jm('tr_TR').format(DateTime.parse(duzenlemetarih));
      var yil2 =
          DateFormat.yMMMEd('tr_TR').format(DateTime.parse(duzenlemetarih));
      this.duzenlemetarih = yil2; //+ "-" + saat2;
    }
    this.miktar = map['miktar'];

    this.cariad = map['cariad'];
  }
}
