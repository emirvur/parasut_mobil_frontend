class Dtoirsurunhar {
  String barkodno;
  num miktar;
  num brfiyat;
  num vergi;
  String ad;
  Dtoirsurunhar(this.barkodno, this.miktar, this.brfiyat, this.vergi, this.ad);

  Dtoirsurunhar.fromMap(Map<String, dynamic> map) {
    this.barkodno = map['barkodno'];
    this.miktar = map['miktar'];
    this.brfiyat = map['brfiyat'] ?? -1;
    this.vergi = map['vergi'] ?? -1;
    this.ad = map['ad'];
  }
}
