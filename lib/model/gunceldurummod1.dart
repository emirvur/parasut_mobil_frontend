class Gunceldurummod1 {
  num toplammiktar;
  num alinan;
  num odenen;
  int fatsayisi;
  int tur;
  int durum;

  Gunceldurummod1(this.toplammiktar, this.alinan, this.odenen, this.fatsayisi,
      this.tur, this.durum);

  Gunceldurummod1.fromMap(Map<String, dynamic> map) {
    // this.id = map['id'];
    this.toplammiktar = map['toplammiktar'];
    this.alinan = map['alinan'];
    this.odenen = map['odenen'];
    this.fatsayisi = map['fatsayisi'];
    this.tur = map['tur'];
    this.durum = map['durum'];
  }
}
