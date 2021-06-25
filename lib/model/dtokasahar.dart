import 'package:intl/intl.dart';

class Dtokasahar {
  num netbakiye;
  int durum;
  num miktar;
  String miktaraciklamasi;
  int tahsid;
  String tediltar;
  int tahskasaid;
  String tahsaciklama;
  num alinmismik;
  int odeid;
  String odenmistar;
  int odkasaid;
  String odaciklama;
  num odendimik;
  String thfatad;
  String ohfatad;
  Dtokasahar(
      this.netbakiye,
      this.durum,
      this.miktar,
      this.miktaraciklamasi,
      this.tahsid,
      this.tediltar,
      this.tahskasaid,
      this.tahsaciklama,
      this.alinmismik,
      this.odeid,
      this.odenmistar,
      this.odkasaid,
      this.odaciklama,
      this.odendimik,
      this.thfatad,
      this.ohfatad);
  Dtokasahar.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.netbakiye = map['netbakiye'];
    this.durum = map['durum'];
    print("dd");
    print(this.durum.toString());
    this.miktar = map['miktar'] ?? -1;
    this.alinmismik = map['alinmismik'] ?? -1;
    this.miktaraciklamasi = map['miktaraciklamasi'] ?? "null";
    this.tahsid = map['tahsid'] ?? -1;
    this.tediltar = map['tediltar'] ?? "null";
    if (this.tediltar != "null") {
      //  var saat1 = DateFormat.jm('tr_TR').format(DateTime.parse(tediltar));
      var yil1 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(tediltar));
      this.tediltar = yil1; //+ "-" + saat1;
    }
    this.tahskasaid = map['tahskasaid'] ?? -1;
    this.tahsaciklama = map['tahsaciklama'] ?? "null";
    this.odeid = map['odeid'] ?? -1;
    this.odenmistar = map['odenmistar'] ?? "null";
    if (this.odenmistar != "null") {
      // var saat2 = DateFormat.jm('tr_TR').format(DateTime.parse(odenmistar));
      var yil2 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(odenmistar));
      this.odenmistar = yil2; // + "-" + saat2;
    }
    this.odkasaid = map['odkasaid'] ?? -1;
    this.odaciklama = map['odaciklama'] ?? "null";
    this.odendimik = map['odendimik'] ?? -1;
    this.thfatad = map['thfatad'] ?? "null";
    this.ohfatad = map['ohfatad'] ?? "null";
  }
}
