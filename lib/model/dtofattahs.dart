import 'package:intl/intl.dart';

class Dtofattahs {
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
  String vadta;
  String alta;
  num alinmism;
  int tahsid;
  Dtofattahs(
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
      this.vadta,
      this.alta,
      this.alinmism,
      this.tahsid);

  Dtofattahs.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    print("qq");
    this.fatid = map['fatid'];
    this.fatTur = map['fatTur'];
    this.durum = map['durum'];
    this.cariId = map['cariId'];
    this.cariad = map['cariad'];
    this.duztarih = map['duzenlemetarih'];
    var saat = DateFormat.jm('tr_TR').format(DateTime.parse(duztarih));
    var yil = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(duztarih));
    this.duztarih = yil; //+ "-" + saat;
    this.fataciklama = map['fatacik'] ?? "null";
    this.katad = map['katad'];
    this.aratop = map['aratop'] ?? -1;
    this.araind = map['araind'] ?? -1;
    this.kdv = map['kdv'] ?? -1;
    this.geneltoplam = map['geneltop'];
    this.vadta = map['vadta'] ?? "null";
    if (this.vadta != "null") {
      /*  var saat1 = DateFormat.jm('tr_TR').format(DateTime.parse(vadta));
      var yil1 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(vadta));
      this.vadta = yil1 + "-" + saat1;*/
    }
    this.alta = map['alta'] ?? "null";
    if (this.alta != "null") {
      var saat2 = DateFormat.jm('tr_TR').format(DateTime.parse(alta));
      var yil2 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(alta));
      this.alta = yil2 + "-" + saat2;
    }
    this.alinmism = map['alinmism'] ?? 0;
    this.tahsid = map['tahsid'];
  }

  Dtofattahs.fromfarkMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    print("qq");
    this.fatid = map['fatid'];
    this.fatTur = map['fatTur'];
    this.durum = map['durum'];
    this.cariId = map['cariId'];
    this.cariad = map['cariad'];
    this.duztarih = map['duzenlemetarih'];
    var saat = DateFormat.jm('tr_TR').format(DateTime.parse(duztarih));
    var yil = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(duztarih));
    this.duztarih = yil + "-" + saat;
    this.fataciklama = map['fatacik'] ?? "null";
    this.katad = map['katad'];
    this.aratop = map['aratop'] ?? -1;
    this.araind = map['araind'] ?? -1;
    this.kdv = map['kdv'] ?? -1;
    this.geneltoplam = map['geneltop'];
    this.vadta = map['vadta'] ?? "null";
    if (this.vadta != "null") {
      /*var saat1 = DateFormat.jm('tr_TR').format(DateTime.parse(vadta));
      var yil1 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(vadta));
      this.vadta = yil1 + "-" + saat1;*/
    }
    this.alta = map['alta'] ?? "null";
    if (this.alta != "null") {
      var saat2 = DateFormat.jm('tr_TR').format(DateTime.parse(alta));
      var yil2 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(alta));
      this.alta = yil2 + "-" + saat2;
    }
    this.alinmism = map['alinmism'];
    this.tahsid = map['tahsid'];
  }
}
