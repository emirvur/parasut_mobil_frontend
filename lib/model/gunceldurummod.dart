class Gunceldurummod {
  num toplammiktar;
  num alinan;
  num odenen;
  int fatsayisi;
  int tur;

  Gunceldurummod(
    this.toplammiktar,
    this.alinan,
    this.odenen,
    this.fatsayisi,
    this.tur,
  );

  Gunceldurummod.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.toplammiktar = map['toplammiktar'];
    this.alinan = map['alinan'];
    this.odenen = map['odenen'];
    this.fatsayisi = map['fatsayisi'];
    this.tur = map['tur'];
  }
}
