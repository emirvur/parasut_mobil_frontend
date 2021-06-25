class Dtourun {
  String barkodno;
  String adi;
  int kategoriId;
  String katad;
  String birim;
  num adet;
  num krseviye;
  num verharal;
  num verharsat;
  num kdv;

  Dtourun(
    this.barkodno,
    this.adi,
    this.kategoriId,
    this.katad,
    this.birim,
    this.adet,
    this.krseviye,
    this.verharal,
    this.verharsat,
    this.kdv,
  );

  Dtourun.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.barkodno = map['barkodno'];
    this.adi = map['adi'];
    this.kategoriId = map['kategoriId'];
    this.katad = map['kategoriad'];
    this.birim = map['birim'];
    this.adet = map['adet'];
    this.krseviye = map['krseviye'] ?? -1;
    this.verharal = map['verharal'];
    this.verharsat = map['verharsat'];
    this.kdv = map['kdv'];
  }
}
