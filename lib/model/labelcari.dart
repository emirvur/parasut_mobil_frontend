class Labcari {
  String label;
  int cariId;
  String cariunvani;
  String kisaisim;
  int katid;
  String eposta;
  String telno;
  String faks;
  String iban;
  String adres;
  int turu;
  String tckn;
  num bakiye;

  Labcari(
      this.label,
      this.cariId,
      this.cariunvani,
      this.kisaisim,
      this.katid,
      this.eposta,
      this.telno,
      this.faks,
      this.iban,
      this.adres,
      this.turu,
      this.tckn,
      this.bakiye); 

  Map<String, dynamic> toMap(int x) {
    var map = Map<String, dynamic>();
    //  map['cariId'] = cariId;
    map['label'] = cariunvani;
    map['cariunvani'] = cariunvani;
    map['cariId'] = cariId;
    map['kisaisim'] = kisaisim;
    map['katid'] = katid;
    map['eposta'] = eposta;
    map['telno'] = telno;
    map['faks'] = faks;
    map['iban'] = iban;
    map['adres'] = adres;
    map['turu'] = turu;
    map['tckn'] = tckn;
    map['bakiye'] = bakiye;
    map['hangicari'] = x;

    return map;
  }

  Labcari.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.label = map['cariunvani'];
    this.cariId = map['cariId'];
    this.cariunvani = map['cariunvani'];
    this.kisaisim = map['kisaisim'] ?? "null";
    this.katid = map['katid'];
    this.eposta = map['eposta'] ?? "null";
    this.telno = map['telno'] ?? "null";
    this.faks = map['faks'] ?? "null";
    this.iban = map['iban'] ?? "null";
    this.adres = map['adres'] ?? "null";
    this.bakiye = map['bakiye'];
    this.turu = map['turu'];
    this.tckn = map['tckn'] ?? "null";
  }
}
