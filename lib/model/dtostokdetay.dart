import 'package:intl/intl.dart';

class Dtostokdetay {
  int fatid;
  String barkodno;
  num miktar;
  num brfiyat;
  num vergi;
  String ad;
  String duzt;
  String fatacik;
  Dtostokdetay(this.fatid, this.barkodno, this.miktar, this.brfiyat, this.vergi,
      this.ad, this.duzt, this.fatacik);

  Dtostokdetay.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];

    this.fatid = map['fatid'] ?? -1;
    this.barkodno = map['barkodno'];
    this.miktar = map['miktar'];
    this.brfiyat = map['brfiyat'] ?? -1;
    this.vergi = map['vergi'] ?? -1;
    this.ad = map['ad'];
    this.duzt = map['duzt'];
    var yil1 = DateFormat.yMMMEd('tr_TR').format(DateTime.parse(duzt));
    this.duzt = yil1;
    this.fatacik = map['fatacik'];
  }
}
