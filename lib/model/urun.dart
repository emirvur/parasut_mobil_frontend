class Urun {
  String barkodno;
  String adi;
  int kategoriId;
  String birim;
  num adet;
  num krseviye;
  num verharal;
  num verharsat;
  num kdv;

  Urun(
    this.barkodno,
    this.adi,
    this.kategoriId,
    this.birim,
    this.adet,
    this.krseviye,
    this.verharal,
    this.verharsat,
    this.kdv,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //  map['cariId'] = cariId;
    map['barkodno'] = barkodno;
    map['adi'] = adi;
    map['kategoriId'] = kategoriId;
    map['birim'] = birim;
    map['adet'] = adet;
    map['krseviye'] = krseviye;
    map['verharal'] = verharal;
    map['verharsat'] = verharsat;
    map['kdv'] = kdv;

    return map;
  }

  Urun.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.barkodno = map['barkodno'];
    this.adi = map['adi'];
    this.kategoriId = map['kategoriId'];
    this.birim = map['birim'];
    this.adet = map['adet'];
    this.krseviye = map['krseviye'] ?? -1;
    this.verharal = map['verharal'];
    this.verharsat = map['verharsat'];
    this.kdv = map['kdv'];
  }
}
