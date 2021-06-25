import 'package:intl/intl.dart';

class Dtoirsaliye {
  int irsid;
  int tur;

  int cariId;
  String cariad;

  String tarih;

  num aratop;
  num araind;
  num kdv;
  num geneltop;
  int fatmi;
  String aciklama;

  Dtoirsaliye(
      this.irsid,
      this.tur,
      this.cariId,
      this.cariad,
      this.tarih,
      this.aratop,
      this.araind,
      this.kdv,
      this.geneltop,
      this.fatmi,
      this.aciklama);

  Dtoirsaliye.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.irsid = map['irsid'];
    this.tur = map['tur'];

    this.cariId = map['cariId'];
    this.cariad = map['cariad'];

    this.tarih = map['tarih'];
    // var saat = DateFormat.jm('tr_TR').format(DateTime.parse(tarih));
    var yil = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(tarih));
    this.tarih = yil; //+ "-" + saat;

    this.aratop = map['aratop'] ?? -1;
    this.araind = map['araind'] ?? -1;
    this.kdv = map['kdv'] ?? -1;
    this.geneltop = map['geneltop'];
    this.fatmi = map['fatmi'];
    this.aciklama = map['aciklama'];
  }
}
