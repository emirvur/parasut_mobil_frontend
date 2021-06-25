class Kasa {
  int kasaid;
  String kasaAd;
  num bakiye;

  Kasa(
    this.kasaid,
    this.kasaAd,
    this.bakiye,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //  map['cariId'] = cariId;
    map['kasaid'] = kasaid;
    map['kasaAd'] = kasaAd;
    map['bakiye'] = bakiye;

    return map;
  }

  Kasa.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.kasaid = map['kasaid'];
    this.kasaAd = map['kasaAd'];
    this.bakiye = map['bakiye'];
  }
}
