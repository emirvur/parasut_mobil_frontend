class Odeput {
  int odeid;
  num odendim;
  num toplam;
  String odent;
  int kasid;
  String acik;
  Odeput(
    this.odeid,
    this.odendim,
    this.toplam,
    this.odent,
    this.kasid,
    this.acik,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //  map['cariId'] = cariId;
    map['id'] = odeid;
    map['odendim'] = odendim;

    map['toplam'] = toplam;
    map['odent'] = odent;
    map['kasid'] = kasid;
    map['acik'] = acik;

    return map;
  }
}
