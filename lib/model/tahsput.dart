class Tahsput {
  int tahsid;
  num alinmismik;
  num toplam;
  String tedt;
  int kasid;
  String acik;
  Tahsput(
    this.tahsid,
    this.alinmismik,
    this.toplam,
    this.tedt,
    this.kasid,
    this.acik,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //  map['cariId'] = cariId;
    map['id'] = tahsid;
    map['alinmismik'] = alinmismik;

    map['toplam'] = toplam;
    map['tedt'] = tedt;
    map['kasid'] = kasid;
    map['acik'] = acik;

    return map;
  }
}
