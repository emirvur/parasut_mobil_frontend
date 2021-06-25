class Kasal {
  String label;
  int kasaid;
  String kasaAd;
  num bakiye;

  Kasal(
    this.label,
    this.kasaid,
    this.kasaAd,
    this.bakiye,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //  map['cariId'] = cariId;
    map['label'] = label;
    map['kasaid'] = kasaid;
    map['kasaAd'] = kasaAd;
    map['bakiye'] = bakiye;

    return map;
  }

  Kasal.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.label = map['kasaAd'];
    this.kasaid = map['kasaid'];
    this.kasaAd = map['kasaAd'];
    this.bakiye = map['bakiye'];
  }
}
