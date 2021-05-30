part of 'models.dart';

class Pdil {
  String idPel;
  String noMeter;
  String nama;
  String alamat;
  String tarip;
  String daya;
  String noHp;
  String nik;
  String npwp;
  String email;
  String catatan;
  bool isKoreksi;
  String tanggalBaca;

  Pdil({
    this.idPel,
    this.noMeter,
    this.nama,
    this.alamat,
    this.tarip,
    this.daya,
    this.noHp,
    this.nik,
    this.npwp,
    this.email,
    this.catatan,
    this.isKoreksi,
    this.tanggalBaca,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnIdPel: idPel,
      columnNoMeter : noMeter,
      columnNama: nama,
      columnAlamat: alamat,
      columnTarip: tarip,
      columnDaya: daya,
      columnNoHp: noHp,
      columnNik: nik,
      columnNpwp: npwp,
      columnEmail : email,
      columnCatatan: catatan,
      columnIsKoreksi: isKoreksi == true ? 1 : 0,
      columnTanggalBaca: tanggalBaca,
    };
    return map;
  }

  Pdil.fromMap(Map<String, dynamic> map) {
    idPel = map[columnIdPel];
    noMeter = map[columnNoMeter];
    nama = map[columnNama];
    alamat = map[columnAlamat];
    tarip = map[columnTarip];
    daya = map[columnDaya];
    noHp = map[columnNoHp];
    nik = map[columnNik];
    npwp = map[columnNpwp];
    email = map[columnEmail];
    catatan = map[columnCatatan];
    isKoreksi = map[columnIsKoreksi] == 1;
    tanggalBaca = map[columnTanggalBaca];
  }

  List<String> toList({bool isPasca = true}) => [
        idPel,
        if(!isPasca) noMeter,
        nama,
        alamat,
        tarip,
        daya,
        noHp,
        nik,
        npwp,
        email,
        catatan,
        tanggalBaca,
      ];

  Pdil copyWith({
    String idPel,
    String noMeter,
    String nama,
    String alamat,
    String tarip,
    String daya,
    String noHp,
    String nik,
    String npwp,
    String email,
    String catatan,
    bool isKoreksi,
    String tanggalBaca,
  }) =>
      Pdil(
        idPel: idPel ?? this.idPel,
        noMeter: noMeter ?? this.noMeter,
        nama: nama ?? this.nama,
        alamat: alamat ?? this.alamat,
        tarip: tarip ?? this.tarip,
        daya: daya ?? this.daya,
        noHp: noHp ?? this.noHp,
        nik: nik ?? this.nik,
        npwp: npwp ?? this.npwp,
        email: email ?? this.email,
        catatan: catatan ?? this.catatan,
        isKoreksi: isKoreksi ?? this.isKoreksi,
        tanggalBaca: tanggalBaca ?? this.tanggalBaca,
      );
}
