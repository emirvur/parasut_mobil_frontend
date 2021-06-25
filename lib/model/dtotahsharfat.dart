import 'package:intl/intl.dart';

class Dtotahsharfat {
  int thid;
  int tahsid;
  String tediltar;
  int kasaid;
  String kasaad;
  String aciklama;
  num alinmismik;
  String ad;

  Dtotahsharfat(this.thid, this.tahsid, this.tediltar, this.kasaid, this.kasaad,
      this.aciklama, this.alinmismik, this.ad);

  Dtotahsharfat.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.thid = map['thid'];
    this.tahsid = map['tahsid'];
    this.tediltar = map['tediltar'] ?? "null";
    if (this.tediltar != "null") {
      //  var saat1 = DateFormat.jm('tr_TR').format(DateTime.parse(tediltar));
      var yil1 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(tediltar));
      this.tediltar = yil1; // + "-" + saat1;
    }
    this.kasaid = map['kasaid'];
    this.kasaad = map['kasaad'];
    this.aciklama = map['aciklama'] ?? "null";
    this.alinmismik = map['alinmismik'] ?? "null";
    this.ad = map['ad'];
  }
}
