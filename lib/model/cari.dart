class Cari {
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

  Cari(
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
      this.bakiye); //kategori eklerken kullan, çünkü id db tarafından olusturuluyor

  Map<String, dynamic> toMap(int x) {
    var map = Map<String, dynamic>();
    //  map['cariId'] = cariId;
    map['cariunvani'] = cariunvani;
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

  Cari.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
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
