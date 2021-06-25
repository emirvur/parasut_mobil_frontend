import 'package:intl/intl.dart';

class Dtoodeharfat {
  int ohid;
  int odeid;
  String odenmistar;
  int kasaid;
  String kasaad;
  String aciklama;
  num odendimik;
  String ad;

  Dtoodeharfat(this.ohid, this.odeid, this.odenmistar, this.kasaid, this.kasaad,
      this.aciklama, this.odendimik, this.ad);

  Dtoodeharfat.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.ohid = map['ohid'];
    print("vvv");
    print(ohid.toString());
    this.odeid = map['odeid'];
    this.odenmistar = map['odenmistar'];
    print(odenmistar.toString());
    if (this.odenmistar != "null") {
      //  var saat2 = DateFormat.jm('tr_TR').format(DateTime.parse(odenmistar));
      var yil2 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(odenmistar));
      this.odenmistar = yil2; //+ "-" + saat2;
    }
    this.kasaid = map['kasaid'];
    this.kasaad = map['kasaad'];
    this.aciklama = map['aciklama'];
    this.odendimik = map['odendimik'];
    this.ad = map['ad'];
  }
}
