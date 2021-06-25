import 'package:intl/intl.dart';

class Dtofatode {
  int fatid;
  int fatTur;
  int durum;
  int cariId;
  String cariad;

  String duztarih;
  String fataciklama;
  String katad;
  num aratop;
  num araind;
  num kdv;
  num geneltoplam;
  String odenecektar;
  String odenmistar;
  num odendimik;
  int odeid;
  Dtofatode(
      this.fatid,
      this.fatTur,
      this.durum,
      this.cariId,
      this.cariad,
      this.duztarih,
      this.fataciklama,
      this.katad,
      this.aratop,
      this.araind,
      this.kdv,
      this.geneltoplam,
      this.odenecektar,
      this.odenmistar,
      this.odendimik,
      this.odeid);

  Dtofatode.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.fatid = map['fatid'];
    this.fatTur = map['fatTur'];
    this.durum = map['durum'];
    this.cariId = map['cariId'];
    this.cariad = map['cariad'];
    this.duztarih = map['duzenlemetarih'];
    print("11deed");
    var saat = DateFormat.jm('tr_TR').format(DateTime.parse(duztarih));
    var yil = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(duztarih));
    print("2de");
    this.duztarih = yil; // + "-" + saat;
    print("3te");
    this.fataciklama = map['fatacik'] ?? "null";
    this.katad = map['katad'];
    this.aratop = map['aratop'] ?? -1;
    this.araind = map['araind'] ?? -1;
    this.kdv = map['kdv'] ?? -1;
    this.geneltoplam = map['geneltop'];
    this.odenecektar = map['odenecektar'] ?? "null";
    if (this.odenecektar != "null") {
      /*  var saat1 = DateFormat.jm('tr_TR').format(DateTime.parse(odenecektar));
      var yil1 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(odenecektar));
      this.odenecektar = yil1 + "-" + saat1;*/
    }
    print("5tee");
    this.odenmistar = map['odenmistar'] ?? "null";
    if (this.odenmistar != "null") {
      var saat2 = DateFormat.jm('tr_TR').format(DateTime.parse(odenmistar));
      var yil2 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(odenmistar));
      this.odenmistar = yil2 + "-" + saat2;
    }

    this.odendimik = map['odendimik'] ?? 0;
    this.odeid = map['odeid'];
  }
}
