class Dtourunhareket {
  int fatid;
  String barkodno;
  num miktar;
  num brfiyat;
  num vergi;
  String ad;
  Dtourunhareket(this.fatid, this.barkodno, this.miktar, this.brfiyat,
      this.vergi, this.ad);

  Dtourunhareket.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];

    this.fatid = map['fatid'] ?? -1;
    this.barkodno = map['barkodno'];
    this.miktar = map['miktar'];
    this.brfiyat = map['brfiyat'] ?? -1;
    this.vergi = map['vergi'] ?? -1;
    this.ad = map['ad'];
  }
}
