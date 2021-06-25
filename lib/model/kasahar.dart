class Kasahar {
  int khid;
  int kasaid;
  int thid;
  int ohid;
  num netbakiye;
  int durum;
  num miktar;
  String miktaraciklamasi;

  Kasahar(this.khid, this.kasaid, this.thid, this.ohid, this.netbakiye,
      this.durum, this.miktar, this.miktaraciklamasi);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['kasaid'] = kasaid;
    map['thid'] = thid;
    map['ohid'] = ohid;
    map['netbakiye'] = netbakiye;
    map['durum'] = durum;
    map['miktar'] = miktar;
    map['miktaraciklamasi'] = miktaraciklamasi;

    return map;
  }

  Kasahar.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.khid = map['khid'];
    this.kasaid = map['kasaid'];
    this.thid = map['thid'] ?? -1;
    this.ohid = map['ohid'] ?? -1;
    this.netbakiye = map['netbakiye'];
    this.durum = map['durum'];
    this.miktar = map['miktar'] ?? -1;
    this.miktaraciklamasi = map['miktaraciklamasi'] ?? "null";
  }
}
